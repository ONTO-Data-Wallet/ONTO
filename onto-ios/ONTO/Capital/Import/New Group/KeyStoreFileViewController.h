//
//  KeyStoreFileViewController.h
//  ONTO
//
//  Created by 赵伟 on 24/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface KeyStoreFileViewController : BaseViewController

@property (nonatomic, copy) NSDictionary *identityDic;
@property (nonatomic,assign) BOOL isWallet;
@property (nonatomic, copy)NSString *QRcode;
@property (nonatomic,assign) BOOL isFirstIdentity;

@end
