//
//  ActionSequenceTableViewController.m
//  TestLiveness
//
//  Created by sluin on 15/11/21.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import "ActionSequenceTableViewController.h"
static NSString *const cellId = @"cellId";

@interface ActionSequenceTableViewController ()

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSMutableArray *arrActions;

@end

@implementation ActionSequenceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"设置动作序列";
    self.color = [UIColor colorWithRed:0 green:121 / 255.0 blue:1.0 alpha:1.0];
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(0, 0, 40, 40)];
    [btnDone setTitle:@"完成" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(onBtnAdd:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
    self.navigationItem.rightBarButtonItem = rightItem;

    CGSize size = [UIScreen mainScreen].bounds.size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 60)];
    view.backgroundColor = [UIColor whiteColor];

    UIButton *btnBlink = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBlink setFrame:CGRectMake(0, 0, size.width / 4, 60)];
    [btnBlink setTitle:@"BLINK" forState:UIControlStateNormal];
    [btnBlink setTitleColor:self.color forState:UIControlStateNormal];
    [btnBlink addTarget:self action:@selector(onBtnAdd:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnBlink];

    UIButton *btnMouth = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMouth setFrame:CGRectMake(1 / 4.0 * size.width, 0, size.width / 4 + 10, 60)];
    [btnMouth setTitle:@"MOUTH" forState:UIControlStateNormal];
    [btnMouth setTitleColor:self.color forState:UIControlStateNormal];
    [btnMouth addTarget:self action:@selector(onBtnAdd:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnMouth];

    UIButton *btnNod = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNod setFrame:CGRectMake(1 / 2.0 * size.width + 10, 0, size.width / 4 - 10, 60)];
    [btnNod setTitle:@"NOD" forState:UIControlStateNormal];
    [btnNod setTitleColor:self.color forState:UIControlStateNormal];
    [btnNod addTarget:self action:@selector(onBtnAdd:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnNod];

    UIButton *btnYaw = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnYaw setFrame:CGRectMake(3 / 4.0 * size.width, 0, size.width / 4, 60)];
    [btnYaw setTitle:@"YAW" forState:UIControlStateNormal];
    [btnYaw setTitleColor:self.color forState:UIControlStateNormal];
    [btnYaw addTarget:self action:@selector(onBtnAdd:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnYaw];

    self.tableView.tableHeaderView = view;
    self.arrActions = [NSMutableArray arrayWithArray:self.tempArrActions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)onBtnAdd:(UIButton *)btnSender {
    if ([btnSender.titleLabel.text isEqualToString:@"完成"]) {
        if (!self.arrActions.count || ![[self.arrActions objectAtIndex:0] isEqualToString:@"BLINK"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"至少应有一个检测动作,且第一个必须为BLINK"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil, nil];

            [alert show];

            return;
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"arrActions"
                                                            object:self
                                                          userInfo:@{@"array": self.arrActions}];
        [self.navigationController popViewControllerAnimated:YES];

    } else {
        if (self.arrActions.count >= 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"最多可设置4个动作"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [self.arrActions addObject:btnSender.titleLabel.text];

        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.textColor = self.color;
    cell.textLabel.text = [self.arrActions objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"至少应有一个检测动作,且第一个必须为BLINK"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        [alert show];

    } else {
        [self.arrActions removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

@end
