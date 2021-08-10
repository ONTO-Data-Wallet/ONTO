//
//  UIButton+EnlargeTouchArea.h
//  LakalaClient
//
//  Created by EDZ on 2017/12/6.
//  Copyright © 2017年 LR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)
//扩大button的点击范围
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

- (void)setEnlargeEdge:(CGFloat) size;

@end
