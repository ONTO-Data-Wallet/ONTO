//
//  ONTODAppHomeRootModel.m
//  ONTO
//
//  Created by onchain on 2019/5/21.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHomeRootModel.h"


@implementation ONTODAppHomeRootModel

+(ONTODAppHomeRootModel*)organizeData:(NSDictionary *)orgData
{
    NSDictionary *modelDict = orgData;
    ONTODAppHomeRootModel *tmpRootModel = [[ONTODAppHomeRootModel alloc] init];
    tmpRootModel.app = [ONTODAppHomeAppModel organizeData:modelDict[@"app"]];
    tmpRootModel.recommend = [ONTODAppHomeAppModel organizeData:modelDict[@"recommend"]];
    tmpRootModel.cooperation = [ONTODAppHomeAppModel organizeData:modelDict[@"cooperation"]];
    tmpRootModel.banner = [ONTODAppHomeBannerModel organizeData:modelDict[@"banner"]];
    
    return tmpRootModel;
}

@end
