//
//  UserModel.m
//  ONTO
//
//  Created by Apple on 2018/7/4.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+(UserModel*)shareInstance{
    static UserModel *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[UserModel alloc]init];
    });
    
    return _shareInstance;
}

-(id)init{
    if (self=[super init]) {
        self.isRefreshList =NO;
        self.isShareWallet =NO;
        self.isCheckTrade  =NO;
        self.isCheckDoneTrade =NO;
        self.isCheckCode = NO;
    }
    return self;
}
@end
