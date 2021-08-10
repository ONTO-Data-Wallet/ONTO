//
//  CardDetailCell.m
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

#import "CardDetailCell.h"
#import "CardModel.h"
#import "Config.h"
@implementation CardDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(NSDictionary*)dic1{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dic1];
    
    _trustLabel.text = Localized(@"OnchainTrust");
    
    if ([[dic valueForKey:@"Context"]isEqualToString:@"claim:employment_authentication"]) {
       self.mainLabel.text = Localized(@"Onchain");
        _dagouImage.hidden = NO;
        _rihgtImage.hidden = YES;
      _trustLabel.text = Localized(@"OnchainTrust1");
        
        _leftImage.image = [UIImage imageNamed:@"onchain"];
    }
  else  if ([[dic valueForKey:@"Context"]isEqualToString:@"claim:linkedin_authentication"]) {
       self.mainLabel.text = Localized(@"Linkedin1");
           _leftImage.image = [UIImage imageNamed:@"LN"];
    }
  else  if ([[dic valueForKey:@"Context"]isEqualToString:@"claim:github_authentication"]) {
      self.mainLabel.text = Localized(@"Github1");
           _leftImage.image = [UIImage imageNamed:@"Github"];
    }
  else  if ([[dic valueForKey:@"Context"]isEqualToString:@"claim:facebook_authentication"]) {
           _leftImage.image = [UIImage imageNamed:@"F"];
       self.mainLabel.text = Localized(@"Facebook1");
    }
 else   if ([[dic valueForKey:@"Context"]isEqualToString:@"claim:twitter_authentication"]) {
           _leftImage.image = [UIImage imageNamed:@"Twitter1"];
      self.mainLabel.text = Localized(@"twitter");
    }
    
//     = "Twitter";
//     = "Linkedin";
//     = "Github";
//     = "Facebook";

    
    
    [dic removeObjectForKey:@"Context"];
    NSArray *keyArr = [dic allKeys];
    NSArray *valueArr = [dic allValues];
    
    NSMutableArray *titleArr = [NSMutableArray array];
    
    for (int i=0; i<keyArr.count; i++) {
        
        [titleArr addObject:[NSString stringWithFormat:@"%@: %@",keyArr[i],valueArr[i]]];
    }
    NSString *tempString = [titleArr componentsJoinedByString:@"\n"];//分隔符逗号
    
    _subLabel1.text = tempString;
    
}


- (void)setFrame:(CGRect)frame{
    
    CGRect f = frame;
    f.origin.x = 10;
    f.size.width = frame.size.width - 20;
    [super setFrame:f];
}


@end
