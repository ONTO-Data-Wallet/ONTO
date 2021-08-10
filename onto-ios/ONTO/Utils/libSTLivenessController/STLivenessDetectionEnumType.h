//
//  STLivenessDetectionEnumType.h
//
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#ifndef STLivenessDetectionEnumType_h
#define STLivenessDetectionEnumType_h
/**
 *活体检测复杂度
 */
typedef NS_ENUM(NSUInteger, STIDLivenessFaceComplexity) {
    /** 简单,活体阈值低 */
    STIDLiveness_COMPLEXITY_EASY,
    /** 一般,活体阈值较低 */
    STIDLiveness_COMPLEXITY_NORMAL,
    /** 较难,活体阈较高 */
    STIDLiveness_COMPLEXITY_HARD,
    /** 困难,活体阈值高 */
    STIDLiveness_COMPLEXITY_HELL
};
/**
 * 检测模块类型
 */
typedef NS_ENUM(NSInteger, STIDLivenessFaceDetectionType) {
    /** 眨眼检测 */
    STIDLiveness_BLINK,
    /** 上下点头检测 */
    STIDLiveness_NOD,
    /** 张嘴检测 */
    STIDLiveness_MOUTH,
    /** 左右转头检测 */
    STIDLiveness_YAW
};

#endif /* STLivenessDetectionEnumType_h */
