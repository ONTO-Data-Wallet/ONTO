//
//  STLivenessController.h
//  STLivenessController
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "STLivenessDetectorDelegate.h"
@class STLivenessDetector;
@protocol STLivenessControllerDelegate <NSObject>

- (void)livenessControllerDeveiceError:(STIDLivenessDeveiceError)deveiceError;

@end

@interface STLivenessController : UIViewController

/**
 *  设置语音提示默认是否开启 , 不设置时默认为YES即开启;
 */

@property (assign, nonatomic) BOOL isVoicePrompt;

@property (strong, nonatomic) STLivenessDetector *detector;



/**
 *  初始化方法
 *  @param apiKeyStr             公有云用户分配一个api key
 *  @param apiSecretStr          公有云用户分配一个api secret
 *  @param delegate              回调代理
 *  @param detectionArr          动作序列, 如@[@(STIDLiveness_BLINK) ,@(STIDLiveness_MOUTH) ,@(STIDLiveness_NOD)
 * ,@(STIDLiveness_YAW)] , 参照 STLivenessFaceEnumType.h
 *
 *  @return 活体检测器实例
 */

- (instancetype)initWithApiKey:(NSString *)apiKeyStr
                     apiSecret:(NSString *)apiSecretStr
                   setDelegate:(id<STLivenessDetectorDelegate, STLivenessControllerDelegate>)delegate
             detectionSequence:(NSArray *)detectionArr;



@end
