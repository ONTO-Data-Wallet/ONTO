//
//  DealCell.h
//  ONTO
//
//  Created by 赵伟 on 2018/3/24.
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
#import "TradeModel.h"

@interface DealCell : UITableViewCell

@property (nonatomic, strong) TradeModel *model;
@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (nonatomic,assign) BOOL isONG;
@end


