//
//  SendConfirmView.m
//  ONTO
//
//  Created by 张超 on 2018/3/25.
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

#import "SendConfirmView.h"
#import "Config.h"
#import "UIView+Banner.h"

@implementation SendConfirmView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
//        [self p_initObserver];
    }
    return self;
}

-(void)p_initObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
}

//修改键盘弹出遮盖输入框的问题
- (void)keyboardAction:(NSNotification*)sender
{
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if([sender.name isEqualToString:UIKeyboardWillShowNotification])
    {
        self.passwordV.top = [value CGRectValue].origin.y-120;
    }
    else
    {
        self.passwordV.bottom = self.bottom;
    }
}

- (void)configUI {
    
    [self addSubview:self.confirmV];
    [self.confirmV addSubview:self.closeB];
    [self.confirmV addSubview:self.titleL];
    [self.confirmV addSubview:self.amountL];
    [self.confirmV addSubview:self.paybyL];
    [self.confirmV addSubview:self.paytoL];
    [self.confirmV addSubview:self.feeL];
    [self.confirmV addSubview:self.feeMoneyL];
    [self.confirmV addSubview:self.confirmB];
    
    [self addSubview:self.passwordV];
    [self.passwordV addSubview:self.inputL];
    [self.passwordV addSubview:self.pwdEnterV];
    [self.passwordV addSubview:self.sureB];
    
    [self.confirmV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(@424);
    }];
    
    [self.closeB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.confirmV);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.closeB.mas_right);
        make.right.equalTo(self.confirmV.mas_right).offset(-40);
        make.top.bottom.mas_equalTo(self.closeB);
    }];
    
    UIView *firstLine = [[UIView alloc] init];
    firstLine.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [self.confirmV addSubview:firstLine];
    
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.confirmV);
        make.top.mas_equalTo(self.closeB.mas_bottom);
        make.height.mas_equalTo(@1);
    }];
    
    [self.amountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(firstLine);
        make.top.equalTo(firstLine.mas_bottom).offset(36);
        make.height.mas_equalTo(@30);
    }];
    
    [self.paytoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmV).offset(17);
        make.right.equalTo(self.confirmV).offset(-17);
        make.top.equalTo(self.amountL.mas_bottom).offset(36);
        make.height.mas_equalTo(@24);
    }];
    
    UIView *secondLine = [[UIView alloc] init];
    secondLine.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [self.confirmV addSubview:secondLine];
    
    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.confirmV);
        make.top.equalTo(self.paytoL.mas_bottom).offset(10);
        make.height.mas_equalTo(@1);
    }];
    
    [self.paybyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmV).offset(17);
        make.right.equalTo(self.confirmV).offset(-17);
        make.top.equalTo(secondLine.mas_bottom).offset(10);
        make.height.mas_equalTo(@24);
    }];
    
    UIView *thirdLine = [[UIView alloc] init];
    thirdLine.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [self.confirmV addSubview:thirdLine];
    
    [thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.confirmV);
        make.top.equalTo(self.paybyL.mas_bottom).offset(10);
        make.height.mas_equalTo(@1);
    }];
    
    [self.feeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmV).offset(17);
        make.top.equalTo(thirdLine.mas_bottom).offset(10);
        make.height.mas_equalTo(@24);
        make.width.mas_equalTo(@100);
    }];
    
    [self.feeMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.confirmV.mas_right).offset(-17);
        make.top.equalTo(thirdLine.mas_bottom).offset(10);
        make.height.mas_equalTo(@24);
        make.left.mas_equalTo(self.feeL.mas_right);
    }];
    
    UIView *lastLine = [[UIView alloc] init];
    lastLine.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [self.confirmV addSubview:lastLine];
    
    [lastLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.confirmV);
        make.top.equalTo(self.feeMoneyL.mas_bottom).offset(10);
        make.height.mas_equalTo(@1);
    }];

    [self.confirmB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 48));
        make.bottom.equalTo(self.mas_bottom).offset(-LL_TabbarSafeBottomMargin);
        make.centerX.mas_equalTo(self);
    }];

    [self.inputL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordV).offset(29);
        make.top.equalTo(self.passwordV).offset(32);
        make.right.equalTo(self.passwordV);
    }];
    
    [self.pwdEnterV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputL.mas_bottom).offset(10);
        make.height.mas_equalTo(@40);
        make.left.equalTo(self.passwordV).offset(29);
        make.right.equalTo(self.passwordV).offset(-29);
    }];
    
    [self.sureB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.passwordV);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 48));
        make.centerY.mas_equalTo(self.confirmB);
    }];
}

- (UIView *)confirmV {
    if (!_confirmV) {
        _confirmV = [[UIView alloc] init];
        _confirmV.backgroundColor = [UIColor whiteColor];
    }
    return _confirmV;
}

