//
//  UIView+Scale.m
//  WirelessSong-order
//
//  Created by 王飞 on 15/2/13.
//  Copyright (c) 2015年 Lohas Inc. All rights reserved.
//

#import "UIView+Scale.h"
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define SCALE_W  ([[UIScreen mainScreen] bounds].size.width/375)//与iphone6屏幕高宽比例
@implementation UIView (Scale)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)scaleFrameBaseWidth{
    self.frame = CGRectMake(self.frame.origin.x * SCALE_W, self.frame.origin.y * SCALE_W, self.frame.size.width * SCALE_W, self.frame.size.height * SCALE_W);
}
- (void)scaleFrameBaseDevice:(NSInteger)iphoneName{
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    switch (iphoneName) {
        case iphone4:
        {
            width = 320;
            height = 480;
        }
            break;
        case iphone5:
        {
            width = 320;
            height = 568;
        }
            break;
        case iphone6:
        {
            width = 375;
            height = 667;
        }
            break;
        case iphone6_Plus:
        {
            width = 414;
            height = 736;
        }
            break;
            
        default:
            break;
    }
    CGFloat scaleW = ScreenWidth / width;
    CGFloat scaleH = ScreenHeight / height;
    self.frame = CGRectMake(self.frame.origin.x*scaleW, self.frame.origin.y*scaleH, self.frame.size.width*scaleW, self.frame.size.height*scaleH);
}
@end
