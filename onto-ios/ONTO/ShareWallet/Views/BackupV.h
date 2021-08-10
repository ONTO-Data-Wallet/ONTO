//
//  BackupV.h
//  ONTO
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Config.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SPACE 10
@interface BackupV : UIView
-(instancetype)initWithTitle:(NSString*)title imageString:(NSString*)imageString leftButtonString:(NSString*)leftButtonString  rightButtonString:(NSString*)rightButtonString ;
@property (nonatomic, copy) void (^callback)(NSString * string);
@property (nonatomic, copy) void (^callleftback)(NSString * string);
- (void)show;
- (void)dismiss;

@end


