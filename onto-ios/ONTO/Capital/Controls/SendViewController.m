//
//  SendViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/24.
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

#import "SendViewController.h"
#import "ImportViewController.h"
#import "SendConfirmView.h"
#import "ContactsViewController.h"
#import "ConfirmPayView.h"
#import "ConfirmJoinView.h"
#import "CopayersOrderViewController.h"
#import "ONTO-Swift.h"
// 屏幕宽屏幕高 屏幕bounds
#define LZYSCREENWIDTH  [UIScreen mainScreen].bounds.size.width



@interface SendViewController ()<UITextFieldDelegate> {
  BOOL isHaveDian;
}

@property(weak, nonatomic) IBOutlet UITextField *addressT;
@property(weak, nonatomic) IBOutlet UITextField *balanceT;
@property(weak, nonatomic) IBOutlet UILabel *feeL;
@property(weak, nonatomic) IBOutlet UILabel *amountL;
@property(weak, nonatomic) IBOutlet UIButton *nextB;
@property(nonatomic, strong) SendConfirmView *sendConfirmV;
@property(nonatomic, copy) NSString *encryptedPrivateKey;
@property(nonatomic, copy) NSString *sendTransferAssetsUrlStr;
@property(nonatomic, copy) NSString *sendvalue;
@property(nonatomic, strong) MBProgressHUD *hub;
@property(weak, nonatomic) IBOutlet UILabel *netWorkLabel;
@property(nonatomic, assign) BOOL dot; //定义第一位是否为.
@property(weak, nonatomic) IBOutlet UILabel *preFeeL;
@property(weak, nonatomic) IBOutlet UILabel *preBalanceL;
@property(nonatomic, copy) NSString *receiveaddress;
@property(nonatomic, copy) NSString *sendaddress;

@property(weak, nonatomic) IBOutlet UILabel *amountTextL;
@property(weak, nonatomic) IBOutlet UILabel *addressTextL;

@property(weak, nonatomic) IBOutlet UILabel *bottomFeeL;
@property(weak, nonatomic) IBOutlet UILabel *bottomFeeL2;
@property(weak, nonatomic) IBOutlet UILabel *bottomFeeL3;
@property(weak, nonatomic) IBOutlet UILabel *bottomFeeL4;
@property(weak, nonatomic) IBOutlet UISwitch *bottomSwitch;
@property(weak, nonatomic) IBOutlet UISlider *bottomSlider;
@property(weak, nonatomic) IBOutlet UIView *bottomView1;

@property(weak, nonatomic) IBOutlet UIView *bottomView2;
@property(weak, nonatomic) IBOutlet UITextField *bottomF2;

@property(weak, nonatomic) IBOutlet UILabel *ongBalanceL;
@property(weak, nonatomic) IBOutlet UILabel *ongLimitLabel;

@property(nonatomic, copy) NSString *gasPrice;
@property(nonatomic, copy) NSString *gasLimit;
@property(nonatomic, assign) BOOL issendJSType;
@property(nonatomic, assign) BOOL isTypeDragon;
@property(nonatomic, strong) UIWindow *window;

@property(nonatomic, copy) NSString *selectAddress;
@property(nonatomic, copy) NSString *selectPWD;
@property(nonatomic, strong) NSDictionary *selectDic;
@property(nonatomic, strong) ConfirmJoinView *sureV;
@property(nonatomic, strong) BrowserView *browserView;
@property(nonatomic, copy) NSString *jsUrl;
@property(nonatomic, copy) NSString *oep4Url;

@end

@implementation SendViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self.view addSubview:self.browserView];
  [self configUI];
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

- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
  [self configNetLabel];

}

