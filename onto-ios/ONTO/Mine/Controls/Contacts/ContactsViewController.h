//
//  ContactsViewController.h
//  ONTO
//
//  Created by 赵伟 on 16/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface ContactsViewController : BaseViewController
@property (nonatomic, copy) void (^callback)(NSString *);
@end