- (UIButton *)closeB {
    if (!_closeB) {
        _closeB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeB setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeB addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeB;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.font = K16FONT;
        _titleL.text = Localized(@"PaymentRequest");
        _titleL.textColor = [UIColor colorWithHexString:@"#6A797C"];
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}

- (UILabel *)amountL {
    if (!_amountL) {
        _amountL = [[UILabel alloc] init];
        _amountL.font = [UIFont systemFontOfSize:25 weight:UIFontWeightHeavy];
        _amountL.textAlignment = NSTextAlignmentCenter;
        _amountL.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
        _amountL.text = [NSString stringWithFormat:@"%@ ONT",self.amountStr];
    }
    return _amountL;
}

- (UILabel *)paytoL {
    if (!_paytoL) {
        _paytoL = [[UILabel alloc] init];
        _paytoL.font = [UIFont systemFontOfSize:13];
        _paytoL.text = [NSString stringWithFormat:@"%@,%@",Localized(@"Paytp"),self.paytoStr];
        _paytoL.textColor = [UIColor colorWithHexString:@"#565656"];
    }
    return _paytoL;
}

- (UILabel *)paybyL {
    if (!_paybyL) {
        _paybyL = [[UILabel alloc] init];
        _paybyL.font = [UIFont systemFontOfSize:13];
        _paybyL.text = [NSString stringWithFormat:@"%@,%@",Localized(@"Payby"),self.paybyStr];
        _paybyL.textColor = [UIColor colorWithHexString:@"#565656"];
    }
    return _paybyL;
}

- (UILabel *)feeL {
    if (!_feeL) {
        _feeL = [[UILabel alloc] init];
        _feeL.font = [UIFont systemFontOfSize:13];
        _feeL.text = Localized(@"Fee");
        _feeL.textColor = [UIColor colorWithHexString:@"#565656"];
    }
    return _feeL;
}

- (UILabel *)feeMoneyL {
    
    if (!_feeMoneyL) {
        
        _feeMoneyL = [[UILabel alloc] init];
        _feeMoneyL.font = [UIFont systemFontOfSize:13];
//      TODO:需要调试看看有没有多一些0
        _feeMoneyL.text = [NSString stringWithFormat:@"%@ ONG",[[NSUserDefaults standardUserDefaults]valueForKey:FEE]];
        _feeMoneyL.textAlignment = NSTextAlignmentRight;
        _feeMoneyL.textColor = [UIColor colorWithHexString:@"#565656"];
     
    }
    return _feeMoneyL;
}

- (UIButton *)confirmB {
    if (!_confirmB) {
        _confirmB = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmB.titleLabel.font = K17BFONT;
        [_confirmB setTitle:Localized(@"Confirm") forState:UIControlStateNormal];
        _confirmB.layer.cornerRadius = 1;
        _confirmB.layer.masksToBounds = YES;
        [_confirmB addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmB setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
        [_confirmB setTitleColor:[UIColor colorWithHexString:@"#0AA5C9"] forState:UIControlStateNormal];
    }
    return _confirmB;
}

- (UIView *)passwordV {
    if (!_passwordV) {
        _passwordV = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, kScreenHeight - 381, kScreenWidth, 381)];
        _passwordV.backgroundColor = [UIColor whiteColor];
    }
    return _passwordV;
}

- (UILabel *)inputL {
    if (!_inputL) {
        _inputL = [[UILabel alloc] init];
        _inputL.font = K14FONT;
        _inputL.textColor = [UIColor colorWithHexString:@"#c3c1c7"];
        _inputL.text = Localized(@"InputTheWalletPassword");
        if (self.isIdentity) {
            _inputL.text = Localized(@"InputONTIDPassword");
        }
        
        _inputL.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    }
    return _inputL;
}

- (void)setIsIdentity:(BOOL)isIdentity{
    
    _isIdentity = isIdentity;
    _pwdEnterV.isIdentity =  _isIdentity;
     _inputL.text = Localized(@"InputONTIDPassword");
}


- (PwdEnterView *)pwdEnterV {
    if (!_pwdEnterV) {
        __weak typeof(self) weakself = self;
        _pwdEnterV = [[PwdEnterView alloc] initWithFrame:CGRectZero];
        [_pwdEnterV setCallbackPwd:^(NSString *pwd_text) {
            weakself.password = pwd_text;
        }];
    }
    return _pwdEnterV;
}

- (UIButton *)sureB {
    if (!_sureB) {
        _sureB = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureB.titleLabel.font = K17BFONT;
        [_sureB setTitle:Localized(@"Confirm") forState:UIControlStateNormal];
        _sureB.layer.cornerRadius = 1;
        _sureB.layer.masksToBounds = YES;
        [_sureB addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sureB setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
        [_sureB setTitleColor:[UIColor colorWithHexString:@"#35BFDF"] forState:UIControlStateNormal];
    }
    return _sureB;
}

- (IBAction)closeAction:(id)sender {
    DebugLog(@"11");
    [self.pwdEnterV.textField resignFirstResponder];
    [self dismiss];
    [self.pwdEnterV hiddenKeyboardView];
}

- (void)dismiss{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(self.center.x , self.center.y + kScreenHeight);
    } completion:^(BOOL finished) {
        self.passwordV.center = CGPointMake(self.center.x + kScreenWidth, self.passwordV.center.y);
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        if (_isCapital)
        {
            UIViewController *vc = [self getCurrentViewController];
            vc.tabBarController.tabBar.hidden = NO;
        }
    }];
    
}

