//
//  ONTODAppHomeBannerModel.m
//  ONTO
//
//  Created by onchain on 2019/5/21.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHomeBannerModel.h"
#import <YYKit.h>

@implementation ONTODAppHomeBannerModel

+(NSArray*)organizeData:(NSArray *)orgData
{
    NSArray *tmpArr = orgData;
    NSMutableArray *mArr = [NSMutableArray array];
    if (tmpArr)
    {
        for (NSDictionary *dict in tmpArr)
        {
            ONTODAppHomeBannerModel *model = [ONTODAppHomeBannerModel modelWithJSON:dict];
            model.appId = dict[@"id"];
            [mArr addObject:model];
        }
    }
    
    return mArr;
    
}

@end
