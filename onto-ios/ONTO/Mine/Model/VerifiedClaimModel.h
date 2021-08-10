//
//  VerifiedClaimModel.h
//  ONTO
//
//  Created by 赵伟 on 2018/3/14.
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

@interface VerifiedClaimModel : NSObject

@property (nonatomic, copy)NSString *ClaimId;
@property (nonatomic, assign)NSInteger CreateTime;
@property (nonatomic, copy)NSString *Description;
@property (nonatomic, copy)NSString *IssuerName;
@property (nonatomic, copy)NSNumber *Status;
@property (nonatomic, copy)NSString *TxnId;
@property (nonatomic, copy)NSString *ClaimContext;

@end

//ClaimId = e5bfa81e9e933efc5e1d93dc8a56abd4144f2747544e03e532f9f1458cf75f1f;
//CreateTime = "2018-03-15 14:42:24";
//Desc = "EID Authentication";
//IssuerName = onchain;
//Status = 2;
//TxnId = "";

