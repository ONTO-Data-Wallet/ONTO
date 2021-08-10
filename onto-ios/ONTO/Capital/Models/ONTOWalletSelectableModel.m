//
//  ONTOWalletSelectableModel.m
//  ONTO
//
//  Created by onchain on 2019/5/15.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTOWalletSelectableModel.h"
#import <YYKit.h>

@implementation ONTOWalletSelectableModel

+(NSArray*)organizeData:(NSArray *)orgData
{
    NSMutableArray *dataArr = [NSMutableArray array];
    if (orgData)
    {
        for (NSDictionary *dict in orgData)
        {
            ONTOWalletSelectableModel *model = [ONTOWalletSelectableModel modelWithJSON:dict];
            [dataArr addObject:model];
        }
    }
    return dataArr;
}

@end
