//
//  ShareWalletPayDetailViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/13.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ShareWalletPayDetailViewController.h"
#import "ShareWalletPayCell.h"
#import "ShareTradeModel.h"
#import "copayerSignModel.h"
#import "ConfirmPayView.h"
#import "ConfirmJoinView.h"
#import "BrowserView.h"
#import "ShareWalletTransferAccountsViewController.h"
@interface ShareWalletPayDetailViewController ()
    <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *createBtn;
@property(nonatomic, assign) NSInteger nowRow;
@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, copy) NSString *nowAddress;
@property(nonatomic, copy) NSString *selectAddress;
@property(nonatomic, copy) NSString *selectPWD;
@property(nonatomic, strong) NSDictionary *selectDic;
@property(nonatomic, strong) NSDictionary *defaultDic;
@property(nonatomic, strong) BrowserView *browserView;
@property(nonatomic, assign) BOOL isCheckPWD;
@property(nonatomic, assign) BOOL isSignTrade;
@property(nonatomic, assign) BOOL isSendTrade;
@property(nonatomic, strong) NSDictionary *walletDic;
@property(nonatomic, strong) NSArray *keyList;
@property(nonatomic, copy) NSString *sendTxData;
@property(nonatomic, strong) MBProgressHUD *hub;
@property(nonatomic, strong) ConfirmJoinView *sureV;
@end