- (IBAction)mysiwtchAction:(UISwitch *)sender {
  if (sender.on == NO) {

    _bottomView2.hidden = YES;
    _bottomFeeL4.textColor = LIGHTGRAYLB;
    _gasPrice = [NSString stringWithFormat:@"%f", _bottomSlider.value];
    _gasLimit = [[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASLIMIT];

  } else {
    _bottomView2.hidden = NO;
    _bottomFeeL4.textColor = BLUELB;

    _gasPrice = _bottomF2.text;

  }
}

- (IBAction)bottomBtnClick:(id)sender {
  if (_bottomView1.hidden == NO) {
    _bottomView1.hidden = YES;
  } else {
    _bottomView1.hidden = NO;
  }
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

- (void)configUI {

  [self setNavTitle:_isOng ? Localized(@"ONGSent") : Localized(@"ONTSent")];
  [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
  self.addressT.placeholder = Localized(@"ReceiverAddress");

  if (_isOng) {
    self.amountL.text = [NSString stringWithFormat:@"%@ %@", [Common getPrecision9Str:_ongAmount],  @"ONG"];
  }else{
    self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, @"ONT"];
  }
    if (_isPum) {
        
        if ([_pumType isEqualToString:@"pumpkin01"]) {
            [self setNavTitle:[NSString stringWithFormat:@"%@ %@",Localized(@"pumSend"),Localized(@"PumpkinRed")]];
            self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, Localized(@"PumpkinRed")];
        }else if ([_pumType isEqualToString:@"pumpkin02"]){
            [self setNavTitle:[NSString stringWithFormat:@"%@ %@",Localized(@"pumSend"),Localized(@"OrangePum")]];
            self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, Localized(@"OrangePum")];
        }else if ([_pumType isEqualToString:@"pumpkin03"]){
            [self setNavTitle:[NSString stringWithFormat:@"%@ %@",Localized(@"pumSend"),Localized(@"PumpkinYellow")]];
            self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, Localized(@"PumpkinYellow")];
        }else if ([_pumType isEqualToString:@"pumpkin04"]){
            [self setNavTitle:[NSString stringWithFormat:@"%@ %@",Localized(@"pumSend"),Localized(@"PumpkinGreen")]];
            self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, Localized(@"PumpkinGreen")];
        }else if ([_pumType isEqualToString:@"pumpkin05"]){
            [self setNavTitle:[NSString stringWithFormat:@"%@ %@",Localized(@"pumSend"),Localized(@"PumpkinIndigo")]];
            self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, Localized(@"PumpkinIndigo")];
        }else if ([_pumType isEqualToString:@"pumpkin06"]){
            [self setNavTitle:[NSString stringWithFormat:@"%@ %@",Localized(@"pumSend"),Localized(@"PumpkinBlue")]];
            self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, Localized(@"PumpkinBlue")];
        }else if ([_pumType isEqualToString:@"pumpkin07"]){
            [self setNavTitle:[NSString stringWithFormat:@"%@ %@",Localized(@"pumSend"),Localized(@"PumpkinPurple")]];
            self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, Localized(@"PumpkinPurple")];
        }else if ([_pumType isEqualToString:@"pumpkin08"]){
            [self setNavTitle:[NSString stringWithFormat:@"%@ %@",Localized(@"pumSend"),Localized(@"PumpkinGolden")]];
            self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, Localized(@"PumpkinGolden")];
        }
    }
    
    if (_isDragon) {
        [self setNavTitle:[NSString stringWithFormat:@"%@ %@",Localized(@"pumSend"),Localized(@"dragon")]];
        self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, Localized(@"dragon")];
        self.balanceT.text = @"1";
        self.balanceT.userInteractionEnabled = NO;
        
    }else{
        self.balanceT.keyboardType = _isOng ? UIKeyboardTypeDecimalPad : UIKeyboardTypeNumberPad;
        self.balanceT.delegate = self;
    }
    if (_isOEP4) {
        [self setNavTitle:[NSString stringWithFormat:@"%@",self.tokenDict[@"ShortName"]]];
        self.amountL.text = [NSString stringWithFormat:@"%@ %@", self.amount, self.tokenDict[@"ShortName"]];
        self.balanceT.keyboardType = UIKeyboardTypeDecimalPad;
    }
  _ongBalanceL.text = [NSString stringWithFormat:@"%@: %@", Localized(@"OngBlance"), _ongAmount];

  
  self.preFeeL.text = Localized(@"Fee");
  self.preBalanceL.text = Localized(@"Balance");

  NSString *feePrecision9Str = [Common getPrecision9Str:[[NSUserDefaults standardUserDefaults] valueForKey:FEE]];
  self.feeL.text = [NSString stringWithFormat:@" %@ ONG", feePrecision9Str];

  [self.balanceT addTarget:self action:@selector(limit10Chars:) forControlEvents:UIControlEventEditingChanged];

  [self.nextB setTitle:Localized(@"Next1") forState:UIControlStateNormal];
  self.nextB.layer.cornerRadius = 1;
  self.nextB.layer.masksToBounds = YES;
  _netWorkLabel.text = Localized(@"Netdisconnected");

  _amountTextL.text = Localized(@"Amount");
  _addressTextL.text = Localized(@"OntAddress");

  self.bottomFeeL.text = Localized(@"Fee");

  _bottomSwitch.onTintColor = [UIColor colorWithHexString:@"#35BFDF"];
  _bottomSwitch.transform = CGAffineTransformMakeScale(0.42, 0.42);//缩放
  [_bottomSlider addTarget:self action:@selector(bottomSliderAction) forControlEvents:UIControlEventValueChanged];
  _bottomSlider.tintColor = BLUELB;

  // [NSUserDefaults standardUserDefaults] valueForKey:ASSETGASPRICE] 是long，所以这里转成string
  _gasPrice = [[[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASPRICE] stringValue];
  _gasLimit = [[[NSUserDefaults standardUserDefaults] valueForKey:ASSETGASLIMIT] stringValue];

  _bottomFeeL2.text = [NSString stringWithFormat:@"%@ ONG", [Common getRealFee:_gasPrice GasLimit:_gasLimit]];

  _bottomF2.keyboardType = UIKeyboardTypeNumberPad;
  _bottomF2.delegate = self;

  _bottomFeeL4.text = Localized(@"Advancedfeesettings");
  _bottomF2.placeholder = Localized(@"CustomeONGPrice");

  [_bottomF2 addTarget:self action:@selector(gasPricechange:) forControlEvents:UIControlEventEditingChanged];
  _ongLimitLabel.text =
      [NSString stringWithFormat:@"%@: %@", Localized(@"CustomeONGlimit"), [[NSUserDefaults standardUserDefaults]
          valueForKey:ASSETGASLIMIT]];

}

