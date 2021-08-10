//
//  KeystoreImportVC.m
//  ONTO
//
//  Created by 赵伟 on 24/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "KeystoreImportVC.h"
#import "BrowserView.h"
#import "ImportSuccessViewController.h"
#import "ToastUtil.h"
#import "HYKeyboard.h"
#import "UITextView+Placeholder.h"
#import "WebIdentityViewController.h"
#import "ImportViewController.h"
#import "Config.h"
#import "ClaimModel.h"
#import "DataBase.h"

#define textViewfont 14

#define KEYBOARD_NIB_PATH @"BangcleSafeKeyBoard.bundle/resources/HYKeyboard"

typedef NS_ENUM(NSInteger, PWDType) {
    PWDTypeDefault,
    PWDTypeNext,
};
@interface KeystoreImportVC ()<HYKeyboardDelegate,UITextFieldDelegate>
{
    HYKeyboard*keyboard;
    NSString*inputText;
}

@property (weak, nonatomic) IBOutlet UITextField *passwordF;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (nonatomic, strong) BrowserView *browserView;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, strong) OTAlertView *alert;
@property (assign, nonatomic) BOOL isSelect;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTop;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLB;

@property (nonatomic, copy) NSString *mynewOntid;//新增identity的idd
@property (nonatomic, copy) NSString *myAppStr;//新增后的所有identity的string
@property (nonatomic, copy) NSDictionary *mynewDic;//新增identity的string
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passFTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottombtnTop;

@end

@implementation KeystoreImportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
    [self protocolIsSelect:_isSelect];
}

-(void)configUI{
    
    if (!_isIdentity) {
        [_textViewTop setConstant:16];
        _topLabel.hidden = YES;

    }
    self.topLabel.text = Localized(@"keystoreImport");
    self.comfirmBtn.layer.cornerRadius = 1;
    self.comfirmBtn.layer.masksToBounds = YES;
    [self.comfirmBtn setTitle:Localized(@"ONTImport") forState:UIControlStateNormal];
    self.mytextView.layer.cornerRadius = 4;
    self.mytextView.layer.masksToBounds = YES;
    self.mytextView.placeholderLabel.text = Localized(@"Enterkeystore");
    [self.helpBtn setTitle:Localized(@"Whatkeystore") forState:UIControlStateNormal];
    
    //密码
    self.passwordF.borderStyle = UITextBorderStyleNone;
    self.passwordF.font = K14FONT;
    self.passwordF.placeholder = Localized(@"passwordLBText");
    self.passwordF.secureTextEntry = YES;
    //键盘需要输入字符-bug
//    self.passwordF.keyboardType = UIKeyboardTypeNumberPad;
    if (!_isIdentity) {
//        self.passwordF.delegate = self;

    }
    
    [self.passwordF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.mytextView.textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16);

    
    [self.comfirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.comfirmBtn.userInteractionEnabled = NO;
    
    [self.checkBox addTarget:self action:@selector(checkBoxAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkBox setImage:[UIImage imageNamed:@"login_checkbox"] forState:UIControlStateNormal];
    [self.checkBox setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateSelected];
    
    self.passwordLB.text =_isIdentity?Localized(@"passwordLB"):Localized(@"Password");
    
    [self setNavTitle:Localized(@"ImportAIdentity")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
//    [self setNavRightImageIcon:[UIImage imageNamed:@"IDScan"] Title:nil];
    if (LL_iPhone5S) {
        [_textViewHeight setConstant:130];
        [_passFTop setConstant:40];
        self.navigationController.navigationBar.translucent = NO;
        if (_isIdentity) {
            [_btnBottom setConstant:0];

        }
    }
    
//    [_btnBottom setConstant:LL_StatusBarAndNavigationBarHeight];

    if (kScreenWidth==375&&kScreenHeight==667) {
        [_bottombtnTop setConstant:20];
    }
    if (kScreenWidth==320) {
        [_bottombtnTop setConstant:30];
    }
    if (kScreenWidth==414) {
        [_bottombtnTop setConstant:88];
    }
}

- (void)navLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)navRightAction {
  
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"CameraRights") message:@"" preferredStyle: UIAlertControllerStyleAlert];
    
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
            return;
        }
    
    ImportViewController *vc = [[ImportViewController alloc] init];
    vc.isKeyStore = YES;
    [vc setCallback:^(NSString *stringValue) {
        self.mytextView.text = stringValue;
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)checkBoxAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        [self.comfirmBtn  setTitleColor:MainColor forState:UIControlStateNormal];
        self.comfirmBtn.userInteractionEnabled = YES;
        
    } else {
        
        [self.comfirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.comfirmBtn.userInteractionEnabled = NO;
        
    }
    
}


