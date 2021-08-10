//
//  LivingSettingGLobalData.m
//  TestSTLivenessController
//
//  Created by huoqiuliang on 16/9/21.
//  Copyright © 2016年 SunLin. All rights reserved.
//

#import "LivingSettingGLobalData.h"
#define k_strSequence @"strSequence"
#define k_outputType @"outputType"
#define k_liveComplexity @"liveComplexity"
#define k_bVoicePrompt @"bVoicePrompt"

@interface LivingSettingGLobalData ()

@property (nonatomic, strong) NSUserDefaults *userDefault;

@end
@implementation LivingSettingGLobalData

@synthesize strSequence = _strSequence, outputType = _outputType, liveComplexity = _liveComplexity,
            bVoicePrompt = _bVoicePrompt;

- (NSUserDefaults *)userDefault {
    if (!_userDefault) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return _userDefault;
}

static LivingSettingGLobalData *gloableData = nil;
+ (LivingSettingGLobalData *)sharedInstanceData {
    @synchronized(self) {
        if (gloableData == nil) {
            gloableData = [[LivingSettingGLobalData alloc] init];
        }
    }
    return gloableData;
}

// ------动作序列

- (NSString *)strSequence {
    _strSequence = [self.userDefault objectForKey:k_strSequence];
    return _strSequence;
}

- (void)setStrSequence:(NSString *)strSequence {
    [self.userDefault setObject:strSequence forKey:k_strSequence];
    [self.userDefault synchronize];
}

// ------输出类型

- (NSInteger)outputType {
    _outputType = [self.userDefault integerForKey:k_outputType];
    return _outputType;
}

- (void)setOutputType:(NSInteger)outputType {
    [self.userDefault setInteger:outputType forKey:k_outputType];
    [self.userDefault synchronize];
}

// ------难易程度

- (NSInteger)liveComplexity {
    _liveComplexity = [self.userDefault integerForKey:k_liveComplexity];
    return _liveComplexity;
}

- (void)setLiveComplexity:(NSInteger)liveComplexity {
    [self.userDefault setInteger:liveComplexity forKey:k_liveComplexity];
    [self.userDefault synchronize];
}

// ------提示语音

- (BOOL)bVoicePrompt {
    _bVoicePrompt = [self.userDefault boolForKey:k_bVoicePrompt];
    return _bVoicePrompt;
}

- (void)setBVoicePrompt:(BOOL)bVoicePrompt {
    [self.userDefault setBool:bVoicePrompt forKey:k_bVoicePrompt];
    [self.userDefault synchronize];
}
@end
