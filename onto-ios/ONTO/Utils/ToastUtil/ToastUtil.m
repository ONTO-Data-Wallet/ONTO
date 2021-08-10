//
//  ToastUtil.m
//  Customer2_0_0
//
//  Created by liuhaoyang on 16/7/1.
//  Copyright © 2016年 xjs_fdm. All rights reserved.
//

#import "ToastUtil.h"

#define appwwindow [[UIApplication sharedApplication].delegate window]

@implementation ToastUtil


+(void)shortToast:(UIView *)view value:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text=text;
    hud.margin = 10.f;
    hud.yOffset = 15.f;
//    hud.offset.y = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.label.font = [UIFont systemFontOfSize:18];
    [hud hideAnimated:YES afterDelay:2.0f];
}

+(void)toast:(UIView *)view value:(NSString *)text longTime:(CGFloat)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text=text;
     hud.label.font  = [UIFont systemFontOfSize:12];
    [hud hideAnimated:YES afterDelay:time];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view{
    if (view == nil) view = appwwindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES]; 
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    [hud hideAnimated:YES afterDelay:15];
    return hud;
}


@end
