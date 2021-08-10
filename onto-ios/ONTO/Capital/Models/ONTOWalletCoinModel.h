//
//  ONTOWalletCoinModel.h
//  ONTO
//
//  Created by onchain on 2019/5/15.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONTOWalletCoinModel : NSObject

@property(nonatomic,copy)NSString         *AssetName;
@property(nonatomic,copy)NSString         *AssetType;
@property(nonatomic,strong)NSNumber       *Balance;

@end

NS_ASSUME_NONNULL_END
