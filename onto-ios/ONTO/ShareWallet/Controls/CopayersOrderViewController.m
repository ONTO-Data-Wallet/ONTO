//
//  CopayersOrderViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/17.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "CopayersOrderViewController.h"
#import "ShareWalletPayDetailViewController.h"
#import "RTDragCellTableView.h"
#import "SequenceCell.h"
#import "BrowserView.h"
#import "ShareWalletTransferAccountsViewController.h"
@interface CopayersOrderViewController ()
    <RTDragCellTableViewDataSource, RTDragCellTableViewDelegate>
@property(nonatomic, strong) RTDragCellTableView *tableView;
@property(nonatomic, strong) UIButton *createBtn;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) NSArray *data;
@property(nonatomic, strong) NSDictionary *walletDic;
@property(nonatomic, strong) BrowserView *browserView;
@property(nonatomic, assign) BOOL isTrade;
@property(nonatomic, assign) BOOL isCreateTrade;
@property(nonatomic, assign) BOOL isSignTrade;
@property(nonatomic, assign) BOOL isOCTrade;
@property(nonatomic, copy) NSString *txData;
@property(nonatomic, copy) NSString *txHash;
@property(nonatomic, strong) NSArray *keyList;
@property(nonatomic, strong) MBProgressHUD *hub;

@end

