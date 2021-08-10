//
//  AddContactViewController.h
//  ONTO
//
//  Created by 赵伟 on 16/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface AddContactViewController : BaseViewController

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, copy) void (^callback)(NSString *,NSString*);

@end