- (void)gasPricechange:(UITextField *)textField {

  if (textField.text.length > 9) {
    textField.text = [textField.text substringToIndex:9];
  }

  if (textField == _bottomF2) {
    _gasPrice = textField.text;
  }

  _bottomFeeL2.text =
      [NSString stringWithFormat:@"%@ ONG", [Common getRealFee:_gasPrice GasLimit:_gasLimit]];
}

- (void)bottomSliderAction {
  [self setNewSliderValue:_bottomSlider andAccuracy:100];
}

- (void)setNewSliderValue:(UISlider *)slider andAccuracy:(float)accuracy {

  // 滑动条的 宽
  float width = LZYSCREENWIDTH;

  // 如： 用户想每滑动一次 增加100的量 每次滑块需要滑动的宽
  float slideWidth = width * accuracy / slider.maximumValue;
  // 在滑动条中 滑块的位置 是根据 value值 显示在屏幕上的 那么 把目前滑块的宽 加上用户新滑动一次的宽 转换成value值
  // 根据当前value值 求出目前滑块的宽
  float currentSlideWidth = slider.value / accuracy * slideWidth;
  // 用户新滑动一次的宽加目前滑动的宽 得到新的 目前滑动的宽
  float newSlideWidth = currentSlideWidth + slideWidth;
  // 转换成 新的 value值
  float value = newSlideWidth / width * slider.maximumValue;
  // 取整
  int d = (int) (value / accuracy) - 1;

  // TODO:因为从0滑到100后在往回滑 即使滑到最左边 还是显示100 应该是算法有点问题 这里就不优化算法了 针对这种特殊情况做些改变
  if (d >= 2) {

    slider.value = d * accuracy;
    [self getFeePrice];

  } else {
    if (d == 0 || slider.value == accuracy) {
      slider.value = accuracy;
    } else if (d == 1) {
      slider.value = 2 * accuracy;
    } else if (d == 2) {
      slider.value = 3 * accuracy;
    }
    [self getFeePrice];
  }
}

- (void)getFeePrice {
  NSDecimalNumber *decimalSlider = [[NSDecimalNumber alloc] initWithFloat:_bottomSlider.value];

  // TODO: 这里应该从配置里面读取吧？
  NSString *fee = [Common getRealFee:decimalSlider.stringValue GasLimit:@"20000"];
  _bottomFeeL2.text = [NSString stringWithFormat:@"%@ ONG", fee];
  _gasPrice = [NSString stringWithFormat:@"%f", _bottomSlider.value];
}

- (void)limit10Chars:(UITextField *)textField {
  if (!_isOng) {
      if (!_isOEP4) {
          if (textField.text.length > 10) {
              textField.text = [textField.text substringToIndex:10];
          }
      }
  }
}

- (void)navLeftAction {
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
  _dot = NO;
  return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (_isOEP4) {
        
    }else{
        
        if (!_isOng || textField == _bottomF2 ) {
            return [self validateNumber:string];
        }
    }

  if ([textField.text rangeOfString:@"."].location == NSNotFound) {
    isHaveDian = NO;
  }
  if ([string length] > 0) {

    unichar single = [string characterAtIndex:0];//当前输入的字符
    if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确

      //首字母不能为0和小数点
      if ([textField.text length] == 0) {
        if (single == '.') {
          [textField.text stringByReplacingCharactersInRange:range withString:@""];
          return NO;
        }

        if (_isOng == NO) {
            if (!_isOEP4) {
                if (single == '0') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
          

        }

      }
      //输入的字符是否是小数点
      if (single == '.') {

        if (!isHaveDian)//text中还没有小数点
        {
          isHaveDian = YES;
          return YES;

        } else {
          [textField.text stringByReplacingCharactersInRange:range withString:@""];
          return NO;
        }
      } else {
        if (isHaveDian) {//存在小数点

          //判断小数点的位数
          NSRange ran = [textField.text rangeOfString:@"."];
            if (_isOEP4) {
                if (range.location - ran.location <= [self.tokenDict[@"Decimals"]intValue] ) {
                    return YES;
                } else {
                    return NO;
                }
            }else{
                if (range.location - ran.location <= 9) {
                    return YES;
                } else {
                    return NO;
                }
            }
          
        } else {
          return YES;
        }
      }
    } else {//输入的数据格式不正确
      [textField.text stringByReplacingCharactersInRange:range withString:@""];
      return NO;
    }
  } else {
    return YES;
  }
}

