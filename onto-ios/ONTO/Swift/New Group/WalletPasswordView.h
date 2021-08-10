//
//  WalletPasswordView.h
//  ONTO
//
//  Created by Apple on 2018/10/25.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WalletPasswordView : UIView
-(instancetype)initWithTitle:(NSString*)title selectedDic:(NSDictionary*)selectedDic;
@property (nonatomic, copy) void (^callback)(NSString *);
@end

