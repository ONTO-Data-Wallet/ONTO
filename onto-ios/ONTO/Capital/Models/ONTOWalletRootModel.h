//
//  ONTOWalletRootModel.h
//  ONTO
//
//  Created by onchain on 2019/5/15.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONTOWalletCoinModel.h"
#import "ONTOWalletTokenModel.h"
#import "ONTOWalletSelectableModel.h"
#import "ONTOWalletCellModel.h"

@class ONTOWalletRootModel;
NS_ASSUME_NONNULL_BEGIN
@interface ONTOWalletRootModel : NSObject

+(ONTOWalletRootModel*)organizeData:(NSArray *)orgData WithAddress:(NSString*)address;

//Data List
@property(nonatomic,strong)NSMutableArray          *modelList;

@property(nonatomic,strong)NSMutableArray          *tokenArray;

@property(nonatomic,strong)NSMutableArray          *defaultTokenArray;

@property(nonatomic,strong)NSMutableArray          *dataMarr;

@property(nonatomic,strong)NSMutableArray          *tokenShowArray;

//Data Properties
@property(nonatomic,strong)NSNumber                *waitboundong;

-(NSMutableArray*)createDataMarr;

@end
NS_ASSUME_NONNULL_END
