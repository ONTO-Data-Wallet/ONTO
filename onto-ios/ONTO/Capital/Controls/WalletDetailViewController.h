//
//  WalletDetailViewController.h
//  ONTO
//
//  Created by 赵伟 on 23/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface WalletDetailViewController : BaseViewController

@property (nonatomic,copy)NSString *address;
@property (nonatomic, copy) NSDictionary *identityDic;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *salt;

@end
