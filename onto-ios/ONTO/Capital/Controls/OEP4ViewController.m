//
//  OEP4ViewController.m
//  ONTO
//
//  Created by Apple on 2019/1/4.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "OEP4ViewController.h"

#import "DealCell.h"
#import "GetViewController.h"
#import "SendViewController.h"
#import "UITableView+EmptyData.h"
#import "UIView+Scale.h"
#import <MJRefresh/MJRefresh.h>
#import "MJRefresh.h"
#import "WebIdentityViewController.h"
#import "SendConfirmView.h"

@interface OEP4ViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UIView *topView;
    UIImageView *bgIV;
}
@property(weak, nonatomic) IBOutlet UILabel *balanceL;
@property(weak, nonatomic) IBOutlet UILabel *titleL;
@property(weak, nonatomic) IBOutlet UILabel *unitL;
@property(weak, nonatomic) IBOutlet UILabel *netWorkLabel;
@property(weak, nonatomic) IBOutlet UIImageView *bigIconImage;

@property(weak, nonatomic) IBOutlet UIView *topHeadView;
@property(weak, nonatomic) IBOutlet UITableView *myTable;
@property(weak, nonatomic) IBOutlet UIButton *sendBtn;
@property(weak, nonatomic) IBOutlet UIButton *getBtn;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(weak, nonatomic) IBOutlet UILabel *tardingRecordLabel;
@property(assign, nonatomic) NSInteger page;

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, copy) NSString *ontNumber;
@property(weak, nonatomic) IBOutlet UILabel *claimableL;
@property(weak, nonatomic) IBOutlet UIButton *claimableB;
@property(weak, nonatomic) IBOutlet UIImageView *rightImage;
@property(nonatomic, copy) NSString *claimOngUrlStr;
@property(nonatomic, strong) MBProgressHUD *hub;
@property(weak, nonatomic) IBOutlet UIButton *waitAlert;
@property(nonatomic, assign) BOOL isDraging;
@property(nonatomic, assign) BOOL isUp;
@property(nonatomic, copy) NSString *nowTimeString;
@property(weak, nonatomic) IBOutlet UIButton *redeemB;
@property(weak, nonatomic) IBOutlet UILabel *Unbound;
@property(weak, nonatomic) IBOutlet UILabel *UnboundLB;
@property(nonatomic, copy) NSString *transferHash;
@property(nonatomic, copy) NSString *transferData;
@property(nonatomic, copy) NSString *mypassword;
@end

@implementation OEP4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hub = [ToastUtil showMessage:@"" toView:nil];
    
    NSLog(@"ISONGSELFPAY=%@",[[NSUserDefaults standardUserDefaults] valueForKey:ISONGSELFPAY]);
    // Do any additional setup after loading the view from its nib.
    [self configUI];
    [self setNavTitle:self.tokenDict[@"ShortName"]];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    [self setNavRightImageIcon:[UIImage imageNamed:@"qrdark"] Title:nil];
}

- (void)getData {
    
    self.isUp = NO;
    self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
    self.isDraging = YES;
    _page = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self FetchHistoryData];
    
    _myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isUp = NO;
        self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
        [self FetchHistoryData];
    }];
    _myTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.isUp = YES;
        [self FetchHistoryData];
    }];
}





- (void)claimOngDetail {
    _hub = [ToastUtil showMessage:@"" toView:nil];
    [self FetchHistoryData];
}


- (void)FetchHistoryData {
    
    self.isDraging = YES;
    NSString *jsonstr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonstr];
    
    NSString *address = dict[@"address"];
    NSString *type = self.tokenDict[@"ShortName"];
    
    
    NSString *urlStr =
    [NSString stringWithFormat:@"%@?address=%@&assetName=%@&beforeTimeStamp=%@", New_History_trade, address, type, self
     .nowTimeString];
    
    [[CCRequest shareInstance]
     requestWithURLString1:urlStr MethodType:MethodTypeGET Params:nil Success:^(id responseObject,
                                                                                id responseOriginal) {
         
         [_hub hideAnimated:YES];
         self.isDraging = NO;
         
         for (NSDictionary *dict in [responseObject valueForKey:@"balance"]) {
             
             if ([dict[@"assetName"] isEqualToString:self.tokenDict[@"ShortName"]]) {//getPrecision9Str
                 self.amount = [Common getPrecision9Str:[dict valueForKey:@"balance"] Decimal:[self.tokenDict[@"Decimals"] intValue]];
                 self.balanceL.text = self.amount;
             }
         }
         NSMutableArray *modelArr = [NSMutableArray array];
         for (NSMutableDictionary *dict in [responseObject valueForKey:@"Transfers"]) {
             
             TradeModel *model = [TradeModel modelWithDictionary:dict];
             
             model.myaddress = address;
             [modelArr addObject:model];
             
         }
         NSArray *arr = [responseObject valueForKey:@"Transfers"];
         if (arr.count > 0) {
             NSDictionary *dic = arr.lastObject;
             self.nowTimeString = dic[@"createTimeLong"];
         }
         
         if (self.isUp == NO) {
             self.dataArray = modelArr;
         } else {
             [self.dataArray addObjectsFromArray:modelArr];
         }
         
         self.isUp = NO;
         [self.myTable reloadData];
         [self endRefresh];
     }                 Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
         
         self.isDraging = NO;
         [self endRefresh];
         [Common showToast:Localized(@"Networkerrors")];
         [_hub hideAnimated:YES];
         
     }];
}

