//
//  AssetRightCell.h
//  ONTO
//
//  Created by 张超 on 2018/3/24.
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

#import <UIKit/UIKit.h>

@interface AssetRightCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleL;
//@property (nonatomic, assign) BOOL smallImage;

- (void)fillImage:(NSString *)imageStr Title:(NSString *)title Small:(BOOL)isSmall;

@end
