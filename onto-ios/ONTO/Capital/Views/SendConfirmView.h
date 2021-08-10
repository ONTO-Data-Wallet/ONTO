//
//  SendConfirmView.h
//  ONTO
//
//  Created by 张超 on 2018/3/25.
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

#import <UIKit/UIKit.h>
#import "PwdEnterView.h"

@interface SendConfirmView : UIView

@property (nonatomic, strong) UIView *confirmV;
@property (nonatomic, strong) UIButton *closeB;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *amountL;
@property (nonatomic, strong) UILabel *paytoL;
@property (nonatomic, strong) UILabel *paybyL;
@property (nonatomic, strong) UILabel *feeL;
@property (nonatomic, strong) UILabel *feeMoneyL;
@property (nonatomic, strong) UIButton *confirmB;

@property (nonatomic, strong) UIView *passwordV;
@property (nonatomic, strong) UILabel *inputL;
@property (nonatomic, strong) UIButton *sureB;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *paytoStr;
@property (nonatomic, copy) NSString *paybyStr;
@property (nonatomic, copy) NSString *amountStr;
@property (nonatomic, copy) NSString *feemoneyStr;
@property (nonatomic, assign) BOOL isCapital; //是否在资产页面
@property (nonatomic, assign) BOOL isWalletBack; //是否在钱包备份页面
@property (nonatomic, assign) BOOL isIdentity; //是否在身份页面
@property (nonatomic, strong) PwdEnterView *pwdEnterV;

@property (nonatomic, assign) BOOL isOng;
@property (nonatomic, assign) BOOL isPum;
@property (nonatomic, assign) BOOL isDragon;
@property (nonatomic, copy) NSString *pumType;
@property (nonatomic, copy) NSString *tokenType;
@property (nonatomic,assign) BOOL isOEP4;
@property (nonatomic,strong) NSDictionary *tokenDict;
@property (nonatomic, copy) void (^callback)(NSString *,NSString *,NSString *,NSString *,NSString *);

- (void)show;
- (void)dismiss;
@end
