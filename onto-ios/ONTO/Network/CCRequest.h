//
//  CCRequest.h
//  ONTO
//
//  Created by Zeus.Zhang on 2018/1/31.
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
#import "Api.h"
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, MethodType) {
    MethodTypePOST,
    MethodTypeGET,
};

typedef void(^CCSuccess)(id responseObject, id responseOriginal);

typedef void(^CCFailure)(NSError *error, NSString *errorDesc, id responseOriginal);

typedef void(^CCProgress)(NSProgress *progress);

@interface CCRequest : NSObject

+ (CCRequest *)shareInstance;

+ (void)checkNetworkLinkStatus;

+ (NSInteger)theNetworkStatus;

- (void)requestWithURLString:(NSString *)urlString
                  MethodType:(MethodType)methodType
                      Params:(id)params
                     Success:(CCSuccess)success
                     Failure:(CCFailure)failure;

- (void)requestWithHMACAuthorization:(NSString *)urlString
                          MethodType:(MethodType)methodType
                              Params:(id)params
                             Success:(CCSuccess)success
                             Failure:(CCFailure)failure;

//有加载提示
- (void)requestWithURLStringNoLoading:(NSString *)urlString MethodType:(MethodType)methodType Params:(id)params Success:(CCSuccess)success Failure:(CCFailure)failure;

//资产接口
- (void)requestWithURLString1:(NSString *)urlString
                   MethodType:(MethodType)methodType
                       Params:(id)params
                      Success:(CCSuccess)success
                      Failure:(CCFailure)failure;

@end
