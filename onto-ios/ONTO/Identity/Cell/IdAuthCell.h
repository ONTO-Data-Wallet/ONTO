//
//  IdAuthCell.h
//  ONTO
//
//  Created by Apple on 2018/6/13.
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
@interface IdAuthCell : UICollectionViewCell
@property(nonatomic,strong)UIView *bgV;
@property(nonatomic,strong)UIImageView * icon;
@property(nonatomic,strong)UILabel * name ;
@property(nonatomic,strong)UILabel * status;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIButton *noticeButton;
-(void)reloadIdAuth:(IdentityModel*)model;
@end
