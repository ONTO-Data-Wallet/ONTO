//
//  ConfirmPayView.h
//  ONTO
//
//  Created by Apple on 2018/7/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPayView : UIView
-(instancetype)initWithType:(BOOL)isONT money:(NSString*)money fromAddress:(NSString*)fromAddress toAddress:(NSString*)toAddress fee:(NSString*)fee;
@property (nonatomic, copy) void (^callback)(NSString *);
- (void)show;
- (void)dismiss;
@end
