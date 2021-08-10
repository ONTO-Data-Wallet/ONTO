//
//  MakeIDCell.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/22.
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

#import "MakeIDCell.h"
#import "Config.h"
#import "FrameAccessor.h"
@implementation MakeIDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_selectBtn setImage:[UIImage imageNamed:@"makecard_checkbox"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"makrcard_Check"] forState:UIControlStateSelected];
    [_notReceiveBtn setTitle:Localized(@"Toauthenticate") forState:UIControlStateNormal];
    
}

- (void) setWithIndex:(NSIndexPath*)index withArr:(NSMutableArray*)array{

    bool isCanSelct = ![array[index.section] isEqualToString:@"0"];
 
    
    if (index.section==0) {
         _claimTitle.text = Localized(@"EmploymentCertification");
        if (isCanSelct==YES) {
            
             _iconImage.image = [UIImage imageNamed:@"makrcard_ec"];
        
        }else{
            
            _iconImage.image = [UIImage imageNamed:@"makecard_ec"];
            
        }
      
    }else if (index.section==1){
         _claimTitle.text = Localized(@"LinkedinClaim");
        if (isCanSelct==YES) {
             _iconImage.image = [UIImage imageNamed:@"makrcard_lc"];
        }else{
            _iconImage.image = [UIImage imageNamed:@"makecard_ln"];
        }
       
    }else if (index.section==2){
          _claimTitle.text = Localized(@"GithubClaim");
        if (isCanSelct==YES) {
             _iconImage.image = [UIImage imageNamed:@"makrcard_gc"];
            
        }else{
            _iconImage.image = [UIImage imageNamed:@"makecard_gc"];
           
        }
        
        
    }
    
    if (isCanSelct==YES) {
        
        _selectBtn.selected = YES;
        _notReceiveBtn.hidden=YES;
        _claimTitle.y = 32;
        
    }else{
        
         _selectBtn.enabled = NO;
        _notReceiveBtn.hidden=NO;
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
    // Configure the view for the selected state
}

@end
