//
//  OTAlertView.m
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

#import "OTAlertView.h"
#import "Config.h"

@implementation OTAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithTitle:(NSString *)alertStr {
    if (self == [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _alertStr = alertStr;
        [self configUI];
        [self configTouch];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa80"];
    
    UIView *alertV = [[UIView alloc] init];
    alertV.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:alertV];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:closeBtn];
    
    UILabel *alertL = [[UILabel alloc] init];
    alertL.numberOfLines = 0;
    alertL.text = self.alertStr;
    alertL.font = K14BFONT;
    alertL.textColor = [UIColor colorWithHexString:@"#20c0db"];
    alertL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:alertL];
    
    UIButton *comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [comfirmBtn setTitle:@"OK" forState:UIControlStateNormal];
    comfirmBtn.backgroundColor = [UIColor colorWithHexString:@"#2295d4"];
    [comfirmBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    comfirmBtn.layer.masksToBounds = YES;
    comfirmBtn.layer.cornerRadius = 1;
     [self addSubview:comfirmBtn];
    
    [alertV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(42);
        make.right.equalTo(self).offset(-42);
        make.centerY.mas_equalTo(self);
    }];
    
    [alertL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertV).offset(20);
        make.right.equalTo(alertV).offset(-20);
        make.top.equalTo(alertV).offset(30);
        make.bottom.equalTo(alertV).offset(-70);
    }];
    
 
    [comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(alertV).offset(-20);
        make.height.mas_equalTo(@30);
        make.centerX.mas_equalTo(alertV);
        make.left.equalTo(alertV).offset(60);
        make.right.equalTo(alertV).offset(-60);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.top.equalTo(alertV).offset(13);
        make.right.equalTo(alertV).offset(-13);
    }];
}

- (void)configTouch {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self removeFromSuperview];
    }];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:singleTap];
}

- (void)closeAction {
    
    __weak typeof(self) weakself = self;
    
    if (weakself.closeBlock) {
        //将自己的值传出去，完成传值
        weakself.closeBlock();
    }
    
    [self removeFromSuperview];
    
}

- (void)showAlert {
    [APP_DELEGATE.window addSubview:self];
}

@end
