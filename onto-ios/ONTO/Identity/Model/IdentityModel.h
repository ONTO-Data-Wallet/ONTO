//
//  IdentityModel.h
//  ONTO
//
//  Created by 赵伟 on 2018/3/13.
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

#import <Foundation/Foundation.h>
@class ChargeModel;
@interface IdentityModel : NSObject

@property (nonatomic,copy) NSString *ClaimContext;
@property (nonatomic, copy) NSString *HeadLogo;
@property (nonatomic,copy) NSString *Type;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *Logo;
@property (nonatomic,copy) NSString *Description;
@property (nonatomic,copy) NSString *H5ReqParam;


@property (nonatomic,copy) NSNumber *IssuedFlag;
@property (nonatomic,copy) NSNumber *IsComing;

@property (nonatomic,strong) ChargeModel *ChargeInfo;
//{
//    ClaimContext = "claim:twitter_authentication";
//    Description = "Twitter is a web site for an American social network and microblog service";
//    IssuedFlag = 0;
//    Name = "Twitter Certification";
//    Type = "Social Media Certification";
//}
@end
