//
//  copayersTradeModel.h
//  ONTO
//
//  Created by Apple on 2018/7/22.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "copayerSignModel.h"
@interface copayersTradeModel : NSObject
@property(nonatomic,copy)NSString        *amount;
@property(nonatomic,strong)NSMutableArray<copayerSignModel*>*coPayerSignVOS;
@end
