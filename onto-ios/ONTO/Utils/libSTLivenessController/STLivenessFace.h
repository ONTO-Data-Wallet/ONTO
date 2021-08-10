//
//  STIDLivenessFace.h
//  STCommonBase
//
//  Created by huoqiuliang on 2018/3/15.
//  Copyright © 2018年 sensetime. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, STIDLivenessOcclusionStatus) {
    /**
     * 遮挡未知
     */
    STIDLiveness_UNKNOW = 0,

    /**
     * 未遮挡
     */
    STIDLiveness_NORMAL,

    /**
     * 遮挡
     */
    STIDLiveness_OCCLUSION,
};

@interface STLivenessFace : NSObject
/**
 *  人脸是否遮挡
 */
@property (assign, nonatomic) BOOL isFaceOcclusion;
/**
 *  对准阶段，眉毛的遮挡状态
 */
@property (assign, nonatomic) STIDLivenessOcclusionStatus browOcclusionStatus;
/**
 *  对准阶段，眼睛的遮挡状态
 */

@property (assign, nonatomic) STIDLivenessOcclusionStatus eyeOcclusionStatus;

/**
 *  对准阶段，鼻子的遮挡状态
 */
@property (assign, nonatomic) STIDLivenessOcclusionStatus noseOcclusionStatus;

/**
 *  对准阶段，嘴巴的遮挡状态
 */

@property (assign, nonatomic) STIDLivenessOcclusionStatus mouthOcclusionStatus;

@end