- (BOOL)validateNumber:(NSString *)number {
  BOOL res = YES;
  NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
  int i = 0;
  while (i < number.length) {
    NSString *string = [number substringWithRange:NSMakeRange(i, 1)];
    NSRange range = [string rangeOfCharacterFromSet:tmpSet];
    if (range.length == 0) {
      res = NO;
      break;
    }
    i++;
  }
  return res;
}

- (IBAction)contactClickAction:(id)sender {
  ContactsViewController *vc = [[ContactsViewController alloc] init];
  [vc setCallback:^(NSString *stringValue) {
    self.addressT.text = stringValue;
  }];
  [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)scanClick:(id)sender {
  [self navRightAction];
}

- (void)navRightAction {

  NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
  AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
  if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:Localized(@"CameraRights") message:@"" preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];

    return;
  }

  ImportViewController *vc = [[ImportViewController alloc] init];
  vc.isReceiverAddress = YES;

  [vc setCallback:^(NSString *stringValue) {
    self.addressT.text = stringValue;
  }];

  [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)sendTransferAssets:(NSString *)prompt {
  NSArray *array = [prompt componentsSeparatedByString:@"params="];
  NSDictionary *dict = [Common dictionaryWithJsonString:array[1]];
  if ([[dict valueForKey:@"error"] integerValue] == 53000) {

    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{}];
    action.titleColor = MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
    return;
  }

  if ([[dict valueForKey:@"error"] integerValue] > 0) {
    [Common showToast:[NSString stringWithFormat:@"%@:%@", Localized(@"Systemerror"), [dict valueForKey:@"error"]]];
    return;
  }
    NSDictionary *params;
    if (_isPum) {
        params   = @{
                     @"sendAddress": _sendaddress,
                     @"receiveAddress": _receiveaddress,
                     @"assetName": _pumType,
                     @"amount": _sendvalue,
                     @"txBodyHash": [dict valueForKey:@"tx"],
                     @"txIdHash": [dict valueForKey:@"txHash"]
                     };
    }else if (_isDragon) {
//        NSString * tokenString = [NSString stringWithFormat:@"dragon%@",_dragonId];
        params   = @{
                     @"sendAddress": _sendaddress,
                     @"receiveAddress": _receiveaddress,
                     @"assetName": @"dragon",
                     @"amount": @"1",
                     @"txBodyHash": [dict valueForKey:@"result"],
                     @"txIdHash": [dict valueForKey:@"txHash"]
                     };
    }else if (_isOEP4) {
        params   = @{
                     @"sendAddress": _sendaddress,
                     @"receiveAddress": _receiveaddress,
                     @"assetName": self.tokenDict[@"ShortName"],
                     @"amount": _sendvalue,
                     @"txBodyHash": [dict valueForKey:@"tx"],
                     @"txIdHash": [dict valueForKey:@"txHash"]
                     };
    }else{
      params   = @{
                     @"sendAddress": _sendaddress,
                     @"receiveAddress": _receiveaddress,
                     @"assetName": _isOng ? @"ong" : @"ont",
                     @"amount": _sendvalue,
                     @"txBodyHash": [dict valueForKey:@"tx"],
                     @"txIdHash": [dict valueForKey:@"txHash"]
                 };
    }
  

  _hub = [ToastUtil showMessage:@"" toView:nil];

  CCSuccess successCallback = ^(id responseObject,
                                id responseOriginal) {

    if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
      NSString *err = [responseOriginal objectForKey:@"error"];
      NSString *msg = [NSString stringWithFormat:@"%@:%@", Localized(@"Systemerror"), err];
      [Common showToast:msg];
      return;
    }

    [_sendConfirmV dismiss];

      if (_isPum  || _isDragon) {
      }else{
          USERMODEL.isRefreshList = YES;
      }
      if (_isDragon) {
          DragonRecordViewController * vc= [[DragonRecordViewController alloc]init];
          vc.walletAddress = self.sendaddress;
          [self.navigationController pushViewController:vc animated:YES];
      }else{
          [self.navigationController popViewControllerAnimated:YES];
      }
    
    [Common showToast:Localized(@"sendSuccess")];
    [_hub hideAnimated:YES];

  };

  CCFailure failureCallback = ^(NSError *error, NSString *errorDesc, id responseOriginal) {

    [Common showToast:Localized(@"Networkerrors")];
    [_hub hideAnimated:YES];

  };

  [[CCRequest shareInstance] requestWithURLStringNoLoading:Assettransfer
                                                MethodType:MethodTypePOST
                                                    Params:params
                                                   Success:successCallback
                                                   Failure:failureCallback];
}

