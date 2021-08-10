//
//  CardModel.h
//  ONTO
//
//  Created by 赵伟 on 2018/3/26.
/*
 * **************************************************************************************
 *  Copyright © 2014-2018 Ontology Foundation Ltd.
 *  All rights reserved.
 *
 *  This software is supplied only under the terms of a license agreement,
 *  nondisclosure agreement or other written agreement with Ontology Foundation Ltd.
 *  Use, redistribution or other disclosure of any parts of this
 *  software is prohibited except in accordance with the terms of such written
 *  agreement with Ontology Foundation Ltd. This software is confidential
 *  and proprietary information of Ontology Foundation Ltd.
 *
 * **************************************************************************************
 *///

#import <Foundation/Foundation.h>

@interface CardModel : NSObject
@property (nonatomic,copy) NSString *Bio;
@property (nonatomic,copy) NSString *Company;
@property (nonatomic,copy) NSString *Email;
@property (nonatomic,copy) NSString *GistUrl;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *Context;

@end

//Content =                 {
//    Bio = "software engineer";
//    Company = onchain;
//    Email = "leewi9@yahoo.com";
//    GistUrl = "https://gist.github.com/42298ebb0c44054c43f48e1afd763ff6";
//    Name = zhouzhou;
//};
//Context = "claim:github_authentication";

