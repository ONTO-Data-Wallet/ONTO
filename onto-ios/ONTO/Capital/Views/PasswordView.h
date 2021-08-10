//
//  SendConfirmView.h
//  ONTO
//
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

@interface PasswordView : UIView

@property (nonatomic, strong) UIView *firstLine;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *bottomWhiteView;
@property (nonatomic, strong) UIButton *closeB;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *inputL;
@property (nonatomic, strong) UIButton *sureB;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) BOOL isIdentity; //是否在身份页面
@property (nonatomic, strong) PwdEnterView *pwdEnterV;

@property (nonatomic, copy) void (^callback)(NSString *);
- (void)showInParentView:(UIView *)parentView ;
- (void)dismiss ;

@end