@implementation ShareWalletPayDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.isCheckPWD = NO;
  self.isSignTrade = NO;
  self.isSendTrade = NO;
  [self createUI];
  [self createNav];
  // Do any additional setup after loading the view.
}
- (void)createUI {
  self.view.backgroundColor = [UIColor whiteColor];
  for (NSInteger i = 0; i < _model.coPayerSignVOS.count; i++) {
    copayerSignModel *cModel = _model.coPayerSignVOS[i];
    if ([cModel.isSign integerValue] == 1) {
      self.nowRow = i;
    }
  }
  [self.view addSubview:self.browserView];
  [self.view addSubview:self.tableView];
  if (self.isComplete == NO) {
    [self.view addSubview:self.createBtn];
    [self showTradeBtn];
  }

}
- (void)showTradeBtn {
  NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
  self.defaultDic =
      [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
  NSMutableArray *keyArr = [NSMutableArray array];
  for (NSDictionary *dic in self.defaultDic[@"coPayers"]) {
    [keyArr addObject:dic[@"publickey"]];
  }
  self.keyList = keyArr;

  NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
  for (NSInteger i = 0; i < _model.coPayerSignVOS.count; i++) {
    copayerSignModel *cModel = _model.coPayerSignVOS[i];
    if ([cModel.isSign integerValue] == 0) {
      for (NSDictionary *dic in array) {
        if ([dic isKindOfClass:[NSDictionary class]] && dic[@"label"]) {
          if ([dic[@"address"] isEqualToString:cModel.address]) {
            self.walletDic = dic;
            self.nowAddress = dic[@"address"];
            self.createBtn.hidden = NO;
            _tableView.frame = CGRectMake(0, 0, SYSWidth, SYSHeight - 64 - 49);
            if (KIsiPhoneX) {
              _tableView.frame = CGRectMake(0, 0, SYSWidth, SYSHeight - 49 - 64 - 34 - 24);
            }
          }
        }
      }
      return;
    }
  }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 68 * SCALE_W;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _model.coPayerSignVOS.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 326 * SCALE_W;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYSWidth, 326 * SCALE_W)];
  topView.backgroundColor = [UIColor whiteColor];

  NSString *fee = [Common getRealFee:_model.gaslimit GasLimit:_model.gasprice];

  UILabel *feeNumLB =
      [[UILabel alloc] initWithFrame:CGRectMake(16 * SCALE_W, 78 * SCALE_W, SYSWidth - 16 * SCALE_W, 17 * SCALE_W)];
  feeNumLB.textAlignment = NSTextAlignmentLeft;
  feeNumLB.textColor = BLACKLB;
  feeNumLB.font = [UIFont systemFontOfSize:14];
  if (self.isComplete) {
    feeNumLB.text = [NSString stringWithFormat:@"%@ %@ ONG", Localized(@"Fee"), self.dic[@"Fee"]];
  } else {
    feeNumLB.text =
        [NSString stringWithFormat:@"%@ %@ ONG", Localized(@"Fee"), fee];
  }

  [topView addSubview:feeNumLB];

  for (int i = 0; i < 3; i++) {
    UIView *line = [[UIView alloc]
        initWithFrame:CGRectMake(16 * SCALE_W, 68.5 * SCALE_W + 113.5 * SCALE_W * i, SYSWidth - 16 * SCALE_W, 1)];
    line.backgroundColor = LINEBG;
    [topView addSubview:line];

    UILabel *amountLB = [[UILabel alloc]
        initWithFrame:CGRectMake(16 * SCALE_W, 9 * SCALE_W + 104.5 * SCALE_W * i, 300 * SCALE_W, 17 * SCALE_W)];
    amountLB.font = [UIFont systemFontOfSize:14];
    amountLB.textColor = LIGHTGRAYLB;
    amountLB.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:amountLB];

    UILabel *amountNumLB = [[UILabel alloc] initWithFrame:CGRectMake(16 * SCALE_W,
                                                                     38 * SCALE_W + 105 * SCALE_W * i,
                                                                     SYSWidth - 16 * SCALE_W,
                                                                     23 * SCALE_W)];
    amountNumLB.textAlignment = NSTextAlignmentLeft;
    amountNumLB.textColor = BLACKLB;
    amountNumLB.font = [UIFont systemFontOfSize:14];
    [topView addSubview:amountNumLB];

    if (i == 0) {
      amountLB.text = Localized(@"Amount");
      if (self.isComplete) {
        NSDictionary *TransferList = self.dic[@"TransferList"][0];
        amountNumLB.text =
            self.isONT ? [NSString stringWithFormat:@"%ld ONT", [TransferList[@"Amount"] integerValue]] :
                [NSString stringWithFormat:@"%@ ONG", _model.amount];
      } else {
        amountNumLB.text = self.isONT ? [NSString stringWithFormat:@"%@ ONT", _model.amount] :
            [NSString stringWithFormat:@"%@ ONG", [Common divideAndReturnPrecision9Str:_model.amount]];

      }

    } else if (i == 1) {

      amountLB.text = Localized(@"addressLB");
      amountNumLB.text = _model.receiveaddress;
    } else {
      amountLB.frame = CGRectMake(16 * SCALE_W, 192 * SCALE_W, 300 * SCALE_W, 17 * SCALE_W);
      line.frame = CGRectMake(16 * SCALE_W, 251.5 * SCALE_W, SYSWidth - 16 * SCALE_W, 1);
      amountNumLB.frame = CGRectMake(16 * SCALE_W, 221 * SCALE_W, SYSWidth - 16 * SCALE_W, 23 * SCALE_W);
      amountLB.text = Localized(@"ShareTime");
      amountNumLB.text = [Common newGetTimeFromTimestamp:[NSString stringWithFormat:@"%ld", [_model
          .createtimestamp longValue] / 1000]];
    }
  }

  UILabel *CopayersLB =
      [[UILabel alloc] initWithFrame:CGRectMake(16 * SCALE_W, 296 * SCALE_W, SYSWidth - 16 * SCALE_W, 17 * SCALE_W)];
  CopayersLB.textAlignment = NSTextAlignmentLeft;
  CopayersLB.textColor = BLACKLB;
  CopayersLB.font = [UIFont systemFontOfSize:14];
  CopayersLB.text =
      [NSString stringWithFormat:Localized(@"shareRule"), [self.defaultDic[@"requiredNumber"] integerValue], [self
          .defaultDic[@"totalNumber"] integerValue]];
  [topView addSubview:CopayersLB];

  return topView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"payDetail";
  ShareWalletPayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[ShareWalletPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  copayerSignModel *signModel = _model.coPayerSignVOS[indexPath.row];

  [cell reloadCellByDic:signModel row:indexPath.row nowRow:self.nowRow];
  if (_model.coPayerSignVOS.count - 1 == indexPath.row) {
    cell.bottomBlueLine.hidden = YES;
    cell.bottomGrayLine.hidden = YES;
  }
  return cell;
}
- (void)createNav {
  [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];

}
- (void)navLeftAction {
  [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc]
        initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight - 64) style:UITableViewStyleGrouped];
    if (KIsiPhoneX) {
      _tableView.frame = CGRectMake(0, 0, SYSWidth, SYSHeight - 64 - 24);//-49-64-34-24
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
  }
  return _tableView;
}
- (UIButton *)createBtn {
  if (!_createBtn) {
    _createBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SYSHeight - 64 - 49, SYSWidth, 49)];
    if (KIsiPhoneX) {
      _createBtn.frame = CGRectMake(0, SYSHeight - 64 - 49 - 34 - 24, SYSWidth, 49);
    }
    _createBtn.hidden = YES;
    [_createBtn setTitle:Localized(@"Confirm") forState:UIControlStateNormal];
    [_createBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    _createBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
    [_createBtn addTarget:self action:@selector(toTrade) forControlEvents:UIControlEventTouchUpInside];
  }
  return _createBtn;
}
- (void)toTrade {

  NSString *ong = [Common getRealFee:_model.gasprice GasLimit:_model.gaslimit];

  NSString *money = self.isONT ?
      [NSString stringWithFormat:@"%@", _model.amount] :
      [Common divideAndReturnPrecision9Str:_model.amount];

  ConfirmPayView *confirmV = [[ConfirmPayView alloc] initWithType:self.isONT money:money
                                                      fromAddress:_model.sendaddress
                                                        toAddress:_model.receiveaddress
                                                              fee:[NSString stringWithFormat:@"%@ ONG", ong]];

  [confirmV setCallback:^(NSString *string) {
    [self createSureView];
  }];
  _window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
  [_window addSubview:confirmV];
  [_window makeKeyAndVisible];
}
- (void)createSureView {
  __weak typeof(self) weakSelf = self;
//    if (!_sureV) {
  _sureV = [[ConfirmJoinView alloc] initWithAddress:self.nowAddress isFirst:NO];
  [_sureV setCallback:^(NSString *address, NSString *password, NSDictionary *selectDic) {
    weakSelf.selectDic = selectDic;
    weakSelf.selectAddress = address;
    weakSelf.selectPWD = password;
    if (password.length == 0) {
      return;
    }
    [weakSelf loadSelfJs:address password:password selectDic:selectDic];

  }];
  _window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
  [_window addSubview:_sureV];
  [_window makeKeyAndVisible];
//    }

}
- (void)loadSelfJs:(NSString *)address password:(NSString *)password selectDic:(NSDictionary *)selectDic {
  NSString *jsStr =
      [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')", [self
          .walletDic valueForKey:@"key"], [Common transferredMeaning:password], address, [self
          .walletDic valueForKey:@"salt"]];
  LOADJS1;
  LOADJS2;
  LOADJS3;

  [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
}

