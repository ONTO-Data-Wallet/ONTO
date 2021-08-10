//
//  STLivenessImage.h
//  STCommonBase
//
//  Created by huoqiuliang on 2018/3/15.
//  Copyright © 2018年 sensetime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface STLivenessImage : NSObject

/**
 *  图片
 */
@property (strong, nonatomic) UIImage *image;

/**
 *  图片在动作序列中的位置, 0为第一个
 */
@property (assign, nonatomic) NSInteger index;

@end
