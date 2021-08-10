//
//  ONTOWalletRootModel.m
//  ONTO
//
//  Created by onchain on 2019/5/15.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTOWalletRootModel.h"
#import <YYKit.h>
#import "Config.h"

@interface ONTOWalletRootModel ()
{
    NSString               *_address;
}
@property(nonatomic,strong)NSMutableArray     *originalTokenMarr;
@property(nonatomic,strong)NSMutableArray     *originalDefaultTokenMarr;
@property(nonatomic,strong)NSMutableArray     *originalTokenShowMarr;
@end
@implementation ONTOWalletRootModel

+(ONTOWalletRootModel*)organizeData:(NSArray *)orgData WithAddress:(NSString*)address
{
    NSMutableArray *dataArr = [NSMutableArray array];
    ONTOWalletRootModel *tmpRootModel = [[ONTOWalletRootModel alloc] init];
    [tmpRootModel p_tokenShowArrayWithAddress:address];
    
    if (orgData)
    {
        for (NSDictionary *dict in orgData)
        {
            @autoreleasepool
            {
                ONTOWalletCoinModel *model = [ONTOWalletCoinModel modelWithJSON:dict];
                [dataArr addObject:model];
                
                if ([model.AssetName isEqualToString:@"ont"] || [model.AssetName isEqualToString:@"ong"])
                {
                    ONTOWalletCellModel *cellModel = [[ONTOWalletCellModel alloc] init];
                    cellModel.type = model.AssetName;
                    cellModel.amount = model.Balance;
                    [tmpRootModel.dataMarr addObject:cellModel];
                }
                else if ([model.AssetName isEqualToString:@"waitboundong"])
                {
                    tmpRootModel.waitboundong = model.Balance;
                }
            }
        }
        
        tmpRootModel.modelList = dataArr;
    }
    
    //合成资产列表的前部分
    [tmpRootModel.dataMarr addObjectsFromArray:tmpRootModel.defaultTokenArray];
    
    return tmpRootModel;
}

//Private
-(void)p_tokenShowArrayWithAddress:(NSString*)address
{
    _address = address;
}

//获取图片logo
-(NSString*)p_getLogoInTokenName:(NSString*)tokenName
{
    NSString *logoStr = @"";
    for (ONTOWalletTokenModel *model in self.tokenArray)
    {
        @autoreleasepool
        {
            NSLog(@"%@", model.ShortName);
            if ([model.ShortName isEqualToString:tokenName])
            {
                logoStr = model.Logo;
                break;
            }
        }
    }
    return logoStr;
}

//获取币的数量
-(NSNumber*)p_getAmountInTokenName:(NSString*)tokenName
{
    NSNumber *amountObjc = [[NSNumber alloc] initWithInt:0];
    for (ONTOWalletCoinModel *model in self.modelList)
    {
        @autoreleasepool
        {
            NSLog(@"%@", model.AssetName);
            if ([model.AssetName isEqualToString:tokenName])
            {
                amountObjc = model.Balance;
            }
        }
    }
    return amountObjc;
}

//Public
-(NSMutableArray*)createDataMarr
{
    NSArray *tmpShowList = self.tokenShowArray;
    for (ONTOWalletSelectableModel *selcModel in tmpShowList)
    {
        @autoreleasepool
        {
            //需要在列表显示
            if ([selcModel.isShow.stringValue isEqualToString:@"1"])
            {
                ONTOWalletCellModel *cellModel = [[ONTOWalletCellModel alloc] init];
                cellModel.type = selcModel.AssetName;
                cellModel.amount = [self p_getAmountInTokenName:cellModel.type];
                cellModel.picUrl = [self p_getLogoInTokenName:cellModel.type];
                [self.dataMarr addObject:cellModel];
            }
        }
    }
    
    return self.dataMarr;
}

//TokenList
-(NSMutableArray*)tokenArray
{
    if (!_tokenArray)
    {
        _tokenArray = [NSMutableArray arrayWithArray:self.originalTokenMarr];
    }
    return _tokenArray;
}

-(NSMutableArray*)originalTokenMarr
{
    if (!_originalTokenMarr)
    {
        _originalTokenMarr = [NSMutableArray arrayWithArray:[ONTOWalletTokenModel organizeData:[[NSUserDefaults standardUserDefaults] valueForKey:TOKENLIST]]];
    }
    return _originalTokenMarr;
}

//defaultTokenArray
-(NSMutableArray*)defaultTokenArray
{
    if (!_defaultTokenArray)
    {
        _defaultTokenArray = [NSMutableArray arrayWithArray:self.originalDefaultTokenMarr];
        
    }
    return _defaultTokenArray;
}

-(NSMutableArray*)originalDefaultTokenMarr
{
    if (!_originalDefaultTokenMarr)
    {
        _originalDefaultTokenMarr = [NSMutableArray arrayWithArray:[ONTOWalletTokenModel organizeDefaultData:[[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTTOKENLIST]]];
    }
    return _originalDefaultTokenMarr;
}

//Data Arr
-(NSMutableArray*)dataMarr
{
    if (!_dataMarr)
    {
        _dataMarr = [NSMutableArray array];
    }
    return _dataMarr;
}

//TokenShowArray
-(NSMutableArray*)tokenShowArray
{
    if (!_tokenShowArray)
    {
        _tokenShowArray = [NSMutableArray arrayWithArray:self.originalTokenShowMarr];
    }
    return _tokenShowArray;
}

-(NSMutableArray*)originalTokenShowMarr
{
    if (!_originalTokenShowMarr)
    {
        _originalTokenShowMarr = [NSMutableArray arrayWithArray:[ONTOWalletSelectableModel organizeData:[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@%@",_address,TOKENLISTSHOW]]]];
    }
    return _originalTokenShowMarr;
}

@end
