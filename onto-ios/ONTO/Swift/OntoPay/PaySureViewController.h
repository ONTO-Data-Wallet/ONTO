//
//  PaySureViewController.h
//  ONTO
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"


@interface PaySureViewController : BaseViewController
@property(nonatomic,strong)NSDictionary *payinfoDic;
@property(nonatomic,strong)NSDictionary *defaultDic;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)NSString *toAddress;
@property(nonatomic,copy)NSString *hashString;
@property(nonatomic,copy)NSString *payerAddress;
@property(nonatomic,copy)NSString *callback;
@property(nonatomic,copy)NSString *payMoney ;
@property(nonatomic,assign)BOOL   isONT;
@end

