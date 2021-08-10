//
//  CapitalViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/16.
/*
 * **************************************************************************************
 *  Copyright © 2014-2018 Ontology Foundation Ltd.
 *  All rights reserved.
 *
 *  This software is supplied only under the terms of a license agreement,
 *  nondisclosure agreement or other written agreement with Ontology Foundation Ltd.
 *  Use, redistribution or other disclosure of any parts of this
 *  software is prohibited except in accordance with the terms of such written
 *  agreement with Ontology Foundation Ltd. This software is confidential
 *  and proprietary information of Ontology Foundation Ltd.
 *
 * **************************************************************************************
 *///

#import "CapitalDetailViewController.h"
#import "DealCell.h"
#import "GetViewController.h"
#import "SendViewController.h"
#import "UITableView+EmptyData.h"
#import "UIView+Scale.h"
#import <MJRefresh/MJRefresh.h>
#import "MJRefresh.h"
#import "WebIdentityViewController.h"
#import "SendConfirmView.h"

@interface CapitalDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
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
@property(nonatomic, strong) SendConfirmView *sendConfirmV;
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

@implementation CapitalDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];

    NSLog(@"ISONGSELFPAY=%@",[[NSUserDefaults standardUserDefaults] valueForKey:ISONGSELFPAY]);
  // Do any additional setup after loading the view from its nib.
  [self configUI];
  [self setNavTitle:self.type];
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

