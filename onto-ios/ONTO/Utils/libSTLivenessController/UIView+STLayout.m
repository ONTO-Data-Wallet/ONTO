//
//  UIView+STLayout.m
//
//  Created by sluin on 15/11/15.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import "UIView+STLayout.h"

@implementation UIView (STLayout)

@dynamic stTop;
@dynamic stBottom;
@dynamic stLeft;
@dynamic stRight;

@dynamic stX;
@dynamic stY;
@dynamic stOrigin;

@dynamic stCenterX;
@dynamic stCenterY;

@dynamic stWidth;
@dynamic stHeight;

@dynamic stSize;

- (CGFloat)stTop {
    return self.frame.origin.y;
}

- (void)setStTop:(CGFloat)stTop {
    CGRect frame = self.frame;
    frame.origin.y = stTop;
    self.frame = frame;
}

- (CGFloat)stLeft {
    return self.frame.origin.x;
}

- (void)setStLeft:(CGFloat)stLeft {
    CGRect frame = self.frame;
    frame.origin.x = stLeft;
    self.frame = frame;
}

- (CGFloat)stBottom {
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setStBottom:(CGFloat)stBottom {
    CGRect frame = self.frame;
    frame.origin.y = stBottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)stRight {
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setStRight:(CGFloat)stRight {
    CGRect frame = self.frame;
    frame.origin.x = stRight - frame.size.width;
    self.frame = frame;
}

- (CGFloat)stX {
    return self.frame.origin.x;
}

- (void)setStX:(CGFloat)stX {
    CGRect frame = self.frame;
    frame.origin.x = stX;
    self.frame = frame;
}

- (CGFloat)stY {
    return self.frame.origin.y;
}

- (void)setStY:(CGFloat)stY {
    CGRect frame = self.frame;
    frame.origin.y = stY;
    self.frame = frame;
}

- (CGPoint)stOrigin {
    return self.frame.origin;
}

- (void)setStOrigin:(CGPoint)stOrigin {
    CGRect frame = self.frame;
    frame.origin = stOrigin;
    self.frame = frame;
}

- (CGFloat)stCenterX {
    return self.center.x;
}

- (void)setStCenterX:(CGFloat)stCenterX {
    CGPoint center = self.center;
    center.x = stCenterX;
    self.center = center;
}

- (CGFloat)stCenterY {
    return self.center.y;
}

- (void)setStCenterY:(CGFloat)stCenterY {
    CGPoint center = self.center;
    center.y = stCenterY;
    self.center = center;
}

- (CGFloat)stWidth {
    return self.frame.size.width;
}

- (void)setStWidth:(CGFloat)stWidth {
    CGRect frame = self.frame;
    frame.size.width = stWidth;
    self.frame = frame;
}

- (CGFloat)stHeight {
    return self.frame.size.height;
}

- (void)setStHeight:(CGFloat)stHeight {
    CGRect frame = self.frame;
    frame.size.height = stHeight;
    self.frame = frame;
}

- (CGSize)stSize {
    return self.frame.size;
}

- (void)setStSize:(CGSize)stSize {
    CGRect frame = self.frame;
    frame.size = stSize;
    self.frame = frame;
}

@end
