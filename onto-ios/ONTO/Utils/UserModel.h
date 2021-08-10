//
//  UserModel.h
//  ONTO
//
//  Created by Apple on 2018/7/4.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
+(UserModel *)shareInstance;

@property(nonatomic,assign)BOOL                  isRefreshList;
@property(nonatomic,assign)BOOL                  isShareWallet;
@property(nonatomic,assign)BOOL                  isCheckTrade;
@property(nonatomic,assign)BOOL                  isCheckDoneTrade;
@property(nonatomic,assign)BOOL                  isCheckCode;

@end
