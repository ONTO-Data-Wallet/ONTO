//
//  ONTOWalletCellModel.h
//  ONTO
//
//  Created by onchain on 2019/5/16.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONTOWalletCellModel : NSObject

@property(nonatomic,copy)NSString         *type;
@property(nonatomic,copy)NSString         *picUrl;
@property(nonatomic,strong)NSNumber       *amount;

@end

NS_ASSUME_NONNULL_END
