//
//  BlockChainCertCell.m
//  ONTO
//
//  Created by 赵伟 on 2018/4/28.
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

#import "BlockChainCertCell.h"
#import "Config.h"
@implementation BlockChainCertCell
-(id)initWithCornerRadius:(CGFloat)radius Style:(UITableViewCellStyle)tyle reuseIdentifier:(NSString*)identifier
{
    self = [super initWithStyle:tyle reuseIdentifier:identifier];
    if (self) {
        _cornerRadius = radius;
        _titleLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 20*SCALE_W, SYSWidth-64*SCALE_W, 14*SCALE_W)];
        [self.contentView addSubview:_titleLB];
        
        _contentLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 44*SCALE_W, SYSWidth-64*SCALE_W, 19*SCALE_W)];
        [self.contentView addSubview:_contentLB];
        
        _renewLB =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SYSWidth-46*SCALE_W, 80*SCALE_W)];
        _renewLB.textColor =BLUELB;
        _renewLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];//[UIFont fontWithName:@"SFProText-Medium" size:14];
        _renewLB.text = @"Renew";
        _renewLB.hidden =YES;
        _renewLB.textAlignment =NSTextAlignmentRight;
        [self.contentView addSubview:_renewLB];
        
        _rightImage =[[UIImageView alloc]initWithFrame:CGRectMake(SYSWidth-40*SCALE_W, 32*SCALE_W, 16*SCALE_W, 16*SCALE_W)];
        _rightImage.image =[UIImage imageNamed:@"IdRight"];
        _rightImage.hidden =YES;
        [self.contentView addSubview:_rightImage];
        
        _line =[[UIView alloc]initWithFrame:CGRectMake(24*SCALE_W, 80*SCALE_W-1, SYSWidth-40*SCALE_W, 1)];
        _line.backgroundColor =LIGHTGRAYBG;
        [self.contentView addSubview:_line];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    UIBezierPath *path;
    switch (_roundCornerType) {
        case KKRoundCornerCellTypeTop: {
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
            break;
        }
            
        case KKRoundCornerCellTypeBottom: {
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
            break;
        }
            
        case KKRoundCornerCellTypeSingleRow: {
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
            break;
        }
            
        case KKRoundCornerCellTypeDefault:
        default: {
            self.layer.mask = nil;
            return;
        }
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}
@end
