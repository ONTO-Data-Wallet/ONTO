//
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "ViewController.h"
#import "Config.h"
#import "Common.h"
#import "LaunchIntroductionView.h"
#import "XHVersion.h"
#import "rsa.h"
#import "fmdb.h"
#import "AFNetworkReachabilityManager.h"
#import <RiskManage/RiskStub.h>
#import "BaseViewController.h"
#import "SecurityViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ONTO-Swift.h"
#import "IQKeyboardManager.h"
#import <Bugly/Bugly.h>
#import <CloudrailSI/CloudrailSI.h>

#import "PaySureViewController.h"
//#import "OntoPayViewController.h"
#import "UIViewController+IFStyle.h"
@interface AppDelegate ()

@property(nonatomic, strong) YYReachability *reach;
@property(nonatomic, strong) MGPopController *netnoticepop;
@property(nonatomic, copy) NSString *hashString;
@property (nonatomic, strong)NSMutableArray * walletArray;
@property (nonatomic, strong)NSDictionary * payinfoDic;
@property (nonatomic, strong)NoNetView * noNetV;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
    self.hashString = @"";
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    self.window.rootViewController = nav;
//    [NSThread sleepForTimeInterval:2.0];
    [self.window makeKeyAndVisible];
    
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
    // 监测网络情况
    [self monitorNetWorkStatus];
    
    //梆梆威胁感知
    //    [self riskStub];
    
    //升级系统通知
    [self systemNotice];
    
    //JS初始化
    _browserView = self.browserView;

    //注册腾讯bugly
    [Bugly startWithAppId:@"9d143f5efc"];
    
//#if DEBUG
//
//#else
//    [Bugly startWithAppId:@"9d143f5efc"];
//#endif

    //CloudRail
    [CRCloudRail setAppKey:@"5bc6a0d516d0d558c90949a9"];
  return YES;
}

//Bugly
- (void)configureBugly {

//  BuglyConfig *config = [[BuglyConfig alloc] init];
//
//  config.unexpectedTerminatingDetectionEnable = YES; //非正常退出事件记录开关，默认关闭
//  config.reportLogLevel = BuglyLogLevelWarn; //报告级别
//  //config.deviceIdentifier = [UIDevice currentDevice].identifierForVendor.UUIDString; //设备标识
//  config.blockMonitorEnable = YES; //开启卡顿监控
//  config.blockMonitorTimeout = 5; //卡顿监控判断间隔，单位为秒
//  //    config.delegate = self;
//
//#if DEBUG
//  config.debugMode = YES; //SDK Debug信息开关, 默认关闭
//  config.channel = @"debug";
//#else
//  config.channel = @"release";
//#endif
//
//  [Bugly startWithAppId:@"948c7f1a1a"
//#if DEBUG
//      developmentDevice:YES
//#endif
//                 config:config];
    
    //注册腾讯bugly
    [Bugly startWithAppId:@"9d143f5efc"];
    
    
}




- (void)cMethed {

  //    c++方法
//        CPPHello::sayHello();
//        Rsa my_rsa;
//
//        string a="b";
//        string c;
//         my_rsa.RsaSign(a, c);
//        bool iss= my_rsa.RsaVeri(a, c);

}

- (void)systemNotice {

  NSString *version = [UIDevice currentDevice].systemVersion;
  if (version.doubleValue < 10.3) {
    MGPopController
        *pop = [[MGPopController alloc] initWithTitle:Localized(@"Versionincompatible") message:@"" image:nil];

    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

    }];
    action.titleColor = [UIColor redColor];

    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;

  }

}

