//
//  NewPasswordSheet.m
//  ONTO
//
//  Created by Apple on 2018/9/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "NewPasswordSheet.h"
#import "LKLPayCodeTextField.h"
#import "Config.h"
#import "BrowserView.h"
#import "COTAlertV.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SPACE 10

@interface NewPasswordSheet()
@property (nonatomic, strong) UIView    *bgView;
@property (nonatomic, strong) UIView    *maskView;
@property (nonatomic, strong) UIWindow  *window;
@property (nonatomic, strong) LKLPayCodeTextField * textF;
@property (nonatomic, copy)   NSString  *title;
@property (nonatomic, strong) BrowserView      *browserView;
@property (nonatomic, copy)   NSString * pwdString;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, assign) BOOL isCheckPWD;
@property (nonatomic, assign) BOOL isCheckLogin;
@property (nonatomic, strong) NSDictionary      *sDic;
@end

@implementation NewPasswordSheet

-(instancetype)initWithTitle:(NSString *)title selectedDic:(NSDictionary*)selectedDic{
    self = [super init];
    if (self) {
        self.title =title;
        self.pwdString = @"";
        self.isCheckPWD = NO;
        self.isCheckLogin = NO;
        self.sDic = selectedDic;
        [self configUI];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //监听当键将要退出时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}
-(void)configUI{
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.browserView];
    [self addSubview:self.maskView];
    UIView *v =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight -332*SCALE_W)];
    UITapGestureRecognizer
    *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissScreenBgView)];
    tapGesture.cancelsTouchesInView = YES;
    [v addGestureRecognizer:tapGesture];
    [self addSubview:v];
    [self addSubview:self.bgView];
    [self createDetailView];
}
-(void)createDetailView{
    UILabel* titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 25*SCALE_W, SYSWidth, 23*SCALE_W)];
    titleLB.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    titleLB.text = self.title;
    [titleLB changeSpace:0 wordSpace:1*SCALE_W];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:titleLB];
    
    UIButton* confirmBtn =[[UIButton alloc]initWithFrame:CGRectMake(58*SCALE_W, 232*SCALE_W, SYSWidth - 116*SCALE_W, 60*SCALE_W)];
    confirmBtn.backgroundColor = [UIColor blackColor];
    [confirmBtn setTitle:Localized(@"NEWCONFIRM") forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [confirmBtn.titleLabel changeSpace:0 wordSpace:3*SCALE_W];
    [_bgView addSubview:confirmBtn];
    
    __weak __typeof(self)weakSelf = self;
    _textF = [[LKLPayCodeTextField alloc]initWithFrame:CGRectMake(20*SCALE_W, 100*SCALE_W, SYSWidth -40*SCALE_W, 50*SCALE_W)];
    _textF.isShowTrueCode = NO;
    _textF.isPSW = YES;
    _textF.finishedBlock = ^(NSString *payCodeString) {
        weakSelf.pwdString = payCodeString;
    };
    [_bgView addSubview:_textF];
    
    [confirmBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        weakSelf.isCheckPWD = YES;
        [weakSelf loadJS];
    }];
}
- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}
-(UIView*)bgView{
    if (!_bgView) {
        
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(0, SYSHeight-332*SCALE_W , Screen_Width, 332*SCALE_W+SafeBottomHeight)];
        _bgView.clipsToBounds =YES;
        _bgView.backgroundColor =[UIColor whiteColor];
    }
    return _bgView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}

- (void)show {
    
    [UIView animateWithDuration:.2 animations:^{
        _bgView.frame = CGRectMake(0, SYSHeight-332*SCALE_W -246-PhotoTopHeight, Screen_Width - (SCALE_W * 0), 332*SCALE_W +SafeBottomHeight);
        _maskView.alpha = .5;
        
    }];
//    _window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
//    [_window addSubview:self];
//    [_window makeKeyAndVisible];
}

- (void)dismiss {
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y += _bgView.bounds.size.height  -332*SCALE_W +246;
        _bgView.frame = rect;
        _maskView.alpha =0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.superview.hidden = YES;
    }];
}

