//
//  BlockChainCertCell.h
//  ONTO
//
//  Created by 赵伟 on 2018/4/28.
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

typedef NS_ENUM(NSInteger,RoundCornerType)
{
    KKRoundCornerCellTypeTop,
    KKRoundCornerCellTypeBottom,
    KKRoundCornerCellTypeSingleRow,
    KKRoundCornerCellTypeDefault
};
@interface BlockChainCertCell : UITableViewCell
{
    CGFloat _cornerRadius;
}
@property(nonatomic,readwrite,assign)RoundCornerType roundCornerType;
@property(nonatomic,strong)UILabel* titleLB;
@property(nonatomic,strong)UILabel* contentLB;
@property(nonatomic,strong)UILabel* renewLB;
@property(nonatomic,strong)UIImageView * rightImage;
@property(nonatomic,strong)UIView* line;
-(id)initWithCornerRadius:(CGFloat)radius Style:(UITableViewCellStyle)tyle reuseIdentifier:(NSString*)identifier;
@end
