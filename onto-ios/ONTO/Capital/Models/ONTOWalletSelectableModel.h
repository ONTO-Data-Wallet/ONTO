//
//  ONTOWalletSelectableModel.h
//  ONTO
//
//  Created by onchain on 2019/5/15.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONTOWalletSelectableModel : NSObject

+(NSArray*)organizeData:(NSArray *)orgData;

@property(nonatomic,copy)NSString         *AssetName;
@property(nonatomic,strong)NSNumber       *isShow;

@end

NS_ASSUME_NONNULL_END