- (void)riskStub {

  [RiskStub initBangcleEverisk:@"voPHxWvPhdzaNIa1p5MtPiuW0ICs6ZtiUTiqTLDV2YcUHaCHEf8FTAbLKcJslMe9ojMoFuP0mrElNdY+QRIhWyx/vx06Z8N87IgBmY35eM4xGo7bqzbSGUuJVXsHpmU9B/ndNrwUPpm1i+t0YlEt4Ch5WUQS/Kkpo+WDer29V0p6/ZbJ3SKsDtOfM9TARey8eQ48Vum6c5l0KOVcg9wKAT8ohqPIYtkwJtRZb9tUeX0q+BL7to64sQVtrfY6V6Vvfmpyg7LKPWmhFeVtoLGg8ngU9wa8zM8oeeTZLFnS9h/1IflMlYxLjdPU/6eNFucqBPM61LYG4j4TOEQTkKr9NxMWl0ThQCbAE8Ukd2lqwUBpfRYkfM49HBzvZQAYbfGmdQgJj94WOoYQWxr9JDpHbGgjv/mao3mTnZhSScySnbfsArhwindpTGOCQY2LOClC5wIGTJAP4OX/o04EuPkA8PjUQ8R+lh1iuDeIEfMcujE="];

  [RiskStub registerServiceWithDataBlock:^(NSDictionary *dictionary, Type modularType) {
    if (modularType == ROOT) {
      if (self.isShowRoot == NO) {

        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"RootDevice") message:@"" image:nil];

        MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

        }];
        action.titleColor = [UIColor redColor];

        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        self.isShowRoot = YES;
      }

    }
  }];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    // Here we pass the response to the SDK which will automatically
    // complete the authentication process.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kCloseSafariViewControllerNotification" object:url];
    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    NSString * urlString = [url absoluteString];
    
    if ([urlString hasPrefix:@"ontoprovider://ont.io?param="] ) {
        NSArray * dataArr = [urlString componentsSeparatedByString:@"param="];
        NSString *dataString = [Common stringEncodeBase64:dataArr[1]];
        NSString *decodeString = [Common decodeString:dataString];
        NSDictionary * dic = [Common dictionaryWithJsonString:decodeString];
        NSNotification * notice = [NSNotification notificationWithName:WAKEPAY_NOTIFICATION object:nil userInfo:dic];
       //发送消息
       [[NSNotificationCenter defaultCenter] postNotification:notice];
//        NSLog(@"paydic=%@",dic);
//        self.payinfoDic = dic;
//        self.walletArray = [NSMutableArray array];
//        if ([dic isKindOfClass:[NSDictionary class]] && dic[@"action"]) {
//            NSArray * arr = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
//            if (arr.count == 0 || arr == nil) {
//                [Common showToast:Localized(@"NoWallet")];
//                return NO;
//            }else{
//                for (NSDictionary *  subDic in arr) {
//                    if (subDic[@"label"] != nil) {
//                        [self.walletArray addObject:subDic];
//                    }
//                }
//                if (self.walletArray.count == 0) {
//                    [Common showToast:Localized(@"NoWallet")];
//                    return NO;
//                }
//            }
//            if ([dic[@"action"] isEqualToString:@"login"]) {
//                OntoPayViewController * vc =[[OntoPayViewController alloc]init];
//                vc.walletArr = self.walletArray;
//                vc.payInfo = dic;
//                UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
//                [rootVC.myNavigationController pushViewController:vc animated:YES];
//
//                ONTOWakePayViewController * vc = [[ONTOWakePayViewController alloc]init];
//                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//                AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//                appdelegate.window.rootViewController.definesPresentationContext = YES;
//                [appdelegate.window.rootViewController presentViewController:vc animated:NO completion:^{
//                }];
//
//                return YES;
//            }else if ([dic[@"action"] isEqualToString:@"invoke"]) {
//                NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];;
//                NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
//
//                PaySureViewController * payVc = [[PaySureViewController alloc]init];
//                payVc.payinfoDic = dic;
//                payVc.defaultDic = dict;
//                payVc.dataArray = self.walletArray;
//
//                UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
//                [rootVC.myNavigationController pushViewController:payVc animated:YES];
//                return YES;
//            }
//        }
//
    }
    return YES;
}
- (NSString *)getNowTimeTimestamp3 {

  if ([[NSUserDefaults standardUserDefaults] valueForKey:LAQUSYSTEMNOTIFICATIONLIST]) {

    return [[NSUserDefaults standardUserDefaults] valueForKey:LAQUSYSTEMNOTIFICATIONLIST];

  } else {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long) [datenow timeIntervalSince1970] * 1000];
    return timeSp;

  }
}

