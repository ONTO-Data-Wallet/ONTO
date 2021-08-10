//
//  ONTOWalletTokenModel.h
//  ONTO
//
//  Created by onchain on 2019/5/15.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONTOWalletTokenModel : NSObject

/*
Decimals = 8;
Desc = contractsDescription;
Hash = 25277b421a58cfc2ef5836767e54eb7abdd31afd;
Logo = "https://i.postimg.cc/kXZBPGHw/Rectangle-7-3x-3.png";
Name = Lucky;
ShortName = LCY;
Type = "OEP-4";
*/

+(NSArray*)organizeData:(NSArray *)orgData;

//DefaultList
+(NSArray*)organizeDefaultData:(NSArray *)orgData;

+(NSArray*)organizeDefaultData:(NSArray *)orgData WithTokenShowList:(NSArray*)list;

@property(nonatomic,strong)NSNumber       *Decimals;
@property(nonatomic,copy)NSString         *Hash;
@property(nonatomic,copy)NSString         *Desc;
@property(nonatomic,copy)NSString         *Logo;
@property(nonatomic,copy)NSString         *Name;
@property(nonatomic,copy)NSString         *ShortName;
@property(nonatomic,copy)NSString         *Type;
//add model
@property(nonatomic,copy)NSString         *ShortName_1;

@end

NS_ASSUME_NONNULL_END
