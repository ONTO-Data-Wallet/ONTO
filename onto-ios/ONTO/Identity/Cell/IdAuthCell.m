//
//  IdAuthCell.m
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

#import "IdAuthCell.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "Config.h"
#import "DataBase.h"
#import "ClaimModel.h"
#import "Common.h"
@implementation IdAuthCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        [self setUpAllChildView];
    }
    return self;
}
-(void)setUpAllChildView{
    _bgV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
//    _bgV.layer.cornerRadius =4;
    [self.contentView addSubview:_bgV];
    
    _icon =[[UIImageView alloc]init];
    _icon.image =[UIImage imageNamed:@"IdHelp"];
    [_bgV addSubview:_icon];
    
    _noticeButton = [[UIButton alloc]init];
    [_noticeButton setImage:[UIImage imageNamed:@"notice"] forState:UIControlStateNormal];
    [_bgV addSubview:_noticeButton];
    
    _name=[[UILabel alloc]init];
    _name.text =@"CFCA";
    _name.textAlignment =NSTextAlignmentCenter;
    _name.font =[UIFont systemFontOfSize:16];
    [_bgV addSubview:_name];
    
    _status =[[UILabel alloc]init];
    _status.text =@"Sep 23,2018";
    _status.textColor =LIGHTGRAYLB;
    _status.font =[UIFont systemFontOfSize:10];
    _status.textAlignment =NSTextAlignmentCenter;
    [_bgV addSubview:_status];
    
    _line =[[UIView alloc]init];
    _line.backgroundColor =GREENLINE;
    [_bgV addSubview:_line];
    [self layoutUI];
}
-(void)layoutUI{
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self.view);
//        make.height.mas_equalTo(@(200 * kScreenWidth / 375));
        make.centerX.equalTo(_bgV);
        make.top.equalTo(_bgV).offset(25*SCALE_W);
        make.width.height.mas_equalTo(58*SCALE_W);
    }];
    
    [_noticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgV);
        make.top.equalTo(_bgV).offset(-2);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_icon.mas_centerX);
        make.top.equalTo(_icon.mas_bottom).offset(8*SCALE_W);
    }];
    
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(_name.mas_centerX);
        make.top.equalTo(_name.mas_bottom).offset(9*SCALE_W);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(_bgV);
    }];
}

