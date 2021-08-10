//
//  CreateWaitViewController.m
//  ONTO
//
//  Created by 张超 on 2018/3/2.
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

#import "CreateWaitViewController.h"
#import "BrowserView.h"
#import "BackView.h"
#import "AnimationView.h"
#import "SuccessView.h"
#import "BackupViewController.h"
#import "CCRequest.h"
#import "ToastUtil.h"
#import "DIManageViewController.h"
#import "ViewController.h"
#import "RemenberWordViewController.h"
#import "KeyStoreBackupVC.h"
#import "KeyStoreFileViewController.h"
#import "CreateOntoSuccessViewController.h"
@interface CreateWaitViewController () {
    UILabel *promptL;
    UIImageView *bgIV;
}

@property(nonatomic, strong) BrowserView *browserView;
@property(nonatomic, strong) UIButton *backupBtn;
@property(nonatomic, strong) UIButton *LaterBtn;

@property(nonatomic, strong) AnimationView *animationV;
@property(nonatomic, strong) SuccessView *successV;

@property(nonatomic, copy) NSString *mynewOntID;
@property(nonatomic, copy) NSString *mynewKey;
@property(nonatomic, copy) NSString *address;

@end

@implementation CreateWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self configNav];
}

- (void)configNav {
    [self setNavTitle:self.isWallet ? Localized(@"CreateWallet") : Localized(@"createOntId")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}

- (void)navLeftAction {
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)configUI {
    bgIV = [[UIImageView alloc] init];
//    bgIV.image = [UIImage imageNamed:@"wait_bg"];
    [self.view addSubview:bgIV];

    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.right.equalTo(self.view);
      make.height.mas_equalTo(@(200 * kScreenWidth / 375));
    }];

    self.animationV = [[AnimationView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [self.animationV setCallback:^{
      [weakSelf showSuccessView:NO];
    }];
    [self.view addSubview:self.animationV];

    [self.animationV mas_makeConstraints:^(MASConstraintMaker *make) {
      if (LL_iPhone5S) {
          make.top.equalTo(self.view).offset(15);

      } else {
          make.top.equalTo(self.view).offset(88);

      }

      make.centerX.mas_equalTo(self.view);
      make.size.mas_equalTo(CGSizeMake(125, 125));
    }];
    [self.animationV layoutIfNeeded];

    promptL = [[UILabel alloc] init];
    promptL.font =
        [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]; //[UIFont fontWithName:@"SFProText-Medium" size:16];
    promptL.text = self.isWallet ? Localized(@"CreateWalletPrompt") : Localized(@"ONTIDCreating");
    promptL.textAlignment = NSTextAlignmentCenter;
    promptL.textColor = [UIColor colorWithHexString:@"#AAB3B4"];
    [self.view addSubview:promptL];

    [promptL mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.mas_equalTo(self.view);
      make.top.equalTo(self.animationV.mas_bottom).offset(18.5);
    }];

    UILabel *noteL = [[UILabel alloc] init];
    noteL.font = K18FONT;
    noteL.text = Localized(@"ONTIDInfo");
    noteL.textAlignment = NSTextAlignmentCenter;
    noteL.textColor = [UIColor colorWithHexString:@"#6A797C"];
    [self.view addSubview:noteL];

    [noteL mas_makeConstraints:^(MASConstraintMaker *make) {

      make.top.equalTo(promptL.mas_bottom).offset(65);
      make.left.right.equalTo(self.view);
    }];

    UILabel *contentL = [[UILabel alloc] init];
    contentL.numberOfLines = 0;
    contentL.textColor = [UIColor colorWithHexString:@"#AAB3B4"];
    contentL.font = K16FONT;
    contentL.text = Localized(@"ONTIDDec");
    [self.view addSubview:contentL];

    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view).offset(46);
      make.right.equalTo(self.view).offset(-36);
      make.top.equalTo(noteL.mas_bottom).offset(15);
    }];

    self.backupBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    self.backupBtn.titleLabel.font = K18FONT;
    self.backupBtn.hidden = YES;
    [self.backupBtn setTitle:Localized(@"BackUpNow") forState:UIControlStateNormal];
    [self.backupBtn setTitleColor:DARKBLUELB forState:UIControlStateNormal];
    [self.backupBtn addTarget:self action:@selector(backupAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backupBtn];

    [self.backupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(@50);
      make.centerX.mas_equalTo(self.view);
      make.bottom.mas_equalTo(self.view).offset(-65);
        if (KIsiPhoneX) {
            make.bottom.mas_equalTo(self.view).offset(-99);
        }else{
            make.bottom.mas_equalTo(self.view).offset(-65);
        }
      make.left.mas_equalTo(self.view).offset(20);
      make.right.mas_equalTo(self.view).offset(-20);
    }];

    self.LaterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LaterBtn.hidden = YES;

    self.LaterBtn.titleLabel.font = K18FONT;
    self.LaterBtn.backgroundColor = [UIColor colorWithHexString:@" #EDF2F5"];
    [self.LaterBtn setTitle:Localized(@"ontstart") forState:UIControlStateNormal];
    [self.LaterBtn setTitleColor:DARKBLUELB forState:UIControlStateNormal];
    [self.LaterBtn addTarget:self action:@selector(backuoLaterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.LaterBtn];

    if (_isWallet) {
        self.LaterBtn.hidden = YES;
    }

    [self.LaterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(@48);
        if (KIsiPhoneX) {
            make.bottom.mas_equalTo(self.view).offset(-34);
        }else{
            make.bottom.mas_equalTo(self.view).offset(0);
        }
      
      make.left.mas_equalTo(self.view).offset(0);
      make.right.mas_equalTo(self.view).offset(0);
    }];

}

