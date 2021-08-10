//
//  KeyStoreQRViewController.h
//  ONTO
//
//  Created by 赵伟 on 24/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface KeyStoreQRViewController : BaseViewController
@property (nonatomic, assign) BOOL isWallet;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy) NSDictionary *identityDic;
@property (nonatomic, copy)NSString *QRcode;
@end
