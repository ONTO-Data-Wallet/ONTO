//
//  IDCardCell.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/22.
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

#import "IDCardCell.h"
#import "UIView+Scale.h"
@implementation IDCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_iconImage scaleFrameBaseWidth];
    [_nameLabel scaleFrameBaseWidth];
    [_dataLabel scaleFrameBaseWidth];
    [_selectImage scaleFrameBaseWidth];
    [_JTIMage scaleFrameBaseWidth];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

 - (void)setFrame:(CGRect)frame{
    
         CGRect f = frame;
         f.origin.x = 10;
         f.size.width = frame.size.width - 20;
         [super setFrame:f];
}


@end
