//
//  WebIdentityViewController.h
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

#import "BaseViewController.h"
typedef enum {
    
    TwitterType = 0,
    LinkedinType = 1,
    GithubType = 2,
    FacebookType = 3
    
} IdentityType;
@interface WebIdentityViewController : BaseViewController
@property (nonatomic, assign) IdentityType identityType; // 类型
@property (nonatomic, copy ) NSString *transaction;//交易详情
@property (nonatomic, copy ) NSString *address;//
@property (nonatomic, copy ) NSString *knowMoreUrl;//了解更多
@property (nonatomic, copy ) NSString *identitycard;//什么事IDCard
@property (nonatomic, copy ) NSString *proction;//用户条款
@property (nonatomic, copy ) NSString *usersprivacy;//ont如何保护用户资产
@property (nonatomic, copy ) NSString *verifyUrl;//ont如何保护用户资产
@property (nonatomic, copy ) NSString *introduce;//介绍
@property (nonatomic, copy ) NSString *claimurl;//媒体
@property (nonatomic, copy ) NSString *helpCentre;//帮助中心
@property (nonatomic, copy ) NSString *claimImage;//logo

@end