- (SendConfirmView *)sendConfirmV {

  if (!_sendConfirmV) {

    _sendConfirmV =
        [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
    __weak typeof(self) weakSelf = self;
    [_sendConfirmV setCallback:^(NSString *token,
                                 NSString *from,
                                 NSString *to,
                                 NSString *value,
                                 NSString *password) {
      DebugLog(@"password=%@", [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]);
      weakSelf.mypassword = password;
      [weakSelf.sendConfirmV dismiss];
        weakSelf.hub = [ToastUtil showMessage:@"" toView:nil];
        [weakSelf.hub hideAnimated:YES afterDelay:5];
      if ([[NSUserDefaults standardUserDefaults] boolForKey:ISONGSELFPAY] == NO
          && [self.ontAmount integerValue] >= 1
          && [Common isEnoughUnboundONG:self.UnboundLB.text]
          ) {

        //代付时如果已解绑的ong大于0.05 ont大于1时候,先给自己转一个ont把解绑的ong移到未提取
        weakSelf.claimOngUrlStr =
            [NSString stringWithFormat:@"Ont.SDK.transferAssets('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','sendTransferAssets')",
                                       @"ONT",
                                       weakSelf.walletDict[@"address"],
                                       weakSelf.walletDict[@"address"],
                                       @"1",
                                       weakSelf.walletDict[@"key"],
                                       [Common transferredMeaning:password],
                                       weakSelf.walletDict[@"salt"],
                                       [[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASPRICE],
                                       [[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASLIMIT],
                                       [[NSUserDefaults standardUserDefaults] valueForKey:ONTPASSADDRSS]];
      } else {

        NSString *address = [[NSUserDefaults standardUserDefaults] boolForKey:ISONGSELFPAY] == YES ?
            weakSelf.walletDict[@"address"] : [[NSUserDefaults standardUserDefaults] valueForKey:ONTPASSADDRSS];

        // 提取claimable的ONG
        NSString *decimalONG10_9_str = [Common getONGMul10_9Str:weakSelf.ongAppove];
        weakSelf.claimOngUrlStr =
            [NSString stringWithFormat:@"Ont.SDK.claimOng('%@','%@','%@','%@','%@','%@','%@','%@','claimOng')",
                                       weakSelf.walletDict[@"address"],
                                       decimalONG10_9_str,
                                       weakSelf.walletDict[@"key"],
                                       [Common transferredMeaning:password],
                                       weakSelf.walletDict[@"salt"],
                                       [[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASPRICE],
                                       [[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASLIMIT],
                                       address];
      }



      //节点方法 每次调用JSSDK前都必须调用
      [weakSelf loadJS];

    }];
  }
  return _sendConfirmV;
}

- (void)loadJS {

  [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:self.claimOngUrlStr completionHandler:nil];
  __weak typeof(self) weakSelf = self;
  [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
    [weakSelf handlePrompt:prompt];
  }];
}

// TODO: 流程分叉太多，已经导致人难以阅读，需要优化重构
- (void)handleClaimONG:(id)obj {

  _hub = [ToastUtil showMessage:@"" toView:nil];

  NSDictionary *params;

  if ([[NSUserDefaults standardUserDefaults] boolForKey:ISONGSELFPAY] == YES) {
    //自付
    params = @{
        @"sendAddress": _walletDict[@"address"],
        @"receiveAddress": _walletDict[@"address"],
        @"assetName": @"ong",
        @"amount": [Common getONGMul10_9Str:self.ongAppove],
        @"txBodyHash": [obj valueForKey:@"tx"],
        @"txIdHash": [obj valueForKey:@"txHash"]
    };
  } else {

    if ([[NSUserDefaults standardUserDefaults] boolForKey:ISONGSELFPAY] == NO
        && [self.ontAmount integerValue] >= 1
        && [Common isEnoughUnboundONG:self.UnboundLB.text]) {

      // 只有unbound ong足够的时候，才会走这里，构造两笔交易，服务器判断第一笔交易成功再提取ong
      params = @{
          @"transferHash": self.transferHash,
          @"transferData": self.transferData,
          @"claimHash": [obj valueForKey:@"txHash"],
          @"claimData": [obj valueForKey:@"tx"]
      };

      [[CCRequest shareInstance]
          requestWithHMACAuthorization:PayforClaimOng MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                                        id responseOriginal) {
        [_hub hideAnimated:YES];
        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
          MGPopController *pop = [[MGPopController alloc]
              initWithTitle:[NSString stringWithFormat:@"%@:%@", Localized(@"Systemerror"), [responseOriginal valueForKey:@"error"]]
                    message:nil image:nil];
          MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

          }];
          action.titleColor = MainColor;
          [pop addAction:action];
          [pop show];
          pop.showCloseButton = NO;

          return;

        }
        _page = 1;
        self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
        self.isUp = NO;
        [self performSelector:@selector(claimOngDetail) withObject:nil afterDelay:1];

        _redeemB.layer.borderColor = [UIColor colorWithHexString:@"#868686"].CGColor; //要设置的颜色
        [_redeemB setTitleColor:[UIColor colorWithHexString:@"#868686"] forState:UIControlStateNormal];
        _redeemB.enabled = NO;

        _ongAppove = ONG_ZERO;
        [self.claimableB setTitle:ONG_ZERO forState:UIControlStateNormal];
        [Common showToast:Localized(@"sendSuccess")];

      }                        Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        [Common showToast:Localized(@"Networkerrors")];
        [_hub hideAnimated:YES];

      }];

      return;

    } else {
      params = @{
          @"SendAddress": _walletDict[@"address"],
          @"ReceiveAddress": _walletDict[@"address"],
          @"AssetName": @"ong",
          @"Amount": [Common getONGMul10_9Str:self.ongAppove],
          @"TxnStr": [obj valueForKey:@"tx"]
      };
    }
  }

  CCSuccess successCallBack = ^(id responseObject, id responseOriginal) {

    [_hub hideAnimated:YES];
    if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {

      MGPopController *pop = [[MGPopController alloc]
          initWithTitle:[NSString stringWithFormat:@"%@:%@", Localized(@"Systemerror"), [responseOriginal valueForKey:@"error"]] message:nil image:nil];
      MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

      }];
      action.titleColor = MainColor;
      [pop addAction:action];
      [pop show];
      pop.showCloseButton = NO;

      return;
    }

    _page = 1;
    self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
    self.isUp = NO;
    [self performSelector:@selector(claimOngDetail) withObject:nil afterDelay:1];

    _ongAppove = ONG_ZERO;
    [self.claimableB setTitle:ONG_ZERO forState:UIControlStateNormal];
    [Common showToast:Localized(@"sendSuccess")];
  };

  CCFailure failureCallBack = ^(NSError *error, NSString *errorDesc, id responseOriginal) {
    [Common showToast:Localized(@"Networkerrors")];
    [_hub hideAnimated:YES];
  };

  bool selfPay = [[NSUserDefaults standardUserDefaults] boolForKey:ISONGSELFPAY];
  if (selfPay) {
    [[CCRequest shareInstance]
        requestWithURLStringNoLoading:Assettransfer MethodType:MethodTypePOST
                               Params:params Success:successCallBack Failure:failureCallBack];
  } else {
    [[CCRequest shareInstance]
        requestWithHMACAuthorization:AssettransferotherPay MethodType:MethodTypePOST
                              Params:params Success:successCallBack Failure:failureCallBack];
  }
}

