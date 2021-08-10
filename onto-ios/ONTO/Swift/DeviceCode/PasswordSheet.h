//
//  PasswordSheet.h
//  ONTO
//
//  Created by Apple on 2018/9/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordSheet : UIView
-(instancetype)initWithTitle:(NSString*)title selectedDic:(NSDictionary*)selectedDic;
@property (nonatomic, copy) void (^callback)(NSString *);
- (void)show;
- (void)dismiss;
@end
