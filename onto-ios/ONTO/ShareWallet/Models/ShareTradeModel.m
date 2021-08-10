//
//  ShareTradeModel.m
//  ONTO
//
//  Created by Apple on 2018/7/22.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ShareTradeModel.h"
#import <MJExtension/MJExtension.h>
@implementation ShareTradeModel
+(NSDictionary*)mj_objectClassInArray{
    return @{@"coPayerSignVOS":[copayerSignModel class]};
}
@end
