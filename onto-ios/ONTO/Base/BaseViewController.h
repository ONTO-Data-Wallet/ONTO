//
//  BaseViewController.h
//  link2svc_2d_mobile_ios
//
//  Created by Zeus.Zhang on 2017/10/11.
/*
 * **************************************************************************************
 *  Copyright © 2014-2018 Ontology Foundation Ltd.
 *  All rights reserved.
 *
 *  This software is supplied only under the terms of a license agreement,
 *  nondisclosure agreement or other written agreement with Ontology Foundation Ltd.
 *  Use, redistribution or other disclosure of any parts of this
 *  software is prohibited except in accordance with the terms of such written
 *  agreement with Ontology Foundation Ltd. This software is confidential
 *  and proprietary information of Ontology Foundation Ltd.
 *
 * **************************************************************************************
 */

#import <UIKit/UIKit.h>
#import "Config.h"


@interface BaseViewController : UIViewController

@property (assign, nonatomic) BOOL isNetWorkConnect; //判断network是否连接正常

- (BOOL)shouldBegin;

- (void)setNavTitle:(NSString *)title;

- (void)setNavTitleAttributesWithColor:(UIColor *)textColor Font:(UIFont *)textFont;

- (void)setNavLeftImageIcon:(UIImage *)imageIcon Title:(NSString *)title;

-(void)setNavRightImageIcon:(UIImage *)imageIcon Title:(NSString *)title;

- (void)setNavLeftItem:(UIBarButtonItem *)item;

- (void)setNavRightItem:(UIBarButtonItem *)item;

- (void)setNavLeftItems:(NSMutableArray *)array;

- (void)navLeftAction;
- (void)navRightAction;
//- (void)setStatusBarBackgroundColor:(UIColor *)color;


+ (BOOL)setTabbarItemWithItemTitle:(NSString *)itemTitle
                    ItemTitleColor:(UIColor *)itemTitleColor
            ItemTitleColorSelected:(UIColor *)itemTitleColorSelected
                     ItemTitleFont:(UIFont *)itemTitleFont
                         ItemImage:(UIImage *)itemImage
                 ItemImageSelected:(UIImage *)itemImageSelected
                           AtIndex:(int)index
                      SourceTabbar:(UITabBarController *)sourceTabbar;

- (void)getNetWork;
- (void)nonNetWork;


@end
