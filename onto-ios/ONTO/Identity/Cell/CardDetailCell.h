//
//  CardDetailCell.h
//  ONTO
//
//  Created by 赵伟 on 2018/3/26.
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
@class CardModel;
@interface CardDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rihgtImage;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel1;
@property (weak, nonatomic) IBOutlet UILabel *subLabel2;
@property (weak, nonatomic) IBOutlet UILabel *subLabel3;
@property (weak, nonatomic) IBOutlet UILabel *trustLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dagouImage;

- (void)configWithModel:(NSDictionary*)dic;
@end
