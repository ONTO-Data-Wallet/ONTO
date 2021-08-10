//
//  XWCountryCodeController.h
//  XWCountryCodeDemo
//
//  Created by 邱学伟 on 16/4/19.
//  Copyright © 2016年 邱学伟. All rights reserved.
//  国家代码选择界面

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
//1.代理传值
@protocol NewCountryCodeViewControllerDelegate <NSObject>

@optional
-(void)returnCountryCode:(NSString *)countryCode;

@end

//2.block传值  typedef void(^returnBlock)(NSString *showText);
typedef void(^returnCountryCodeReginBlock) (NSString *countryCodeStr,NSString *reginString);

@interface NewCountryCodeViewController : BaseViewController

//代理
@property (nonatomic, assign) id<NewCountryCodeViewControllerDelegate> deleagete;

//block声明属性
@property (nonatomic, copy) returnCountryCodeReginBlock returnCountryCodeReginBlock;
//block声明方法
-(void)toReturnCountryCode:(returnCountryCodeReginBlock)block;


@end
