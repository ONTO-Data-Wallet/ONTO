//
//  DIManageCell.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/12.
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

#import "DIManageCell.h"
#import "UIView+Scale.h"
#import "Config.h"

@implementation DIManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_userIcon scaleFrameBaseWidth];
    [_nameLabel scaleFrameBaseWidth];
    [_defaultBtn scaleFrameBaseWidth];
    [_defaultLabel scaleFrameBaseWidth];
    [_backUpBtn scaleFrameBaseWidth];
//    [_defaultBtn setImage:[UIImage imageNamed:@"ID_Unselect"] forState:UIControlStateNormal];
    [_defaultBtn setImage:[UIImage imageNamed:@"identity_Select"] forState:UIControlStateSelected];
    //描边
    _backUpBtn.layer.masksToBounds = YES;
    _backUpBtn.layer.cornerRadius = 12.5*SCALE_W;
    _backUpBtn.layer.borderWidth = 0.5;
    _backUpBtn.layer.borderColor  = [UIColor colorWithHexString:@"#20C0DB"].CGColor; //要设置的颜色
    [_backUpBtn setTitle:Localized(@"BackUp") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
