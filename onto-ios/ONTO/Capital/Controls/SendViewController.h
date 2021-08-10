//
//  SendViewController.h
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

@interface SendViewController : BaseViewController
@property (nonatomic,copy) NSString *walletAddr;
@property (nonatomic,copy) NSString *amount;

@property (nonatomic,assign) BOOL isOng;
@property (nonatomic,copy) NSString *ongAmount;
@property (nonatomic,assign) BOOL isShareWallet;
@property (nonatomic,assign) BOOL isPum;
@property (nonatomic,assign) BOOL isDragon;
@property (nonatomic,assign) BOOL isOEP4;
@property (nonatomic,copy) NSString *pumType;
@property (nonatomic,copy) NSString *dragonId;

@property (nonatomic,strong) NSDictionary *tokenDict;
@end
