//
//  UIView+Banner.h
//  VIPStudent
//
//  Created by Wen xu on 2018/3/2.
//  Copyright © 2018年 VIPractice. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (Banner)

/**  起点x坐标  */
@property (nonatomic, assign) CGFloat x;
/**  起点y坐标  */
@property (nonatomic, assign) CGFloat y;
/**  中心点x坐标  */
@property (nonatomic, assign) CGFloat centerX;
/**  中心点y坐标  */
@property (nonatomic, assign) CGFloat centerY;
/**  宽度  */
@property (nonatomic, assign) CGFloat width;
/**  高度  */
@property (nonatomic, assign) CGFloat height;
/**  顶部  */
@property (nonatomic, assign) CGFloat top;
/**  底部  */
@property (nonatomic, assign) CGFloat bottom;
/**  左边  */
@property (nonatomic, assign) CGFloat left;
/**  右边  */
@property (nonatomic, assign) CGFloat right;
/**  size  */
@property (nonatomic, assign) CGSize size;
/**  origin */
@property (nonatomic, assign) CGPoint origin;


/**
 快速给View添加4边阴影
 参数:阴影透明度，默认0
 */
- (void)addProjectionWithShadowOpacity:(CGFloat)shadowOpacity;

/**
 快速给View添加4边框
 参数:边框宽度
 */
- (void)addBorderWithWidth:(CGFloat)width;

/**
 快速给View添加4边框
 width:边框宽度
 borderColor:边框颜色
 */
- (void)addBorderWithWidth:(CGFloat)width borderColor:(UIColor *)borderColor;

/**
 快速给View添加圆角
 参数:圆角半径
 */
- (void)addRoundedCornersWithRadius:(CGFloat)radius;

/**
 快速给View添加圆角
 radius:圆角半径
 corners:且那几个角
 类型共有以下几种:
 typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
 UIRectCornerTopLeft,
 UIRectCornerTopRight ,
 UIRectCornerBottomLeft,
 UIRectCornerBottomRight,
 UIRectCornerAllCorners
 };
 */
- (void)addRoundedCornersWithRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;

/**
 *  自动从xib创建视图
 */
+(instancetype)viewFromXIB;

@end
