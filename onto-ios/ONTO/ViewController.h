//
//  ViewController.h
//  ONTO
//
//  Created by Zeus.Zhang on 2018/1/31.
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
 *///

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITabBarControllerDelegate>


/**
 引导页
 */
+ (void)gotoGuideVC;

/**
 创建主页
 */
+ (void)gotoHomeVC;

/**
 身份主页
 */
+ (void)gotoIdentityVC;

/**
 备份页
 */
+ (void)gotoBackupVC;

/**
 资产页x
 */
+ (void)gotoCapitalVC;

//创建完ONT ID的跳转
+ (void)selectIdentityVC;

@end

