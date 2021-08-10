//
//  ChargeModel.h
//  ONTO
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChargeModel : NSObject
@property(nonatomic,copy)NSString        *Amount;
@property(nonatomic,copy)NSString        *AssetName;
@property(nonatomic,copy)NSString        *Charge;
@property(nonatomic,copy)NSString        *ToAddress;
@property(nonatomic,copy)NSString        *GasLimit;
@property(nonatomic,copy)NSString        *GasPrice;
@end

