//
//  KeystoreImportVC.h
//  ONTO
//
//  Created by 赵伟 on 24/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface KeystoreImportVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *mytextView;

@property (nonatomic, assign) BOOL isIdentity;
@end
