//
//  IndentityCell.h
//  ONTO
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

#import <UIKit/UIKit.h>
@class IdentityModel;
@interface IndentityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *certicationTitle;
@property (weak, nonatomic) IBOutlet UIImageView *cerImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (nonatomic, copy) NSArray *imageArr;
@property (nonatomic, copy) NSArray *titleArr;
@property (weak, nonatomic) IBOutlet UIImageView *waitCircle;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)setwithIndex:(NSIndexPath *)indexPath;
- (void)setwithModel:(IdentityModel *)model;

@end
