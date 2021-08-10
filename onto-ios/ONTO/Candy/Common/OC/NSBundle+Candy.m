//
//  NSBundle+Candy.m
//  ONTO
//
//  Created by PC-269 on 2018/9/14.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "NSBundle+Candy.h"
#import <objc/runtime.h>
#import <MJRefresh/MJRefresh.h>

@implementation NSBundle (Candy)

+(void)load
{
    //获取两个方法的Method，参考Runtime默认写法
    //class_getClassMethod 获取类方法
    //class_getInstanceMethod 获取实例方法
    Method  sys = class_getClassMethod([NSBundle class], @selector(mj_localizedStringForKey:value:));
    Method  sysMy = class_getClassMethod([NSBundle class], @selector(cd_localizedStringForKey:value:));
    //实现交换
    method_exchangeImplementations(sys, sysMy);
}

+ (NSString *)cd_localizedStringForKey:(NSString *)key value:(NSString *)value {
    
    static NSBundle *bundle = nil;
    static NSString *preLng = nil;
    NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"userLanguage"];
    if (bundle == nil || language != preLng ) {
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        //NSString *language = [NSLocale preferredLanguages].firstObject;
        preLng = language;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        // 从MJRefresh.bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[NSBundle mj_refreshBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end
