//
//  SendConfirmView.m
//  ONTO
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

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "PasswordView.h"
#import "Config.h"

int HeightCloseB = 40;
int InputLabelMarginTop = 32;
int PasswordMaringTop = 10;
int SureBMariginTop = 50;
int PwdEnterVHeight = 40;
int Height = 240;

@implementation PasswordView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self addSubview:self.maskView];
//    [self.maskView addSubview:self.bottomWhiteView];
    [self addSubview:self.bottomWhiteView];

    [self.bottomWhiteView addSubview:self.firstLine];
    [self.bottomWhiteView addSubview:self.closeB];
    [self.bottomWhiteView addSubview:self.titleL];
    [self.bottomWhiteView addSubview:self.inputL];
    [self.bottomWhiteView addSubview:self.pwdEnterV];
    [self.bottomWhiteView addSubview:self.sureB];
  }
  return self;
}

//NOTE: 总的高度写死了，就是240
//- (int)height {
//    return self.inputL.height + HeightCloseB + self.titleL.height + InputLabelMarginTop + PasswordMaringTop
//        + PasswordHeight;
//
//}

// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (void)updateConstraints {

  [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.top.bottom.mas_equalTo(self);
  }];

//  [self.bottomWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.left.right.mas_equalTo(self.maskView);
//    make.top.mas_equalTo(self.maskView.mas_bottom);
//    make.height.mas_equalTo(Height);
//  }];

  [self.bottomWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self);
    make.top.mas_equalTo(self.mas_bottom);
    make.height.mas_equalTo(Height);
  }];

  [self.closeB mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.mas_equalTo(self.bottomWhiteView);
    make.size.mas_equalTo(CGSizeMake(40, HeightCloseB));
  }];

  [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.closeB.mas_right);
    make.right.equalTo(self.mas_right).offset(-40);
    make.top.bottom.mas_equalTo(self.closeB);
  }];

  [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self.bottomWhiteView);
    make.top.mas_equalTo(self.closeB.mas_bottom);
    make.height.mas_equalTo(@1);
  }];

  [self.inputL mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.bottomWhiteView).offset(29);
    make.top.equalTo(self.firstLine).offset(InputLabelMarginTop);
    make.right.equalTo(self.bottomWhiteView);
  }];

  [self.pwdEnterV mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.inputL.mas_bottom).offset(PasswordMaringTop);
    make.height.mas_equalTo(PwdEnterVHeight);
    make.left.equalTo(self.bottomWhiteView).offset(29);
    make.right.equalTo(self.bottomWhiteView).offset(-29);
  }];

  // NOTE: 如何设置底部对齐，则会导致动画的时候，现出来sureB，所以这里是通过设置和pwdEnterV相对的位置
  [self.sureB mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.bottomWhiteView);
    make.size.mas_equalTo(CGSizeMake(kScreenWidth, 48));
    make.top.equalTo(self.pwdEnterV.mas_bottom).offset(SureBMariginTop);
  }];

  //according to apple super should be called at end of method
  [super updateConstraints];
}

- (void)layoutSubViews {
  [super layoutSubviews];
}


- (UIView *)maskView {
  if (!_maskView) {
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = RGBA(43, 64, 69, 0.7);;
    _maskView.UserInteractionEnabled = false;
  }
  return _maskView;
}

- (UIView *)bottomWhiteView {
  if (!_bottomWhiteView) {
    _bottomWhiteView = [[UIView alloc] init];
    _bottomWhiteView.backgroundColor = [UIColor whiteColor];
  }
  return _bottomWhiteView;
}

- (void)sureAction:(UIButton *)btn {
  if (_callback) {
    // _callback 里面需要影藏按钮
    _callback(self.pwdEnterV.textField.text);
  }
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

- (UIView *)firstLine {
  if (!_firstLine) {
    _firstLine = [[UIView alloc] init];
    _firstLine.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
  }
  return _firstLine;
}

- (UIButton *)closeB {
  if (!_closeB) {
    _closeB = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeB setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_closeB addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _closeB;
}

- (IBAction)closeAction:(id)sender {
  [self dismiss];
}

- (void)dismiss {

  // 向下动画
  [self.bottomWhiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self);
    make.top.mas_equalTo(self.mas_bottom);
    make.height.mas_equalTo(Height);
  }];

  [UIView animateWithDuration:0.3
                   animations:^{

                     [self layoutIfNeeded];

                   } completion:^(BOOL finished) {

        //NOTE: 这个很重要
        [self.pwdEnterV.textField resignFirstResponder];
        [self.pwdEnterV hiddenKeyboardView];
        UITabBarController *vc = [self getCurrentViewController];
        vc.tabBar.hidden = NO;
        [self removeFromSuperview];
      }
  ];
}

- (UITabBarController *)getCurrentViewController {

  UITabBarController *result = nil;
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  result = (UITabBarController *) window.rootViewController;
  return result;

}

-(void)showAnimation{

  [[NSOperationQueue mainQueue] addOperationWithBlock:^{


    // 向上动画
    [self.bottomWhiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.right.mas_equalTo(self);
      make.bottom.mas_equalTo(self.mas_bottom);
      make.height.mas_equalTo(Height);
    }];

    [UIView animateWithDuration:0.3
                     animations:^{

                       [self layoutIfNeeded];

                     } completion:^(BOOL finished) {

          [self performSelector:@selector(becomeFirst) withObject:nil afterDelay:0.1];

        }];
  }];
};

- (void)showInParentView:(UIView *)parentView {
  [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;

  self.titleL.text = Localized(@"EnterPassword");
  [self.pwdEnterV clearPassword];
  self.password = @"";
  UITabBarController *vc = [self getCurrentViewController];
  vc.tabBar.hidden = YES;
  [parentView addSubview:self];
  [self performSelector:@selector(showAnimation) withObject:nil afterDelay:0.1];
}

- (void)becomeFirst {
  if (_isIdentity) {
    [self.pwdEnterV.textField becomeFirstResponder];
  }
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

- (void)setIsIdentity:(BOOL)isIdentity {

  _isIdentity = isIdentity;
  _pwdEnterV.isIdentity = _isIdentity;
  _inputL.text = Localized(@"InputONTIDPassword");
}

- (PwdEnterView *)pwdEnterV {
  if (!_pwdEnterV) {
    __weak typeof(self) weakself = self;
    _pwdEnterV = [[PwdEnterView alloc] initWithFrame:CGRectZero];
  }
  return _pwdEnterV;
}
@end
