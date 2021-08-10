//
//  SuccessView.h
//  ONTO
//
//  Created by 张超 on 2018/3/10.
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

@interface SuccessView : UIView

@property (nonatomic, assign) BOOL isWallet;

- (instancetype)initWithFrame:(CGRect)frame Success:(BOOL)isSuccess;
@property (nonatomic,strong)UILabel *successL;
@property (nonatomic,strong)UILabel *successContentL;
@end
