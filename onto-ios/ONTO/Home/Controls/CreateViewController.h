//
//  CreateViewController.h
//  ONTO
//
//  Created by Zeus.Zhang on 2018/2/7.
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

@interface CreateViewController : BaseViewController

@property (nonatomic, assign) BOOL isWallet; //创建钱包
@property (nonatomic, assign) BOOL isIdentity; //创建身份
@end

