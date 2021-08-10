//
//  IndentityCell.m
//  OnChain
//
//  Created by 赵伟 on 2018/3/8.
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

#import "IndentityCell.h"
#import "UIView+Scale.h"
#import "Config.h"
#import "IdentityModel.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation IndentityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_iconImage scaleFrameBaseWidth];
    [_certicationTitle scaleFrameBaseWidth];
    [_cerImage scaleFrameBaseWidth];
    [_arrow scaleFrameBaseWidth];
    [_lineView scaleFrameBaseWidth];
    _imageArr = @[@[@"SM"],@[@"twitter",@"LN",@"Github",@"F"]];
    _titleArr =@[@[Localized(@"Identity")], @[Localized(@"Twitter"),Localized(@"Linkedin"),Localized(@"Github"),Localized(@"Facebook")]];
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 1;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.waitCircle.layer addAnimation:animation forKey:nil];
    
}

- (void)setwithIndex:(NSIndexPath *)indexPath{

    _iconImage.image = [UIImage imageNamed:(NSString*)_imageArr[indexPath.section][indexPath.row]];
    _certicationTitle.text = _titleArr[indexPath.section][indexPath.row];
}

- (void)setwithModel:(IdentityModel *)model{
   
  _certicationTitle.text = model.Name;
    
    if ([model.Logo isNotBlank]) {
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.Logo]];
    }else{
        _iconImage.image = [UIImage imageNamed:@"SM"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

