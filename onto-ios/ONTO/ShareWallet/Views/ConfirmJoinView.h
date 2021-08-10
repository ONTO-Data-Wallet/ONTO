//
//  ConfirmJoinView.h
//  ONTO
//
//  Created by Apple on 2018/7/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PwdEnterView.h"
@interface ConfirmJoinView : UIView

@property (nonatomic, copy) void (^callback)(NSString *,NSString *,NSDictionary *);
- (instancetype)initWithAddress:(NSString*)address  isFirst:(BOOL)isFirst;
- (void)show;
- (void)dismiss;
@end