-(void)reloadIdAuth:(IdentityModel *)model{
    
    ClaimModel *claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:model.ClaimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];

    if ([model.ClaimContext hasPrefix:@"claim:idm"]) { //claim:sfp
        _name.hidden =YES;
        _noticeButton.hidden =NO;
        [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bgV).offset(60*SCALE_W);
            make.height.mas_equalTo(22*SCALE_W);
            make.width.mas_equalTo(104*SCALE_W);
        }];
        NSArray *AppNativeListArr = [[NSUserDefaults standardUserDefaults]objectForKey:APPAUCHARR];
        
        int num1 =0;
        
        for (NSDictionary *dic in AppNativeListArr) {
            if ([dic[@"ClaimContext"] hasPrefix:@"claim:idm"]) {
                
                ClaimModel *claimmodel1 = [[DataBase sharedDataBase]getCalimWithClaimContext:dic[@"ClaimContext"] andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
                if ([dic[@"IssuedFlag"] integerValue] == 9) {
                    num1++;
                }
                if ([dic[@"IssuedFlag"] integerValue] == 0) {
                    if ([claimmodel1.status integerValue] == 1) {
                        num1 ++;
                    }
                }
            }
        }
        if (num1 ==3) {
            _noticeButton.hidden =YES;
        }
        int num2 =0;
        for (NSDictionary *dic in AppNativeListArr) {
            if ([dic[@"ClaimContext"] hasPrefix:@"claim:idm"]) {
                
                ClaimModel *claimmodel1 = [[DataBase sharedDataBase]getCalimWithClaimContext:dic[@"ClaimContext"] andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
                if ([dic[@"IssuedFlag"] integerValue] == 0) {
                    num2++;
                }
                if ([dic[@"IssuedFlag"] integerValue] == 0) {
                    if ([claimmodel1.status integerValue] == 1) {
                        num2 --;
                    }
                }
            }
        }
        if (num2 ==3) {
            _noticeButton.hidden =YES;
        }
    }else if ([model.ClaimContext hasPrefix:@"claim:sfp"]) { //claim:sfp
        _name.hidden =YES;
        _noticeButton.hidden =NO;
        [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_bgV).offset(60*SCALE_W);
//            make.height.mas_equalTo(22*SCALE_W);
//            make.width.mas_equalTo(104*SCALE_W);
            make.top.equalTo(_bgV).offset(25*SCALE_W);
            make.height.mas_equalTo(84*SCALE_W);
            make.width.mas_equalTo(84*SCALE_W);
        }];
        NSArray *AppNativeListArr = [[NSUserDefaults standardUserDefaults]objectForKey:APPAUCHARR];
        
        int num1 =0;
        
        for (NSDictionary *dic in AppNativeListArr) {
            if ([dic[@"ClaimContext"] hasPrefix:@"claim:sfp"]) {
                
                ClaimModel *claimmodel1 = [[DataBase sharedDataBase]getCalimWithClaimContext:dic[@"ClaimContext"] andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
                if ([dic[@"IssuedFlag"] integerValue] == 9) {
                    num1++;
                }
                if ([dic[@"IssuedFlag"] integerValue] == 0) {
                    if ([claimmodel1.status integerValue] == 1) {
                        num1 ++;
                    }
                }
            }
        }
        if (num1 ==3) {
            _noticeButton.hidden =YES;
        }
        int num2 =0;
        for (NSDictionary *dic in AppNativeListArr) {
            if ([dic[@"ClaimContext"] hasPrefix:@"claim:sfp"]) {
                
                ClaimModel *claimmodel1 = [[DataBase sharedDataBase]getCalimWithClaimContext:dic[@"ClaimContext"] andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
                if ([dic[@"IssuedFlag"] integerValue] == 0) {
                    num2++;
                }
                if ([dic[@"IssuedFlag"] integerValue] == 0) {
                    if ([claimmodel1.status integerValue] == 1) {
                        num2 --;
                    }
                }
            }
        }
        if (num2 ==3) {
            _noticeButton.hidden =YES;
        }
    }
    else{
        _noticeButton.hidden =YES;
        if ([model.ClaimContext hasPrefix:@"claim:sensetime"]) {
            _name.hidden =YES;
            [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgV).offset(39.5*SCALE_W);
                make.height.mas_equalTo(70*SCALE_W);
                make.width.mas_equalTo(70*SCALE_W);
            }];
        }else{
            
            
            [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgV).offset(25*SCALE_W);
                make.height.mas_equalTo(58*SCALE_W);
                make.width.mas_equalTo(58*SCALE_W);
            }];
        }
        
    }
    _name.text =model.Name;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.Logo]];
    if ([model.IsComing integerValue]==1) {
        _icon.alpha =0.3;
        if ([model.ClaimContext hasPrefix:@"claim:idm"]) {
            _icon.alpha =1.0;
        }
        if ([model.ClaimContext hasPrefix:@"claim:sfp"]) {
            _icon.alpha =1.0;
        }
        _bgV.backgroundColor =[UIColor whiteColor];
        _bgV.layer.cornerRadius =4.f;
        _bgV.layer.borderWidth =1.f;
        _bgV.layer.borderColor =[[UIColor colorWithHexString:@"#EDF2F5"]CGColor];
        _line.hidden =YES;
        _name.textColor =LIGHTGRAYLB;
        _status.text = Localized(@"IdComing");
        _status.textColor =LIGHTGRAYLB;
    }else{
        if ([model.ClaimContext hasPrefix:@"claim:idm"]) {//
            _icon.alpha =1.0;
            _bgV.backgroundColor =LIGHTGRAYBG;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _bgV.bounds;
            maskLayer.path = maskPath.CGPath;
            _bgV.layer.mask = maskLayer;
            _bgV.layer.borderWidth =0.f;
            _status.hidden =YES;
            _line.hidden =YES;
            
        }else if ([model.ClaimContext hasPrefix:@"claim:sfp"]) {//claim:sfp
            _icon.alpha =1.0;
            _bgV.backgroundColor =LIGHTGRAYBG;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _bgV.bounds;
            maskLayer.path = maskPath.CGPath;
            _bgV.layer.mask = maskLayer;
            _bgV.layer.borderWidth =0.f;
            _status.hidden =YES;
            _line.hidden =YES;
            
        }
        else{
            if ([model.ClaimContext hasPrefix:@"claim:sensetime"]){
                _name.text =@"";
            }else{
                _name.hidden =NO;
            }
            _icon.alpha =1.0;
            _bgV.backgroundColor =LIGHTGRAYBG;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _bgV.bounds;
            maskLayer.path = maskPath.CGPath;
            _bgV.layer.mask = maskLayer;
            _bgV.layer.borderWidth =0.f;
            _name.textColor =LIGHTGRAYLB;
            
            _status.text =@"";
            _status.textColor =LIGHTGRAYLB;
            
            _status.hidden =NO;
            _line.hidden =YES;
            //        NSLog(@"%d -- %d",model.IssuedFlag,claimmodel.status);
            NSInteger issuedflag =[model.IssuedFlag integerValue] ;
            NSDictionary* dic =[Common dictionaryWithJsonString:claimmodel.Content];
            NSString *expTime;
            if (dic.count!=0) {
                NSDictionary* dic1 =[Common claimdencode:dic[@"EncryptedOrigData"]];
                NSDictionary* dic2 =dic1[@"claim"];
                expTime =dic2[@"exp"];
            }else{
//                return;
            }
            if (issuedflag==0 && [claimmodel.status integerValue]!=1 ) {
                _icon.alpha = 0.3;
                _line.hidden =YES;
                _status.text =@"";
                _line.hidden =YES;
            }else if (issuedflag==0 && [claimmodel.status integerValue]==1){
                NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
                NSTimeInterval time=[date timeIntervalSince1970];
                NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
                
                if ([timeString integerValue] >= [expTime integerValue]) {
                    _status.text =Localized(@"IdExpired");
                    _icon.alpha = 0.3;
                    _status.textColor = [UIColor colorWithHexString:@"#B41F3C"];
                    _line.hidden =YES;
                }else{
                    
                    NSString * newTimeString = [Common getTimeFromTimestamp:expTime];
                    if (newTimeString.length>=10) {
                        _status.text =[newTimeString substringToIndex:10];
                    }else{
                        _status.text =@"";
                    }
                    
                    _line.hidden =NO;
                    _icon.alpha = 1.0;
                    _status.textColor =LIGHTGRAYLB;
                    _name.textColor =BLACKLB;
                }
            }else if (issuedflag == 3){
                _status.text =Localized(@"IdProgress");
                _status.textColor = [UIColor colorWithHexString:@"#FF9A49"];
                _line.hidden =YES;
                _icon.alpha = 0.3;
            }else if (issuedflag ==9 ){
//                _status.text =[[Common getTimeFromTimestamp:expTime]substringToIndex:10];
//                NSString * newTimeString = [Common getTimeFromTimestamp:expTime];
//                if (newTimeString.length>=10) {
//                    _status.text =[newTimeString substringToIndex:10];
//                }else{
//                    _status.text =@"";
//                }
                _status.text = Localized(@"calimDone");
                _line.hidden =NO;
                _icon.alpha = 1.0;
                _status.textColor =LIGHTGRAYLB;
                _name.textColor =BLACKLB;
            }else if (issuedflag ==8 ){
                _status.text = Localized(@"Claimstatus22");
                _line.hidden =YES;
                _icon.alpha = 1.0;
                _status.textColor =[UIColor colorWithHexString:@"#EE2C44"];
                _name.textColor =BLACKLB;
            }
        }
        
        
    }
}
@end
