//
//  MnemonicImportVC.m
//  ONTO
//
//  Created by 赵伟 on 24/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "MnemonicImportVC.h"
#import "ImportSuccessViewController.h"
#import "ToastUtil.h"
#import "HYKeyboard.h"
#import "UITextView+Placeholder.h"
//#import "MBProgressHUD.h"
#import "WebIdentityViewController.h"
#import "Config.h"



#define KEYBOARD_NIB_PATH @"BangcleSafeKeyBoard.bundle/resources/HYKeyboard"
#define textViewfont 14

typedef NS_ENUM(NSInteger, PWDType) {
    PWDTypeDefault,
    PWDTypeNext,
};
@interface MnemonicImportVC ()<HYKeyboardDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    HYKeyboard*keyboard;
    NSString*inputText;
}

@property (weak, nonatomic) IBOutlet UITextView *mytextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordF;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordF;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;

@property (nonatomic, assign) PWDType type;
@property (nonatomic, copy) NSString *pwdString;
@property (nonatomic, copy) NSString *tempString;
@property (nonatomic, assign) BOOL isreType;//判断当前输入框
@property (nonatomic, strong) OTAlertView *alert;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (assign, nonatomic) BOOL isSelect;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *WalletPWD;
@property (weak, nonatomic) IBOutlet UILabel *WalletSurePWD;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewtop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textviewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withKeyStoreTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomtextViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnTop;

@end

