//
//  ShareWalletTransferAccountsViewController.h
//  ONTO
//
//  Created by Apple on 2018/7/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "BaseViewController.h"
#import "XHSegmentViewController.h"
@interface ShareWalletTransferAccountsViewController : XHSegmentViewController
@property(nonatomic,assign)BOOL         isONT;
@property(nonatomic,copy)NSString       *amount;
@property(nonatomic,copy)NSString       *ongAppove;
@property(nonatomic,copy)NSString       *GoalType;
@property(nonatomic,copy)NSString       *exchange;
@property(nonatomic,copy)NSString       *address;
@property(nonatomic,copy)NSString       *ongAmount;
@property(nonatomic,copy)NSString       *waitboundong;
@end