- (BrowserView *)browserView {
  if (!_browserView) {
    _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [_browserView setCallbackPrompt:^(NSString *prompt) {
      [weakSelf handlePrompt:prompt];
    }];
    [_browserView setCallbackJSFinish:^{
      [weakSelf loadJS];
    }];
  }
  return _browserView;
}
- (void)loadJS {
  if (self.isSignTrade == YES) {
    NSString *jsStr =
        [NSString stringWithFormat:@" Ont.SDK.signMultiAddrTransaction('%@','%@','%@','%@','%@','%@','%@','signMultiAddrTransaction')", self
            .walletDic[@"key"], self.nowAddress, self.walletDic[@"salt"], [Common transferredMeaning:self
            .selectPWD], [self arrayToJSONString:self.keyList], self.defaultDic[@"requiredNumber"], _model
                                       .transactionbodyhash];

    LOADJS1;
    LOADJS2;
    LOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
  }

  if (self.isSendTrade == YES) {
    NSString
        *jsStr = [NSString stringWithFormat:@" Ont.SDK.sendTransaction('%@','sendTransaction')", self.sendTxData];

    LOADJS1;
    LOADJS2;
    LOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
  }

}
- (void)handlePrompt:(NSString *)prompt {

  [MBProgressHUD hideHUDForView:self.view animated:YES];
  NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
  NSString *resultStr = promptArray[1];
  id obj =
      [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

  if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
      self.isSignTrade = YES;
      [self loadJS];
    } else {
      MGPopController
          *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
      MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

      }];
      action.titleColor = MainColor;
      [pop addAction:action];
      [pop show];
      pop.showCloseButton = NO;
    }

  }
  if ([prompt hasPrefix:@"signMultiAddrTransaction"]) {
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
      _hub = [ToastUtil showMessage:@"" toView:nil];
      [self signOCTradeByTxHash:nil txData:obj[@"signedHash"]];
    } else {
      if ([[obj valueForKey:@"error"] integerValue] > 0) {

        [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[obj valueForKey:@"error"]]];
//                [ToastUtil shortToast:self.view value:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[obj valueForKey:@"error"]]];
        return;
      }
    }
  }
  if ([prompt hasPrefix:@"sendTransaction"]) {
      [_hub hideAnimated:YES];
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
//            NSDictionary* dic =obj[@"result"];
        
      [_sureV dismiss];
      [self performSelector:@selector(popToView) withObject:nil afterDelay:0.3];
//            [self sendOCTrade:dic[@"Result"]];
    } else {
      if ([[obj valueForKey:@"error"] integerValue] > 0) {

        [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[obj valueForKey:@"error"]]];
//                [ToastUtil shortToast:self.view value:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[obj valueForKey:@"error"]]];
        return;
      }
    }
  }

}
- (void)popToView {
  for (UIViewController *controller in self.navigationController.viewControllers) {
    if ([controller isKindOfClass:[ShareWalletTransferAccountsViewController class]]) {
      USERMODEL.isCheckTrade = NO;
      [self.navigationController popToViewController:controller animated:YES];
    }
  }
}

