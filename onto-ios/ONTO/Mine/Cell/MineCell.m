//
//  MineCell.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/9.
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

#import "MineCell.h"
#import "UIView+Scale.h"
#import "Config.h"

@implementation MineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [_iconImage scaleFrameBaseWidth];
//    [_MineTitle scaleFrameBaseWidth];
//    [_arrow scaleFrameBaseWidth];
//    [_lineImage scaleFrameBaseWidth];
//    _imageArr = @[@"Me_wm",@"Me_vc",@"Me_im",@"Me_wm",@"Me_ss",@"Me_hc",@"Me_as"];
//    _titleArr = @[Localized(@"Myauthorization"),Localized(@"Myverifledclaim"),Localized(@"Digitalidentitymanage"),Localized(@"Walletmanage"),Localized(@"Systemsettings"),Localized(@"Helpcenter"),Localized(@"Aboutus")];
   
}

- (void)setwithIndex:(NSIndexPath *)indexPath{
    
    _iconImage.image = [UIImage imageNamed:(NSString*)_imageArr[indexPath.section][indexPath.row]];
    _MineTitle.text = _titleArr[indexPath.section][indexPath.row];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
