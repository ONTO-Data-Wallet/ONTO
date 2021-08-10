//
//  WalletBackupVC.h
//  ONTO
//
//  Created by 赵伟 on 08/06/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface WalletBackupVC : BaseViewController
@property (nonatomic,copy) NSString *remenberWord;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *passwordHash;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *salt;

@end