-(void)sendOCTrade:(NSString*)transactionHash{
  NSString *urlStr = [NSString stringWithFormat:@"%@?transactionHash=%@", SendTradeToChain, transactionHash];
  [[CCRequest shareInstance] requestWithURLStringNoLoading:urlStr MethodType:MethodTypePOST Params:nil Success:^(id responseObject, id responseOriginal) {
    [_sureV dismiss];
    [self performSelector:@selector(popToView) withObject:nil afterDelay:0.3];
  }                         Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
    [Common showToast:Localized(@"Networkerrors")];
//        [ToastUtil shortToast:self.view value:Localized(@"Networkerrors")];

  }];
}
- (void)signOCTradeByTxHash:(NSString *)txHash txData:(NSString *)txData {
    self.sendTxData = txData;
    NSDictionary *params =@{@"signedAddress": self.nowAddress,
                          @"transactionIdHash": _model.transactionidhash,
                          @"signedHash": txData};
    if (self.nowRow+2 == [self.defaultDic[@"requiredNumber"]integerValue]) {
        self.isSignTrade =NO;
        self.isSendTrade =YES;
        [self loadJS];
    }else{
        [[CCRequest shareInstance]
         requestWithHMACAuthorization:SignSharedWalletTrade MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                                              id responseOriginal) {
            [_hub hideAnimated:YES];
            [_sureV dismiss];
            [self performSelector:@selector(popToView) withObject:nil afterDelay:0.3];
        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
            [_hub hideAnimated:YES];
            [Common showToast:Localized(@"Networkerrors")];
            
        }];
    }

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
