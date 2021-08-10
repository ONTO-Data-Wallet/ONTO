//
//  UIView+STLayout.h
//
//  Created by sluin on 15/11/15.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (STLayout)

@property (assign, nonatomic) CGFloat stTop;
@property (assign, nonatomic) CGFloat stBottom;
@property (assign, nonatomic) CGFloat stLeft;
@property (assign, nonatomic) CGFloat stRight;

@property (assign, nonatomic) CGFloat stX;
@property (assign, nonatomic) CGFloat stY;
@property (assign, nonatomic) CGPoint stOrigin;

@property (assign, nonatomic) CGFloat stCenterX;
@property (assign, nonatomic) CGFloat stCenterY;

@property (assign, nonatomic) CGFloat stWidth;
@property (assign, nonatomic) CGFloat stHeight;
@property (assign, nonatomic) CGSize stSize;

@end
