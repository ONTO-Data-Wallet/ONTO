//
//  KeyStoreBackupVC.h
//  ONTO
//
//  Created by 赵伟 on 24/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "XHSegmentViewController.h"

@interface KeyStoreBackupVC : XHSegmentViewController

@property (nonatomic, assign) BOOL isWallet;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy) NSDictionary *identityDic;
@property (nonatomic, assign) BOOL isFirstIdentity;//第一次创建身份

@property (nonatomic, copy) void (^callback)(NSString *);
@property (nonatomic, assign) BOOL isFix;  //判断translant
@property (nonatomic, copy)NSString *passwordString;

@end
