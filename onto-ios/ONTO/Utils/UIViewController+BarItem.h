//
//  UIViewController+BarItem.h
//  flow
//
//  Created by 赵弈宇 on 17/2/20.
//  Copyright © 2017年 赵弈宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BarItem)
#pragma mark - UIBarButtonItem instance


/// ======================================== ///
/// @name   生成只带标题的UIBarButtonItem
/// ======================================== ///



/**
 *  生成默认的一个UIBarButtonItem,使用默认颜色,字体等
 *  @param title  标题
 *  @param action 执行的动作
 *
 */
- (UIBarButtonItem * _Nullable)itemWithTitle:(NSString * _Nullable)title
                                      action:(SEL _Nullable)action;

- (UIBarButtonItem * _Nullable)itemWithTitle:(NSString * _Nullable)title
                                 titleInsets:(UIEdgeInsets)titleInsets
                                      action:(SEL _Nullable)action;

/// ========================================
/// @name   生成带图片的UIBarButtonItem
/// ========================================

- (UIBarButtonItem * _Nullable)itemWithImage:(UIImage * _Nullable)image action:(SEL _Nullable)action;


- (UIBarButtonItem * _Nullable)itemWithImage:(UIImage * _Nullable)image
                                 imageInsets:(UIEdgeInsets)imageInsets
                                      action:(SEL _Nullable)action;

/// ========================================
/// @name   生成带标题,图片的UIBarButtonItem
/// ========================================

- (UIBarButtonItem * _Nullable)itemWithTitle:(NSString * _Nullable)title
                                       image:(UIImage * _Nullable)image
                                 titleInsets:(UIEdgeInsets)titleInsets imageInsets:(UIEdgeInsets)imageInsets
                                      action:(SEL _Nullable)action;

- (UIBarButtonItem  * _Nullable)itemWithTitle:( NSString  * _Nullable )title
                                        image:( UIImage  * _Nullable )image titleInsets:(UIEdgeInsets)titleInsets
                        normalTitleAttributes:(NSDictionary * _Nullable)normalTitleAttributes
                     highlightTitleAttributes:(NSDictionary * _Nullable)highlightTitleAttributes
                                  imageInsets:(UIEdgeInsets)imageInsets
                                       action:(SEL _Nullable)action;

#pragma mark - back UIBarButtonItem

/**
 *  生成一个默认返回按钮
 *
 *  @param image  返回按钮图片
 *  @param action 返回按钮动作
 */
- (UIBarButtonItem * _Nullable)backItemWithImage:(UIImage *_Nonnull)image action:(SEL _Nullable)action;

/**
 *  生成一个带有标题,返回图片的返回按钮
 *  默认title颜色whiteColor  高亮颜色RGB(136,136,136)
 *  @param title  返回按钮标题
 *  @param image  返回按钮图片
 *  @param action 按钮动作
 *
 */
- (UIBarButtonItem * _Nullable)backItemWithTitle:(NSString * _Nullable)title
                                           image:(UIImage * _Nonnull)image
                                          action:(SEL _Nullable)action;

/**
 *  配置navigationBar titleView显示一张图片
 *
 *  @param image 显示的图片
 */
- (void)setupNavigationBarWithImage:(UIImage * _Nonnull)image;

- (void)viewBack;
@end
