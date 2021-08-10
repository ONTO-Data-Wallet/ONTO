//
//  STLivenessDetectorDelegate.h
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STLivenessEnumTypeHeader.h"
#import "STLivenessFaceEnumType.h"
#import "STLivenessDetectionEnumType.h"
#import "STLivenessImage.h"
#import "STLivenessFace.h"

/**
 *  活体检测器代理
 */
@protocol STLivenessDetectorDelegate <NSObject>

@required

/**
 *  活体检测成功回调
 *
 *  @param protobufId         回传加密后的二进制数据在公有云的id
 *  @param protobufData       回传加密后的二进制数据
 *  @param requestId          网络请求的id
 *  @param imageArr           根据指定输出方案回传 STImage 数组 , STImage属性见 STImage.h
 */
- (void)livenessDidSuccessfulGetProtobufId:(NSString *)protobufId
                              protobufData:(NSData *)protobufData
                                 requestId:(NSString *)requestId
                                    images:(NSArray *)imageArr;

/**
 *  活体检测失败回调
 *
 *  @param livenessResult    运行结果STIDLivenessResult
 *  @param faceError         活体检测失败类型
 *  @param protobufData      回传加密后的二进制数据
 *  @param requestId         网络请求的id
 *  @param imageArr          根据指定输出方案回传 STImage 数组 , STImage属性见 STImage.h
 */
- (void)livenessDidFailWithLivenessResult:(STIDLivenessResult)livenessResult
                                faceError:(STIDLivenessFaceError)faceError
                             protobufData:(NSData *)protobufData
                                requestId:(NSString *)requestId
                                   images:(NSArray *)imageArr;
/**
 *  活体开始在线验证的回调
 */
@optional
- (void)livenessOnlineBegin;

/**
 *  活体检测被取消的回调
 */

- (void)livenessDidCancel;

@optional

/**
 *  每个检测模块开始的回调方法
 *
 *  @param detectionType       当前开始检测的模块类型
 *  @param detectionIndex      当前开始检测的模块在动作序列中的位置, 从0开始.
 */

- (void)livenessDidStartDetectionWithDetectionType:(STIDLivenessFaceDetectionType)detectionType
                                    detectionIndex:(NSInteger)detectionIndex;

/**
 *  每一帧数据回调一次,回调当前模块已用时间及当前模块允许的最大处理时间.
 *
 *  @param past                当前模块检测已用时间
 *  @param duration            当前模块检测总时间
 */

- (void)livenessTimeDidPast:(CGFloat)past duration:(CGFloat)duration;

/**
 *  人脸对准的回调
 *  @param distanceStatus       人脸的远近
 *  @param boundStatus          人脸的位置
 *  @param faceModel            回传STLivenessFace对象,STLivenessFace属性见 STLivenessFace.h
 */

- (void)livenessTrackerDistanceStatus:(STIDLivenessFaceDistanceStatus)distanceStatus
                          boundStatus:(STIDLivenessFaceBoundStatus)boundStatus
                            faceModel:(STLivenessFace *)faceModel;

/**
 *  人脸对准成功的回调
 */

- (void)livenessTrackerSuccessed;

/**
 *  每一帧数据回调一次,返回每帧人脸框位置信息
 *
 *  @param rect                 返回每帧人脸框在屏幕上的位置信息
 */

- (void)livenessFaceRect:(CGRect)rect;

/**
 * 帧率
 */

- (void)videoFrameRate:(NSInteger)rate;

@end