@implementation MnemonicImportVC
- (void)viewDidLoad {
    [super viewDidLoad];
//        self.navigationController.navigationBar.translucent = NO;

    [self configUI];
    [self protocolIsSelect:_isSelect];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

-(void)protocolIsSelect:(BOOL)select {
    
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

    return YES;
}


-(void)configUI{
    
    self.nameF.placeholder = Localized(@"CorrectName");
     self.nameL.text = Localized(@"Name");
    
    self.comfirmBtn.layer.cornerRadius = 1;
    self.comfirmBtn.layer.masksToBounds = YES;
    [self.comfirmBtn setTitle:Localized(@"LoginImport") forState:UIControlStateNormal];
    [self.comfirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.comfirmBtn.userInteractionEnabled = NO;
    
    
    self.mytextView.layer.cornerRadius = 4;
    self.mytextView.layer.masksToBounds = YES;
    
    if (_walletType==1) {
        self.mytextView.placeholderLabel.text = Localized(@"Separatethmnemonic");
        [self.helpBtn setTitle: Localized(@"WhatisMnemonic") forState:UIControlStateNormal];
    }else if (_walletType==2){
        self.mytextView.placeholderLabel.text = Localized(@"HEXformat");
        [self.helpBtn setTitle:Localized(@"WhatisPrivatekey") forState:UIControlStateNormal];
        
    }else if (_walletType==3){
        self.mytextView.placeholderLabel.text = Localized(@"WIFtext");
        [self.helpBtn setTitle:Localized(@"WhatisWIF") forState:UIControlStateNormal];
    }
    
    //密码
    self.passwordF.borderStyle = UITextBorderStyleNone;
    self.passwordF.font = K14FONT;
    self.passwordF.placeholder = Localized(@"SelectAlertPassWord");
    self.passwordF.secureTextEntry = YES;
   
//    self.passwordF.delegate = self;
    [self.passwordF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //重复密码
    self.reEnterPasswordF.borderStyle = UITextBorderStyleNone;
    self.reEnterPasswordF.font = K14FONT;
    self.reEnterPasswordF.placeholder = Localized(@"LoginRetypePassword");
    self.reEnterPasswordF.secureTextEntry = YES;
//    self.reEnterPasswordF.keyboardType = UIKeyboardTypeNumberPad;
//    self.passwordF.keyboardType = UIKeyboardTypeNumberPad;
//    self.reEnterPasswordF.delegate = self;
    
    self.WalletPWD.text = Localized(@"Password");
    self.WalletSurePWD.text = Localized(@"SurePWD");
    
    [self.reEnterPasswordF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.mytextView.textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16);

    
    [self.checkBox addTarget:self action:@selector(checkBoxAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkBox setImage:[UIImage imageNamed:@"login_checkbox"] forState:UIControlStateNormal];
    [self.checkBox setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateSelected];
    [self.view addSubview:self.checkBox];
    
    if (LL_iPhone5S) {

        [_textViewtop setConstant:0];
        [_textviewHeight setConstant:100];
         [_withKeyStoreTop setConstant:67];
        [_passwordTop setConstant:130];
        [_bottomtextViewTop setConstant:10];
        [_checkBtnTop setConstant:13];
    }
    if (kScreenWidth==375&&kScreenHeight==667) {
        [_bottomBtnTop setConstant:10];
    }
    if (kScreenWidth==320) {
        [_bottomBtnTop setConstant:-10];
    }
    if (kScreenWidth==414) {
        [_bottomBtnTop setConstant:80];
    }
}

- (void)checkBoxAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {

        [self.comfirmBtn setTitleColor:MainColor forState:UIControlStateNormal];
        self.comfirmBtn.userInteractionEnabled = YES;
        
    } else {
        
        [self.comfirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.comfirmBtn.userInteractionEnabled = NO;
        
    }
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if([textView.text length] == 0){
        
        textView.textColor = [UIColor lightGrayColor];
        textView.tag = 0;
        
    }
}

- (void)loadJS{


    NSString *jsurl ;
    
    if (_walletType==1) {

        jsurl = [NSString stringWithFormat:@"Ont.SDK.importAccountMnemonic('%@','%@','%@','importAccountMnemonic')",self.nameF.text,self.mytextView.text,[Common transferredMeaning:self.passwordF.text]];
    }
    if (_walletType==2) {
   
        
        jsurl = [NSString stringWithFormat:@"Ont.SDK.importAccountWithPrivateKey('%@','%@','%@','importAccountWithPrivateKey')",self.nameF.text,self.mytextView.text,[Common transferredMeaning:self.passwordF.text]];
    }
    
    if (_walletType==3) {

        jsurl = [NSString stringWithFormat:@"Ont.SDK.importAccountWithWif('%@','%@','%@','importAccountWithWif')",self.nameF.text,self.mytextView.text,[Common transferredMeaning:self.passwordF.text]];
    }
    
    
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsurl completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    __weak typeof(self) weakSelf = self;
    
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}

- (void)handlePrompt:(NSString *)prompt {
    DebugLog(@"prompt%@",prompt);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"importAccountWithWif"] || [prompt hasPrefix:@"importAccountMnemonic"] || [prompt hasPrefix:@"importAccountWithPrivateKey"]) {
        
        if ([[obj valueForKey:@"error"] integerValue] > 0)
        {
//            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"ImportFail") message:nil image:nil];
//            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//                
//            }];
//            action.titleColor =MainColor;
//            [pop addAction:action];
//            [pop show];
//            pop.showCloseButton = NO;
            
            return;
        }
        
        NSMutableString *str=[obj valueForKey:@"result"];
        NSDictionary *jsDic= [Common dictionaryWithJsonString:str];
        DebugLog(@"~~~~~~~~%@",[obj valueForKey:@"result"]);
        
        NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
        NSMutableArray *newArray;
        if (allArray) {
            newArray = [[NSMutableArray alloc] initWithArray:allArray];
        } else {
            newArray = [[NSMutableArray alloc] init];
        }
        //防止重复添加
        for (int i=0; i<allArray.count; i++)
        {
            if ( [[allArray[i] valueForKey:@"address"]isEqualToString:[jsDic valueForKey:@"address"]])
            {
                
//                MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletAlreadyin") message:nil image:nil];
//                MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//                    
//                }];
//                action.titleColor =MainColor;
//                [pop addAction:action];
//                [pop show];
//                pop.showCloseButton = NO;
                
                return;
            }
        }
        
        
        //       [jsDic setValue:self.nameF.text forKey:@"label"];
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

- (IBAction)confirmClick:(id)sender {

    
    
    
    if (_walletType==1) {
        
        NSArray *array = [self.mytextView.text componentsSeparatedByString:@" "];

        if (array.count!=12) {
            
            
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Mnemonic12") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            return;
        }

//        if (self.mytextView.text.length ==0) {
//
//
//            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"EnterMnemonic") message:nil image:nil];
//            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//
//            }];
//            action.titleColor =MainColor;
//            [pop addAction:action];
//            [pop show];
//            pop.showCloseButton = NO;
//             return;
//        }
        
    }
    
    
    if (_walletType==3) {
        
        if (self.mytextView.text.length !=52) {
      
            
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WIFtext52") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
          return;
        }
//
    }
    if (_walletType==2) {
        if (self.mytextView.text.length !=64) {
            
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"HEXformat64") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
         return;
        }

    }
    
    
    if (self.nameF.text.length <= 0 || self.nameF.text.length > 12) {
        
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"SelectAlert") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }
    if (![AppHelper checkName:self.nameF.text]) {
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"CorrectName") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }
    if (self.passwordF.text.length < 8||self.reEnterPasswordF.text.length < 8 ) {

        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"SelectAlertPassWord") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }
 
   
    
    if ([self.passwordF.text isEqualToString:self.reEnterPasswordF.text]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            [self loadJS];
        return;
        
    } else {
    
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"PWDERROR") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
    }

    if (!self.checkBox.selected) {
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"SelectBox") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }


}

