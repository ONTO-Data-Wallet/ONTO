//
//  LiveOutputViewController.m
//  TestSTLivenessController
//
//  Created by huoqiuliang on 16/5/9.
//  Copyright © 2016年 SunLin. All rights reserved.
//

#import "LiveOutputViewController.h"
static NSString *const cellId = @"cellId";
@interface LiveOutputViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation LiveOutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选图方案";
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    headerView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [UIView new];
    self.dataSource = @[@"单图", @"多图"];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onBtnOk)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { //! OCLINT
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { //! OCLINT
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;

    cell.textLabel.text = self.dataSource[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == self.currentIndex) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.currentIndex = indexPath.row;
}

- (void)onBtnOk {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"outputType"
                                                        object:self
                                                      userInfo:@{
                                                          @"outputType": @(self.currentIndex)
                                                      }];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
