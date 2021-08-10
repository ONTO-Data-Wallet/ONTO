//
//  CreateViewController.m
//  ONTO
//
//  Created by Zeus.Zhang on 2018/2/7.
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

#import "CreateViewController.h"
#import "PwdEnterView.h"
#import "OTAlertView.h"
#import "CreatePwdViewController.h"
#import "WebIdentityViewController.h"
#import "CreateWaitViewController.h"
#import "HYKeyboard.h"
#import "MGPopController.h"
#import "WalletBackupVC.h"
#import "ViewController.h"
#import "Config.h"
#import "IQKeyboardManager.h"
#define textViewfont 14

#define KEYBOARD_NIB_PATH @"BangcleSafeKeyBoard.bundle/resources/HYKeyboard"
typedef NS_ENUM(NSInteger, PWDType) {
    PWDTypeDefault,
    PWDTypeNext,
};

@interface CreateViewController ()<HYKeyboardDelegate,UITextFieldDelegate,UITextViewDelegate>

{
    HYKeyboard*keyboard;
    NSString*inputText;
    NSInteger i;
}

@property (nonatomic, strong) PwdEnterView *pwdView;
@property (nonatomic, strong) UITextField *nameF;
@property (nonatomic, strong) UITextField *passWordF;
@property (nonatomic, strong) UITextField *RetypeF;
@property (nonatomic, strong) UIButton    *pwdAlertBtn;
@property (nonatomic, strong) UIView      *pwdAlertV;
@property (nonatomic, strong) UILabel *pwdL;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, assign) PWDType type;
@property (nonatomic, copy) NSString *pwdString;
@property (nonatomic, copy) NSString *tempString;
@property (nonatomic, assign) BOOL isreType;//判断当前输入框
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MGPopController *pop;
@property (nonatomic, copy) NSString *mynewOntID;
@property (nonatomic, copy) NSString *mynewKey;
@property (nonatomic, copy) NSString *address;
@property (nonatomic,copy) NSString *passwordHash;
@property (nonatomic,copy) NSString *walletkey;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (assign, nonatomic) BOOL isSelect;
@property (nonatomic,copy) NSString *salt;
@property (nonatomic, copy) NSDictionary *jsDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewleftBtnTop;

@end

@implementation CreateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[CreateViewController class]];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self configNav];
    [self configUI];
    [self protocolIsSelect:_isSelect];
    self.navigationController.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
- (void)protocolIsSelect:(BOOL)select {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:Localized(@"LoginService")];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"zhifubao://"
                             range:[[attributedString string] rangeOfString:Localized(@"TheTermsofService")]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"weixin://"
                             range:[[attributedString string] rangeOfString:Localized(@"PrivacyPolicy")]];
    
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

- (void)loadJS {
    NSString *jsStr;
    
    if (self.isWallet) {
        NSString *password = self.passWordF.text;
        
 
        //创建钱包
        jsStr = [NSString stringWithFormat:@"Ont.SDK.createAccount('%@','%@','getAssetAccountDataStr')",self.nameF.text,[Common transferredMeaning:password]];

    }
    
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    __weak typeof(self) weakSelf = self;

    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
    
}
- (void)handlePrompt:(NSString *)prompt{
    
     if ([prompt hasPrefix:@"getAssetAccountDataStr"]) {

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
        [newArray addObject:jsDic];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:ALLASSET_ACCOUNT];
        
        //储存助记词

        [Common setEncryptedContent:(NSString*)[obj valueForKey:@"mnemonicEnc"] WithKey:[jsDic valueForKey:@"address"]];
        
        _address = [jsDic valueForKey:@"address"];
        _passwordHash = [jsDic valueForKey:@"passwordHash"];
        _walletkey = [jsDic valueForKey:@"key"];
        _salt = [jsDic valueForKey:@"salt"];

        NSString *jsonStr = [Common  dictionaryToJson:newArray[newArray.count-1]];
        [Common setEncryptedContent:jsonStr WithKey:ASSET_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self successAtionIsWallet:YES];

        
    }
    
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        DebugLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.timer invalidate];
    i=20;
}

- (void)configNav {
    
    [self setNavTitle:Localized(@"LoginCreateCount")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:nil];
    if (self.isWallet) {
        [self setNavTitle:Localized(@"CreateWallet")];
    }
}