- (void)decryptEncryptedPrivateKey:(NSString *)prompt {

  NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
  NSString *resultStr = [promptArray[1] dataUsingEncoding:NSUTF8StringEncoding];
  id obj = [NSJSONSerialization JSONObjectWithData:resultStr options:0 error:nil];

  if ([[obj objectForKey:@"error"] integerValue] == 0) {

    [_sureV dismiss];
    [self performSelector:@selector(pushCopayersOrderViewController) withObject:nil afterDelay:0.2];

  } else {

    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{}];
    action.titleColor = MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;

  }
}

- (void)dragondecryptEncryptedPrivateKey:(NSString *)prompt {
    _hub = [ToastUtil showMessage:@"" toView:nil];
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = [promptArray[1] dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:resultStr options:0 error:nil];
    
    if ([[obj objectForKey:@"error"] integerValue] == 0) {
        NSString * dragonHast = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:DRAGONCODEHASH]];
        self.sendTransferAssetsUrlStr = [NSString stringWithFormat:@"transfer('%@','%@','%@',%d,'%@')",dragonHast,self.sendaddress,self.receiveaddress,[_dragonId intValue],[obj objectForKey:@"result"] ];
        
        
        _issendJSType = YES;
        _isTypeDragon = YES;
        [self.browserView.wkWebView evaluateJavaScript:self.sendTransferAssetsUrlStr completionHandler:nil];
    } else {
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
        MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{}];
        action.titleColor = MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        
    }
}
- (void)handlePrompt:(NSString *)prompt {
  [self hideHud];
  [_hub hideAnimated:YES];

  if ([prompt hasPrefix:@"sendTransferAssets"]) {

    [self sendTransferAssets:prompt];

  }  else if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {

    [self decryptEncryptedPrivateKey:prompt];

  } else if ([prompt hasPrefix:@"transferOep8"]){
      [self sendTransferAssets:prompt];
  }else if ([prompt hasPrefix:@"transferOep4"]){
      [self sendTransferAssets:prompt];
  }else if ([prompt hasPrefix:@"dragonPSW"]){
      [self dragondecryptEncryptedPrivateKey:prompt];
  }else if ([prompt hasPrefix:@"dragonTrafer"]){
//      [self dragonTrafer:prompt];
      [self sendTransferAssets:prompt];
  }else if ([prompt hasPrefix:@"sendTransaction"]){
      [self sendTransferAssets:prompt];
  }else if ([prompt hasPrefix:@"oep4PSW"]){
      [self oep4decryptEncryptedPrivateKey:prompt];
  }else{
      
      
  }
    
}
-(void)oep4decryptEncryptedPrivateKey:(NSString *)prompt {
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = [promptArray[1] dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:resultStr options:0 error:nil];
    
    if ([[obj objectForKey:@"error"] integerValue] == 0) {
         _issendJSType = YES;
        LOADJS1;
        LOADJS2 ;
        LOADJS3;
        [self.browserView.wkWebView evaluateJavaScript:self.sendTransferAssetsUrlStr completionHandler:nil];
    } else {
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
        MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{}];
        action.titleColor = MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        
    }
}
- (void)dragonTrafer:(NSString *)prompt {
    NSArray *array = [prompt componentsSeparatedByString:@"params="];
    NSDictionary *dict = [Common dictionaryWithJsonString:array[1]];
    NSLog(@"dict%@",dict);
    
//    self.sendTransferAssetsUrlStr =[NSString stringWithFormat:@"Ont.SDK.sendTransaction('%@','sendTransaction')", dict[@"result"]];
//    NSLog(@"-->%@<--",self.sendTransferAssetsUrlStr);
//    _issendJSType = YES;
//    LOADJS1;
//    LOADJS2;
//    LOADJS3;
//    [self.browserView.wkWebView evaluateJavaScript:self.sendTransferAssetsUrlStr completionHandler:nil];
}
//TODO: 这个Copayers单词应该是写错了，等到知道这个页面是干嘛的要改掉
- (void)pushCopayersOrderViewController {
  CopayersOrderViewController *vc = [[CopayersOrderViewController alloc] init];
  vc.isONT = !self.isOng;
  vc.fromAddress = _walletAddr;
  vc.toAddress = self.addressT.text;
  vc.amout = self.balanceT.text;
  vc.gasLimit = self.gasLimit;
  vc.gasPrice = [NSString stringWithFormat:@"%ld", [self.gasPrice integerValue]];
  vc.nowAddress = self.selectAddress;
  vc.selectPWD = self.selectPWD;
  vc.selectDic = self.selectDic;
  [self.navigationController pushViewController:vc animated:YES];
}

