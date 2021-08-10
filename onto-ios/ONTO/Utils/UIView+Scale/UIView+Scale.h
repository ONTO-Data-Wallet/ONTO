//
//  UIView+Scale.h
//  WirelessSong-order
//
//  Created by 王飞 on 15/2/13.
//  Copyright (c) 2015年 Lohas Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger, typeIphone) {
    iphone4 = 4,
    iphone5,
    iphone6,
    iphone6_Plus
};
@interface UIView (Scale)
- (void)scaleFrameBaseWidth;
- (void)scaleFrameBaseDevice:(NSInteger)iphoneName;
@end