- (void)dismiss1 {
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y += _bgView.bounds.size.height   -332*SCALE_W +246;
        _bgView.frame = rect;
    } completion:^(BOOL finished) {
    }];
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    _bgView.frame = CGRectMake(0, SYSHeight-332*SCALE_W -246, Screen_Width - (SCALE_W * 0), 332*SCALE_W +SafeBottomHeight);
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self dismiss1];
    
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
- (void)loadJS{
    if ([_pwdString isEqualToString:@""]) {
        return;
    }
    NSString* str = [Common getEncryptedContent:APP_ACCOUNT];
    NSDictionary* jsDic = [Common dictionaryWithJsonString:str];
    NSArray* arr  = jsDic[@"identities"];
    NSDictionary* defaultDic;
    for (NSDictionary* subDic in arr) {
        if ([subDic[@"ontid"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]) {
            defaultDic = subDic;
        }
    }
    
    if (_isLogin == NO) {
        defaultDic = self.sDic;
    }
    NSArray *controlsArr= defaultDic[@"controls"];
    NSDictionary* detailDic = controlsArr[0];
    
    NSString* jsStr ;
    if (_isCheckPWD == YES) {
        _hub=[ToastUtil showMessage:@"" toView:nil];
        jsStr =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",detailDic[@"key"],_pwdString,detailDic[@"address"],detailDic[@"salt"]];
    }
    if (_isCheckLogin == YES) {
        NSDictionary *params ;
        if (_isLogin == NO) {
            params=  @{@"OwnerOntId":self.sDic[@"ontid"]};
            
        }else{
            params=@{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]};
        }
        NSString *signature = [Common dictionaryToJson:params];
        signature = [signature stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        signature = [signature stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        signature = [Common hexStringFromString:signature];
        jsStr =  [NSString stringWithFormat:@"Ont.SDK.signData('%@','%@','%@','%@','%@','newsignDataStr')",signature,detailDic[@"key"],[Common base64EncodeString:_pwdString],detailDic[@"address"],detailDic[@"salt"]];
    }
    
    LOADJS1;
    LOADJS2;
    LOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    
}
- (void)handlePrompt:(NSString *)prompt{
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            _pwdString = @"";
            [self dismiss];
            COTAlertV *failV = [[COTAlertV alloc]initWithTitle:Localized(@"newError") imageString:@"cotfail" buttonString:Localized(@"cotRetry")];
            failV.callback = ^(NSString *string) {
                [_textF clearKeyCode];
            };
            [failV show];
            
        }else{
            if (_isLogin == YES) {
                _isCheckPWD = NO;
                _isCheckLogin = YES;
                [_textF resignFirstResponder];
                [self loadJS];
            }else{
//                if (_isDefault == YES){
                    _isCheckPWD = NO;
                    _isCheckLogin = YES;
                    [_textF resignFirstResponder];
                    [self loadJS];
//                }else{
//
//                    [_hub hideAnimated:YES];
//                    if (_callback) {
//                        _callback(@"");
//                    }
//                    [self dismiss];
//                }
            }
            
        }
    }else if ([prompt hasPrefix:@"newsignDataStr"]){
        NSDictionary * paramsSign;
        if (_isLogin == NO) {
            paramsSign=@{@"OwnerOntId":self.sDic[@"ontid"],@"Signature":obj[@"Value"]};
            
        }else{
            paramsSign=@{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],@"Signature":obj[@"Value"]};
        }
        [[CCRequest shareInstance] requestWithURLStringNoLoading:Devicecode_regain MethodType:MethodTypePOST Params:paramsSign Success:^(id responseObject, id responseOriginal) {
            NSDictionary * ResultDic = responseOriginal[@"Result"];
            NSString * codeStr = ResultDic[@"DeviceCode"];
            [[NSUserDefaults standardUserDefaults] setValue:codeStr forKey:DEVICE_CODE];
            [[NSUserDefaults standardUserDefaults] setValue:codeStr forKey:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@DeviceCode",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]];
             [_hub hideAnimated:YES];
            _maskView.alpha =0;
            [self removeFromSuperview];
            self.superview.hidden = YES;
            if (_callback) {
                _callback(@"");
            }
            
        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
            [_hub hideAnimated:YES];
//            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_CODE]);
//            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:ONT_ID]);
            [Common showToast:Localized(@"NetworkAnomaly")];
            _maskView.alpha =0;
            [self removeFromSuperview];
            self.superview.hidden = YES;
        }];
    }
}
#pragma mark - 消失视图
-(void)dismissScreenBgView{
    [_textF.textField resignFirstResponder];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.3];
    
}

@end