- (void)handlePrompt:(NSString *)prompt {
  [_hub hideAnimated:YES];

  NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
  NSString *resultStr = [promptArray[1] dataUsingEncoding:NSUTF8StringEncoding];
  id obj = [NSJSONSerialization JSONObjectWithData:resultStr options:0 error:nil];

  if ([[obj valueForKey:@"error"] integerValue] > 0) {
    if ([[obj valueForKey:@"error"] integerValue] == 53000) {
      [Common showToast:Localized(@"PASSWORDERROR")];
    } else {
      [Common showToast:[NSString stringWithFormat:@"%@:%@", Localized(@"Systemerror"), [obj valueForKey:@"error"]]];
    }
    return;
  }

  if ([prompt hasPrefix:@"claimOng"]) {

    //js-sdk prompt claimOng, 说明前面unbound ong不足以发起自转账，所以直接提取ong
    //注意提取ong的时候，sdk只能构造交易，发送交易需要自己发送；但是发送资产，sdk会直接上链
    [self handleClaimONG:obj];

  } else if ([prompt hasPrefix:@"sendTransferAssets"]) {

    //前面sendTransferAssets是构造了一笔自转账，所以到这里是要claimOng了，这个时候unbound ong已经到claimableong了

    _transferHash = [obj valueForKey:@"txHash"];
    _transferData = [obj valueForKey:@"tx"];

    NSDecimalNumber *decimalONG = [[NSDecimalNumber alloc] initWithString:self.ongAppove];
    NSDecimalNumber *decimalUnboundONG = [[NSDecimalNumber alloc] initWithString:self.UnboundLB.text];
    NSDecimalNumber *claimONG = [decimalONG decimalNumberByAdding:decimalUnboundONG];
    NSString *claimONG10_9str = [Common getONGMul10_9Str:claimONG.stringValue];

    NSString *address =
        [[NSUserDefaults standardUserDefaults] boolForKey:ISONGSELFPAY] == YES ? self.walletDict[@"address"] :
            [[NSUserDefaults standardUserDefaults] valueForKey:ONTPASSADDRSS];

    self.claimOngUrlStr =
        [NSString stringWithFormat:@"Ont.SDK.claimOng('%@','%@','%@','%@','%@','%@','%@','%@','claimOng')",
                                   self.walletDict[@"address"],
                                   claimONG10_9str,
                                   self.walletDict[@"key"],
                                   [Common transferredMeaning:self.mypassword],
                                   self.walletDict[@"salt"],
                                   [[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASPRICE],
                                   [[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASLIMIT],
                                   address];

    //节点方法 每次调用JSSDK前都必须调用
    [self loadJS];

  }

}

- (void)claimOngDetail {
  _hub = [ToastUtil showMessage:@"" toView:nil];
  [self FetchHistoryData];
}

static NSString *extracted() {
  return New_History_trade;
}

- (void)FetchHistoryData {

    self.isDraging = YES;
    _hub = [ToastUtil showMessage:@"" toView:nil];
    [_hub hideAnimated:YES afterDelay:5];
    NSString *jsonstr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonstr];

    NSString *address = dict[@"address"];
    NSString *type;
    if ([_type isEqualToString:@"ONG"]) {
        type = @"ong";
    } else {
        type = @"ont";
        
    }

  NSString *urlStr =
      [NSString stringWithFormat:@"%@?address=%@&assetName=%@&beforeTimeStamp=%@", New_History_trade, address, type, self
          .nowTimeString];

  [[CCRequest shareInstance]
      requestWithURLString1:urlStr MethodType:MethodTypeGET Params:nil Success:^(id responseObject,
                                                                                 id responseOriginal) {

    [_hub hideAnimated:YES];
    self.isDraging = NO;
    for (NSDictionary *dict in [responseObject valueForKey:@"balance"]) {

      if ([dict[@"assetName"] isEqualToString:@"ont"]) {
        self.amount = [dict valueForKey:@"balance"];
      }

      if ([dict[@"assetName"] isEqualToString:@"ong"]) {
        self.amount = [dict valueForKey:@"balance"];
        // 由于这个节目在ont和ong的时候是复用的，在ont界面中amount表示ont总量，ongAmount表示ong总量。
        // 在ong界面中amount和ongAmount一样
        self.ongAmount = self.amount;
      }

      if ([dict[@"assetName"] isEqualToString:@"waitboundong"]) {
        _UnboundLB.text = [Common getPrecision9Str:[dict valueForKey:@"balance"]];
        if ([_UnboundLB.text isEqualToString:@"0"]) {
          _UnboundLB.text = ONG_ZERO;
        }
      }
    }

    _balanceL.text = _amount;
    if ([_type isEqualToString:@"ONG"]) {
      _balanceL.text = _amount;
      if ([self.balanceL.text isEqualToString:@"0"]) {
        self.balanceL.text = ONG_ZERO;
      }
    }

    DebugLog(@"@---------self.amount - %@",self.amount);
    DebugLog(@"@---------self.ongAmount - %@",self.ongAmount);
    self.unitL.text = [NSString stringWithFormat:@"%@%@", [_GoalType isEqualToString:@"CNY"] ? @"¥" :
        @"$", [Common countNumAndChangeformat:[Common getMoney:self.amount Exchange:self.exchange]]];

    if ([_type isEqualToString:@"ONG"]) {
      self.unitL.text = [NSString stringWithFormat:@"%@%@", [_GoalType isEqualToString:@"CNY"] ? @"¥" : @"$", @"0"];
    }
    if ([_type isEqualToString:@"ONG"]) {
      self.unitL.hidden = YES;
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
  [self.navigationController pushViewController:sendVC animated:YES];
}

- (void)configUI {

  if (KIsiPhoneX) {
    self.myTable.height = 430;
  }

  if (![_type isEqualToString:@"ONG"]) {

    _claimableL.hidden = YES;
    _claimableB.hidden = YES;
    _rightImage.hidden = YES;
    _redeemB.hidden = YES;
    self.Unbound.hidden = YES;
    self.UnboundLB.hidden = YES;
    self.waitAlert.hidden = YES;
  } else {
    self.Unbound.text = Localized(@"waitboundong");
    self.UnboundLB.text = [Common getPrecision9Str:_waitboundong];
    if ([self.UnboundLB.text isEqualToString:@"0"]) {
      self.UnboundLB.text = ONG_ZERO;
    }
    [self.waitAlert setEnlargeEdge:20];
  }
  _claimableL.text = Localized(@"UNCLAIMEDONG");
  [_claimableB setTitle:_ongAppove forState:UIControlStateNormal];
  if ([_claimableB.titleLabel.text isEqualToString:@"0"]) {
    [_claimableB setTitle:ONG_ZERO forState:UIControlStateNormal];
  }

  self.titleL.text = self.type;
  _myTable.delegate = self;
  _myTable.dataSource = self;
  [self setExtraCellLineHidden:self.myTable];
  _myTable.separatorStyle = UITableViewCellSelectionStyleNone;
  _myTable.separatorColor = [UIColor whiteColor];


  //描边
  _sendBtn.layer.masksToBounds = YES;
  _sendBtn.layer.cornerRadius = 1;

  _getBtn.layer.masksToBounds = YES;
  _getBtn.layer.cornerRadius = 1;
  _getBtn.layer.borderWidth = 0.5;
  _getBtn.layer.borderColor = [UIColor colorWithHexString:@"#1a78bb"].CGColor; //要设置的颜色

  [_sendBtn setTitle:Localized(@"Send") forState:UIControlStateNormal];
  [_getBtn setTitle:Localized(@"Get") forState:UIControlStateNormal];

  _tardingRecordLabel.text = Localized(@"Tradingrecord");

  if ([_type isEqualToString:@"ONG"]) {
    _bigIconImage.image = [UIImage imageNamed:@"ong_bg"];
  }

  _netWorkLabel.text = Localized(@"Netdisconnected");

  _redeemB.layer.masksToBounds = YES;
  _redeemB.layer.cornerRadius = 2;

  _redeemB.layer.masksToBounds = YES;
  _redeemB.layer.cornerRadius = 3;
  _redeemB.layer.borderWidth = 0.5;
  _redeemB.layer.borderColor = [UIColor colorWithHexString:@"#35BFDF"].CGColor; //要设置的颜色
  [_redeemB setTitle:Localized(@"Redeem") forState:UIControlStateNormal];
}

- (IBAction)redeemClick:(id)sender {

  NSString *price = [[[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASPRICE] stringValue];
  NSString *limit = [[[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASLIMIT] stringValue];
  NSString *fee = [Common getRealFee:price GasLimit:limit];
  NSDecimalNumber *d_fee = [[NSDecimalNumber alloc] initWithString:fee];

  NSDecimalNumber *d_ongAmount = [[NSDecimalNumber alloc] initWithString:_ongAmount];
  NSDecimalNumber *d_ongAppove = [[NSDecimalNumber alloc] initWithString:_ongAppove];
  NSComparisonResult resultOfongAmountAndFee = [d_ongAmount compare:d_fee];

  if ([[NSUserDefaults standardUserDefaults] boolForKey:ISONGSELFPAY] == YES) {

    if (resultOfongAmountAndFee == NSOrderedAscending
        || [d_ongAppove isEqualToNumber:[NSDecimalNumber notANumber]]
        || [d_ongAppove compare:[NSDecimalNumber zero]] == NSOrderedSame
        ) {

      MGPopController
          *pop = [[MGPopController alloc] initWithTitle:Localized(@"NotenoughCarryONG") message:@"" image:nil];
      MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

      }];
      action.titleColor = MainColor;

      [pop addAction:action];
      [pop show];
      pop.showCloseButton = NO;

      return;
    }else {
        
        MGPopController *pop =
        [[MGPopController alloc] initWithTitle:Localized(@"Notice") message:Localized(@"Eachredeem") image:nil];
        MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"IUnderstand") action:^{
            [self.view addSubview:self.sendConfirmV];
            self.sendConfirmV.paybyStr = @"";
            self.sendConfirmV.amountStr = @"";
            self.sendConfirmV.isCapital = YES;
            [self.sendConfirmV show];
        }];
        action.titleColor = MainColor;
        
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
    }

  } else if ([[NSUserDefaults standardUserDefaults] boolForKey:ISONGSELFPAY] == NO) {
    [self ongNoSelfPay];

  }
}
- (void)ongNoSelfPay {
  //代付时如果已解绑的ong大于0.05 ont大于1时候,先给自己转一个ont把解绑的ong移到未提取

  if ([self.ontAmount longValue] >= 1 && [Common isEnoughUnboundONG:self.UnboundLB.text]) {
    MGPopController *pop = [[MGPopController alloc]
        initWithTitle:Localized(@"Notice") message:Localized(@"PressingRedeem") image:nil];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"IUnderstand") action:^{
      [self.view addSubview:self.sendConfirmV];
      self.sendConfirmV.paybyStr = @"";
      self.sendConfirmV.amountStr = @"";
      self.sendConfirmV.isCapital = YES;
      [self.sendConfirmV show];
    }];
    action.titleColor = MainColor;

    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;

  } else if (![Common isEnoughClaimableONG:_ongAppove]) {
    [Common showToast:Localized(@"NOONG")];
  } else {
    [self.view addSubview:self.sendConfirmV];
    self.sendConfirmV.paybyStr = @"";
    self.sendConfirmV.amountStr = @"";
    self.sendConfirmV.isCapital = YES;
    [self.sendConfirmV show];
  }
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
//    _timer = [NSTimer scheduledTimerWithTimeInterval:10.0
//                                              target:self
//                                            selector:@selector(loopFetchHistoryData)
//                                            userInfo:nil
//                                             repeats:YES];
    [self getData];
  } else {
    USERMODEL.isRefreshList = NO;
    [self performSelector:@selector(getNewData) withObject:nil afterDelay:1];
  }

  [self configNetLabel];

}
- (void)getNewData {
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
    if ([_type isEqualToString:@"ONG"]) {
        _UnboundLB.hidden = NO;
    }
}

- (void)nonNetWork {
    _netWorkLabel.hidden = NO;
    if ([_type isEqualToString:@"ONG"]) {
        _UnboundLB.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_timer invalidate];
  _timer = nil;
}

//- (void)loopFetchHistoryData {
//
//  if (self.isDraging == YES) {
//    return;
//  }
//  self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
//  self.isUp = NO;
//  [self FetchHistoryData];
//}

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

