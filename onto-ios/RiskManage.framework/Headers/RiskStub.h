//
//  RiskManage.h
//  RiskManageSDK
//
//  Created by yanbf on 2016/12/29.
//  Copyright © 2016 yanbf. All rights reserved.
//
#undef DEBUG
#import <Foundation/Foundation.h>

#pragma mark - ModularType
typedef enum{
    UDID,
    DEVINFO,
    APKINFO,
    CRASH,
    EMULATOR,
    LOCATION,
    ROOT,
    HOST_FRAUD,
    DEVICES_REUSE,
    INJECT,
    DEBUG,
    GAME_PLUGIN,
    SPEED,ENV_CHECK,
    GYROSCOPE,
}Type;

typedef void (^CallBack)(NSDictionary *dictionary,Type modularType);

@interface RiskStub : NSObject

@property (nonatomic, copy) CallBack modularDataBlock;

/**
 Everisk init,会进行一些耗时操作建议在didFinishLaunchingWithOptions异步加载。
 
 @param key secret key
 */
+ (void)initBangcleEverisk:(NSString *)key;

/**
 registerService
 
 @param listener block
 */
+ (void)registerServiceWithDataBlock:(CallBack)listener;

/**
 addExtraUserData
 
 @param key string
 @param value string
 @return BOOL
 */
+ (BOOL)addExtraUserData:(NSString *)key withUserDatavalue:(NSString *)value;

/**
 Get the device's UDID directly
 */
+ (NSString *)getEveriskUdid;

/**
 RiskStub manager singleton
 
 @return RiskStub
 */
+ (RiskStub *)sharedManager;

@end
