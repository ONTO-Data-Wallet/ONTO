//
//  ShareWalletPayDetailViewController.h
//  ONTO
//
//  Created by Apple on 2018/7/13.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "BaseViewController.h"
@class ShareTradeModel;
@interface ShareWalletPayDetailViewController : BaseViewController
@property(nonatomic,strong)ShareTradeModel    *model;
@property(nonatomic,copy)NSString             *address;
@property(nonatomic,assign)BOOL                isONT;
@property(nonatomic,strong)NSDictionary       *dic;
@property(nonatomic,assign)BOOL                isComplete;;
@end
