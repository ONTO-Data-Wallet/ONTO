//
//  NewPasswordSheet.h
//  ONTO
//
//  Created by Apple on 2018/9/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPasswordSheet : UIView
-(instancetype)initWithTitle:(NSString*)title selectedDic:(NSDictionary*)selectedDic;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isDefault;
    
@property (nonatomic, copy) void (^callback)(NSString *);
- (void)show;
- (void)dismiss;
@end
