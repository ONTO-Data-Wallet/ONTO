//
//  LivingSettingGLobalData.h
//  TestSTLivenessController
//
//  Created by huoqiuliang on 16/9/21.
//  Copyright © 2016年 SunLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LivingSettingGLobalData : NSObject

/**动作序列*/
@property (copy, nonatomic) NSString *strSequence;

/**输出类型*/
@property (nonatomic, assign) NSInteger outputType;

/**难易程度*/
@property (nonatomic, assign) NSInteger liveComplexity;

/**提示语音*/
@property (nonatomic, assign) BOOL bVoicePrompt;

+ (LivingSettingGLobalData *)sharedInstanceData;

@end
