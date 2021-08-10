//
//  SuccessView.m
//  ONTO
//
//  Created by 张超 on 2018/3/10.
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

#import "SuccessView.h"
#import "Config.h"

@implementation SuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame Success:(BOOL)isSuccess {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI:isSuccess];
    }
    return self;
}

- (void)configUI:(BOOL)isSuccess {
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:(isSuccess ? @"wait_success" : @"wait_failure")];
    [self addSubview:imageV];
    
    _successL = [[UILabel alloc] init];
    if (self.isWallet) {
        _successL.text = isSuccess ? Localized(@"SuccessWalletAlert") : Localized(@"FailureWalletAlert");
    } else {
        _successL.text = isSuccess ? Localized(@"SuccessAlert") : Localized(@"FailureAlert");
    }
    _successL.textColor = [UIColor whiteColor];
    _successL.textAlignment = NSTextAlignmentCenter;
    _successL.font = K16BFONT;
    _successL.numberOfLines = 0;
    [self addSubview:_successL];
    
    _successContentL = [[UILabel alloc] init];
//    successContentL.text = Localized(@"SuccessContent");
    _successContentL.textColor = [UIColor colorWithHexString:@"#88d5ff"];
    _successContentL.font = K12BFONT;
    _successContentL.numberOfLines = 0;
    _successContentL.textAlignment = NSTextAlignmentCenter;
    _successContentL.hidden = !isSuccess;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:
                                      self.isWallet?Localized(@"WalletSuccessContent"): Localized(@"SuccessContent")];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    _successContentL.attributedText = str;
    [self addSubview:_successContentL];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isSuccess) {
            make.top.mas_equalTo(self);
        } else {
            make.top.equalTo(self).offset(22);
        }
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(57, 57));
    }];
    
    [_successL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.mas_equalTo(self);
        make.top.equalTo(imageV.mas_bottom).offset(21);
        if (isSuccess) {
            
        } else {
//            make.bottom.equalTo(self).offset(76);
        }
    }];
    
    [_successContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24);
        make.right.equalTo(self).offset(-24);
        make.bottom.equalTo(self);
        if (isSuccess) {
            make.top.equalTo(_successL.mas_bottom).offset(15);
        } else {
            
        }
    }];

}

@end