- (void)backuoLaterAction {

    if (self.isWallet || _isIdentity) {
        //资产账户导入成功跳转到资产根页
        [self.navigationController popToRootViewControllerAnimated:YES];

    } else {
        if ([self.LaterBtn.titleLabel.text isEqualToString:Localized(@"ontstart")]) {

            if (_isFirst) {

                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISFIRST_BACKUP];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [ViewController gotoIdentityVC];

            } else {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[DIManageViewController class]]) {
                        DIManageViewController *vc = (DIManageViewController *) controller;
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }

        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
    }

}

- (void)backupAction:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:Localized(@"BackUpNow")]) {
        if (_isWallet) {

            [self presentAlart];

        } else {
            //备份

            NSString *str = [Common getEncryptedContent:APP_ACCOUNT];
            NSDictionary *jsDic = [Common dictionaryWithJsonString:str];
//            KeyStoreBackupVC *vc = [[KeyStoreBackupVC alloc]init];
//            vc.isWallet = NO;
//            vc.isFirstIdentity = YES;
            NSDictionary *dic = [NSMutableArray arrayWithArray:jsDic[@"identities"]][
                [[NSMutableArray arrayWithArray:jsDic[@"identities"]] count] - 1];
//
//                vc.identityDic = dic;
//                vc.name =  dic[@"label"];
//
//            [self.navigationController pushViewController:vc animated:YES];

            KeyStoreFileViewController *vc = [[KeyStoreFileViewController alloc] init];
            vc.identityDic = dic;
            vc.isWallet = NO;
            vc.isFirstIdentity = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }

    } else {
        //重新注册
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)presentAlart {

    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:nil message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];

    //增加取消按钮；

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(
        UIAlertAction *_Nonnull action) {

    }]];

    //增加确定按钮；

    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //获取第1个输入框；
        UITextField *userNameTextField = alertController.textFields.firstObject;
        DebugLog(@"支付密码 = %@",userNameTextField.text);
        
        if ([_password isEqualToString:userNameTextField.text]) {
            RemenberWordViewController *vc = [[RemenberWordViewController alloc]init];
            vc.remenberWord = [Common getEncryptedContent:_address];
            vc.address =_address;
            vc.confirmPwd = _password;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [Common showToast:Localized(@"PASSWORDERROR")];
//              [ToastUtil shortToast:self.view value:Localized(@"PASSWORDERROR")];
            
        }
        
    }]];
    //定义第一个输入框；

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {

      textField.placeholder = @"请输入密码";
      textField.secureTextEntry = YES;
      textField.keyboardType = UIKeyboardTypeNumberPad;
      [textField addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];

    }];

    [self presentViewController:alertController animated:true completion:nil];
}
- (void)textFieldDidChange1:(UITextField *)textField {

    if (textField.text.length > 6) {

        textField.text = [textField.text substringToIndex:6];

    }

}
- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.view addSubview:self.browserView];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}
- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }

}

- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
          DebugLog(@"prompt=%@", prompt);
          [weakSelf handlePrompt:prompt];
        }];
        [_browserView setCallbackJSFinish:^{
          [weakSelf loadJS];
        }];
    }
    return _browserView;
}

- (void)loadJS {
    NSString *jsStr;

    if (self.isWallet) {
        //创建钱包
        jsStr =
            [NSString stringWithFormat:@"Ont.SDK.createAccount('%@','%@','getAssetAccountDataStr')", self.label, self
                .password];

    } else if (_isIdentity) {
        //第二次创建身份账户
        jsStr = [NSString stringWithFormat:@"Ont.SDK.createIdentity('%@','%@','%@','%@','%@','createIdentity')", self
            .label, self.password, [[NSUserDefaults standardUserDefaults]
                                               valueForKey:ONTPASSADDRSS], [[NSUserDefaults standardUserDefaults]
                                               valueForKey:ONTIDGASPRICE], [[NSUserDefaults standardUserDefaults]
                                               valueForKey:ONTIDGASLIMIT]];
    } else {
        jsStr = [NSString stringWithFormat:@"Ont.SDK.createWallet('%@','%@','%@','%@','%@','getWalletDataStr')", self
            .label, self.password, [[NSUserDefaults standardUserDefaults]
                                               valueForKey:ONTPASSADDRSS], [[NSUserDefaults standardUserDefaults]
                                               valueForKey:ONTIDGASPRICE], [[NSUserDefaults standardUserDefaults]
                                               valueForKey:ONTIDGASLIMIT]];
    }

    //节点方法 每次调用JSSDK前都必须调用
    LOADJS1;
    LOADJS2;
    LOADJS3;
    NSLog(@"jsStr ->%@<-",jsStr);
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
//    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable, NSError * _Nullable error) {
//
//    }];

}

