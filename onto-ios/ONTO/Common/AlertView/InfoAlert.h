//
//  InfoAlert.h
//  ONTO
//
//  Created by Apple on 2018/12/18.
//  Copyright © 2018 Zeus. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Config.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SPACE 10
@interface InfoAlert : UIView
-(instancetype)initWithTitle:(NSString*)title msgString:(NSString*)msgString buttonString:(NSString*)buttonString leftString:(NSString*)leftString;
@property (nonatomic, copy) void (^callback)(NSString * string);
@property (nonatomic, copy) void (^callleftback)(NSString * string);
- (void)show;
- (void)dismiss;
@end