- (void)configUI {

    self.nameF = [[UITextField alloc] init];
    self.nameF.borderStyle = UITextBorderStyleNone;
    self.nameF.backgroundColor = [UIColor whiteColor];
    self.nameF.font = K14FONT;
    self.nameF.delegate = self;
    self.nameF.placeholder = Localized(@"CorrectName");           //ONTIDPWD
    if (self.isWallet) {
        self.nameF.placeholder = Localized(@"CorrectName");
    }
    [Common setTextFieldLeftPadding:self.nameF width:10];
    [self.view addSubview:self.nameF];
    
    [self.nameF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(210);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 30), 40));
    }];
    
  
   
    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.text =_isIdentity? Localized(@"UserName"): Localized(@"IdentityName");
    namelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    namelabel.textColor =BLACKLB;
    [self.view addSubview:namelabel];
    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(180);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 48), 40));
    }];

    if (LL_iPhone5S) {
        [self.nameF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(190);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - 30), 40));
        }];
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(160);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - 48), 40));
        }];
        [_textViewTop setConstant:246];
        [_textViewleftBtnTop setConstant:393];
    }
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"E9EDEF"];
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.nameF);
        make.left.mas_equalTo(namelabel);
        make.height.mas_equalTo(@1);
    }];
    
    //密码
    self.passWordF = [[UITextField alloc] init];
    self.passWordF.borderStyle = UITextBorderStyleNone;
    self.passWordF.backgroundColor = [UIColor whiteColor];
    self.passWordF.font = K14FONT;
    self.passWordF.placeholder = _isWallet?Localized(@"SelectAlertPassWord"):Localized(@"SelectAlertPassWord1");
   
    
    self.passWordF.secureTextEntry = YES;
    if (!_isWallet) {
        
        self.passWordF.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    
    [Common setTextFieldLeftPadding:self.passWordF width:10];
    [self.view addSubview:self.passWordF];
    
    UILabel *passWordlabel = [[UILabel alloc] init];
    passWordlabel.text =Localized(@"ONTIDPWD");
    passWordlabel.font =  [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]; //[UIFont fontWithName:@"SFProText-Semibold" size:14];
    passWordlabel.textColor =BLACKLB;
    [self.view addSubview:passWordlabel];
    [passWordlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameF).offset(55);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 48), 40));
    }];
    passWordlabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];

    UIButton * eyeBtn =[[UIButton alloc]init];
    [eyeBtn setImage:[UIImage imageNamed:@"eyeclose"] forState:UIControlStateNormal];
    eyeBtn.selected =NO;
    [self.view addSubview:eyeBtn];
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passWordlabel.mas_centerY);
        make.right.mas_equalTo(self.passWordF);
    }];
    
    if (self.isWallet) {
        namelabel.text = Localized(@"WalletName");
        passWordlabel.text =Localized(@"PWD");
    }
    
    [self.passWordF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameF.mas_bottom).offset(45);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 30), 40));
    }];
    
    [self.passWordF addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithHexString:@"E9EDEF"];
    [self.view addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.passWordF);
        make.height.mas_equalTo(@1);
        make.left.mas_equalTo(namelabel);

    }];
    
    //重复密码
    self.RetypeF = [[UITextField alloc] init];
    
    self.RetypeF.borderStyle = UITextBorderStyleNone;
    self.RetypeF.backgroundColor = [UIColor whiteColor];
    self.RetypeF.font = K14FONT;
    self.RetypeF.placeholder = Localized(@"LoginRetypePassword");
    self.RetypeF.secureTextEntry = YES;
    if (!_isWallet) {
        self.RetypeF.keyboardType = UIKeyboardTypeNumberPad;
//        self.RetypeF.delegate = self;
//        self.passWordF.delegate = self;
    }
    
    
    
    [self.RetypeF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [eyeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.RetypeF resignFirstResponder];
        [self.passWordF resignFirstResponder];
        if (!eyeBtn.selected) {
            [eyeBtn setImage:[UIImage imageNamed:@"eyeopen"] forState:UIControlStateNormal];
            self.RetypeF.secureTextEntry =NO;
            self.passWordF.secureTextEntry =NO;
        }else{
            [eyeBtn setImage:[UIImage imageNamed:@"eyeclose"] forState:UIControlStateNormal];
            self.RetypeF.secureTextEntry =YES;
            self.passWordF.secureTextEntry =YES;
        }
        eyeBtn.selected =!eyeBtn.selected;
    }];
    
    UILabel *retypeL = [[UILabel alloc] init];
    retypeL.text = Localized(@"SurePWD");
    retypeL.textColor =BLACKLB;
    retypeL.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]; //[UIFont fontWithName:@"SFProText-Semibold" size:14];
    [self.view addSubview:retypeL];
    [retypeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passWordF).offset(55);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 48), 40));
    }];
    retypeL.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    
    [Common setTextFieldLeftPadding:self.RetypeF width:10];
    [self.view addSubview:self.RetypeF];
    
    [self.RetypeF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passWordF.mas_bottom).offset(45);
        make.centerX.equalTo(self.view);
        //        make.bottom.equalTo(nameL.mas_bottom).offset(48);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 30), 40));
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithHexString:@"E9EDEF"];
    [self.view addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.RetypeF);
        make.height.mas_equalTo(@1);
        make.left.mas_equalTo(namelabel);

    }];
    

    [self.checkBox addTarget:self action:@selector(checkBoxAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkBox setImage:[UIImage imageNamed:@"login_checkbox"] forState:UIControlStateNormal];
    [self.checkBox setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateSelected];
    [self.view addSubview:self.checkBox];
    
    UILabel *checkL = [[UILabel alloc] init];
    checkL.hidden = YES;
    checkL.numberOfLines = 0;
    checkL.font = K12FONT;
    checkL.textColor = [UIColor colorWithHexString:@"#5e5e5e"];
    NSMutableAttributedString *str;
    str = [[NSMutableAttributedString alloc] initWithString:Localized(@"LoginService")];
    
    if (![[Common getUserLanguage]isEqualToString:@"en"]) {
        [str addAttribute:NSForegroundColorAttributeName value:MAINAPPCOLOR range:NSMakeRange(str.length - 9, 9)];
        [str addAttribute:NSFontAttributeName value:K12FONT range:NSMakeRange(str.length - 7, 7)];
    } else {
        [str addAttribute:NSForegroundColorAttributeName value:MAINAPPCOLOR range:NSMakeRange(str.length - 35, 35)];
    }
    //    }
    checkL.attributedText = str;
    [self.view addSubview:checkL];
    
    [checkL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.checkBox);
        make.top.equalTo(line2.mas_bottom).offset(23);
        make.left.equalTo(self.checkBox.mas_right).offset(17);
        make.right.equalTo(self.view).offset(-40);
    }];
    
    checkL.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [checkL addGestureRecognizer:labelTapGestureRecognizer];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.nextBtn setTitle:Localized(@"createONT") forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:MainColor forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = K16BFONT;
    self.nextBtn.backgroundColor = [UIColor colorWithHexString:@"#EDF2F5"];
    
    [self.nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    self.nextBtn.userInteractionEnabled = NO;
    [self.nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    self.nextBtn.layer.cornerRadius = 1;
    self.nextBtn.layer.masksToBounds = YES;
//    self.nextBtn.userInteractionEnabled = YES;
    CGFloat bottom = LL_iPhoneX ? 34.f : 0.f;

    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(@50);
        
//        if (SYSWidth==320) {
//
//            make.top.equalTo(checkL.mas_bottom).offset(20);
//
//        }else{
            make.bottom.equalTo(self.view).offset(-bottom);
        
//        }
    }];
    
    self.pwdAlertBtn =[[UIButton alloc]init];
    [self.pwdAlertBtn setImage:[UIImage imageNamed:@"pwdAlert"] forState:UIControlStateNormal];
    [self.pwdAlertBtn addTarget:self action:@selector(showPwdAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pwdAlertBtn];
    
    CGSize strSize = [passWordlabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightMedium]}];
    [self.pwdAlertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(11*SCALE_W+strSize.width+24);
        make.centerY.equalTo(passWordlabel);
    }];
    
    self.pwdAlertV =[[UIView alloc]init];
    self.pwdAlertV.backgroundColor =BLUELB;
    self.pwdAlertV.layer.cornerRadius =10;
    self.pwdAlertV.hidden =YES;
    [self.view addSubview:self.pwdAlertV];
    
    
    UILabel *pwdAlertLB =[[UILabel alloc]init];
    pwdAlertLB.textColor =[UIColor whiteColor];
    pwdAlertLB.numberOfLines =0;
    pwdAlertLB.textAlignment =NSTextAlignmentLeft;
    pwdAlertLB.font =[UIFont systemFontOfSize:12];
    [self.pwdAlertV addSubview:pwdAlertLB];
    
    NSString* pwdStr ;
    if (_isWallet) {
        pwdStr =Localized(@"walletAlert");
    }else{
        pwdStr =Localized(@"identityAlert");
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:pwdStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    paragraphStyle.alignment =NSTextAlignmentLeft ;
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [pwdStr length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [pwdStr length])];
    pwdAlertLB.attributedText = attributedString;
    
    CGSize pwdStrSize = [attributedString boundingRectWithSize:CGSizeMake(168*SCALE_W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  context:nil].size;
    
    [self.pwdAlertV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdAlertBtn);
        make.top.equalTo(self.pwdAlertBtn.mas_bottom).offset(5.5*SCALE_W);
        make.width.mas_equalTo(188*SCALE_W);
        //        make.height.mas_equalTo(100*SCALE_W);
    }];
    
    [pwdAlertLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.pwdAlertV).offset(10*SCALE_W);
        make.right.equalTo(self.pwdAlertV).offset(-10*SCALE_W);
        make.width.mas_equalTo(168*SCALE_W);
    }];
    
    [self.pwdAlertV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20*SCALE_W +pwdStrSize.height);
    }];
}
-(void)showPwdAlert{
    self.pwdAlertV.hidden =NO;
}
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
//    WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
//    vc.proction = [NSString stringWithFormat:@"http://47.52.72.227:8000/documents/user_privacy_and_protection_clause/%@",ENORCN];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)checkBoxAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
//        self.nextBtn.backgroundColor = [UIColor colorWithHexString:@"#EDF2F5"];
        [self.nextBtn setTitleColor:MainColor forState:UIControlStateNormal];

        self.nextBtn.userInteractionEnabled = YES;
    } else {
        
//        self.nextBtn.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa"];
        [self.nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        self.nextBtn.userInteractionEnabled = NO;
    }
    
}
- (void)nextAction {
    
    if (self.nameF.text.length <= 0 || self.nameF.text.length > 12) {
        [Common showToast:Localized(@"SelectAlert")];
//        [ToastUtil shortToast:self.view value:Localized(@"SelectAlert")];
        return;
    }
    DebugLog(@"AppHelper=%d",[AppHelper checkName:self.nameF.text]);
    
    if (![AppHelper checkName:self.nameF.text]) {
        [Common showToast:Localized(@"CorrectName")];
//        [ToastUtil shortToast:self.view value:Localized(@"CorrectName")];
        return;
    }
    
    if (_isWallet) {
        if (self.passWordF.text.length > 15||self.RetypeF.text.length > 15|| self.passWordF.text.length < 8||self.passWordF.text.length <8) {
            [Common showToast:Localized(@"SelectAlertPassWord")];
//            [ToastUtil shortToast:self.view value:Localized(@"SelectAlertPassWord")];
            return;
        }
    }else{
        if (self.passWordF.text.length < 6||self.RetypeF.text.length < 6 ) {
     
            [Common showToast:Localized(@"SelectAlertPassWord1")];
//            [ToastUtil shortToast:self.view value:Localized(@"SelectAlertPassWord1")];
            return;
        }
    }
    
    if (!self.checkBox.selected) {
//        [Common showToast:Localized(@"SelectBox")];
        [ToastUtil shortToast:self.view value:Localized(@"SelectBox")];
          return;
    }
    
    if ([self.passWordF.text isEqualToString:self.RetypeF.text]) {
        
        if (_isWallet==YES) {
            
            [self loadJS];
            
            self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            
            _pop = [[MGPopController alloc] initWithTitle:@"20 secs..." message:Localized(@"Creating") image:[UIImage imageNamed:@"Rectangle 17"]];
            [_pop show];
            _pop.showCloseButton = NO;
            
        }else{
            CreateWaitViewController *VC = [[CreateWaitViewController alloc] init];
            VC.isWallet = self.isWallet;
            VC.isIdentity = _isIdentity;
            VC.label = self.nameF.text;
            VC.isFirst = YES;
            VC.password = self.passWordF.text;
            [self.navigationController pushViewController:VC animated:YES];
          
        }
        


    } else {
        [Common showToast:Localized(@"PWDERROR")];
//        [ToastUtil shortToast:self.view value:Localized(@"PWDERROR")];
        
    }
    
  
}

