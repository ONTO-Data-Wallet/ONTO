//
//  BackView.m
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

#import "BackView.h"
#import "Config.h"

@implementation BackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self configUI];
        [self configTap];
    }
    return self;
}

- (void)configUI {
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"cotback"];
    if (self.isCOT) {
        imageV.image = [UIImage imageNamed:@"cotback"];
    }
    imageV.userInteractionEnabled = YES;
    [self addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.left.mas_equalTo(self);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = K12BFONT;
    titleL.textColor = [UIColor whiteColor];
    titleL.userInteractionEnabled = YES;
    [self addSubview:titleL];

    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.mas_equalTo(self);
        make.left.equalTo(imageV.mas_right).offset(8);
    }];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    DebugLog(@"%@",NSStringFromCGRect(self.frame));
    [super layoutSubviews];
}

- (void)configTap {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        _callbackBack();
    }];
    [self addGestureRecognizer:tap];
    
}

@end