- (IBAction)helpClick:(id)sender {
//    @property (nonatomic ,assign) NSInteger walletType;//1 mnenonic 2 private key 3 WIF
    WebIdentityViewController *VC= [[WebIdentityViewController alloc]init];
    if (_walletType==1) {
            VC.introduce = [NSString stringWithFormat:@"https://info.onto.app/#/detail/%@",[ENORCN isEqualToString:@"cn"]?@"2":@"17"];
    }else if (_walletType==2){
            VC.introduce = [NSString stringWithFormat:@"https://info.onto.app/#/detail/%@",[ENORCN isEqualToString:@"cn"]?@"4":@"19"];
    }else if (_walletType==3){
            VC.introduce = [NSString stringWithFormat:@"https://info.onto.app/#/detail/%@",[ENORCN isEqualToString:@"cn"]?@"5":@"20"];
    }
        [self.navigationController pushViewController:VC animated:YES];
   
}
#pragma mark baseAction

- (void)textFieldDidChange:(UITextField *)textField

{
    
    if (textField == self.reEnterPasswordF || textField == self.passwordF) {
        
        if (textField.text.length > 15) {
            
            textField.text = [textField.text substringToIndex:15];
            
        }
        
    }
    
}

- (void)textFieldDidChange1:(UITextField *)textField

{
    
    if (textField == self.passwordF || textField == self.reEnterPasswordF) {
        
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
    [self.reEnterPasswordF resignFirstResponder];
    
    if (textField==self.passwordF) {
        _isreType = NO;
    }else if (textField ==self.reEnterPasswordF){
        _isreType = YES;
    }
    
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
    keyboard.hostTextField = _isreType==NO?self.passwordF:self.reEnterPasswordF;
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
    keyboard.stringPlaceholder = _isreType==NO?self.passwordF.placeholder:self.reEnterPasswordF.placeholder;
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

-(void)inputOverWithTextField:(UITextField *)textField inputText:(NSString *)text{
    
    inputText=text;
    if (_isreType) {
        self.reEnterPasswordF.text = text;
    }else{
        self.passwordF.text = text;
    }
    
    [self hiddenKeyboardView];
}

-(void)inputOverWithChange:(UITextField *)textField changeText:(NSString *)text
{
    //    DebugLog(@"变化内容:%@",text);
    inputText=text;
    if (_isreType) {
        self.reEnterPasswordF.text = text;
        [self textFieldDidChange:self.reEnterPasswordF];
        
    }else{
        
        self.passwordF.text = text;
        [self textFieldDidChange:self.passwordF];
        
    }
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