- (IBAction)confirmAction:(id)sender {
    DebugLog(@"11");
    [UIView animateWithDuration:0.5 animations:^{
        self.passwordV.center = CGPointMake(self.center.x, self.passwordV.center.y);
        self.titleL.text = Localized(@"EnterPassword");
//        self.titleL.textColor = [UIColor blackColor];
    
    }];
}

- (void)sureAction:(UIButton *)btn {
//    if (self.password.length == 6) {
        if (_callback) {
//            [self closeAction:btn];
            _callback(_tokenType,self.paybyStr,self.paytoStr,self.amountStr,self.password);
        }
//    }
}

- (void)show {
    
    if (_isCapital||_isWalletBack){
        self.passwordV.center = CGPointMake(self.center.x, self.passwordV.center.y);
        self.titleL.text = Localized(@"EnterPassword");
        [self.pwdEnterV clearPassword];
        self.password = @"";
    }
    
    if (_isOng) {
         _tokenType =@"ONG";
    }else{
        _tokenType = @"ONT";
    }
    if (_isPum) {
        if ([_pumType isEqualToString:@"pumpkin01"]) {
            _tokenType = Localized(@"PumpkinRed");
        }else if ([_pumType isEqualToString:@"pumpkin02"]){
            _tokenType =Localized(@"OrangePum");
        }else if ([_pumType isEqualToString:@"pumpkin03"]){
            _tokenType = Localized(@"PumpkinYellow");
        }else if ([_pumType isEqualToString:@"pumpkin04"]){
            _tokenType = Localized(@"PumpkinGreen");
        }else if ([_pumType isEqualToString:@"pumpkin05"]){
           _tokenType = Localized(@"PumpkinIndigo");
        }else if ([_pumType isEqualToString:@"pumpkin06"]){
            _tokenType = Localized(@"PumpkinBlue");
        }else if ([_pumType isEqualToString:@"pumpkin07"]){
            _tokenType = Localized(@"PumpkinPurple");
        }else if ([_pumType isEqualToString:@"pumpkin08"]){
            _tokenType = Localized(@"PumpkinGolden");
        }
        
    }
    if (_isDragon) {
        _tokenType = Localized(@"dragon");
    }
    if (_isOEP4) {
        _tokenType = self.tokenDict[@"ShortName"];
    }
    [self.pwdEnterV clearPassword];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.center = CGPointMake(self.center.x , kScreenHeight/2);
            
        } completion:^(BOOL finished) {
            
            self.backgroundColor = RGBA(43, 64, 69, 0.7);
            //        [UIColor colorWithHexString:@"0D181A"];
            
            if (_isCapital){
                UIViewController *vc = [self getCurrentViewController];
                vc.tabBarController.tabBar.hidden = YES;
            }
            
        }];
        
        [self performSelector:@selector(becomeFirst) withObject:nil afterDelay:0.1];
//            [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                self.backgroundView.alpha = 1.0f;
//                self.actionSheetView.frame = CGRectMake(0, self.frame.size.height-self.actionSheetView.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
//            } completion:nil];
    }];
//    }
    
    [self p_initObserver];
    
    
}
-(void)becomeFirst{
    if (_isIdentity) {
        [self.pwdEnterV.textField becomeFirstResponder];
    }
}

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
//    UIResponder *next = [self nextResponder];
//    do {
//        if ([next isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)next;
//        }
//        next = [next nextResponder];
//    } while (next != nil);
//    return nil;
    
    {
        UIViewController *result = nil;
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        if (window.windowLevel != UIWindowLevelNormal) {
            NSArray *windows = [[UIApplication sharedApplication] windows];
            
            for (UIWindow *temWin in windows) {
                if (temWin.windowLevel == UIWindowLevelNormal) {
                    window = temWin;
                    break;
                }
            }
        }
        
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nestResponder = [frontView nextResponder];
        if ([nestResponder isKindOfClass:[UIViewController class]]) {
            result = nestResponder;
        } else {
            result = window.rootViewController;
        }
        return result;
    }
}

- (void)setPaybyStr:(NSString *)paybyStr {
    _paybyStr = paybyStr;
    self.paybyL.text = [NSString stringWithFormat:@"%@%@",Localized(@"Payby"),paybyStr];
}

- (void)setPaytoStr:(NSString *)paytoStr {
    _paytoStr = paytoStr;
    self.paytoL.text = [NSString stringWithFormat:@"%@%@",Localized(@"Payto"),paytoStr];
}

- (void)setFeemoneyStr:(NSString *)feemoneyStr {
    _feemoneyStr = feemoneyStr;
    self.feeMoneyL.text = feemoneyStr;
}

- (void)setAmountStr:(NSString *)amountStr {
    _amountStr = amountStr;
    self.amountL.text = [NSString stringWithFormat:@"%@ %@",amountStr,_tokenType];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
