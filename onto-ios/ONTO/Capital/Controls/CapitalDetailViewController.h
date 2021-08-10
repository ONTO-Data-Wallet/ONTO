//
//  CapitalDetailViewController.h
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

#import "BaseViewController.h"

@interface CapitalDetailViewController : BaseViewController

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *exchange;
@property (nonatomic, copy) NSString *GoalType;
@property (nonatomic, copy) NSDictionary *walletDict;
@property (nonatomic, copy) NSString *ongAppove;
@property (nonatomic, copy) NSString *ongAmount;
@property (nonatomic, copy) NSString *ontAmount;

@property(nonatomic,copy)NSString*waitboundong;
@end