@implementation CopayersOrderViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DebugLog(@"amout=%@", self.amout);
  [self getData];
  [self createUI];
  [self createNav];
  // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.isTrade = NO;
  self.isCreateTrade = NO;
  self.isSignTrade = NO;
  self.isOCTrade = NO;
}
- (void)createUI {
  self.view.backgroundColor = [UIColor whiteColor];

  [self.view addSubview:self.tableView];
  [self.view addSubview:self.createBtn];
  [self.view addSubview:self.browserView];

}
- (void)getData {
  self.data = [NSArray array];
  NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
  self.walletDic =
      [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
  NSMutableArray *arr = [NSMutableArray array];
  NSMutableArray *keyArr = [NSMutableArray array];
  for (NSDictionary *dic in self.walletDic[@"coPayers"]) {
    [keyArr addObject:dic[@"publickey"]];
    if (![dic[@"address"] isEqualToString:self.nowAddress]) {
      [arr addObject:dic];
    }
  }
  self.data = arr;
  self.keyList = keyArr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60 * SCALE_W;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"orderID";
  SequenceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[SequenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  NSDictionary *dic = self.data[indexPath.row];
  cell.numLB.text = [NSString stringWithFormat:@"%ld", indexPath.row + 2];
  cell.addressLB.text =
      [NSString stringWithFormat:@"%@ %@", Localized(@"shareAddress"), dic[@"address"]];//dic[@"address"];
  cell.nameLB.text = dic[@"name"];
  return cell;
}
- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView {
  return _data;
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray {
  _data = newArray;
  [tableView reloadData];
}

- (void)createNav {
  [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];

}
- (void)navLeftAction {
  [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[RTDragCellTableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, SYSWidth, SYSHeight - 49 - 64);
    if (KIsiPhoneX) {
      _tableView.frame = CGRectMake(0, 0, SYSWidth, SYSHeight - 49 - 64 - 34 - 24);
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = YES;
    _tableView.tableHeaderView = self.topView;
  }
  return _tableView;
}

- (UIButton *)createBtn {
  if (!_createBtn) {
    _createBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SYSHeight - 64 - 49, SYSWidth, 49)];
    if (KIsiPhoneX) {
      _createBtn.frame = CGRectMake(0, SYSHeight - 64 - 49 - 34 - 24, SYSWidth, 49);
    }
    [_createBtn setTitle:Localized(@"ShareComplete") forState:UIControlStateNormal];
    [_createBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    _createBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
    [_createBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
      if (self.isTrade == YES) {
        self.isTrade = NO;
        return;
      }
      self.isTrade = YES;
      self.isCreateTrade = YES;
      [self loadJS];
    }];
  }
  return _createBtn;
}

- (UIView *)topView {
  if (!_topView) {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYSWidth, 161 * SCALE_W)];
    _topView.backgroundColor = [UIColor whiteColor];

    UILabel *titleLB =
        [[UILabel alloc] initWithFrame:CGRectMake(20 * SCALE_W, 12 * SCALE_W, SYSWidth - 40 * SCALE_W, 17 * SCALE_W)];
    titleLB.textAlignment = NSTextAlignmentLeft;
    titleLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleLB.text = Localized(@"Sponsor");
    titleLB.textColor = [UIColor colorWithHexString:@"#6A797C"];
    [_topView addSubview:titleLB];

    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 44 * SCALE_W, SYSWidth, 60 * SCALE_W)];
    bgV.backgroundColor = [UIColor colorWithHexString:@"#EDF2F5"];
    [_topView addSubview:bgV];

    UIImageView *numImage =
        [[UIImageView alloc] initWithFrame:CGRectMake(20 * SCALE_W, 12 * SCALE_W, 15 * SCALE_W, 15 * SCALE_W)];
    numImage.image = [UIImage imageNamed:@"sharecircleblue"];
    [bgV addSubview:numImage];

    UILabel *numLB = [[UILabel alloc] initWithFrame:CGRectMake(20 * SCALE_W, 12 * SCALE_W, 15 * SCALE_W, 15 * SCALE_W)];
    numLB.textColor = BLUELB;
    numLB.textAlignment = NSTextAlignmentCenter;
    numLB.text = @"1";
    numLB.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [bgV addSubview:numLB];

    UILabel *nameLB =
        [[UILabel alloc] initWithFrame:CGRectMake(41 * SCALE_W, 12 * SCALE_W, SYSWidth - 61 * SCALE_W, 15 * SCALE_W)];
    nameLB.textAlignment = NSTextAlignmentLeft;
    nameLB.textColor = BLACKLB;
    nameLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    nameLB.text = self.selectDic[@"label"];
    [bgV addSubview:nameLB];

    UILabel *addressLB =
        [[UILabel alloc] initWithFrame:CGRectMake(41 * SCALE_W, 33 * SCALE_W, SYSWidth - 61 * SCALE_W, 15 * SCALE_W)];
    addressLB.textAlignment = NSTextAlignmentLeft;
    addressLB.textColor = BLACKLB;
    addressLB.font = [UIFont systemFontOfSize:12];
    addressLB.text = [NSString stringWithFormat:@"%@ %@", Localized(@"shareAddress"), self.selectDic[@"address"]];
    [bgV addSubview:addressLB];

    UILabel *alertLB =
        [[UILabel alloc] initWithFrame:CGRectMake(20 * SCALE_W, 134 * SCALE_W, SYSWidth - 40 * SCALE_W, 17 * SCALE_W)];
    alertLB.textAlignment = NSTextAlignmentLeft;
    alertLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    alertLB.text = Localized(@"DragSequence");
    alertLB.textColor = [UIColor colorWithHexString:@"#6A797C"];
    [_topView addSubview:alertLB];
  }
  return _topView;
}
- (void)loadJS {

  if (self.isCreateTrade == YES) {

    NSString *jsStr =
        [NSString stringWithFormat:@" Ont.SDK.makeMultiSignTransaction('%@','%@','%@','%@','%@','%@','makeMultiSignTransaction')",
                                   self.isONT ? @"ONT" : @"ONG", self.fromAddress, self.toAddress,
                                   self.isONT ? self.amout : [Common getONGMul10_9Str:self.amout],
                                   self.gasPrice, self.gasLimit];
    LOADJS1;
    LOADJS2;
    LOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
  }

  if (self.isSignTrade == YES) {
    NSString *jsStr1 =
        [NSString stringWithFormat:@" Ont.SDK.signMultiAddrTransaction('%@','%@','%@','%@','%@','%@','%@','signMultiAddrTransaction')", self
            .selectDic[@"key"], self.nowAddress, self.selectDic[@"salt"], [Common transferredMeaning:self
            .selectPWD], [self arrayToJSONString:self.keyList], self.walletDic[@"requiredNumber"], self.txData];

    LOADJS1;
    LOADJS2;
    LOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr1 completionHandler:nil];
  }

}
- (void)handlePrompt:(NSString *)prompt {

  [MBProgressHUD hideHUDForView:self.view animated:YES];
  NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
  NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[obj valueForKey:@"error"]]];
