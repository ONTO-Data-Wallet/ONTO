//
//  SocialAuthCell.h
//  ONTO
//
//  Created by Apple on 2018/6/14.
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
#import "IdentityModel.h"
@interface SocialAuthCell : UITableViewCell
@property(nonatomic,strong)UIView      *bgView;
@property(nonatomic,strong)UIImageView *typeIcon;
@property(nonatomic,strong)UILabel     *typeName;
@property(nonatomic,strong)UILabel     *typeStatus;
@property(nonatomic,strong)UIView      *line;
-(void)reloadIdAuth:(IdentityModel*)model;
@end
