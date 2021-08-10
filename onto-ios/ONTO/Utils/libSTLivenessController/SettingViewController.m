//
//  SettingViewController.m
//  TestSTLivenessController
//
//  Created by huoqiuliang on 16/5/9.
//  Copyright © 2016年 SunLin. All rights reserved.
//

#import "SettingViewController.h"
#import "ActionSequenceTableViewController.h"
#import "LiveOutputViewController.h"
#import "LiveComplexityViewController.h"

static NSString *const cellId = @"cellId";

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISwitch *switchView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.tableView.rowHeight = 50;
    self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(arrayActions:)
                                                 name:@"arrActions"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(liveComplexity:)
                                                 name:@"liveComplexity"
                                               object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { //! OCLINT
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { //! OCLINT
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    self.switchView = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 10, 49, 31)];
    self.switchView.on = self.bVoicePrompt;

    [self.switchView addTarget:self action:@selector(onSwitchViewAction:) forControlEvents:UIControlEventValueChanged];

    if (section == 0 && row == 0) {
        cell.textLabel.text = @"设置动作序列";
    } else if (section == 0 && row == 1) {
        cell.textLabel.text = @"选择难易程度";
    } else if (section == 1 && row == 0) {
        cell.textLabel.text = @"提示声音";
        [cell.contentView addSubview:self.switchView];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        switch (row) {
            case 0: {
                ActionSequenceTableViewController *actionSequenceVC = [[ActionSequenceTableViewController alloc] init];
                actionSequenceVC.tempArrActions = self.arrActions;

                [self.navigationController pushViewController:actionSequenceVC animated:YES];
                break;
            }

            case 1: {
                LiveComplexityViewController *viewController = [[LiveComplexityViewController alloc] init];
                viewController.liveComplexity = self.liveComplexity;
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark Actions

- (void)onSwitchViewAction:(UISwitch *)sender {
    BOOL setting = sender.isOn;
    [self.switchView setOn:setting animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"voicePrompt"
                                                        object:self
                                                      userInfo:@{
                                                          @"voicePrompt": @(setting)
                                                      }];
}

#pragma mark === NSNotification Action

- (void)arrayActions:(NSNotification *)notification {
    NSDictionary *arryDictionary = [notification userInfo];

    self.arrActions = [NSMutableArray
        arrayWithArray:[[arryDictionary[@"array"] componentsJoinedByString:@" "] componentsSeparatedByString:@" "]];

    [self.tableView reloadData];
}
- (void)liveComplexity:(NSNotification *)notification {
    NSDictionary *arryDictionary = [notification userInfo];
    if ([arryDictionary[@"liveComplexity"] isEqual:@0]) {
        self.liveComplexity = STIDLiveness_COMPLEXITY_EASY;
    } else if ([arryDictionary[@"liveComplexity"] isEqual:@1]) {
        self.liveComplexity = STIDLiveness_COMPLEXITY_NORMAL;
    } else if ([arryDictionary[@"liveComplexity"] isEqual:@2]) {
        self.liveComplexity = STIDLiveness_COMPLEXITY_HARD;
    } else if ([arryDictionary[@"liveComplexity"] isEqual:@3]) {
        self.liveComplexity = STIDLiveness_COMPLEXITY_HELL;
    }

    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
