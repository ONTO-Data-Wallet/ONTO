//
//  ConfirmPwdViewController.m
//  ONTO
//
//  Created by 张超 on 2018/3/11.
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

#import "ConfirmPwdViewController.h"
#import "PwdEnterView.h"
#import "ImportSuccessViewController.h"
#import "CCRequest.h"
#import "BackupViewController.h"
#import "WebConsole.h"
#import "RemenberWordViewController.h"
#import "KeyStoreBackupVC.h"
#import "KeyStoreFileViewController.h"

@interface ConfirmPwdViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) PwdEnterView *pwdView;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, copy) NSString *confirmPwd;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, copy) NSString *mynewOntid;//新增identity的idd
@end

@implementation ConfirmPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    
    
    [WebConsole enable];

}


- (void)configUI {
    
    if (_isClaims==NO) {
    }
    
    [self setNavTitle:Localized(@"EnterPwd")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    
    UILabel * nameLB =[[UILabel alloc]init];
    nameLB.textColor =[UIColor colorWithHexString:@"#6A797C"];
    nameLB.text =self.identityName;
    nameLB.textAlignment =NSTextAlignmentLeft;
    nameLB.font =[UIFont systemFontOfSize:32 weight:UIFontWeightBold];
    [self.view addSubview:nameLB];
    
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(32);
        make.top.equalTo(self.view).offset(16);
    }];
    
    UIView * blueLine =[[UIView alloc]init];
    blueLine.backgroundColor =[UIColor colorWithHexString:@"#35BFDF"];
    [self.view addSubview:blueLine];
    
    [blueLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.left.equalTo(self.view);
        make.width.mas_offset(4);
        make.height.mas_offset(82);
    }];
    
    
    UILabel *setL = [[UILabel alloc] init];
    setL.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    setL.textColor = [UIColor colorWithHexString:@"#2B4045"];
//    setL.text = Localized(@"PleaseEnterPwd"); //LoginRetypePassword
    setL.text =Localized(@"Password");
    [self.view addSubview:setL];
    
    [setL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(24);
        make.top.equalTo(self.view).offset(92);
    }];

    
    _password =[[UITextField alloc]init];
    _password.textColor =[UIColor colorWithHexString:@"#2B4045"];
    _password.font =K14FONT;
    _password.delegate =self;
    _password.keyboardType = UIKeyboardTypeNumberPad;
    _password.secureTextEntry =YES;
    _password.placeholder = Localized(@"EnterONTIDPwd");
    [self.view addSubview:_password];
    
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(118);
        make.left.equalTo(self.view).offset(24);
        make.right.equalTo(self.view).offset(-24);
        make.height.mas_offset(30);
    }];
    
    UIView* line =[[UIView alloc]init];
    line.backgroundColor =LIGHTGRAYBG;
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_password);
        make.top.equalTo(_password.mas_bottom).offset(0);
        make.height.mas_offset(1);
    }];
    
    UILabel *noteL = [[UILabel alloc] init];
    noteL.font = K18FONT;
    noteL.text = Localized(@"ONTIDInfo");
    noteL.textAlignment =NSTextAlignmentCenter;
    noteL.textColor = [UIColor colorWithHexString:@"#6A797C"];
    [self.view addSubview:noteL];
    
    [noteL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(218);
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


    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:Localized(@"ONTImport") forState:UIControlStateNormal];
    [confirmBtn setTitleColor:DARKBLUELB forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];

    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.view.mas_bottom).offset(-48);
        make.height.mas_equalTo(@48);
        make.left.mas_equalTo(self.view).offset(0);
        make.right.mas_equalTo(self.view).offset(0);
        //////
    }];
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmAction {
 
    if (_password.text.length == 6) {
        //身份备份验证
        if (_ontID) {
            if ([Common judgePasswordisMatchWithPassWord:_password.text WithOntId:_ontID]) {

                BackupViewController *backupVC = [[BackupViewController alloc] init];
                backupVC.isDigitalIdentity = _isDigitalIdentity;
                backupVC.identityDic = _identityDic;
                backupVC.name = _name;
                [self.navigationController pushViewController:backupVC animated:YES];
                [Common setTimestampwithPassword:_password.text WithOntId:_ontID];
                
            }else{
                
                MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
                MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                    
                }];
                action.titleColor =MainColor;
                [pop addAction:action];
                [pop show];
                pop.showCloseButton = NO;
                
            }
            return;
        }
        
        //钱包备份验证
        if (_walladdress) {
            
       NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','decryptEncryptedPrivateKey')",[self.identityDic valueForKey:@"key"] ,_password.text,self.walladdress];


            [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
            __weak typeof(self) weakSelf = self;
            [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
                [weakSelf handlePrompt:prompt];
            }];
            
            
            
            return;

        }

        if (_isClaims==YES) {
            if ([self.delegate respondsToSelector:@selector(getCalim:)]) {
                // 调用代理对象的登录方法，代理对象去实现登录方法
                [self.delegate getCalim:_password.text];
                [self.navigationController popViewControllerAnimated:YES];
            }
            return;
        }
        
        [self showHudInView:self.view hint:Localized(@"Importing")];
        NSString *jsStr;
        if (self.isWallet) {
            // 调用导入钱包接口
            jsStr  =  [NSString stringWithFormat:@"Ont.SDK.importAccountWithQrcode('%@','%@','%@','%@','importAccountWithWallet')",self.identityName,self.encryptedStr,_password.text,self.prefix];
        } else {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:IDENTITY_CREATED]) {
            //第二次导入身份
            jsStr  =  [NSString stringWithFormat:@"Ont.SDK.importIdentityWithWallet('%@','%@','%@','%@','%@','importIdentityWithWallet')",[Common getEncryptedContent:APP_ACCOUNT] ,self.identityName,self.encryptedStr,_password.text,self.prefix];
        } else {
            //第一次
           jsStr  =  [NSString stringWithFormat:@"Ont.SDK.importIdentityAndCreateWallet('%@','%@','%@','%@','importIdentityAndCreateWallet')",self.identityName,self.encryptedStr,_password.text,self.prefix];
        }}
        
        //节点方法 每次调用JSSDK前都必须调用
       
        [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:[jsStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] completionHandler:nil];
        __weak typeof(self) weakSelf = self;
        [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
            [weakSelf handlePrompt:prompt];
        }];
    }
}

