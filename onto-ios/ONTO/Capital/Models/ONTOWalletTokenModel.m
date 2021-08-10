//
//  ONTOWalletTokenModel.m
//  ONTO
//
//  Created by onchain on 2019/5/15.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTOWalletTokenModel.h"
#import <YYKit.h>

@implementation ONTOWalletTokenModel

+(NSArray*)organizeData:(NSArray *)orgData
{
    NSMutableArray *dataArr = [NSMutableArray array];
    if (orgData)
    {
        for (NSDictionary *dict in orgData)
        {
            ONTOWalletTokenModel *model = [ONTOWalletTokenModel modelWithJSON:dict];
            [dataArr addObject:model];
        }
        
        //add
        ONTOWalletTokenModel *addModel1 = [[ONTOWalletTokenModel alloc] init];
        addModel1.ShortName = @"totalpumpkin";
        addModel1.Logo = @"pumkinRectangle 7";
        addModel1.Type = @"OEP-8";
        addModel1.ShortName_1 = @"PUMPKIN";
        [dataArr addObject:addModel1];
        
        ONTOWalletTokenModel *addModel2 = [[ONTOWalletTokenModel alloc] init];
        addModel2.ShortName = @"HyperDragons";
        addModel2.Logo = @"dragonRectangle_1";
        addModel2.Type = @"OEP-5";
        addModel2.ShortName_1 = @"HyperDragons";
        [dataArr addObject:addModel2];
    }
    return dataArr;
}

+(NSArray*)organizeDefaultData:(NSArray *)orgData
{
    NSMutableArray *dataArr = [NSMutableArray array];
    if (orgData)
    {
        for (NSDictionary *dict in orgData)
        {
            ONTOWalletTokenModel *model = [ONTOWalletTokenModel modelWithJSON:dict];
            [dataArr addObject:model];
        }
    }
    return dataArr;
}

+(NSArray*)organizeDefaultData:(NSArray *)orgData WithTokenShowList:(NSArray*)list
{
    NSMutableArray *dataArr = [NSMutableArray array];
    if (orgData)
    {
        for (NSDictionary *dict in orgData)
        {
            ONTOWalletTokenModel *model = [ONTOWalletTokenModel modelWithJSON:dict];
            [dataArr addObject:model];
        }
        
        //add
        ONTOWalletTokenModel *addModel1 = [[ONTOWalletTokenModel alloc] init];
        addModel1.ShortName = @"totalpumpkin";
        addModel1.Logo = @"pumkinRectangle 7";
        addModel1.Type = @"OEP-8";
        addModel1.ShortName_1 = @"PUMPKIN";
        [dataArr addObject:addModel1];
        
        ONTOWalletTokenModel *addModel2 = [[ONTOWalletTokenModel alloc] init];
        addModel2.ShortName = @"HyperDragons";
        addModel2.Logo = @"dragonRectangle_1";
        addModel2.Type = @"OEP-5";
        addModel2.ShortName_1 = @"HyperDragons";
        [dataArr addObject:addModel2];
    }
    return dataArr;
}

@end
