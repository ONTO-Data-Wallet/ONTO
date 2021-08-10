//
//  SocialAuthCell.m
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

#import "SocialAuthCell.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "Config.h"
#import "DataBase.h"
#import "ClaimModel.h"
#import "Common.h"
@implementation SocialAuthCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(16*SCALE_W, 16*SCALE_W, SYSWidth-32*SCALE_W, 88*SCALE_W)];
        _bgView.backgroundColor = LIGHTGRAYBG;
        [self.contentView addSubview:_bgView];
        
        _typeIcon =[[UIImageView alloc]init];
        _typeIcon.image =[UIImage imageNamed:@"IdHelp"];
        [_bgView addSubview:_typeIcon];
        
        _typeName =[[UILabel alloc]init];
        _typeName.font =[UIFont systemFontOfSize:18];
        _typeName.text =@"Facebook";
        _typeName.textAlignment =NSTextAlignmentLeft;
        [_bgView addSubview:_typeName];
        
        _typeStatus =[[UILabel alloc]init];
        _typeStatus.text =@"";
        _typeStatus.font =[UIFont systemFontOfSize:12];
        _typeStatus.textAlignment =NSTextAlignmentRight;
        [_bgView addSubview:_typeStatus];
        
        _line =[[UIView alloc]init];
        _line.backgroundColor =GREENLINE;
        _line.hidden =YES;
        [_bgView addSubview:_line];
        
        [self layoutUI];
    }
    return self;
}
-(void)layoutUI{
    [_typeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(16*SCALE_W);
        make.centerY.equalTo(_bgView.mas_centerY);
        make.width.height.mas_offset(34*SCALE_W);
    }];
    
    [_typeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeIcon.mas_right).offset(12*SCALE_W);
        make.centerY.equalTo(_bgView.mas_centerY);
        make.width.mas_offset(120*SCALE_W);
    }];
    
    [_typeStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgView.mas_right).offset(-19*SCALE_W);
        make.centerY.equalTo(_bgView.mas_centerY);
        make.width.mas_offset(SYSWidth -32*SCALE_W -200*SCALE_W);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView.mas_right).offset(-2);
        make.top.bottom.equalTo(_bgView);
        make.width.mas_offset(2);
    }];
}
-(void)reloadIdAuth:(IdentityModel *)model{
    _typeName.text = model.Name;
    [_typeIcon sd_setImageWithURL:[NSURL URLWithString:model.Logo]];
    
     ClaimModel *claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:model.ClaimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
    NSInteger issuedflag =[model.IssuedFlag integerValue] ;
    NSDictionary* dic =[Common dictionaryWithJsonString:claimmodel.Content];
    NSString* expTime;
    if (dic.count!=0) {
        NSDictionary* dic1 =[Common claimdencode:dic[@"EncryptedOrigData"]];
        NSDictionary* dic2 =dic1[@"claim"];
        expTime =dic2[@"exp"];
    }else{
//        return;
    }
    
    _typeName.textColor =LIGHTGRAYLB;
    _line.hidden =YES;
    _typeStatus.text =@"";
    _typeStatus.textColor =LIGHTGRAYLB;
    
    if (issuedflag==0 && [claimmodel.status integerValue]!=1 ) {
        _typeStatus.text =@"";
        _bgView.layer.cornerRadius = 4;
        _typeIcon.alpha = 0.3;
    }else if (issuedflag==0 && [claimmodel.status integerValue]==1){
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
        NSTimeInterval time=[date timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
        if ([timeString integerValue] >= [expTime integerValue]) {
            _typeStatus.text =Localized(@"IdExpired");
            _typeStatus.textColor = [UIColor colorWithHexString:@"#B41F3C"];
            _typeIcon.alpha = 0.3;
        }else{
            
            NSString * newTimeString = [Common getTimeFromTimestamp:expTime];
            if (newTimeString.length>=10) {
                _typeStatus.text =[NSString stringWithFormat:Localized(@"IdExpiredTime"),[newTimeString substringToIndex:10]];
            }else{
                _typeStatus.text =@"";
            }
            
//            NSString * timeStr =[[Common getTimeFromTimestamp:expTime] substringToIndex:10];
//            _typeStatus.text =[NSString stringWithFormat:Localized(@"IdExpiredTime"),timeStr];
            _line.hidden =NO;
            _typeIcon.alpha = 1.0;
            _typeStatus.textColor =LIGHTGRAYLB;
            _typeName.textColor =BLACKLB;
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _bgView.bounds;
            maskLayer.path = maskPath.CGPath;
            _bgView.layer.mask = maskLayer;
        }
    }else if (issuedflag == 3){
        _typeStatus.text =Localized(@"IdProgress");
        _typeStatus.textColor = [UIColor colorWithHexString:@"#FF9A49"];
        _bgView.layer.cornerRadius = 4;
        _typeIcon.alpha = 0.3;
    }else if (issuedflag ==9 ){
//        NSString * timeStr =[[Common getTimeFromTimestamp:expTime] substringToIndex:10];
//        _typeStatus.text =[NSString stringWithFormat:Localized(@"IdExpiredTime"),timeStr];
//        NSString * newTimeString = [Common getTimeFromTimestamp:expTime];
//        if (newTimeString.length>=10) {
//            _typeStatus.text =[NSString stringWithFormat:Localized(@"IdExpiredTime"),[newTimeString substringToIndex:10]];
//        }else{
//            _typeStatus.text =@"";
//        }
        _typeStatus.text = Localized(@"calimDone");
        _line.hidden =NO;
        _typeIcon.alpha = 1.0;
        _typeStatus.textColor =LIGHTGRAYLB;
        _typeName.textColor =BLACKLB;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
