//
//  AssetCell.h
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
#import "BaseBorderCell.h"

@interface AssetCell : BaseBorderCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weizhi;

- (void)fillData:(NSString *)name amount:(NSString *)amount type:(NSString *)type tokenArray:(NSMutableArray *)tokenArray;

@end
