//
//  MoneyDetailViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "MoneyDetailViewController.h"
#import "ShareWalletPayDetailViewController.h"
#import "ShareWalletDetailCell.h"
#import "ShareTradeModel.h"
#import "copayerSignModel.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
@interface MoneyDetailViewController ()
    <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) NSString *nowTimeString;
@property(nonatomic, assign) BOOL isDraging;
@property(nonatomic, assign) BOOL isUp;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) UIView *emptyV;
@property(nonatomic, strong) MBProgressHUD *hub;
@end

@implementation MoneyDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createUI];

}

- (void)getData {
  self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
  self.isDraging = YES;
  [self netRequest];
}
- (void)netRequest {
  self.isDraging = YES;

  NSDictionary *params = @{
      @"sharedAddress": self.address,
      @"assetName": self.isONT ? @"ont" : @"ong",
      @"beforeTimeStamp": self.nowTimeString
  };

  [[CCRequest shareInstance]
      requestWithHMACAuthorization:GetShareWalletPending
                        MethodType:MethodTypeGET Params:params
                           Success:^(id responseObject, id responseOriginal) {

                             self.isDraging = NO;
                             [_hub hideAnimated:YES];
                             if (![Common dx_isNullOrNilWithObject:responseOriginal]
                                 && [[responseOriginal valueForKey:@"error"] integerValue] > 0) {
                               [Common showToast:
                                   [NSString stringWithFormat:@"%@:%@", Localized(@"Systemerror"),
                                                              [responseOriginal valueForKey:@"error"]]];
                               return;
                             }
                             NSArray *arr = [responseOriginal valueForKey:@"SigningSharedTransfers"];
                             if (arr.count > 0) {
                               NSDictionary *dic = arr.lastObject;
                               self.nowTimeString = dic[@"createtimestamp"];
                             }

                             if (self.isUp == NO) {
                               self.dataArray =
                                   [ShareTradeModel mj_objectArrayWithKeyValuesArray:responseOriginal[@"SigningSharedTransfers"]];
                             } else {
                               NSArray
                                   *newArray =
                                   [ShareTradeModel mj_objectArrayWithKeyValuesArray:responseOriginal[@"SigningSharedTransfers"]];
                               [self.dataArray addObjectsFromArray:newArray];
                             }
                             if (self.dataArray.count == 0) {
                               _tableView.tableHeaderView = self.emptyV;
                             } else {
                               _tableView.tableHeaderView = nil;
                             }
                             [_tableView reloadData];
                             self.isUp = NO;
                             [_timer invalidate];
                             _timer = nil;
                             _timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                                       target:self
                                                                     selector:@selector(function)
                                                                     userInfo:nil
                                                                      repeats:YES];
                             [self endRefresh];
                           }
                           Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {

                             [_hub hideAnimated:YES];
                             if (self.dataArray.count == 0) {
                               _tableView.tableHeaderView = self.emptyV;
                             } else {
                               _tableView.tableHeaderView = nil;
                             }
                             [self endRefresh];
                             self.isDraging = NO;
                             [Common showToast:Localized(@"NetworkAnomaly")];
                           }
  ];
}
- (void)function {

  if (self.isDraging == YES) {
    return;
  }
  self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
  self.isUp = NO;
  [self netRequest];
}
- (void)createUI {

  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                             10 * SCALE_W,
                                                             SYSWidth,
                                                             SYSHeight - 49 - 64
                                                                 - 225 * SCALE_W) style:UITableViewStylePlain];
  if (KIsiPhoneX) {
    _tableView.frame = CGRectMake(0, 10 * SCALE_W, SYSWidth, SYSHeight - 49 - 64 - 34 - 24 - 225 * SCALE_W);
  }
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.backgroundColor = [UIColor whiteColor];
  _tableView.showsVerticalScrollIndicator = NO;
  _tableView.delegate = self;
  _tableView.dataSource = self;
  [self.view addSubview:_tableView];

  _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    self.isUp = NO;
    self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
    [self getData];
  }];
  _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    self.isUp = YES;
    [self netRequest];
  }];

//    [self.view addSubview:self.emptyV];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 84 * SCALE_W;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"shareDetail";
  ShareWalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (!cell) {
    cell = [[ShareWalletDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
  }
  ShareTradeModel *model = self.dataArray[indexPath.row];
  [cell reloadCell:model isONT:self.isONT];
  return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  USERMODEL.isCheckTrade = YES;
  ShareTradeModel *model = self.dataArray[indexPath.row];
  model.isRead = YES;
  ShareWalletPayDetailViewController *vc = [[ShareWalletPayDetailViewController alloc] init];
  vc.isONT = self.isONT;
  vc.address = self.address;
  vc.model = model;
  [self.navigationController pushViewController:vc animated:YES];
}
- (void)endRefresh {
  [self.tableView.mj_header endRefreshing];
  [self.tableView.mj_footer endRefreshing];

}
- (void)viewWillAppear:(BOOL)animated {
  _hub = [ToastUtil showMessage:@"" toView:nil];
  if (USERMODEL.isCheckTrade == YES) {
    USERMODEL.isCheckTrade = NO;
    if (_dataArray.count > 0) {
      [_tableView reloadData];
    }
  } else {
    [self.dataArray removeAllObjects];
    [self performSelector:@selector(getData) withObject:nil afterDelay:1];
//        [self getData];
  }
  [_timer invalidate];
  _timer = nil;
  _timer =
      [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(function) userInfo:nil repeats:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_hub hideAnimated:YES];
  [_timer invalidate];
  _timer = nil;
}
- (UIView *)emptyV {
  if (!_emptyV) {
    _emptyV = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * SCALE_W, SYSWidth, 191 * SCALE_W)];
    _emptyV.backgroundColor = [UIColor whiteColor];

    UIImageView *image = [[UIImageView alloc]
        initWithFrame:CGRectMake((SYSWidth - 101 * SCALE_W) / 2, 63 * SCALE_W, 101 * SCALE_W, 101 * SCALE_W)];
    image.image = [UIImage imageNamed:@"noData"];
    [_emptyV addSubview:image];

    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 173 * SCALE_W, SYSWidth, 17 * SCALE_W)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = LIGHTGRAYLB;
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = Localized(@"ListNoRecord");
    [_emptyV addSubview:lb];

  }
  return _emptyV;
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