- (void)handlePrompt:(NSString *)prompt {

    //第一次创建身份第一个方法
    if ([prompt hasPrefix:@"getWalletDataStr"]) {

        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        id obj =
            [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {

            [self showSuccessView:NO];

            return;
        }

        NSMutableString *str = [obj valueForKey:@"result"];
        NSDictionary *jsDic = [self parseJSONStringToNSDictionary:str];
        NSString *defaultOntid = [jsDic valueForKey:@"defaultOntid"];

        NSMutableString *appStr1 = [NSMutableString stringWithString:str];

        [[NSUserDefaults standardUserDefaults] setValue:defaultOntid forKey:ONT_ID];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_CREATED];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@DeviceCode",defaultOntid ] ];
        
        [Common setEncryptedContent:[appStr1 stringByReplacingOccurrencesOfString:@"\n" withString:@""] WithKey:APP_ACCOUNT];

        [[NSUserDefaults standardUserDefaults] synchronize];

        NSArray *identities = [jsDic valueForKey:@"identities"];
        NSString *encryptedPrivateKey = [[[identities[0] valueForKey:@"controls"] objectAtIndex:0] valueForKey:@"key"];
        NSString *identityName = [identities[0] valueForKey:@"label"];
        [[NSUserDefaults standardUserDefaults] setValue:identityName forKey:IDENTITY_NAME];
        [[NSUserDefaults standardUserDefaults] setValue:encryptedPrivateKey forKey:ENCRYPTED_PRIVATEKEY];

        NSDictionary *params = @{@"OwnerOntId": [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID],
            @"TxnStr": [obj valueForKey:@"tx"]};
        [[CCRequest shareInstance]
            requestWithHMACAuthorization:Ontidregister MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                                         id responseOriginal) {
          if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
              [self showSuccessView:NO];
              return;
          }

          [self showSuccessView:YES];
          NSString *deviceCode = [responseObject valueForKey:@"DeviceCode"];
          [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:DEVICE_CODE];
          [[NSUserDefaults standardUserDefaults]
              setValue:deviceCode forKey:[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]];
          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_EXISIT];
          //存下时间戳和密码
          [Common setTimestampwithPassword:_password WithOntId:[[NSUserDefaults standardUserDefaults]
              valueForKey:ONT_ID]];

        }                        Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {

        }];

    } else if ([prompt hasPrefix:@"signDataStr"]) {
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        NSDictionary *signature = [self parseJSONStringToNSDictionary:resultStr];

        id obj =
            [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [self showSuccessView:NO];
            return;
        }

        NSDictionary *params =
            @{@"OwnerOntId": [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID], @"Signature": signature};
        [[CCRequest shareInstance]
            requestWithURLStringNoLoading:Devicecode_gain MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                                            id responseOriginal) {
          if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {

              [self showSuccessView:NO];
              return;
          }
          [self.animationV A_stopAnimation];
          [self showSuccessView:YES];
          NSString *deviceCode = [responseObject valueForKey:@"DeviceCode"];
          [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:DEVICE_CODE];
          [[NSUserDefaults standardUserDefaults]
              setValue:deviceCode forKey:[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]];
          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_EXISIT];
          //存下时间戳和密码
          [Common setTimestampwithPassword:_password WithOntId:[[NSUserDefaults standardUserDefaults]
              valueForKey:ONT_ID]];
        }                         Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {

        }];
    } else if ([prompt hasPrefix:@"getAssetAccountDataStr"]) { //创建AssetAccount

        self.backupBtn.userInteractionEnabled = YES;
        self.LaterBtn.userInteractionEnabled = YES;

        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        id obj =
            [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

        if ([[obj valueForKey:@"error"] integerValue] > 0) {

            [self showSuccessView:NO];
            return;
        }

        DebugLog(@"~~~~~~~~%@", [obj valueForKey:@"result"]);
        NSMutableString *str = [obj valueForKey:@"result"];

        NSDictionary *jsDic = [self parseJSONStringToNSDictionary:str];

        NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
        NSMutableArray *newArray;
        if (allArray) {
            newArray = [[NSMutableArray alloc] initWithArray:allArray];
        } else {
            newArray = [[NSMutableArray alloc] init];
        }
        [newArray addObject:jsDic];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:ALLASSET_ACCOUNT];

        //储存助记词
        [Common setEncryptedContent:(NSString *) [obj valueForKey:@"mnemonicEnc"] WithKey:[jsDic valueForKey:@"address"]];

        _address = [jsDic valueForKey:@"address"];
        _passwordHash = [jsDic valueForKey:@"passwordHash"];
        NSString *jsonStr = [Common dictionaryToJson:newArray[newArray.count - 1]];
        [Common setEncryptedContent:jsonStr WithKey:ASSET_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self.animationV A_stopAnimation];
        [self showSuccessView:YES];

    } else if ([prompt hasPrefix:@"createIdentity"]) {
        //添加identity

        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        id obj =
            [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [self showSuccessView:NO];
            return;
        }

        NSMutableString *str = [obj valueForKey:@"result"];

        NSMutableDictionary *jsDic =
            [NSMutableDictionary dictionaryWithDictionary:[self parseJSONStringToNSDictionary:[Common getEncryptedContent:APP_ACCOUNT]]];

        NSMutableArray *arrIdentity = [NSMutableArray arrayWithArray:jsDic[@"identities"]];
        NSDictionary *dic = [self parseJSONStringToNSDictionary:str];
        [arrIdentity addObject:dic];
        [jsDic setValue:arrIdentity forKey:@"identities"];
        NSString *appStr = [self DataTOjsonString:jsDic];
        _mynewOntID = [dic valueForKey:@"ontid"];

        NSDictionary *params = @{@"OwnerOntId":_mynewOntID,@"TxnStr":[obj valueForKey:@"tx"]};

        [[CCRequest shareInstance]
         requestWithHMACAuthorization:Ontidregister MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                                      id responseOriginal) {
             if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
                 [self showSuccessView:NO];
                 return;
             }
             [self showSuccessView:YES];
             NSString *deviceCode = [responseObject valueForKey:@"DeviceCode"];
             [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:_mynewOntID];
             //存下时间戳和密码
             [Common setTimestampwithPassword:_password WithOntId:_mynewOntID];
             _mynewKey = [[[dic valueForKey:@"controls"] objectAtIndex:0] valueForKey:@"key"];
             NSMutableString *appStr1 = [NSMutableString stringWithString:appStr];
             [Common setEncryptedContent:[appStr1 stringByReplacingOccurrencesOfString:@"\n" withString:@""] WithKey:APP_ACCOUNT];
             
             
             //设为默认身份
             {
                 
                 
                 NSString * key = [dic [@"controls"] valueForKey:@"key"];
                 NSString * identityName = [dic valueForKey:@"label"];
                 [[NSUserDefaults standardUserDefaults] setValue:[dic valueForKey:@"ontid"] forKey:ONT_ID];
                 [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@DeviceCode",[dic valueForKey:@"ontid"] ] ];
                 [[NSUserDefaults standardUserDefaults] setValue:identityName forKey:IDENTITY_NAME];
                 [[NSUserDefaults standardUserDefaults] setValue:key forKey:ENCRYPTED_PRIVATEKEY];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 NSInteger selet = [[jsDic valueForKey:@"identities"] count]-1;
                 [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", @(selet)] forKey:SELECTINDEX];
                 NSString *deviececode = [responseObject valueForKey:@"DeviceCode"];
                 [[NSUserDefaults standardUserDefaults] setValue:deviececode forKey:DEVICE_CODE];
                 
                 
                 [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SOCKET_LOGOUT object:nil];
                 //切换后 websoket 需要重连
                 AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                 appDelegate.isSocketConnect = YES;
                 
                 
             }
             
             
         } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
             [self.animationV A_stopAnimation];
             [self showSuccessView:NO];
         }];
        

    } else if ([prompt hasPrefix:@"NewsignDataStr"]) {
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];

        id obj =
            [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

        if ([[obj valueForKey:@"error"] integerValue] > 0) {

            [self showSuccessView:NO];
            return;
        }

        NSDictionary *signature = [self parseJSONStringToNSDictionary:resultStr];
        NSDictionary *params = @{@"OwnerOntId": _mynewOntID, @"Signature": signature};
        [[CCRequest shareInstance]
            requestWithURLStringNoLoading:Devicecode_gain MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                                            id responseOriginal) {

          if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {

              [self showSuccessView:NO];
              return;
          }

          [self showSuccessView:YES];
          NSString *deviceCode = [responseObject valueForKey:@"DeviceCode"];
          [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:_mynewOntID];
          //存下时间戳和密码
          [Common setTimestampwithPassword:_password WithOntId:_mynewOntID];

        }                         Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
          [self.animationV A_stopAnimation];
          [self showSuccessView:NO];
        }];
    }

}

