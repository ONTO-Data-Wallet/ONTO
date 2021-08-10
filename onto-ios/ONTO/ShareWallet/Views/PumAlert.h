//
//  PumAlert.h
//  ONTO
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Config.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SPACE 10

@interface PumAlert : UIView
-(instancetype)initWithTitle:(NSString*)title imageString:(NSString*)imageString numString:(NSString*)numString  buttonString:(NSString*)buttonString;
-(instancetype)initWithTitle:(NSMutableAttributedString*)title imageString:(NSString*)imageString numString:(NSString*)numString  buttonString:(NSString*)buttonString isCandy:(BOOL)isCandy;
@property (nonatomic, copy) void (^callback)(NSString * string);
- (void)show;
- (void)dismiss;
@end

