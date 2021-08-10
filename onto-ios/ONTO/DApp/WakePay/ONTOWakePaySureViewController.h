//
//  ONTOWakePaySureViewController.h
//  ONTO
//
//  Created by Apple on 2019/5/16.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "BaseViewController.h"


@interface ONTOWakePaySureViewController : BaseViewController
@property(nonatomic, strong)NSDictionary * infoDic;
@property(nonatomic, strong)id              responseOriginal;
@property (nonatomic, copy) void(^sureBlock)(void);
@end

