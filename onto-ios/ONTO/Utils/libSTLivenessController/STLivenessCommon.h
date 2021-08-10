//
//  STLivenessCommon.h
//  STLivenessController
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#ifndef STLivenessCommon_h
#define STLivenessCommon_h

#define ACCOUNT_API_KEY @"100772c1a0df4858aed19c0354e3e294"
#define ACCOUNT_API_SECRET @"b568ffe08f6a4981a5463d8db4a5bdb8"


#define kSTColorWithRGB(rgbValue)                                         \
    [UIColor colorWithRed:((float) ((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                    green:((float) ((rgbValue & 0xFF00) >> 8)) / 255.0    \
                     blue:((float) (rgbValue & 0xFF)) / 255.0             \
                    alpha:1.0]

#define kSTScreenWidth [UIScreen mainScreen].bounds.size.width
#define kSTScreenHeight [UIScreen mainScreen].bounds.size.height

#define kSTViewTagBase 1000

#endif /* STLivenessCommon_h */
