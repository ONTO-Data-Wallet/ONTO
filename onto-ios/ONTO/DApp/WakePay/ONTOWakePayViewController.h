//
//  ONTOWakePayViewController.h
//  ONTO
//
//  Created by Apple on 2019/5/15.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ONTOWakePayViewController : BaseViewController
@property(nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, copy) void(^pwdBlock)(NSString *pwdString);
@end

NS_ASSUME_NONNULL_END