- (void)monitorNetWorkStatus {
  //监测方法
  AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
  //开启监听，记得开启，不然不走block
  [manger startMonitoring];
  //2.监听改变
  [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    /*
     AFNetworkReachabilityStatusUnknown = -1,
     AFNetworkReachabilityStatusNotReachable = 0,
     AFNetworkReachabilityStatusReachableViaWWAN = 1,
     AFNetworkReachabilityStatusReachableViaWiFi = 2,
     */

      
      
    if (status == AFNetworkReachabilityStatusNotReachable) {
      //无网络通知
      [[NSNotificationCenter defaultCenter] postNotificationName:NONNETNOTIFICATION object:nil];
      _isNetWorkConnect = NO;
//        [self.noNetV show];
        
    } else {
      //有网络通知
      [[NSNotificationCenter defaultCenter] postNotificationName:GETNETNOTIFICATION object:nil];
      _isNetWorkConnect = YES;
//        [self.noNetV dismiss];
    }
  }];

}
- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
  //    进入后台程序处理非活动状态。

  [self setTimerMode];

}
- (void)setTimerMode {
  UIApplication *application = [UIApplication sharedApplication];
  __block UIBackgroundTaskIdentifier bgTask;

  bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      if (bgTask != UIBackgroundTaskInvalid) {
        bgTask = UIBackgroundTaskInvalid;
      }
    });
  }];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    dispatch_async(dispatch_get_main_queue(), ^{
      if (bgTask != UIBackgroundTaskInvalid) {
        bgTask = UIBackgroundTaskInvalid;
      }
    });
  });
}
- (NoNetView *)noNetV {
    if (!_noNetV) {
        _noNetV = [[NoNetView alloc]initWithFrame:CGRectZero];
    }
    return _noNetV;
}
- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SOCKET_APPACTIVE object:nil];

  if ([APP_DELEGATE.window.rootViewController isKindOfClass:[UITabBarController class]]
      && _isNeedPrensentLogin == YES) {
    SecurityViewController *vc = [[SecurityViewController alloc] init];
    vc.isPresent = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

    [APP_DELEGATE.window.rootViewController presentViewController:nav animated:NO completion:nil];
    self.isNeedPrensentLogin = NO;
  }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (BrowserView *)browserView {
  if (!_browserView) {
    _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
    LOADJS1;
    LOADJS2;
    LOADJS3;
      __weak typeof(self) weakSelf = self;
    [_browserView setCallbackPrompt:^(NSString *prompt) {
      DebugLog(@"prompt=%@", prompt);
        [weakSelf handlePrompt:prompt];
    }];
    [_browserView setCallbackJSFinish:^{

    }];
  }
  return _browserView;
}
- (void)handlePrompt:(NSString *)prompt{
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"verifyFailed") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }
//    NSString * toPubkey;
//    if ([prompt hasPrefix:@"decodeTransHash"]) {
//        
//        NSDictionary * resultDic = obj[@"result"];
//        NSArray * sigsArr = resultDic[@"sigs"];
//        NSDictionary * dic = sigsArr[0];
//        NSArray * pubKeysArr = dic[@"pubKeys"];
//        NSDictionary * subDic = pubKeysArr[0];
//        toPubkey = subDic[@"key"];
//        NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.adderssFromPublicKey('%@','adderssFromPublicKey')",subDic[@"key"]];
//        
//        LOADJS1;
//        LOADJS2;
//        LOADJS3;
//        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
//    }
//    if ([prompt hasPrefix:@"adderssFromPublicKey"]) {
//        NSString * toAddress = obj[@"result"];
//        NSLog(@"toAddress=%@",toAddress);
//        NSString * title = [NSString stringWithFormat:Localized(@"payTest"),toAddress];
//        NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
//        NSDictionary *walletDict = [Common dictionaryWithJsonString:jsonStr];
//        NSLog(@"walletDict=%@",walletDict);
//        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"verifySuccess") message:title image:nil];
//        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"sendSign") action:^{
//            
//            NSString* jsStr  =  [NSString stringWithFormat:@"addSign('%@','%@')",self.hashString,walletDict[@"key"]];
//            LOADJS1;
//            LOADJS2;
//            LOADJS3;
//            [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
//        }];
//        MGPopAction *action1 =   [MGPopAction actionWithTitle:Localized(@"Cancel") action:^{
//        }];
//        action.titleColor =MainColor;
//        [pop addAction:action];
//        [pop addAction:action1];
//        [pop show];
//        pop.showCloseButton = NO;
//        return;
//    }
//    if ([prompt hasPrefix:@"addSign"]) {
//        NSString * resultString = obj[@"result"];
//        NSLog(@"toAddress=%@",resultString);
//    }
    
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
