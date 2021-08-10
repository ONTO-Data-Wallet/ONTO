//
//  ScreenLockController.h
//  ONTO
//
//  Created by 赵伟 on 17/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface ScreenLockController : BaseViewController

@property (nonatomic, copy) NSString *ontID;
@property (nonatomic, assign) BOOL isManage;
@property (nonatomic, copy)NSString *manageName;

@property (nonatomic, assign) BOOL isDigitalIdentity;
@property (nonatomic, copy) NSDictionary *identityDic;
@property (nonatomic, assign) BOOL isWallet;
@property (nonatomic, assign) BOOL isIdentity;
@property (nonatomic, copy)NSString *name;
@end
