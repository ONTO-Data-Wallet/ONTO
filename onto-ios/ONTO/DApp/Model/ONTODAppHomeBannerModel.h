//
//  ONTODAppHomeBannerModel.h
//  ONTO
//
//  Created by onchain on 2019/5/21.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONTODAppHomeBannerModel : NSObject

+(NSArray*)organizeData:(NSArray *)orgData;

@property(nonatomic,copy)NSString        *created_at;
@property(nonatomic,copy)NSString        *image;
@property(nonatomic,copy)NSString        *appId;//Id
@property(nonatomic,copy)NSString        *is_dapp;
@property(nonatomic,copy)NSString        *link;
@property(nonatomic,copy)NSString        *tags;
@property(nonatomic,copy)NSString        *updated_at;
@property(nonatomic,strong)NSNumber      *weight;

@end

NS_ASSUME_NONNULL_END
