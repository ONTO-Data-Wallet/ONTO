//
//  UIViewController+BarItem.m
//  flow
//
//  Created by 赵弈宇 on 17/2/20.
//  Copyright © 2017年 赵弈宇. All rights reserved.
//

#import "UIViewController+BarItem.h"
#import <objc/runtime.h>

#define kXMNBarItemNormalAttributes @{NSForegroundColorAttributeName:[UIColor whiteColor]}
#define kXMNBarItemHighlightAttributes @{NSForegroundColorAttributeName:[UIColor whiteColor]}
@implementation UIViewController (BarItem)
#pragma mark - UIBarButtonItem instance

/// ========================================
/// @name   生成带标题的UIBarButtonItem
/// ========================================


- (UIBarButtonItem * _Nullable)itemWithTitle:(NSString * _Nullable)title action:(SEL _Nullable)action {
    return [self itemWithTitle:title titleInsets:UIEdgeInsetsZero action:action];
}

- (UIBarButtonItem * _Nullable)itemWithTitle:(NSString * _Nullable)title titleInsets:(UIEdgeInsets)titleInsets action:(SEL _Nullable)action {
    return [self itemWithTitle:title image:nil titleInsets:titleInsets imageInsets:UIEdgeInsetsZero action:action];
}


/// ========================================
/// @name   生成带图片的UIBarButtonItem
/// ========================================


- (UIBarButtonItem * _Nullable)itemWithImage:(UIImage * _Nullable)image action:(SEL _Nullable)action{
    return [self itemWithImage:image imageInsets:UIEdgeInsetsZero action:action];
}

- (UIBarButtonItem * _Nullable)itemWithImage:(UIImage * _Nullable)image imageInsets:(UIEdgeInsets)imageInsets action:(SEL _Nullable)action {
    return [self itemWithTitle:nil image:image titleInsets:UIEdgeInsetsZero imageInsets:imageInsets action:action];
}

/// ========================================
/// @name   生成带图片,标题的UIBarButtonItem
/// ========================================

- (UIBarButtonItem * _Nullable)itemWithTitle:(NSString * _Nullable)title image:(UIImage * _Nullable)image titleInsets:(UIEdgeInsets)titleInsets imageInsets:(UIEdgeInsets)imageInsets action:(SEL _Nullable)action {
    return [self itemWithTitle:title image:image titleInsets:titleInsets normalTitleAttributes:nil highlightTitleAttributes:nil imageInsets:imageInsets action:action];
}

static NSString *kXMNButtonAction;

- (UIBarButtonItem  * _Nullable)itemWithTitle:( NSString  * _Nullable )title image:( UIImage  * _Nullable )image titleInsets:(UIEdgeInsets)titleInsets normalTitleAttributes:(NSDictionary * _Nullable)normalTitleAttributes highlightTitleAttributes:(NSDictionary * _Nullable)highlightTitleAttributes imageInsets:(UIEdgeInsets)imageInsets action:(SEL _Nullable)action {
    
    if (title && !image) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
        [item setTitlePositionAdjustment:UIOffsetMake(titleInsets.left, titleInsets.top) forBarMetrics:UIBarMetricsDefault];
        normalTitleAttributes ? [item setTitleTextAttributes:normalTitleAttributes forState:UIControlStateNormal] : kXMNBarItemNormalAttributes;
        highlightTitleAttributes ? [item setTitleTextAttributes:highlightTitleAttributes forState:UIControlStateHighlighted] : kXMNBarItemHighlightAttributes;
        highlightTitleAttributes ? [item setTitleTextAttributes:highlightTitleAttributes forState:UIControlStateSelected] : kXMNBarItemHighlightAttributes;
        [item setTintColor:kXMNBarItemNormalAttributes[NSForegroundColorAttributeName]];
        return item;
    }else if (image != nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        [button setImageEdgeInsets:imageInsets];
        if (title) {
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleEdgeInsets:titleInsets];
            [button setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:normalTitleAttributes] forState:UIControlStateNormal];
            [button setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:highlightTitleAttributes] forState:UIControlStateSelected];
            [button setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:highlightTitleAttributes] forState:UIControlStateHighlighted];
        }
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        objc_setAssociatedObject(button, &kXMNButtonAction, NSStringFromSelector(action), OBJC_ASSOCIATION_COPY_NONATOMIC);
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        return item;
    }
    return nil;
}

- (void)btnTouchUp:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 5;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        // UIControlEventTouchUpOutside
    } else {
        // UIControlEventTouchUpInside
        NSString *actionString = objc_getAssociatedObject(sender, &kXMNButtonAction);
        if (actionString) {
            _Pragma("clang diagnostic push")
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
            [self performSelector:NSSelectorFromString(actionString) withObject:sender];
            _Pragma("clang diagnostic pop")
        }
        
    }
}

- (UIBarButtonItem * _Nullable)backItemWithImage:(UIImage *_Nonnull)image action:(SEL _Nullable)action {
    /**
     *  不传入nil,传入@""可以解决按钮左侧无法点击bug
     */
    return [self backItemWithTitle:@"      " image:image action:action];
}


- (UIBarButtonItem * _Nullable)backItemWithTitle:(NSString * _Nullable)title image:(UIImage * _Nonnull)image action:(SEL _Nullable)action {
    
    return [self itemWithTitle:title image:image titleInsets:UIEdgeInsetsMake(0, 0, 0, -4) normalTitleAttributes:kXMNBarItemNormalAttributes highlightTitleAttributes:kXMNBarItemHighlightAttributes imageInsets:UIEdgeInsetsMake(0, -8, 0, -5) action:action];
}

- (void)setupNavigationBarWithImage:(UIImage * _Nonnull)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView sizeToFit];
    self.navigationItem.titleView = imageView;
}

- (void)viewBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
