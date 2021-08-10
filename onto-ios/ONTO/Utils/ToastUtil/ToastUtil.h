//
//  ToastUtil.h
//  Customer2_0_0
//
//  Created by liuhaoyang on 16/7/1.
//  Copyright © 2016年 xjs_fdm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface ToastUtil : NSObject

 
//弹出提醒  
+(void)shortToast:(UIView *)view value:(NSString *)text;

//弹出提醒 可指定弹出时间
+(void)toast:(UIView *)view value:(NSString *)text longTime:(CGFloat)time;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

@end
