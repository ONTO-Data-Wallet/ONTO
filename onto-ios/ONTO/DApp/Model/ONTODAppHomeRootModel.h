//
//  ONTODAppHomeRootModel.h
//  ONTO
//
//  Created by onchain on 2019/5/21.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONTODAppHomeBannerModel.h"
#import "ONTODAppHomeAppModel.h"

NS_ASSUME_NONNULL_BEGIN

//Dapp主页根结点
@interface ONTODAppHomeRootModel : NSObject

+(ONTODAppHomeRootModel*)organizeData:(NSDictionary *)orgData;

//DAPP列表
@property(nonatomic,strong)NSArray        *app;
//DAPP推荐栏
@property(nonatomic,strong)NSArray        *recommend;
//DAPP合作栏
@property(nonatomic,strong)NSArray        *cooperation;
//Banner栏
@property(nonatomic,strong)NSArray        *banner;

@end

NS_ASSUME_NONNULL_END
