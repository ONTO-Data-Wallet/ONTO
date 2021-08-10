//
//  STLivenessRect.h
//  STCommonBase
//
//  Created by huoqiuliang on 2018/3/15.
//  Copyright © 2018年 sensetime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STLivenessRect : NSObject
/**
 *  相对于原图,人脸框最左边的坐标
 */
@property (nonatomic, assign) NSInteger left;

/**
 *  相对于原图,人脸框最上边的坐标
 */
@property (nonatomic, assign) NSInteger top;

/**
 *  相对于原图,人脸框最右边的坐标
 */
@property (nonatomic, assign) NSInteger right;

/**
 *  相对于原图,人脸框最下边的坐标
 */
@property (nonatomic, assign) NSInteger bottom;

@end
