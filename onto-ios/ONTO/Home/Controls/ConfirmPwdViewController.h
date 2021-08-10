//
//  ConfirmPwdViewController.h
//  ONTO
//
//  Created by 张超 on 2018/3/11.
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

#import "BaseViewController.h"
@protocol GetCalimProtocol <NSObject>

@optional

- (void)getCalim:(NSString*)password;
@end

@interface ConfirmPwdViewController : BaseViewController

@property (nonatomic, copy) NSString *encryptedStr;
@property (nonatomic, copy) NSString *identityName;
@property (nonatomic, copy) NSString *prefix;

@property (nonatomic, assign) BOOL isClaims;
//@property(copy,nonatomic)void(^passValueBlock)(NSString* password);
@property (nonatomic, assign) BOOL isWallet;
@property (nonatomic, copy) NSString *ontID;
@property (nonatomic, copy) NSString *walladdress;


@property (nonatomic, assign) BOOL isHideLeft;
@property (nonatomic, assign) BOOL isDigitalIdentity;
@property (nonatomic, copy) NSDictionary *identityDic;
@property (nonatomic, assign) BOOL isIdentity;
@property (nonatomic, copy)NSString *name;

@property (nonatomic, assign) BOOL ismnenomix;

@property (nonatomic, weak) id<GetCalimProtocol> delegate;

@end