- (SendConfirmView *)sendConfirmV {

  if (!_sendConfirmV) {
    _sendConfirmV =
        [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
    __weak typeof(self) weakSelf = self;
    _sendConfirmV.tokenType = _isOng ? @"ONG" : @"ONT";
      int pumInt = 1;
      if (_isPum) {
          if ([_pumType isEqualToString:@"pumpkin01"]) {
              _sendConfirmV.tokenType = Localized(@"PumpkinRed");
              pumInt = 1;
          }else if ([_pumType isEqualToString:@"pumpkin02"]){
              _sendConfirmV.tokenType =Localized(@"OrangePum");
              pumInt = 2;
          }else if ([_pumType isEqualToString:@"pumpkin03"]){
              _sendConfirmV.tokenType = Localized(@"PumpkinYellow");
              pumInt = 3;
          }else if ([_pumType isEqualToString:@"pumpkin04"]){
              _sendConfirmV.tokenType = Localized(@"PumpkinGreen");
              pumInt = 4;
          }else if ([_pumType isEqualToString:@"pumpkin05"]){
              _sendConfirmV.tokenType = Localized(@"PumpkinIndigo");
              pumInt = 5;
          }else if ([_pumType isEqualToString:@"pumpkin06"]){
              _sendConfirmV.tokenType = Localized(@"PumpkinBlue");
              pumInt = 6;
          }else if ([_pumType isEqualToString:@"pumpkin07"]){
              _sendConfirmV.tokenType = Localized(@"PumpkinPurple");
              pumInt = 7;
          }else if ([_pumType isEqualToString:@"pumpkin08"]){
              _sendConfirmV.tokenType = Localized(@"PumpkinGolden");
              pumInt = 8;
          }
          
      }
      if (_isDragon) {
          _sendConfirmV.tokenType = Localized(@"dragon");
      }
      if (_isOEP4) {
          _sendConfirmV.tokenType = self.tokenDict[@"ShortName"];
          _sendConfirmV.tokenDict = self.tokenDict;
      }
    NSString *jsStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsStr];
    [_sendConfirmV setCallback:^(NSString *token,
                                 NSString *from,
                                 NSString *to,
                                 NSString *value,
                                 NSString *password) {
        if (weakSelf.isPum) {
            
            NSString * PumpkinCodeHash = [[NSUserDefaults standardUserDefaults] valueForKey:PUMPKINHASH];
            token = weakSelf.pumType;
            weakSelf.sendvalue = value;
            weakSelf.sendaddress = from;
            weakSelf.receiveaddress = to;
            weakSelf.sendTransferAssetsUrlStr = [NSString stringWithFormat:@"Ont.SDK.transferOep8('%@','%@','%@','%@',%d,'%@','%@','%@','%@','%@','%@','transferOep8')",
                                                 PumpkinCodeHash,
                                                 from,
                                                 to,
                                                 value,
                                                 pumInt,
                                                 weakSelf.encryptedPrivateKey,
                                                 [Common transferredMeaning:password],
                                                 dict[@"salt"],
                                                 [Common getPrecision9Str:weakSelf.gasPrice],
                                                 [Common getPrecision9Str:weakSelf.gasLimit],
                                                 weakSelf.walletAddr];

            
            _issendJSType = YES;
            
            _hub = [ToastUtil showMessage:@"" toView:nil];
            
//            [weakSelf.browserView.wkWebView evaluateJavaScript:weakSelf.sendTransferAssetsUrlStr completionHandler:nil];
            
            [weakSelf.browserView.wkWebView evaluateJavaScript:weakSelf.sendTransferAssetsUrlStr completionHandler:^(id msgDict, NSError * _Nullable error) {
                [weakSelf.hub hideAnimated:YES];
                [Common showToast:Localized(@"PASSWORDERROR")];
                [weakSelf.sendConfirmV dismiss];
            }];
            
            
        }else if (weakSelf.isDragon) {
            weakSelf.sendaddress = from;
            weakSelf.receiveaddress = to;
            
            weakSelf.sendTransferAssetsUrlStr =
            [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','dragonPSW')", [dict valueForKey:@"key"], [Common transferredMeaning:password], dict[@"address"], [dict valueForKey:@"salt"]];
            _isTypeDragon = NO;
            _issendJSType = YES;
            
//            [weakSelf.browserView.wkWebView evaluateJavaScript:weakSelf.sendTransferAssetsUrlStr completionHandler:nil];
            
            _hub = [ToastUtil showMessage:@"" toView:nil];
            [weakSelf.browserView.wkWebView evaluateJavaScript:weakSelf.sendTransferAssetsUrlStr completionHandler:^(id msgDict, NSError * _Nullable error) {
                [weakSelf.hub hideAnimated:YES];
                [Common showToast:Localized(@"PASSWORDERROR")];
                [weakSelf.sendConfirmV dismiss];
            }];
            
        }else if (weakSelf.isOEP4) {
            NSString * CodeHash = weakSelf.tokenDict[@"Hash"];
            
            token = weakSelf.tokenDict[@"ShortName"];
            weakSelf.sendvalue = [Common getOEP4Str:value Decimals:[weakSelf.tokenDict[@"Decimals"] intValue] ];;
            weakSelf.sendaddress = from;
            weakSelf.receiveaddress = to;
            weakSelf.sendTransferAssetsUrlStr = [NSString stringWithFormat:@"Ont.SDK.transferOep4('%@','%@','%@','%@','%@','%@','%@','%@','%@','transferOep4')",
                                                 CodeHash,
                                                 from,
                                                 to,
                                                 [Common getOEP4Str:value Decimals:[weakSelf.tokenDict[@"Decimals"] intValue] ],
                                                 weakSelf.encryptedPrivateKey,
                                                 [Common transferredMeaning:password],
                                                 dict[@"salt"],
                                                 [Common getPrecision9Str:weakSelf.gasPrice],
                                                 [Common getPrecision9Str:weakSelf.gasLimit]];
            
            
            _issendJSType = YES;
            NSString * pwdCheck =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','oep4PSW')", [dict valueForKey:@"key"], [Common transferredMeaning:password], dict[@"address"], [dict valueForKey:@"salt"]];
            [weakSelf.browserView.wkWebView evaluateJavaScript:pwdCheck completionHandler:nil];
            _hub = [ToastUtil showMessage:@"" toView:nil];
        }else{
            token = weakSelf.isOng ? @"ONG" : @"ONT";
            NSString *myvalue = @"";
            weakSelf.sendvalue = value;
            
            if (weakSelf.isOng) {
                myvalue = [Common getONGMul10_9Str:value];
                weakSelf.sendvalue = myvalue;
            }
            
            weakSelf.sendaddress = from;
            weakSelf.receiveaddress = to;
            weakSelf.sendTransferAssetsUrlStr =
            [NSString stringWithFormat
             :@"Ont.SDK.transferAssets('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','sendTransferAssets')",
             token, from, to,
             weakSelf.isOng ? myvalue : value,
             weakSelf.encryptedPrivateKey,
             [Common transferredMeaning:password],
             dict[@"salt"],
             [Common getPrecision9Str:weakSelf.gasPrice],
             [Common getPrecision9Str:weakSelf.gasLimit],
             weakSelf.walletAddr];
            
            _issendJSType = YES;
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:TESTNETADDR]);
//            [weakSelf.browserView.wkWebView evaluateJavaScript:weakSelf.sendTransferAssetsUrlStr completionHandler:nil];
            
            //处理交易失败没有回调-bug
            [weakSelf.browserView.wkWebView evaluateJavaScript:weakSelf.sendTransferAssetsUrlStr completionHandler:^(id dict, NSError * _Nullable error) {
                NSLog(@"%@", error);
                if (error)
                {
                    [weakSelf.hub hideAnimated:YES];
                    [Common showToast:Localized(@"TransactionFailure")];
                    [weakSelf.sendConfirmV dismiss];
                }
                
            }];
            
            _hub = [ToastUtil showMessage:@"" toView:nil];
        }
      
    }];
  }
  return _sendConfirmV;
}