- (void)handlePrompt:(NSString *)prompt {
    
    if ([prompt hasPrefix:@"importAccountWithWallet"]) { //创建AssetAccount
         [self hideHud];
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            
            [self failAction];
            return;
        }
        
        DebugLog(@"~~~~~~~~%@",[obj valueForKey:@"result"]);
        NSMutableString *str=[obj valueForKey:@"result"];
        NSDictionary *jsDic= [self parseJSONStringToNSDictionary:str];
        NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
        NSMutableArray *newArray;
        if (allArray) {
            newArray = [[NSMutableArray alloc] initWithArray:allArray];
        } else {
            newArray = [[NSMutableArray alloc] init];
        }
        //防止重复添加
        for (int i=0; i<allArray.count; i++) {
            if ( [[allArray[i] valueForKey:@"key"]isEqualToString:[[jsDic valueForKey:@"accounts"][0]valueForKey:@"key"]]) {
                ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
                vc.isWallect = self.isWallet;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }
        
        [newArray addObject:jsDic];
       
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:ALLASSET_ACCOUNT];
        [Common setEncryptedContent:[Common dictionaryToJson:newArray[newArray.count-1]] WithKey:ASSET_ACCOUNT];
        ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
        vc.isWallect = self.isWallet;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else  if ([prompt hasPrefix:@"importIdentityAndCreateWallet"]) { //导入
        [self hideHud];
        DebugLog(@"improtIdentity=%@",prompt);
//        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        DebugLog(@"%@",obj);
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            
        ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
            vc.isFailure = YES;
            vc.isWallect = self.isWallet;
            [self.navigationController pushViewController:vc animated:YES];
        }
 else {
        id result = [NSJSONSerialization JSONObjectWithData:[[obj valueForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        DebugLog(@"!!!!!%@",result);
        NSMutableString *str=[obj valueForKey:@"result"];
        
    NSString *str1 =  [str stringByReplacingOccurrencesOfString:@"\"isDefault\":false" withString:@"\"isDefault\":\"false\""];
        
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\"isDefault\":ture" withString:@"\"isDefault\":\"ture\""];
        
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_CREATED];
     [Common setEncryptedContent:str2 WithKey:APP_ACCOUNT];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_CREATED];
            
    [[NSUserDefaults standardUserDefaults] synchronize];
        NSDictionary *jsDic= [self parseJSONStringToNSDictionary:str2];
     
     NSString *defaultOntid = [jsDic valueForKey:@"defaultOntid"];
     [[NSUserDefaults standardUserDefaults] setValue:defaultOntid forKey:ONT_ID];
     [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@DeviceCode",defaultOntid ] ];
     NSArray *identities = [jsDic valueForKey:@"identities"];
     NSString *identityName = [identities[0] valueForKey:@"label"];
     [[NSUserDefaults standardUserDefaults] setValue:identityName forKey:IDENTITY_NAME];
     
     NSString *jsStr =  [NSString stringWithFormat:@"Ont.SDK.signData('%@','%@','%@','%@','signDataStr')",defaultOntid,self.encryptedStr,_password.text,self.prefix];

     [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
     __weak typeof(self) weakSelf = self;
     [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
         [weakSelf handlePrompt:prompt];
     }];
 }
        
    }else if ([prompt hasPrefix:@"importIdentityWithWallet"]){
        //添加identity
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            
            ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
            vc.isFailure = YES;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }

        id result = [NSJSONSerialization JSONObjectWithData:[[obj valueForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        DebugLog(@"!!!!!%@",result);
        NSMutableString *str=[obj valueForKey:@"result"];
//        [[NSUserDefaults standardUserDefaults] setValue:str forKey:APP_ACCOUNT];
        [Common setEncryptedContent:str WithKey:APP_ACCOUNT];

        NSDictionary *jsDic= [self parseJSONStringToNSDictionary:str];
        NSArray *arr = jsDic[@"identities"];
        
        NSDictionary *newIdenDic = arr[arr.count-1];
        _mynewOntid = [newIdenDic valueForKey:@"ontid"];
        NSString *newKey = [[newIdenDic valueForKey:@"controls"][0] valueForKey:@"key"];
        NSString *jsStr =  [NSString stringWithFormat:@"Ont.SDK.signData('%@','%@','%@','%@','newsignDataStr')",_mynewOntid,newKey,_password.text,self.prefix];
    
        [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        __weak typeof(self) weakSelf = self;
        [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
            [weakSelf handlePrompt:prompt];
        }];
        
    }else if ([prompt hasPrefix:@"newsignDataStr"]) {
       
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
     
        NSDictionary *signature = [self parseJSONStringToNSDictionary:resultStr];
        NSDictionary *params = @{@"OwnerOntId":_mynewOntid,@"Signature":signature};
        
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [self failAction];
            return;
        }
        
        [[CCRequest shareInstance] requestWithURLStringNoLoading:Devicecode_gain MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
            
            if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
                
                [self failAction];
                return;
            }
            
            //导入identity后储存devicCode
    
            NSString *deviceCode = [responseObject valueForKey:@"DeviceCode"];
            [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:_mynewOntid];
            
//            [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:DEVICE_CODE];
            
            ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
            vc.isWallect = self.isWallet;
            [self.navigationController pushViewController:vc animated:YES];
            //存下时间戳和密码
            [Common setTimestampwithPassword:_password.text WithOntId:_mynewOntid];
        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
            
            
        }];
        
    }else if ([prompt hasPrefix:@"signDataStr"]) {
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        NSDictionary *signature = [self parseJSONStringToNSDictionary:resultStr];
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [self failAction];
            return;
        }

        
        NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],@"Signature":signature};
        [[CCRequest shareInstance] requestWithURLStringNoLoading:Devicecode_gain MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
            
            if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
                ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
                vc.isFailure = YES;
                vc.isWallect = _isWallet;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            
            NSString *deviceCode = [responseObject valueForKey:@"DeviceCode"];
            [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:DEVICE_CODE];
            [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];

            //存下时间戳和密码
            [Common setTimestampwithPassword:_password.text WithOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
            
            ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
            vc.isWallect = self.isWallet;
            [self.navigationController pushViewController:vc animated:YES];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_EXISIT];

        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
            
            
        }];
    }else if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
            
            if (_ismnenomix) {
                
                    RemenberWordViewController *vc = [[RemenberWordViewController alloc]init];
                    vc.address = _walladdress;
                    vc.remenberWord = [Common getEncryptedContent:_walladdress];
                    [self.navigationController pushViewController:vc animated:YES];
            }else{

//                KeyStoreBackupVC *backupVC = [[KeyStoreBackupVC alloc] init];
//                                backupVC.isWallet = YES;
//                                backupVC.identityDic = _identityDic;
//                                backupVC.name = _name;
//                [self.navigationController pushViewController:backupVC animated:YES];
                
                
                KeyStoreFileViewController *vc = [[KeyStoreFileViewController alloc] init];
                vc.identityDic = _identityDic;
                vc.isWallet = NO;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
           
            
        }else{
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
        }
    }
}

- (void)failAction{
    
    ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
    vc.isFailure = YES;
    vc.isWallect = _isWallet;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
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
