//
//  CopayersOrderViewController.h
//  ONTO
//
//  Created by Apple on 2018/7/17.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface CopayersOrderViewController : BaseViewController
@property(nonatomic,assign)BOOL           isONT;
@property(nonatomic,copy)  NSString       *fromAddress;
@property(nonatomic,copy)  NSString       *toAddress;
@property(nonatomic,copy)  NSString       *amout;
@property(nonatomic,copy)  NSString       *gasPrice;
@property(nonatomic,copy)  NSString       *gasLimit;
@property(nonatomic,copy)  NSString       *nowAddress;
@property(nonatomic,copy)  NSString       *selectPWD;
@property(nonatomic,strong)NSDictionary   *selectDic;

@end