- (IBAction)nextAction:(id)sender {

  [_addressT resignFirstResponder];
  [_balanceT resignFirstResponder];

  if (self.addressT.text.length != 34 || ![[self firstCharactorWithString:self.addressT.text] isEqualToString:@"A"]) {

    MGPopController
        *pop = [[MGPopController alloc] initWithTitle:Localized(@"EnterReceiverAddress") message:nil image:nil];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

    }];
    action.titleColor = MainColor;

    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;

    return;

  }

  if ([Common isStringEmpty:self.addressT.text] || [Common isStringEmpty:self.balanceT.text]) {
    return;
  }

  NSDecimalNumber
      *decimalFee = [[NSDecimalNumber alloc] initWithString:[Common getRealFee:_gasPrice GasLimit:_gasLimit]];;
  NSDecimalNumber *decimalSend = [[NSDecimalNumber alloc] initWithString:self.balanceT.text];
  NSDecimalNumber *decimalAmount = [[NSDecimalNumber alloc] initWithString:self.amount];

  // 这里比较ONG或者ONT发送的总量是否大于余额
  NSComparisonResult resultOfBalanceAndAmount = [decimalSend compare:decimalAmount];
  if (resultOfBalanceAndAmount == NSOrderedDescending) {

    MGPopController
        *pop = [[MGPopController alloc] initWithTitle:Localized(@"TransfergreaterT") message:nil image:nil];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

    }];
    action.titleColor = MainColor;

    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;

    return;
  }

  NSDecimalNumber *decimalCost = nil;
  if (self.isOng) {
    decimalCost = [decimalSend decimalNumberByAdding:decimalFee];
  } else {
    decimalCost = decimalFee;
  }
  NSDecimalNumber *decimalOngAmount = [[NSDecimalNumber alloc] initWithString:self.ongAmount];

  // 这里是比较ong是否足够，如果是发送ong，那么就要把ong手续费和发送的ong加起来和ong余额比较
  NSComparisonResult resultOfCostAndOngAmount = [decimalCost compare:decimalOngAmount];
  if (resultOfCostAndOngAmount == NSOrderedDescending) {
    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"NotenoughONG") message:nil image:nil];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

    }];
    action.titleColor = MainColor;

    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;

    return;
  }

  // 提示性信息，doubleValue丢失一些精度没关系
  if (decimalFee.doubleValue > 0.1) {

    MGPopController *pop = [[MGPopController alloc]
        initWithTitle:[NSString stringWithFormat:Localized(@"transactionfee"), decimalFee
            .stringValue] message:nil image:nil];

    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"Confirm") action:^{
      if (self.isShareWallet) {
        ConfirmPayView *confirmV = [[ConfirmPayView alloc]
             initWithType:!self.isOng money:self.balanceT.text fromAddress:_walletAddr toAddress:self.addressT
                .text fee:_bottomFeeL2.text];
        [confirmV setCallback:^(NSString *string) {
          [self createSureView];
        }];
        _window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [_window addSubview:confirmV];
        [_window makeKeyAndVisible];
      } else {

        self.sendConfirmV.paytoStr = self.addressT.text;
        NSString *jsStr = [Common getEncryptedContent:ASSET_ACCOUNT];
        NSDictionary *dict = [Common dictionaryWithJsonString:jsStr];
        self.sendConfirmV.paybyStr = dict[@"address"];
        self.sendConfirmV.amountStr = self.balanceT.text;
        self.encryptedPrivateKey = dict[@"key"];
        self.sendConfirmV.isOng = _isOng;
        self.sendConfirmV.isPum = _isPum;
        self.sendConfirmV.isDragon = _isDragon;
        self.sendConfirmV.pumType = _pumType;
        self.sendConfirmV.feemoneyStr = _bottomFeeL2.text;
        self.sendConfirmV.isOEP4 = self.isOEP4;
        self.sendConfirmV.tokenDict = self.tokenDict;
        [self.sendConfirmV show];
      }
    }];
    action.titleColor = MainColor;
    [pop addAction:action];
    MGPopAction *action1 = [MGPopAction actionWithTitle:Localized(@"Cancel") action:^{}];
    action.titleColor = MainColor;
    [pop addAction:action1];
    [pop show];
    pop.showCloseButton = NO;
    return;
  }

  if ([decimalSend compare:[NSDecimalNumber zero]] == NSOrderedSame) {

    MGPopController
        *pop = [[MGPopController alloc] initWithTitle:Localized(@"TransferZeroNotice") message:nil image:nil];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

    }];
    action.titleColor = MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;

    return;
  }
  if (self.isShareWallet) {
    ConfirmPayView *confirmV = [[ConfirmPayView alloc]
         initWithType:!self.isOng money:self.balanceT.text fromAddress:_walletAddr toAddress:self.addressT
            .text fee:_bottomFeeL2.text];
    [confirmV setCallback:^(NSString *string) {
      [self createSureView];
    }];
    _window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [_window addSubview:confirmV];
    [_window makeKeyAndVisible];

  } else {

    self.sendConfirmV.paytoStr = self.addressT.text;
    NSString *jsStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsStr];
    self.sendConfirmV.paybyStr = dict[@"address"];
    self.sendConfirmV.amountStr = self.balanceT.text;
    self.encryptedPrivateKey = dict[@"key"];
    self.sendConfirmV.isOng = _isOng;
    self.sendConfirmV.isPum = _isPum;
    self.sendConfirmV.isDragon = _isDragon;
    self.sendConfirmV.pumType = _pumType;
    self.sendConfirmV.feemoneyStr = _bottomFeeL2.text;
    self.sendConfirmV.isOEP4 = self.isOEP4;
    self.sendConfirmV.tokenDict = self.tokenDict;
    [self.sendConfirmV show];
  }

}
- (void)createSureView {
  __weak typeof(self) weakSelf = self;
  _sureV = [[ConfirmJoinView alloc] initWithAddress:self.walletAddr isFirst:YES];
  [_sureV setCallback:^(NSString *address, NSString *password, NSDictionary *selectDic) {
    weakSelf.selectDic = selectDic;
    weakSelf.selectAddress = address;
    weakSelf.selectPWD = password;
    if (password.length == 0) {
      return;
    }
    NSString *jsStr =
        [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')", [selectDic valueForKey:@"key"], [Common transferredMeaning:password], address, [selectDic valueForKey:@"salt"]];
    _jsUrl = jsStr;
    [weakSelf loadJS];
    _hub = [ToastUtil showMessage:@"" toView:nil];
  }];
  _window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
  [_window addSubview:_sureV];
  [_window makeKeyAndVisible];
}

- (void)loadJS {
  if (![Common isStringEmpty:_jsUrl]) {
    [self.browserView.wkWebView evaluateJavaScript:_jsUrl completionHandler:nil];
  }
}

//获取某个字符串或者汉字的首字母.
- (NSString *)firstCharactorWithString:(NSString *)string {

  NSMutableString *str = [NSMutableString stringWithString:string];
  CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
  CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformStripDiacritics, NO);
  NSString *pinYin = [str capitalizedString];
  return [pinYin substringToIndex:1];

}

@end
