//
//  ShareWalletTransferAccountsViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ShareWalletTransferAccountsViewController.h"
#import "ShareWalletDetailViewController.h"
#import "MoneyDetailViewController.h"
#import "MoneyDetailDoneViewController.h"
#import "SendViewController.h"
#import "WebIdentityViewController.h"

@interface ShareWalletTransferAccountsViewController ()
@property(nonatomic, strong) UIButton *createBtn;
@property(nonatomic, strong) UILabel *moneyNum;
@property(nonatomic, strong) UILabel *moneyNumChange;
@property(nonatomic, strong) UILabel *waitOngLB;
@property(nonatomic, strong) UIButton *alertBtn;
@property(nonatomic, strong) UILabel *ClaimableONG;
@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, copy) NSString *nowTimeString;

@end

@implementation ShareWalletTransferAccountsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createUI];
  [self createNav];

  // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [_timer invalidate];
  _timer = nil;
  _timer =
      [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(scheduledTimerFunction) userInfo:nil repeats:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_timer invalidate];
  _timer = nil;
}
- (void)createUI {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.createBtn];

  UIImageView *logoImage =
      [[UIImageView alloc] initWithFrame:CGRectMake(SYSWidth - 151 * SCALE_W, 0, 151 * SCALE_W, 170 * SCALE_W)];
  logoImage.image = [UIImage imageNamed:@"newong_bg"];
  [self.view addSubview:logoImage];

  _moneyNum =
      [[UILabel alloc] initWithFrame:CGRectMake(16 * SCALE_W, 16 * SCALE_W, SYSWidth - 32 * SCALE_W, 32 * SCALE_W)];
  _moneyNum.font = [UIFont systemFontOfSize:32 weight:UIFontWeightMedium];
  _moneyNum.textAlignment = NSTextAlignmentLeft;
  _moneyNum.textColor = BLACKLB;

  if (self.isONT) {
    _moneyNum.text = [Common countNumAndChangeformat:_amount];
  } else {
    _moneyNum.text = [Common getPrecision9Str:_amount];
    if ([_moneyNum.text isEqualToString:@"0"]) {
      _moneyNum.text = ONG_ZERO;
    }
  }
  [self.view addSubview:_moneyNum];

  if (self.isONT) {

    NSString *moneyPrefix = [_GoalType isEqualToString:@"CNY"] ? @"¥" : @"$";
    NSString *menoy = [Common countNumAndChangeformat:[Common getMoney:self.amount Exchange:self.exchange]];
    NSString *moneyNumChangeStr = [NSString stringWithFormat:@"%@%@", moneyPrefix, menoy];

    CGSize strSize = [moneyNumChangeStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    CGRect rectNumChange = CGRectMake(16 * SCALE_W, 54 * SCALE_W, strSize.width, 18 * SCALE_W);
    _moneyNumChange = [[UILabel alloc] initWithFrame:rectNumChange];
    _moneyNumChange.textColor = LIGHTGRAYLB;
    _moneyNumChange.textAlignment = NSTextAlignmentLeft;
    _moneyNumChange.text = moneyNumChangeStr;
    _moneyNumChange.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_moneyNumChange];

    CGRect rectAlertBtn = CGRectMake(25 * SCALE_W + strSize.width, 56 * SCALE_W, 14 * SCALE_W, 14 * SCALE_W);
    _alertBtn = [[UIButton alloc] initWithFrame:rectAlertBtn];
    [_alertBtn setImage:[UIImage imageNamed:@"pwdAlert"] forState:UIControlStateNormal];

    [_alertBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
      MGPopController *pop = [[MGPopController alloc]
          initWithTitle:@""
                message:Localized(@"Referenceonly")
                  image:[UIImage imageNamed:@"notice_light_gray"]];
      MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{}];
      action.titleColor = MainColor;
      [pop addAction:action];
      [pop show];
      pop.showCloseButton = NO;
    }];
    [self.view addSubview:_alertBtn];
  }

  //TODO: 不知道为啥一直在计算大小，为啥不用autolayout
  CGSize claimableLBStrSize = [Localized(@"ClaimableONG")
      sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightMedium]}];
  CGSize waitboundongSize = [Localized(@"waitboundong")
      sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightMedium]}];
  CGSize redeemSize = [Localized(@"redeemComing")
      sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightMedium]}];

  if (self.isONT == NO) {

    CGRect rectClaimableLB = CGRectMake(16 * SCALE_W, 78 * SCALE_W, claimableLBStrSize.width, 14 * SCALE_W);
    UILabel *claimableLB = [[UILabel alloc] initWithFrame:rectClaimableLB];
    claimableLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    claimableLB.textColor = LIGHTGRAYLB;
    claimableLB.textAlignment = NSTextAlignmentLeft;
    claimableLB.text = Localized(@"ClaimableONG");
    [self.view addSubview:claimableLB];

    UIButton *RedeemBtn = [[UIButton alloc] initWithFrame:CGRectMake(31 * SCALE_W + claimableLBStrSize.width,
                                                                     75 * SCALE_W,
                                                                     redeemSize.width + 8 * SCALE_W,
                                                                     20 * SCALE_W)];

    RedeemBtn.backgroundColor = [UIColor colorWithHexString:@"#37C0E8"];
    [RedeemBtn setTitle:Localized(@"redeemComing") forState:UIControlStateNormal];
    [RedeemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RedeemBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    RedeemBtn.layer.cornerRadius = 2;
    [self.view addSubview:RedeemBtn];

    _ClaimableONG = [[UILabel alloc]
        initWithFrame:CGRectMake(16 * SCALE_W, 102 * SCALE_W, SYSWidth - 32 * SCALE_W, 18 * SCALE_W)];
    _ClaimableONG.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _ClaimableONG.textAlignment = NSTextAlignmentLeft;
    _ClaimableONG.textColor = BLACKLB;
    _ClaimableONG.text = [Common getPrecision9Str:_ongAppove];

    if ([_ClaimableONG.text isEqualToString:@"0"]) {
      _ClaimableONG.text = ONG_ZERO;
    }

    [self.view addSubview:_ClaimableONG];

    UIButton *ClaimableBtn =
        [[UIButton alloc] initWithFrame:CGRectMake(16 * SCALE_W, 127 * SCALE_W, 70 * SCALE_W, 24 * SCALE_W)];
    [ClaimableBtn setTitle:Localized(@"Redeem") forState:UIControlStateNormal];
    [ClaimableBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    ClaimableBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    ClaimableBtn.layer.cornerRadius = 2;
    ClaimableBtn.layer.borderWidth = 0.5;
    ClaimableBtn.layer.borderColor = [BLUELB CGColor];

    UILabel *waitLB = [[UILabel alloc]
        initWithFrame:CGRectMake(16 * SCALE_W, 130 * SCALE_W, waitboundongSize.width, 18 * SCALE_W)];
    waitLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    waitLB.textColor = LIGHTGRAYLB;
    waitLB.textAlignment = NSTextAlignmentLeft;
    waitLB.text = Localized(@"waitboundong");
    [self.view addSubview:waitLB];

    UIButton *alertV = [[UIButton alloc]
        initWithFrame:CGRectMake(25 * SCALE_W + waitboundongSize.width, 133 * SCALE_W, 14 * SCALE_W, 14 * SCALE_W)];
    [alertV setImage:[UIImage imageNamed:@"pwdAlert"] forState:UIControlStateNormal];
    [alertV handleControlEvent:UIControlEventTouchUpInside withBlock:^{
      WebIdentityViewController *VC = [[WebIdentityViewController alloc] init];
      VC.introduce = [NSString stringWithFormat:@"https://info.onto.app/#/detail/%@",
                                                [ENORCN isEqualToString:@"cn"] ? @"57" : @"58"];
      [self.navigationController pushViewController:VC animated:YES];
    }];
    [self.view addSubview:alertV];

    _waitOngLB = [[UILabel alloc]
        initWithFrame:CGRectMake(16 * SCALE_W, 156 * SCALE_W, SYSWidth - 32 * SCALE_W, 18 * SCALE_W)];
    _waitOngLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _waitOngLB.textAlignment = NSTextAlignmentLeft;
    _waitOngLB.textColor = BLACKLB;

    _waitOngLB.text = [Common getPrecision9Str:_waitboundong];
    if ([_waitOngLB.text isEqualToString:@"0"]) {
      _waitOngLB.text = ONG_ZERO;
    }
    [self.view addSubview:_waitOngLB];
  }

  MoneyDetailViewController *vc1 = [[MoneyDetailViewController alloc] init];
  vc1.address = self.address;
  vc1.isONT = self.isONT;
  vc1.title = Localized(@"sharePending");

  MoneyDetailDoneViewController *vc2 = [[MoneyDetailDoneViewController alloc] init];
  vc2.address = self.address;
  vc2.isONT = self.isONT;
  vc2.title = Localized(@"Completed");

  self.viewControllers = @[vc1, vc2];
  self.segmentBorderColor = [UIColor colorWithHexString:@"#2B4045"];
  self.segmentTitleColor = [UIColor colorWithHexString:@"#0AA5C9"];
}

- (void)createNav {
  [self setNavTitle:self.isONT ? @"ONT" : @"ONG"];
  [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
  [self setNavRightImageIcon:[UIImage imageNamed:@"newcode"] Title:@""];

}
- (void)navLeftAction {
  USERMODEL.isShareWallet = NO;
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)navRightAction {
  ShareWalletDetailViewController *vc = [[ShareWalletDetailViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}
- (UIButton *)createBtn {
  if (!_createBtn) {
    _createBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SYSHeight - 64 - 49, SYSWidth, 49)];
    if (KIsiPhoneX) {
      _createBtn.frame = CGRectMake(0, SYSHeight - 64 - 49 - 34 - 24, SYSWidth, 49);
    }
    [_createBtn setImage:[UIImage imageNamed:@"shareSend"] forState:UIControlStateNormal];
    [_createBtn setTitle:Localized(@"Send") forState:UIControlStateNormal];
    [_createBtn setTitleColor:[UIColor colorWithHexString:@"#0AA5C9"] forState:UIControlStateNormal];
    _createBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
    [_createBtn addTarget:self action:@selector(confirmTrade) forControlEvents:UIControlEventTouchUpInside];

  }
  return _createBtn;
}
- (void)confirmTrade {

  NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
  NSDictionary *dic =
      [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
  NSArray *shareArr = dic[@"coPayers"];

  NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
  BOOL isHAve = NO;
  for (NSDictionary *listDic in array) {
    for (NSDictionary *shareDic in shareArr) {
      if ([listDic isKindOfClass:[NSDictionary class]] && listDic[@"label"]) {
        if ([listDic[@"address"] isEqualToString:shareDic[@"address"]]) {
          isHAve = YES;
        }
      }
    }
  }
  if (isHAve == YES) {
    SendViewController *vc = [[SendViewController alloc] init];
    vc.isOng = !self.isONT;
    vc.walletAddr = self.address;
    vc.isShareWallet = YES;
    vc.amount = _amount;
    vc.ongAmount = _ongAmount;
    [self.navigationController pushViewController:vc animated:YES];
  } else {
    MGPopController
        *pop = [[MGPopController alloc] initWithTitle:Localized(@"ShareNoCommonWallet") message:nil image:nil];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{
    }];
    action.titleColor = MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
  }
}

- (void)scheduledTimerFunction {

  self.nowTimeString = [NSString stringWithFormat:@"%@000", [Common getNowTimeTimestamp]];
  NSString *urlStr = [NSString stringWithFormat:@"%@?address=%@&assetName=%@&beforeTimeStamp=%@",
          New_History_trade, self.address, self.isONT ? @"ont" : @"ong", self.nowTimeString];

  CCSuccess successCallback = ^(id responseObject, id responseOriginal) {

    for (NSDictionary *dict in [responseObject valueForKey:@"balance"]) {

      if ([dict[@"assetName"] isEqualToString:@"ont"]) {

        self.amount = [dict valueForKey:@"balance"];
        _moneyNum.text = [Common countNumAndChangeformat:self.amount];
        NSString *money = [Common countNumAndChangeformat:[Common getMoney:_amount Exchange:self.exchange]];
        NSString *prefix = [_GoalType isEqualToString:@"CNY"] ? @"¥" : @"$";
        NSString *moneyNumChangeStr = [NSString stringWithFormat:@"%@%@", prefix, money];
        CGSize strSize = [moneyNumChangeStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
        _moneyNumChange.frame = CGRectMake(16 * SCALE_W, 54 * SCALE_W, strSize.width, 18 * SCALE_W);
        _moneyNumChange.text = moneyNumChangeStr;
        _alertBtn.frame = CGRectMake(25 * SCALE_W + strSize.width, 56 * SCALE_W, 14 * SCALE_W, 14 * SCALE_W);

      }

      if ([dict[@"assetName"] isEqualToString:@"ong"]) {

        self.amount = [dict valueForKey:@"balance"];
        _moneyNum.text = [Common getPrecision9Str:_amount];

        if ([_moneyNum.text isEqualToString:@"0"]) {
          _moneyNum.text = ONG_ZERO;
        }
        _ongAmount = _amount;

      }

      if ([dict[@"assetName"] isEqualToString:@"waitboundong"]) {

        _waitOngLB.text = [Common getPrecision9Str:[dict valueForKey:@"balance"]];
        if ([_waitOngLB.text isEqualToString:@"0"]) {
          _waitOngLB.text = ONG_ZERO;
        }

      }

      if ([dict[@"assetName"] isEqualToString:@"unboundong"]) {

        _ongAppove = [dict valueForKey:@"balance"];
        _ClaimableONG.text = [Common getPrecision9Str:_ongAppove];
        if ([_ClaimableONG.text isEqualToString:@"0"]) {
          _ClaimableONG.text = ONG_ZERO;
        }

      }

    }
  };

  CCFailure failureCallback = ^(NSError *error, NSString *errorDesc, id responseOriginal) {
    [ToastUtil shortToast:self.view value:Localized(@"NetworkAnomaly")];
  };

  [[CCRequest shareInstance] requestWithURLString1:urlStr
                                        MethodType:MethodTypeGET
                                            Params:nil
                                           Success:successCallback
                                           Failure:failureCallback];

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
