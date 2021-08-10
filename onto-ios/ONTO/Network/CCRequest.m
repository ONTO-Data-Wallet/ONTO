//
//  CCRequest.m
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

#import "CCRequest.h"
#import "ToastUtil.h"
#import "../Common/Common.h"
#import "NSString+YYAdd.h"
#import "Config.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation CCRequest {
    AFHTTPSessionManager *manager;
}

static CCRequest *shareInstance = nil;
static NSInteger networkStatus = -1;

+ (CCRequest *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[CCRequest alloc] init];
    });
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (shareInstance == nil) {
        shareInstance = [super allocWithZone:zone];
    }
    return shareInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        manager = [[AFHTTPSessionManager manager] init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;
    }
    return self;
}

+ (void)checkNetworkLinkStatus {
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        networkStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                break;
            default:break;
        }
    }];
    [reachability startMonitoring];
}

+ (NSInteger)theNetworkStatus {
    return networkStatus;
}

+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, strlen(cStr), digest); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

- (void)requestWithHMACAuthorization:(NSString *)urlString MethodType:(MethodType)methodType Params:(id)params Success:(CCSuccess)success Failure:(CCFailure)failure {
    
    @try {
        MBProgressHUD *hub = [ToastUtil showMessage:@"" toView:nil];
        
        NSString *requestUrl;
        if ([urlString hasPrefix:@"http"]) {
            requestUrl = urlString;
        } else {
            requestUrl = [BaseURL stringByAppendingString:urlString];
        }
        DebugLog(@"url  %@", requestUrl);
        
        NSMutableDictionary *params_dict = [[NSMutableDictionary alloc] initWithDictionary:params];
        
        // 注意这里options设置为0，因为发现POST函数里面默认也是0，不要用NSJSONWritingPrettyPrinted和NSJSONWritingSortedKeys
        NSData
        *data = [NSJSONSerialization dataWithJSONObject:params_dict options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *base64Hash = [self getHMACSha256String:jsonString Path:urlString Method:methodType];
        
        [manager.requestSerializer setValue:base64Hash forHTTPHeaderField:@"Authorization"];
        [manager.requestSerializer setValue:@"0.8" forHTTPHeaderField:@"Version"];
        [manager.requestSerializer setValue:@"CN" forHTTPHeaderField:@"Language"];
        
        switch (methodType) {
            case MethodTypePOST: {
                [manager POST:requestUrl parameters:params_dict progress:nil
                      success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                          [hub hideAnimated:YES];
                          [self handleResponse:responseObject Success:success Failure:failure];
                      }
                      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                          [hub hideAnimated:YES];
                          [self showError:error Failure:failure];
                      }];
            }
                break;
            case MethodTypeGET: {
                DebugLog(@"%@", params_dict);
                [manager GET:requestUrl parameters:params_dict progress:nil success:^(NSURLSessionDataTask *_Nonnull task,
                                                                                      id _Nullable responseObject) {
                    [hub hideAnimated:YES];
                    [self handleResponse:responseObject Success:success Failure:failure];
                }    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                    [self showError:error Failure:failure];
                    [hub hideAnimated:YES];
                }];
            }
                break;
            default:break;
        }
    }
    @catch (NSException *exception) {
        DebugLog(@"Error: %@", exception);
    }
    @finally {
        
    }
    
}

- (NSString *)getHMACSha256String:(NSString *)data Path:(NSString *)path Method:(MethodType)method {
    // NSTimeInterval is defined as double
    
    NSNumber *timeStampObj = [Common getNowTimeTimestamp];
    NSString *nonce = [Common base64EncodeString:[[NSUUID UUID] UUIDString]];
    
    NSString *requestContentBase64String = @"";
    NSString *methodStr = @"GET";
    if (method != MethodTypeGET) {
        const char *cStr = [data UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, strlen(cStr), digest); // This is the md5 call
        NSData *digestData = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
        requestContentBase64String = [digestData base64EncodedStringWithOptions:0];
        methodStr = @"POST";
    }
    DebugLog(@"Yin requestContentBase64String  %@", requestContentBase64String);
    
    NSString *combineString =
    [NSString stringWithFormat:@"%@%@%@%@%@%@", App_Id, methodStr, path, timeStampObj, nonce, requestContentBase64String];
    DebugLog(@"Yin combineString  %@", combineString);
    
    NSData *saltData = [App_Secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [combineString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    
    NSString *base64EncodingHash = [hash base64Encoding];
    DebugLog(@"Yin hash  %@", base64EncodingHash);
    
    NSString *base64Hash =
    [NSString stringWithFormat:@"ont:%@:%@:%@:%@", App_Id, base64EncodingHash, nonce, timeStampObj];
    return base64Hash;
}

- (void)requestWithURLString:(NSString *)urlString MethodType:(MethodType)methodType Params:(id)params Success:(CCSuccess)success Failure:(CCFailure)failure {
    MBProgressHUD *hub = [ToastUtil showMessage:@"" toView:nil];
    
    NSString *requestUrl;
    NSMutableDictionary *params_dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    if ([urlString hasPrefix:@"http"]) {
        requestUrl = urlString;
    } else {
        requestUrl = [BaseURL stringByAppendingString:urlString];
    }
    
    //消息通知
    if ([urlString isEqualToString:Notice_query]) {
        requestUrl = [requestUrl stringByAppendingString:@"/100/1"];
    }
    
    if ([ENORCN isEqualToString:@"cn"]) {
        [manager.requestSerializer setValue:@"CN" forHTTPHeaderField:@"Language"];
    }else{
        [manager.requestSerializer setValue:@"EN" forHTTPHeaderField:@"Language"];
    }
    DebugLog(@"url  %@", requestUrl);
    switch (methodType) {
        case MethodTypePOST: {
            [manager POST:requestUrl parameters:params_dict progress:nil success:^(NSURLSessionDataTask *_Nonnull task,
                                                                                   id _Nullable responseObject) {
                [hub hideAnimated:YES];
                [self handleResponse:responseObject Success:success Failure:failure];
            }     failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                [hub hideAnimated:YES];
                [self showError:error Failure:failure];
            }];
        }
            break;
        case MethodTypeGET: {
            DebugLog(@"%@", params_dict);
            [manager GET:requestUrl parameters:params_dict progress:nil success:^(NSURLSessionDataTask *_Nonnull task,
                                                                                  id _Nullable responseObject) {
                [hub hideAnimated:YES];
                [self handleResponse:responseObject Success:success Failure:failure];
            }    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                [self showError:error Failure:failure];
                [hub hideAnimated:YES];
            }];
        }
            break;
        default:break;
    }
}

