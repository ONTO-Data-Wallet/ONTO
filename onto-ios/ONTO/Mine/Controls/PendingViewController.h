//
//  PendingViewController.h
//  ONTO
//
//  Created by 赵伟 on 2018/3/10.
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
typedef enum {

    PendingType = 0,
    HistroryType = 1,
    ALLType = 2

} VerfiedClaimType;
typedef void (^ReturnValueBlock)(void);
@interface PendingViewController : BaseViewController

@property (nonatomic, assign) VerfiedClaimType verfiedClaimType; // 类型
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;

@end

