//
//  ONTODAppHomeAppModel.m
//  ONTO
//
//  Created by onchain on 2019/5/21.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHomeAppModel.h"
#import <YYKit.h>

@implementation ONTODAppHomeAppModel
+(NSArray*)organizeData:(NSArray *)orgData
{
    NSArray *tmpArr = orgData;
    NSMutableArray *mArr = [NSMutableArray array];
    if (tmpArr)
    {
        for (NSDictionary *dict in tmpArr)
        {
            ONTODAppHomeAppModel *model = [ONTODAppHomeAppModel modelWithJSON:dict];
            model.appId = dict[@"id"];
            model.appDescription = dict[@"description"];
            [mArr addObject:model];
        }
    }
    
    return mArr;
    
}


@end