- (void)timerAction {
    
    i--;
    _pop.titleLabel.text = [NSString stringWithFormat:@"%ld secs...",(long)i];
    if (i==0) {
        [self failAction];
    }
}

- (void)successAtionIsWallet:(BOOL)isWallet{
    [self.timer invalidate];
    [_pop dismiss];
    
    if (isWallet) {
        
        WalletBackupVC *vc = [[WalletBackupVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        vc.remenberWord = [Common getEncryptedContent:_address];
        vc.address =_address;
        vc.passwordHash = _passwordHash;
        vc.key = self.walletkey;
        vc.salt = self.salt;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
         [ViewController gotoIdentityVC];
    }
    
   
    
}

- (void)failAction{
    [self.timer invalidate];
    [_pop dismiss];
    i=20;

    _pop = [[MGPopController alloc] initWithTitle:@"Oops!" message:@"Creation fails" image:[UIImage imageNamed:@"createfail"]];
    [_pop addAction:[MGPopAction actionWithTitle:@"Retry" action:^{
        
    }]];
    [_pop show];
    _pop.showCloseButton = NO;
    
}

#pragma mark baseAction
- (void)navLeftAction {
    if (self.type == PWDTypeNext) {
        self.type = PWDTypeDefault;
        self.pwdString = @"";
        [self.pwdView clearPassword];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textFieldDidChange:(UITextField *)textField{

    if (textField == self.RetypeF) {
        
        if (_isWallet) {
            
            if (textField.text.length > 15) {
                
                textField.text = [textField.text substringToIndex:15];
                
            }
            
        }else{
         
            if (textField.text.length > 6) {
                
                textField.text = [textField.text substringToIndex:6];
                
            }
        }
        
      
        
    }
    
}

- (void)textFieldDidChange1:(UITextField *)textField{
    
    if (textField == self.passWordF) {
        
        if (_isWallet) {
            
            if (textField.text.length > 15) {
                
                textField.text = [textField.text substringToIndex:15];
                
            }
            
        }else{
            
            if (textField.text.length > 6) {
                
                textField.text = [textField.text substringToIndex:6];
                
            }
        }
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.pwdAlertBtn.userInteractionEnabled =YES;
    self.pwdAlertV.hidden =YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    inputText = @"";
    [textField resignFirstResponder];
    
    [self.nameF resignFirstResponder];
    [self.passWordF resignFirstResponder];
    [self.RetypeF resignFirstResponder];
    
    if (textField==self.passWordF) {
        _isreType = NO;
    }else if (textField ==self.RetypeF){
        _isreType = YES;
    }
    
    if (textField == self.nameF) {
        return YES;
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
    self.pwdAlertBtn.userInteractionEnabled =NO;
    self.pwdAlertV.hidden =YES;
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
    keyboard.hostTextField = _isreType==NO?self.passWordF:self.RetypeF;
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
    keyboard.stringPlaceholder = _isreType==NO?self.passWordF.placeholder:self.RetypeF.placeholder;
    keyboard.intMaxLength = 15;//最大输入长度
    keyboard.keyboardType = HYKeyboardTypeNone;//输入框类型
    /**更新安全键盘输入类型*/
    [keyboard shouldRefresh:HYKeyboardTypeNone];
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
    rect.origin.y=self.view.frame.size.height-keyboard.view.frame.size.height;
    keyboard.view.frame=rect;
    [UIView commitAnimations];
}

#pragma mark--关闭键盘回调

-(void)inputOverWithTextField:(UITextField *)textField inputText:(NSString *)text
{
    inputText=text;
    if (_isreType) {
         self.RetypeF.text = text;
    }else{
         self.passWordF.text = text;
    }
   
    [self hiddenKeyboardView];

}

-(void)inputOverWithChange:(UITextField *)textField changeText:(NSString *)text
{
    inputText=text;
    if (_isreType) {
        self.RetypeF.text = text;
        [self textFieldDidChange:self.RetypeF];

    }else{
        self.passWordF.text = text;
        [self textFieldDidChange:self.passWordF];

    }
    if (textField.text.length == 15) {
        DebugLog(@"输入完毕");
        [textField resignFirstResponder];
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
    self.pwdAlertBtn.userInteractionEnabled =YES;
    self.pwdAlertV.hidden =YES;
    [self hiddenKeyboardView];
}
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    self.pwdAlertBtn.userInteractionEnabled =NO;
    self.pwdAlertV.hidden =YES;
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

