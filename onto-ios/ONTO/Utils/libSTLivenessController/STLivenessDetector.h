//
//  STLivenessDetector.h
//  STLivenessDetector
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "STLivenessDetectorDelegate.h"
#import "STLivenessFaceEnumType.h"
extern NSTimeInterval const kSenseIdLivenessDefaultTimeOutDuration;
extern CGFloat const kSenseIdLivenessDefaultHacknessThresholdScore;
@interface STLivenessDetector : NSObject

/**
 *  设置活体对准阶段是否进行眉毛的遮挡检测 , 不设置时默认为NO;
 */

@property (assign, nonatomic) BOOL isBrowOcclusion;

/**
 *  初始化方法
 *  @param modelPathStr          模型资源 SenseID_Composite_General_Liveness.model的路径
 *  @param financeLicensePathStr SenseID_Liveness_Interactive.lic的路径.
 *  @param apiKeyStr             公有云用户分配一个api key
 *  @param apiSecretStr          公有云用户分配一个api secret
 *  @param delegate              回调代理
 *  @param detectionArr          动作序列, 如@[@(STIDLiveness_BLINK) ,@(STIDLiveness_MOUTH) ,@(STIDLiveness_NOD)
 * ,@(STIDLiveness_YAW)] , 参照STLivenessFaceEnumType.h
 *  @param isTracker             开始检测前是否有对准, YES有对准，NO无对准
 *  @return 活体检测器实例
 */

- (instancetype)initWithModelPath:(NSString *)modelPathStr
               financeLicensePath:(NSString *)financeLicensePathStr
                           apiKey:(NSString *)apiKeyStr
                        apiSecret:(NSString *)apiSecretStr
                      setDelegate:(id<STLivenessDetectorDelegate>)delegate
                detectionSequence:(NSArray *)detectionArr
                        isTracker:(BOOL)isTracker;

/**
 *  人脸对准目标框
 *  @param point               人脸对准目标框（圆的）的的中心点的X和Y,默认值  CGPointMake([UIScreen
 * mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0)
 *  @param radius              人脸对准目标框（圆的）的半径，默认值 [UIScreen mainScreen].bounds.size.width/2.5;
 *  @param previewframe        视频预览框的frame
 */
- (void)setPrepareCenterPoint:(CGPoint)point prepareRadius:(CGFloat)radius previewframe:(CGRect)previewframe;

/**
 *  每个模块允许的最大检测时间
 *
 *  @param duration           每个模块允许的最大检测时间,等于0时为不设置超时时间,默认为10s,单位是s
 */

- (void)setTimeOutDuration:(NSTimeInterval)duration;

/**
 *  获取每个模块允许的最大检测时间
 *
 *  @return                   检测时间，单位是s
 */
- (NSTimeInterval)timeOutDuration;

/**
 *  活体检测器的难易度
 *
 *  @param complexity         活体检测的复杂度, 默认为 LIVE_COMPLEXITY_NORMAL
 */

- (void)setComplexity:(STIDLivenessFaceComplexity)complexity;

/**
 *  活体检测的阈值
 *
 *  @param score              活体检测的阈值默认为0.99，取值范围 0 < score <= 1
 */

- (void)setHacknessThresholdScore:(CGFloat)score;

/**
 *  对连续输入帧进行人脸跟踪及活体检测
 *
 *  @param sampleBuffer        每一帧的图像数据
 *  @param faceOrientation     人脸的朝向
 *  @param isVideoMirrored     是否镜像
 */
- (void)trackAndDetectWithCMSampleBuffer:(CMSampleBufferRef)sampleBuffer
                          faceOrientaion:(STIDLivenessFaceOrientaion)faceOrientation
                         isVideoMirrored:(BOOL)isVideoMirrored;

/**
 *  开始检测
 */

- (void)startDetection;

/**
 *  取消检测
 */

- (void)cancelDetection;

/**
 *  获取SDK版本
 *
 *  @return                     SDK版本
 */

+ (NSString *)getVersion;

@end
