//
//  CreateShareWalletDoneViewController.h
//  ONTO
//
//  Created by Apple on 2018/7/10.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface CreateShareWalletDoneViewController : BaseViewController
@property(nonatomic,copy)NSString           *nameStr;
@property(nonatomic,assign)NSInteger        totalNum;
@property(nonatomic,assign)NSInteger        requiredNum;
@property(nonatomic,strong)NSMutableArray   *dataArray;
@end