- (void)requestWithURLStringNoLoading:(NSString *)urlString MethodType:(MethodType)methodType Params:(id)params Success:(CCSuccess)success Failure:(CCFailure)failure {
    
    NSString *requestUrl;
    NSMutableDictionary *params_dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    if ([urlString hasPrefix:@"http"] || [urlString hasPrefix:@"https"]) {
        requestUrl = urlString;
    } else {
        requestUrl = [BaseURL stringByAppendingString:urlString];
    }
    if ([ENORCN isEqualToString:@"cn"]) {
        [manager.requestSerializer setValue:@"CN" forHTTPHeaderField:@"Language"];
    }else{
        [manager.requestSerializer setValue:@"EN" forHTTPHeaderField:@"Language"];
    }
    DebugLog(@"url  %@", requestUrl);
    switch (methodType) {
        case MethodTypePOST: {
            [manager POST:requestUrl parameters:params_dict progress:nil success:^(NSURLSessionDataTask *_Nonnull task,
                                                                                   id _Nullable responseObject) {
                [self handleResponse:responseObject Success:success Failure:failure];
            }     failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                failure(nil, @"fail", @"fail");
                
                //                [self showError:error DataTask:task Failure:failure];
                
            }];
        }
            break;
        case MethodTypeGET: {
            [manager GET:requestUrl parameters:params_dict progress:nil success:^(NSURLSessionDataTask *_Nonnull task,
                                                                                  id _Nullable responseObject) {
                [self handleResponse:responseObject Success:success Failure:failure];
            }    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                [self showError:error Failure:failure];
            }];
        }
            break;
        default:break;
    }
}

- (void)requestWithURLString1:(NSString *)urlString MethodType:(MethodType)methodType Params:(id)params Success:(CCSuccess)success Failure:(CCFailure)failure {
    
    NSString *requestUrl;
    NSMutableDictionary *params_dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    if ([urlString hasPrefix:@"http"]) {
        requestUrl = urlString;
    } else {
        requestUrl = [BaseURL stringByAppendingString:urlString];
    }
    
    if ([urlString hasPrefix:Get_Blance]) {
        requestUrl = [CapitalURL stringByAppendingString:urlString];
        
    }
    if ([ENORCN isEqualToString:@"cn"]) {
        [manager.requestSerializer setValue:@"CN" forHTTPHeaderField:@"Language"];
    }else{
        [manager.requestSerializer setValue:@"EN" forHTTPHeaderField:@"Language"];
    }
//    [manager.operationQueue cancelAllOperations];
    DebugLog(@"url==  %@", requestUrl);
    switch (methodType) {
        case MethodTypePOST: {
            [manager POST:requestUrl parameters:params_dict progress:nil success:^(NSURLSessionDataTask *_Nonnull task,
                                                                                   id _Nullable responseObject) {
                [self handleResponse:responseObject Success:success Failure:failure];
            }     failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                failure(nil, @"fail", @"fail");
                
            }];
        }
            break;
        case MethodTypeGET: {
            DebugLog(@"%@", params_dict);
            [manager GET:requestUrl parameters:params_dict progress:nil success:^(NSURLSessionDataTask *_Nonnull task,
                                                                                  id _Nullable responseObject) {
                [self handleResponse:responseObject Success:success Failure:failure];
            }    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                failure(nil, @"fail", @"fail");
            }];
        }
            break;
        default:break;
    }
}

- (void)handleResponse:(id)responseObject
               Success:(CCSuccess)success
               Failure:(CCFailure)failure {
    
    if ([[responseObject valueForKey:@"Error"] integerValue] > 0) {
        failure(nil, [responseObject valueForKey:@"Desc"], responseObject);
    } else {
        success([responseObject valueForKey:@"Result"], responseObject);
    }
}

- (id)showError:(NSError *)error
        Failure:(CCFailure)failure {
    NSDictionary *responseDic = nil;
    @try {
        if ([error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]) {
            responseDic = [NSJSONSerialization                                 JSONObjectWithData:[error
                                                                                                   .userInfo valueForKey:@"com.alamofire.serialization.response.error.data"] options:kNilOptions error:nil];
            failure(nil, [responseDic valueForKey:@"error"], responseDic);
        } else {
            failure(nil, error.userInfo[NSLocalizedDescriptionKey], nil);
            return nil;
        }
    } @catch (NSException *exception) {
        failure(nil, @"Net Error", nil);
        return nil;
    }
    return nil;
}

@end