//        [ToastUtil shortToast:self.view value:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[obj valueForKey:@"error"]]];
    self.isTrade = NO;
    self.isCreateTrade = NO;
    self.isSignTrade = NO;
    self.isOCTrade = NO;
    return;
  }
  if ([prompt hasPrefix:@"makeMultiSignTransaction"]) {
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
      self.txData = obj[@"txData"];
      self.txHash = obj[@"txHash"];
      if (self.isCreateTrade == YES) {
        self.isCreateTrade = NO;
        self.isSignTrade = YES;
        [self loadJS];
      }
    }
  }
  if ([prompt hasPrefix:@"signMultiAddrTransaction"]) {
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
      if (self.isSignTrade == YES) {
        self.isSignTrade = NO;
        self.txData = obj[@"signedHash"];
        [self createOCTrade];
      }
      self.isSignTrade = NO;
    }
  }
}
- (void)createOCTrade {
  _hub = [ToastUtil showMessage:@"" toView:nil];
  NSMutableArray *arr = [NSMutableArray array];
//    [arr addObject:self.selectDic];
  for (NSDictionary *dic in self.walletDic[@"coPayers"]) {
    if ([dic[@"address"] isEqualToString:self.nowAddress]) {
      [arr addObject:dic];
    }
  }
  [arr addObjectsFromArray:self.data];
  NSDictionary *params =
      @{@"sendAddress": self.fromAddress,
          @"receiveAddress": self.toAddress,
          @"assetName": self.isONT ? @"ont" : @"ong",
          @"amount": self.isONT ? self.amout : [Common getONGMul10_9Str:self.amout],
          @"gasLimit": self.gasLimit,
          @"gasPrice": self.gasPrice,
          @"transactionIdHash": self.txHash,
          @"transactionBodyHash": self.txData,
          @"coPayers": arr};

  [[CCRequest shareInstance]
      requestWithHMACAuthorization:CreateSharedWalletTrade MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                                             id responseOriginal) {
    [_hub hideAnimated:YES];
    for (UIViewController *controller in self.navigationController.viewControllers) {
      if ([controller isKindOfClass:[ShareWalletTransferAccountsViewController class]]) {
        [self.navigationController popToViewController:controller animated:YES];

      }

    }

  }Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
    [_hub hideAnimated:YES];
    self.isTrade = NO;
    self.isCreateTrade = NO;
    self.isSignTrade = NO;
    self.isOCTrade = NO;
        [Common showToast:Localized(@"Networkerrors")];
//        [ToastUtil shortToast:self.view value:Localized(@"Networkerrors")];

  }];
}
- (void)signOCTradeByTxHash:(NSString *)txHash txData:(NSString *)txData {
  NSDictionary *params = @{@"signedAddress": self.nowAddress, @"transactionIdHash": self.txHash, @"signedHash": txData};
  [[CCRequest shareInstance]
      requestWithHMACAuthorization:SignSharedWalletTrade MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                                           id responseOriginal) {

    for (UIViewController *controller in self.navigationController.viewControllers) {
      if ([controller isKindOfClass:[ShareWalletTransferAccountsViewController class]]) {
        [self.navigationController popToViewController:controller animated:YES];

      }

    }

  }                        Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
    self.isTrade = NO;
    self.isCreateTrade = NO;
    self.isSignTrade = NO;
    self.isOCTrade = NO;
        [Common showToast:Localized(@"Networkerrors")];

  }];
}
- (BrowserView *)browserView {
  if (!_browserView) {
    _hub = [ToastUtil showMessage:@"" toView:nil];

    _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [_browserView setCallbackPrompt:^(NSString *prompt) {
      [weakSelf handlePrompt:prompt];
    }];
    [_browserView setCallbackJSFinish:^{
      [_hub hideAnimated:YES];
    }];
  }
  return _browserView;
}
- (NSString *)arrayToJSONString:(NSArray *)array {
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
  return jsonResult;
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
