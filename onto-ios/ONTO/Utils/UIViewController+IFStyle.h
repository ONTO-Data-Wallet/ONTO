//
//  UIViewController+IFStyle.h
//  flow
//
//  Created by 赵弈宇 on 17/2/20.
//  Copyright © 2017年 赵弈宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BarItem.h"
#import <objc/runtime.h>
@interface UIViewController (IFStyle)
@property (strong,nonatomic) UIViewController* vc;
@property(nonatomic,strong,readonly)UINavigationController *myNavigationController;

- (void)setupControllerWithTitle:(NSString *)title;

- (void)setupControllerWithTitle:(NSString *)title backTitle:(NSString *)backTitle;

- (void)setupControllerWithTitle:(NSString *)title showBack:(BOOL)showBack;

- (void)setupControllerWithTitle:(NSString *)title showBack:(BOOL)showBack andVC:(UIViewController*)vc;

- (UIViewController *)pushVCWithName:(NSString *)name params:(NSDictionary *)params animated:(BOOL)animated;

- (UIViewController *)presentVCWithName:(NSString *)name params:(NSDictionary *)params animated:(BOOL)animated inNavigationController:(BOOL)inNavigationController;


+ (void)setupNavigationBarStyle;

@end
