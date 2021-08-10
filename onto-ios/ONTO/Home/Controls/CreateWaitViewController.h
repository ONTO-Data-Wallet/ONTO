//
//  CreateWaitViewController.h
//  ONTO
//
//  Created by 张超 on 2018/3/2.
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

@interface CreateWaitViewController : BaseViewController

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) BOOL isWallet;
@property (nonatomic, assign) BOOL isIdentity;
@property (nonatomic, copy) NSString *passwordHash;

@property (nonatomic, copy) NSString *meninomicStr;
@property (nonatomic, assign) BOOL isFirst;

@end