- (NSString *)DataTOjsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        DebugLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary
        *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

- (void)showSuccessView:(BOOL)isSuccess {
    [self.animationV A_stopAnimation];
    self.animationV.timeL.hidden = YES;
    if (isSuccess) {
        if (_isWallet) {
            self.backupBtn.hidden = NO;
            self.LaterBtn.hidden = NO;
            promptL.text = Localized(@"Done");
            promptL.textColor = BLUELB;
            self.animationV.imageV.image = [UIImage imageNamed:@"createSucess"];
        }else{
            CreateOntoSuccessViewController* vc= [[CreateOntoSuccessViewController alloc]init];
            vc.isFirst = self.isFirst;
            vc.isIdentity = self.isIdentity;
            [self.navigationController pushViewController:vc animated:NO];
            
        }

//        return;
    } else {
        promptL.text = Localized(@"CreateFailed");
        promptL.textColor = [UIColor colorWithHexString:@"#6A797C"];
        self.backupBtn.hidden = YES;
        self.LaterBtn.hidden = NO;
        [self.LaterBtn setTitle:Localized(@"CFCATryAgain") forState:UIControlStateNormal];
        self.animationV.imageV.image = [UIImage imageNamed:@"createFail"];
    }

    if (_isWallet) {
        [self.backupBtn setBackgroundColor:MainColor];
        [self.backupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }

    if (_isWallet) {
        self.successV.successL.text = Localized(@"SuccessWalletAlert");

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:
            Localized(@"WalletSuccessContent")];
        self.successV.successContentL.attributedText = str;
    }
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
