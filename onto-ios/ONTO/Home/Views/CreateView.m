//
//  CreateView.m
//  ONTO
//
//  Created by Zeus.Zhang on 2018/2/24.
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

#import "CreateView.h"
#import "Config.h"

@implementation CreateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setQrcode_str:(NSString *)qrcode_str {
    _imageV.image = [UIImage LX_ImageOfQRFromURL:qrcode_str codeSize:200];
}

- (void)configUI {
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self addSubview:_imageV];
    UIButton *backupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backupBtn setTitle:@"Back up account" forState:UIControlStateNormal];
    [backupBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    backupBtn.titleLabel.font = K14FONT;
    backupBtn.backgroundColor = MAINAPPCOLOR;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
