//
//  ClaimModel.h
//  ONTO
//
//  Created by 赵伟 on 2018/5/3.
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

@interface ClaimModel : NSObject

//@"ClaimId":self.claimId?self.claimId:@"",
//@"ClaimContext":self.claimContext?self.claimContext:@"",

@property(nonatomic,strong) NSNumber *ModelID;
@property(nonatomic,copy) NSString *ClaimContext;
@property(nonatomic,copy) NSString *OwnerOntId;
@property(nonatomic,copy) NSString *Content;
@property(nonatomic,copy) NSString *status;

@end
