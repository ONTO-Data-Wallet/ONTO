//
//  CreateView.h
//  ONTO
//
//  Created by Zeus.Zhang on 2018/2/24.
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

@interface CreateView : UIView

@property (nonatomic, copy) NSString *qrcode_str;
@property (nonatomic, strong) UIImageView *imageV;
@end
