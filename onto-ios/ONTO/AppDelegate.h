//
//  AppDelegate.h
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
#import "BrowserView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isSocketConnect; //判断socket是否连接成功
@property (assign, nonatomic) BOOL isNetWorkConnect; //判断network是否连接正常
@property (assign, nonatomic) BOOL isEpire;  //是否过期
@property (assign, nonatomic) BOOL isNeedPrensentLogin;  //是否需要弹出登录框
@property (assign, nonatomic) BOOL isShowRoot;  //已经出现过root弹框
@property (nonatomic, strong) BrowserView *browserView;
@property (nonatomic, copy) NSString *selectCountry;
@property (nonatomic, copy) NSString *selectShuftiCountry;

@end