- (void)endRefresh {
    
    [self.myTable.mj_header endRefreshing];
    [self.myTable.mj_footer endRefreshing];
    
}

- (IBAction)sendAction:(id)sender {
    NSString *jsonstr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonstr];
    
    SendViewController *sendVC = [[SendViewController alloc] init];
    sendVC.amount = self.amount;
    sendVC.isOng = [_type isEqualToString:@"ONG"] ? YES : NO;
    sendVC.walletAddr = dict[@"address"];
    sendVC.ongAmount = self.ongAmount;
    sendVC.tokenDict = self.tokenDict;
    sendVC.isOEP4 = YES;
    [self.navigationController pushViewController:sendVC animated:YES];
}

- (void)configUI {
    
    if (KIsiPhoneX) {
        self.myTable.height = 430;
    }
    
    _claimableL.hidden = YES;
    _claimableB.hidden = YES;
    _rightImage.hidden = YES;
    _redeemB.hidden = YES;
    self.Unbound.hidden = YES;
    self.UnboundLB.hidden = YES;
    self.waitAlert.hidden = YES;
    
    self.titleL.text = self.tokenDict[@"ShortName"];
    _myTable.delegate = self;
    _myTable.dataSource = self;
    [self setExtraCellLineHidden:self.myTable];
    _myTable.separatorStyle = UITableViewCellSelectionStyleNone;
    _myTable.separatorColor = [UIColor whiteColor];
    self.amount = [Common getPrecision9Str:self.amount Decimal:[self.tokenDict[@"Decimals"] intValue]];
    self.balanceL.text = self.amount;
    //描边
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 1;
    
    [_sendBtn setTitle:Localized(@"Send") forState:UIControlStateNormal];
    
    _tardingRecordLabel.text = Localized(@"Tradingrecord");
    
    if ([_type isEqualToString:@"ONG"]) {
        _bigIconImage.image = [UIImage imageNamed:@"ong_bg"];
    }
    
    _netWorkLabel.text = Localized(@"Netdisconnected");
}

- (void)navLeftAction
{
    //发送刷新钱包界面的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh_Home" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightAction {
    
    GetViewController *getVC = [[GetViewController alloc] init];
    [self.navigationController pushViewController:getVC animated:YES];
    
}

//隐藏tableView多余的行

- (void)setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (USERMODEL.isRefreshList == NO) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                  target:self
                                                selector:@selector(loopFetchHistoryData)
                                                userInfo:nil
                                                 repeats:YES];
        [self getData];
    } else {
        USERMODEL.isRefreshList = NO;
        [self performSelector:@selector(getNewData) withObject:nil afterDelay:1];
    }
    
    [self configNetLabel];
    
}
- (void)getNewData {
    _hub = [ToastUtil showMessage:@"" toView:nil];
    self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
    self.isUp = NO;
    [self getData];
}
- (void)configNetLabel {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.isNetWorkConnect == NO) {
        [self nonNetWork];
    } else {
        [self getNetWork];
    }
    
}

- (void)getNetWork {
    
    _netWorkLabel.hidden = YES;
    
}

- (void)nonNetWork {
    
    _netWorkLabel.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)loopFetchHistoryData {
    
    if (self.isDraging == YES) {
        return;
    }
    self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
    self.isUp = NO;
    [self FetchHistoryData];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"cellid";
    DealCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = (DealCell *) [[[NSBundle mainBundle] loadNibNamed:@"DealCell" owner:self options:nil] lastObject];
    }
    
    cell.isONG = [_type isEqualToString:@"ONG"];
    if (_dataArray.count != 0 || _dataArray.count >= indexPath.row + 1) {//防止奔溃
        cell.model = self.dataArray[indexPath.row];
        
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [tableView tableViewDisplayWitMsg:Localized(@"NOtradingrecord") ifNecessaryForRowCount:_dataArray.count];
    return self.dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArray.count == 0) {
        return;
    }
    
    WebIdentityViewController *vc = [[WebIdentityViewController alloc] init];
    vc.transaction = [self.dataArray[indexPath.row] valueForKey:@"transferhash"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)waitAlertAction:(id)sender {
    WebIdentityViewController *VC = [[WebIdentityViewController alloc] init];
    VC.introduce = [NSString stringWithFormat:@"https://info.onto.app/#/detail/%@",
                    [ENORCN isEqualToString:@"cn"] ? @"57" : @"58"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//让tableView分割线居左的代理方法

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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