- (void)protocolIsSelect:(BOOL)select {
    
    //    LoginService = "我已阅读并同意服务条款及隐私协议.";
    //    the Terms of Service = "服务条款";
    //    Privacy Policy  = "隐私协议";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:Localized(@"LoginService")];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"zhifubao://"
                             range:[[attributedString string] rangeOfString:Localized(@"TheTermsofService")]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"weixin://"
                             range:[[attributedString string] rangeOfString:Localized(@"PrivacyPolicy")]];
    //    [attributedString addAttribute:NSLinkAttributeName
    //                             value:@"jianhang://"
    //                             range:[[attributedString string] rangeOfString:@"《建行协议》"]];
    
    
    UIImage *image = [UIImage imageNamed:select == YES ? @"login_checked" : @"dis"];
    CGSize size = CGSizeMake(0, 0);
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    [image drawInRect:CGRectMake(0, 2, size.width, size.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = resizeImage;
    NSMutableAttributedString *imageString = [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
    [imageString addAttribute:NSLinkAttributeName
                        value:@"checkbox://"
                        range:NSMakeRange(0, imageString.length)];
    [attributedString insertAttributedString:imageString atIndex:0];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:textViewfont] range:NSMakeRange(0, attributedString.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10; // 调整行间距
    NSRange range = NSMakeRange(0, imageString.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    //    _textview.textColor = [UIColor colorWithHexString:@"#6A797C"];
    _textview.attributedText = attributedString;
    _textview.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#35BFDF"],
                                     NSUnderlineColorAttributeName: [UIColor colorWithHexString:@"#AAB3B4"],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    _textview.delegate = self;
    _textview.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    _textview.scrollEnabled = NO;
    
    
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if ([[URL scheme] isEqualToString:@"zhifubao"]) {
        WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
        vc.proction = APPTERMS;
        
        [self.navigationController pushViewController:vc animated:YES];        return NO;
    } else if ([[URL scheme] isEqualToString:@"weixin"]) {
        WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
        vc.proction = APPPRIVACY;
        
        [self.navigationController pushViewController:vc animated:YES];        return NO;
    }
    //    else if ([[URL scheme] isEqualToString:@"checkbox"]) {
    //        self.isSelect = !self.isSelect;
    //        [self protocolIsSelect:self.isSelect];
    //        return NO;
    //    }
    return YES;
}

- (IBAction)confirmClick:(id)sender {

    if (self.mytextView.text.length <= 0 ) {
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:_isIdentity==YES?Localized(@"SelectAlertPassWord1"):Localized(@"keystoreA") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }
    

    
    
    
    
    if (_isIdentity) {
        if (self.passwordF.text.length < 6) {
            
            
            MGPopController *pop = [[MGPopController alloc] initWithTitle:_isIdentity?Localized(@"SelectAlertPassWord1"):Localized(@"SelectAlert") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            return;
        }
    }else{
        
        NSDictionary *strDict = [Common dictionaryWithJsonString:_mytextView.text];
        NSString *type ;
        if  ([strDict isKindOfClass:[NSDictionary class]] && strDict[@"type"]){
            type = strDict[@"type"];
        }
        
        if (![type isEqualToString:@"A"] ) {
            
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"keystoreA") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            return;
        }

        
        
        if (self.passwordF.text.length < 8) {
            
            
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"SelectAlertPassWord") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            return;
        }
    }
    

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self loadJS];
    
}

- (IBAction)helpClick:(id)sender {
    
    WebIdentityViewController *VC= [[WebIdentityViewController alloc]init];
    VC.introduce = [NSString stringWithFormat:@"https://info.onto.app/#/detail/%@",[ENORCN isEqualToString:@"cn"]?@"3":@"18"];
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)handlePrompt:(NSString *)prompt{
    
    //创建AssetAccount
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([prompt hasPrefix:@"importIdentityAndCreateWallet"]) { //第一次导入身份
        [self hideHud];
        DebugLog(@"improtIdentity=%@",prompt);
        //
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        
        
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        DebugLog(@"%@",obj);
        if ([[obj valueForKey:@"error"] integerValue] > 0)
        {
//            NSString * titleString;
//            if ([[obj valueForKey:@"error"] integerValue] == 53000){
//                titleString = [NSString stringWithFormat:@"%@ %@",Localized(@"ImportFail"),Localized(@"PASSWORDERROR")];
//            }else{
//                titleString = [NSString stringWithFormat:@"%@ %@: %@",Localized(@"ImportFail"),Localized(@"Systemerror"),[obj valueForKey:@"error"]];
//            }
//            MGPopController *pop = [[MGPopController alloc] initWithTitle:titleString message:nil image:nil];
//            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//
//            }];
//            action.titleColor =MainColor;
//            [pop addAction:action];
//            [pop show];
//            pop.showCloseButton = NO;
            
            
            return;
        }
        else {
            id result = [NSJSONSerialization JSONObjectWithData:[[obj valueForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            DebugLog(@"!!!!!%@",result);
            NSMutableString *str=[obj valueForKey:@"result"];
            
            NSString *str1 =  [str stringByReplacingOccurrencesOfString:@"\"isDefault\":false" withString:@"\"isDefault\":\"false\""];
            
            NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\"isDefault\":ture" withString:@"\"isDefault\":\"ture\""];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_CREATED];
            //    [[NSUserDefaults standardUserDefaults] setValue:str2 forKey:APP_ACCOUNT];
            [Common setEncryptedContent:str2 WithKey:APP_ACCOUNT];
         
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSDictionary *jsDic= [Common dictionaryWithJsonString:str2];
            
            NSString *defaultOntid = [jsDic valueForKey:@"defaultOntid"];
            [[NSUserDefaults standardUserDefaults] setValue:defaultOntid forKey:ONT_ID];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@DeviceCode",defaultOntid] ];
//           NSArray *identities = [jsDic valueForKey:@"identities"];
           
             NSDictionary *strDict = [Common dictionaryWithJsonString:_mytextView.text];
            NSString *identityName =strDict[@"label"];
            [[NSUserDefaults standardUserDefaults] setValue:identityName forKey:IDENTITY_NAME];
            
             NSString *jsStr =  [NSString stringWithFormat:@"Ont.SDK.signData('%@','%@','%@','%@','%@','signDataStr')",defaultOntid,strDict[@"key"],self.passwordF.text,strDict[@"address"],strDict[@"salt"]];

            LOADJS1;
            LOADJS2;
            LOADJS3;
        
            [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
            
        }
        
    }else if ([prompt hasPrefix:@"importIdentityWithWallet"]){
        //第二次 添加identity
        
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        if ([[obj valueForKey:@"error"] integerValue] > 0)
        {
            
//            NSString * titleString;
//            if ([[obj valueForKey:@"error"] integerValue] == 53000){
//                titleString = [NSString stringWithFormat:@"%@ %@",Localized(@"ImportFail"),Localized(@"PASSWORDERROR")];
//            }else{
//                titleString = [NSString stringWithFormat:@"%@ %@: %@",Localized(@"ImportFail"),Localized(@"Systemerror"),[obj valueForKey:@"error"]];
//            }
//            MGPopController *pop = [[MGPopController alloc] initWithTitle:titleString message:nil image:nil];
//            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//
//            }];
//            action.titleColor =MainColor;
//            [pop addAction:action];
//            [pop show];
//            pop.showCloseButton = NO;
            
            
            return;
            
//            ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
//            vc.isFailure = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
        }
        
        id result = [NSJSONSerialization JSONObjectWithData:[[obj valueForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        DebugLog(@"!!!!!%@",result);
        NSMutableString *str=[obj valueForKey:@"result"];
//        [Common setEncryptedContent:str WithKey:APP_ACCOUNT];
        
        NSMutableDictionary *jsDic= [NSMutableDictionary dictionaryWithDictionary:[Common dictionaryWithJsonString:[Common getEncryptedContent:APP_ACCOUNT]]];
        
        NSMutableArray *arrIdentity =[NSMutableArray arrayWithArray:jsDic[@"identities"]];
        //导入钱包数据
        NSDictionary *newDic =[Common dictionaryWithJsonString:str];
        [arrIdentity addObject:newDic];
        [jsDic setValue:arrIdentity forKey:@"identities"];

            NSArray *idenArr = jsDic[@"identities"];
            for (int i=0; i<idenArr.count-1; i++) {
                NSDictionary *dic = idenArr[i];
                //身份导入重复时
                if ([[newDic valueForKey:@"ontid"] isEqualToString:[dic valueForKey:@"ontid"]]) {

                    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Alreadyin") message:nil image:nil];
                    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                    action.titleColor =MainColor;
                    [pop addAction:action];
                    [pop show];
                    pop.showCloseButton = NO;
                    
                    return;
                }
            }
            
        
        _mynewOntid= [newDic valueForKey:@"ontid"];
      

        NSDictionary *strDict = [Common dictionaryWithJsonString:_mytextView.text];
        //存下时间戳和密码
        [Common setTimestampwithPassword:self.passwordF.text WithOntId:_mynewOntid];
        
        self.myAppStr = [NSMutableString stringWithString:[Common dictionaryToJson:jsDic]];
        self.mynewDic = [NSDictionary dictionaryWithDictionary:newDic];

        NSString *jsStr =  [NSString stringWithFormat:@"Ont.SDK.signData('%@','%@','%@','%@','%@','newsignDataStr')",_mynewOntid,strDict[@"key"],self.passwordF.text,strDict[@"address"],strDict[@"salt"]];
        //节点方法 每次调用JSSDK前都必须调用
        LOADJS1;
        LOADJS2;
        LOADJS3;
        
        
        
        
        
        [self.view addSubview:self.browserView];
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        
    }else if ([prompt hasPrefix:@"newsignDataStr"]) {
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            
            ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
            vc.isFailure = YES;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        NSDictionary *signature = [Common dictionaryWithJsonString:resultStr];
        NSDictionary *params = @{@"OwnerOntId":_mynewOntid,@"Signature":signature};
        
        
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
            NSString *identityName = [_mynewDic valueForKey:@"label"];
            [Common setEncryptedContent:[self.myAppStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] WithKey:APP_ACCOUNT];
            [[NSUserDefaults standardUserDefaults] setValue:identityName forKey:IDENTITY_NAME];
            
            NSString *deviceCode = [responseObject valueForKey:@"DeviceCode"];
            [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:_mynewOntid];
            
            ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
            vc.isWallect = NO;
            [self.navigationController pushViewController:vc animated:YES];
            //存下时间戳和密码
            [Common setTimestampwithPassword:_passwordF.text WithOntId:_mynewOntid];
            
            
            
            //设为默认身份
            {
                
                
                
                NSString * key = [_mynewDic valueForKey:@"key"];
                NSString * identityName = [_mynewDic valueForKey:@"label"];
                [[NSUserDefaults standardUserDefaults] setValue:[_mynewDic valueForKey:@"ontid"] forKey:ONT_ID];
                 [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@DeviceCode",[_mynewDic valueForKey:@"ontid"] ] ];
                [[NSUserDefaults standardUserDefaults] setValue:identityName forKey:IDENTITY_NAME];
                [[NSUserDefaults standardUserDefaults] setValue:key forKey:ENCRYPTED_PRIVATEKEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSInteger selet = [[[Common dictionaryWithJsonString:_myAppStr] valueForKey:@"identities"] count]-1;
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", @(selet)] forKey:SELECTINDEX];
                NSString *deviececode = [responseObject valueForKey:@"DeviceCode"];
                [[NSUserDefaults standardUserDefaults] setValue:deviececode forKey:DEVICE_CODE];
                
                
//                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SOCKET_LOGOUT object:nil];
//                //切换后 websoket 需要重连
//                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//                appDelegate.isSocketConnect = YES;
                
                
            }
            
            NSDictionary *strDict = [Common dictionaryWithJsonString:_mytextView.text];
            NSArray * array = strDict[@"claimArray"];
            for (NSDictionary *claimStr in array) {
                
                ClaimModel *model = [[ClaimModel alloc] init];
                model.OwnerOntId = [[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID];
                model.ClaimContext = claimStr[@"claimName"];
                model.Content =  [Common dictionaryToJson:claimStr[@"claimContent"]] ;
                model.status =@"1";
                [[DataBase sharedDataBase] addClaim:model isSoket:NO];
                
            }
            
            [[NSUserDefaults standardUserDefaults]setValue:strDict[@"country"] forKey:[NSString stringWithFormat:@"%@c",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]];
            
        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
            
            
        }];
        
    }else if ([prompt hasPrefix:@"signDataStr"]) {
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        NSDictionary *signature = [Common dictionaryWithJsonString:resultStr];
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
                vc.isWallect = NO;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            
            NSString *deviceCode = [responseObject valueForKey:@"DeviceCode"];
            [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:DEVICE_CODE];
            [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
            
            //存下时间戳和密码
            [Common setTimestampwithPassword:_passwordF.text WithOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
            
            ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
            vc.isWallect = NO;
            [self.navigationController pushViewController:vc animated:YES];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_EXISIT];
            
            
            NSDictionary *strDict = [Common dictionaryWithJsonString:_mytextView.text];
            NSArray * array = strDict[@"claimArray"];
            for (NSDictionary *claimStr in array) {
                
                ClaimModel *model = [[ClaimModel alloc] init];
                model.OwnerOntId = [[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID];
                model.ClaimContext = claimStr[@"claimName"];
                model.Content =  [Common dictionaryToJson:claimStr[@"claimContent"]] ;
                model.status =@"1";
                [[DataBase sharedDataBase] addClaim:model isSoket:NO];
                
            }
            
            [[NSUserDefaults standardUserDefaults]setValue:strDict[@"country"] forKey:[NSString stringWithFormat:@"%@c",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]];
            
     
        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
            
            
        }];
    }else if ([prompt hasPrefix:@"importAccountWithWallet"]) {
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        
//        NSString * titleString;
//        if ([[obj valueForKey:@"error"] integerValue] == 53000){
//            titleString = [NSString stringWithFormat:@"%@ %@",Localized(@"ImportFail"),Localized(@"PASSWORDERROR")];
//        }else{
//            titleString = [NSString stringWithFormat:@"%@ %@: %@",Localized(@"ImportFail"),Localized(@"Systemerror"),[obj valueForKey:@"error"]];
//        }
//        MGPopController *pop = [[MGPopController alloc] initWithTitle:titleString message:nil image:nil];
//        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//
//        }];
//        action.titleColor =MainColor;
//        [pop addAction:action];
//        [pop show];
//        pop.showCloseButton = NO;
        
        
        return;
    }
    
    DebugLog(@"~~~~~~~~%@",[obj valueForKey:@"result"]);
    NSMutableString *str=[obj valueForKey:@"result"];
    NSDictionary *jsDic= [Common dictionaryWithJsonString:str];
    NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    NSMutableArray *newArray;
    if (allArray) {
        newArray = [[NSMutableArray alloc] initWithArray:allArray];
    } else {
        newArray = [[NSMutableArray alloc] init];
    }
    //防止重复添加
    for (int i=0; i<allArray.count; i++) {
        if ([[allArray[i] valueForKey:@"address"]isEqualToString:[jsDic valueForKey:@"address"]])
        {
            
//            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletAlreadyin") message:nil image:nil];
//            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//
//            }];
//            action.titleColor = MainColor;
//            [pop addAction:action];
//            [pop show];
//            pop.showCloseButton = NO;
            
            return;
        }
    }
    
    [newArray addObject:jsDic];
    
    [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:ALLASSET_ACCOUNT];
    [Common setEncryptedContent:[Common dictionaryToJson:newArray[newArray.count-1]] WithKey:ASSET_ACCOUNT];
    ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
    vc.isWallect = YES;
    [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)failAction{
    
    ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
    vc.isFailure = YES;
    vc.isWallect = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
            DebugLog(@"prompt=%@",prompt);
            [weakSelf handlePrompt:prompt];
        }];
        [_browserView setCallbackJSFinish:^{
            [weakSelf loadJS];
        }];
    }
    return _browserView;
}

- (void)loadJS{
    //节点方法 每次调用JSSDK前都必须调用
    LOADJS1;
    LOADJS2;
    LOADJS3;
    
    [self.view addSubview:self.browserView];
    
     NSDictionary *strDict = [Common dictionaryWithJsonString:_mytextView.text];
   
    
     NSString *urlstr;
    if (_isIdentity) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:IDENTITY_CREATED]) {
           
            //第二次导入身份
           urlstr =  [NSString stringWithFormat:@"Ont.SDK.importIdentityWithWallet('%@','%@','%@','%@','%@','importIdentityWithWallet')",strDict[@"label"],strDict[@"key"],self.passwordF.text,strDict[@"address"],strDict[@"salt"]];
        } else {
            //第一次导入身份
            urlstr   =  [NSString stringWithFormat:@"Ont.SDK.importIdentityAndCreateWallet('%@','%@','%@','%@','%@','importIdentityAndCreateWallet')",strDict[@"label"],strDict[@"key"],self.passwordF.text,strDict[@"address"],strDict[@"salt"]];
        }
    
        //节点方法 每次调用JSSDK前都必须调用
        LOADJS1;
        LOADJS2;
        LOADJS3;
        NSString *url = [urlstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//         NSString *url1 = [url stringByReplacingOccurrencesOfString:@" " withString:@""];

    [self.browserView.wkWebView evaluateJavaScript:url completionHandler:nil];
}
    else{
        // 导入钱包
        NSString *urlstr = [NSString stringWithFormat:@"Ont.SDK.importAccountWithWallet('%@','%@','%@','%@','%@','importAccountWithWallet')",[strDict valueForKey:@"label"],[strDict valueForKey:@"key"],[strDict valueForKey:@"address"],[strDict valueForKey:@"salt"],[Common transferredMeaning:self.passwordF.text]];
        NSString *str = [urlstr stringByReplacingOccurrencesOfString:@" " withString:@""];
            //     [self showHudInView:self.view hint:Localized(@"Importing")];
        LOADJS1;
        LOADJS2;
        LOADJS3;
        [self.browserView.wkWebView evaluateJavaScript:[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] completionHandler:nil];
        
    }
    
 
}
#pragma mark baseAction
//- (void)navLeftAction {
//    if (self.type == PWDTypeNext) {
//        self.type = PWDTypeDefault;
//        self.pwdString = @"";
//        [self.passwordF clearPassword];
//        [self.reEnterPasswordF clearPassword];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

- (void)textFieldDidChange:(UITextField *)textField

{
    if (_isIdentity) {
        
        if (textField.text.length > 6) {
            
            textField.text = [textField.text substringToIndex:6];
            
        }
        
    }else{
        if (textField.text.length > 15) {
            
            textField.text = [textField.text substringToIndex:15];
            
        }
        
    }
    
   
        
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    inputText = @"";
    [textField resignFirstResponder];
    
    [self.mytextView resignFirstResponder];
    [self.passwordF resignFirstResponder];
    

    
    //具体调用显示安全键盘位置根据项目的实际情况调整，此处只是作为demo演示
    [self showSecureKeyboardAction];
    
    
    
    return NO;
}
/**初始化安全键盘*/
- (void)showSecureKeyboardAction{
    
    if (keyboard) {
        [keyboard.view removeFromSuperview];
        keyboard.view =nil;
        keyboard=nil;
    }
    
    keyboard = [[HYKeyboard alloc] initWithNibName:KEYBOARD_NIB_PATH bundle:nil];
    /**弹出安全键盘的宿主控制器，不能传nil*/
    keyboard.hostViewController = self;
    /**是否设置按钮无按压和动画效果*/
    //    keyboard.btnPressAnimation=YES;
    /**是否设置按钮随机变化*/
    keyboard.btnrRandomChange=YES;
    /**是否显示密码明文动画*/
    keyboard.shouldTextAnimation=YES;
    /**安全键盘事件回调，必须实现HYKeyboardDelegate内的其中一个*/
    keyboard.keyboardDelegate=self;
    /**弹出安全键盘的宿主输入框，可以传nil*/
    keyboard.hostTextField = self.passwordF;
    /**是否输入内容加密*/
    keyboard.secure = YES;
    //设置加密类型，分为AES和SM42种类型，默认为SM4
    //    [keyboard setSecureType:HYSecureTypeAES];
    //    keyboard.arrayText = [NSMutableArray arrayWithArray:contents];//把已输入的内容以array传入;
    /**输入框已有的内容*/
    keyboard.contentText=inputText;
    keyboard.synthesize = YES;//hostTextField输入框同步更新，用*填充
    /**是否清空输入框内容*/
    keyboard.shouldClear = YES;
    /**背景提示*/
    keyboard.stringPlaceholder = self.passwordF.placeholder;
    keyboard.intMaxLength = 15;//最大输入长度
//    keyboard.keyboardType = HYKeyboardTypeNumber;//输入框类型
    /**更新安全键盘输入类型*/
//    [keyboard shouldRefresh:HYKeyboardTypeNumber];
    //    [keyboard setTextAnimationSecond:0.8];//默认不设置，动画时长为1秒
    //--------添加安全键盘到ViewController---------
    
    [self.view addSubview:keyboard.view];
    [self.view bringSubviewToFront:keyboard.view];
    //安全键盘显示动画
    CGRect rect=keyboard.view.frame;
    rect.size.width=self.view.frame.size.width;
    rect.origin.y=self.view.frame.size.height+10;
    keyboard.view.frame=rect;
    //显示输入框动画
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.2f];

    rect.origin.y=kScreenHeight-keyboard.view.frame.size.height-LL_StatusBarAndNavigationBarHeight-LL_TabbarSafeBottomMargin-44;
    
    keyboard.view.frame=rect;
    [UIView commitAnimations];
}

#pragma mark--关闭键盘回调

-(void)inputOverWithTextField:(UITextField *)textField inputText:(NSString *)text
{
    inputText=text;
  
     self.passwordF.text = text;
    [self hiddenKeyboardView];
    
}

-(void)inputOverWithChange:(UITextField *)textField changeText:(NSString *)text
{
    //    DebugLog(@"变化内容:%@",text);
    inputText=text;

        self.passwordF.text = text;
        [self textFieldDidChange:self.passwordF];
        
    
    if (textField.text.length == 15) {
        DebugLog(@"输入完毕");
        [textField resignFirstResponder];
        //        _callbackPwd(textField.text);
        [self hiddenKeyboardView];
    }
}

-(void)hiddenKeyboardView
{
    //隐藏输入框动画
    [ UIView animateWithDuration:0.3 animations:^
     {
         CGRect rect=keyboard.view.frame;
         rect.origin.y=self.view.frame.size.height+10;
         keyboard.view.frame=rect;
         
     }completion:^(BOOL finished){
         
         [keyboard.view removeFromSuperview];
         keyboard.keyboardDelegate=nil;
         keyboard.view =nil;
         keyboard=nil;
     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hiddenKeyboardView];
}

@end
