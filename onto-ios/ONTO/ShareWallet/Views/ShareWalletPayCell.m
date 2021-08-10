//
//  ShareWalletPayCell.m
//  ONTO
//
//  Created by Apple on 2018/7/13.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ShareWalletPayCell.h"
#import "Config.h"
@implementation ShareWalletPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _statusImage =[[UIImageView alloc]init];
    _statusImage.image =[UIImage imageNamed:@"sharecircleblue"];
    [self addSubview:_statusImage];
    
    _indexLB =[[UILabel alloc]init];
    _indexLB.textAlignment =NSTextAlignmentCenter;
    _indexLB.text =@"1";
    _indexLB.font =[UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    _indexLB.textColor =BLUELB;
    [self addSubview:_indexLB];
    
    _nameLB =[[UILabel alloc]init];
    _nameLB.textAlignment =NSTextAlignmentLeft;
    _nameLB.text=@"Xiao";
    _nameLB.font =[UIFont systemFontOfSize:14];
    _nameLB.textColor =BLACKLB;
    [self addSubview:_nameLB];
    
    _addressLB =[[UILabel alloc]init];
    _addressLB.textAlignment =NSTextAlignmentLeft;
    _addressLB.font =[UIFont systemFontOfSize:12];
//    _addressLB.numberOfLines =0;
    _addressLB.text =[NSString stringWithFormat:@"%@ 12DfP6nSw1ZCJwJiqjEYHVxwfoz2y2MKmv",Localized(@"shareAddress")];//@"Address: 12DfP6nSw1ZCJwJiqjEYHVxwfoz2y2MKmv";
    _addressLB.textColor =BLACKLB;
    [self addSubview:_addressLB];
    
    _sentButton =[[UIButton alloc]init];
    _sentButton.layer.cornerRadius =1;
    [_sentButton setTitle:Localized(@"ShareSent") forState:UIControlStateNormal];
    [_sentButton setTitleColor:BLUELB forState:UIControlStateNormal];
    _sentButton.titleLabel.font =[UIFont systemFontOfSize:12];
    _sentButton.backgroundColor =LIGHTGRAYBG;
//    [self addSubview:_sentButton];
    
    _line =[[UIView alloc]init];
    _line.backgroundColor =LINEBG;
    [self addSubview:_line];
    
    _topBlueLine =[[DashLine alloc]initWithFrame:CGRectMake(24*SCALE_W, 0, 1*SCALE_W, 14*SCALE_W) withLineLength:3*SCALE_W withLineSpacing:2*SCALE_W withLineColor:BLUELB];
    _topBlueLine.hidden =YES;
    [self addSubview:_topBlueLine];
    _topGrayLine =[[DashLine alloc]initWithFrame:CGRectMake(24*SCALE_W, 0, 1*SCALE_W, 14*SCALE_W) withLineLength:3*SCALE_W withLineSpacing:2*SCALE_W withLineColor:LIGHTGRAYLB];
    _topGrayLine.hidden =YES;
    [self addSubview:_topGrayLine];
    _bottomBlueLine =[[DashLine alloc]initWithFrame:CGRectMake(24*SCALE_W, 31*SCALE_W, 1*SCALE_W, 37*SCALE_W) withLineLength:3*SCALE_W withLineSpacing:2*SCALE_W withLineColor:BLUELB];
    _bottomBlueLine.hidden =YES;
    [self addSubview:_bottomBlueLine];
    _bottomGrayLine =[[DashLine alloc]initWithFrame:CGRectMake(24*SCALE_W, 31*SCALE_W, 1*SCALE_W, 37*SCALE_W) withLineLength:3*SCALE_W withLineSpacing:2*SCALE_W withLineColor:LIGHTGRAYLB];
    _bottomGrayLine.hidden =YES;
    [self addSubview:_bottomGrayLine];
    
    [_statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16*SCALE_W);
        make.top.equalTo(self).offset(14*SCALE_W);
        make.width.height.mas_offset(17*SCALE_W);
    }];
    
    [_indexLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16*SCALE_W);
        make.top.equalTo(self).offset(14*SCALE_W);
        make.width.height.mas_offset(17*SCALE_W);
    }];
    
    [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusImage.mas_right).offset(10*SCALE_W);
        make.centerY.equalTo(_statusImage);
    }];

    [_addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusImage.mas_right).offset(10*SCALE_W);
        make.right.equalTo(self).offset(-38*SCALE_W);
        make.top.equalTo(_statusImage.mas_bottom).offset(9*SCALE_W);
    }];
//
//    [_sentButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-16*SCALE_W);
//        make.centerY.equalTo(_statusImage);
//        make.width.mas_offset(48*SCALE_W);
//        make.height.mas_offset(20*SCALE_W);
//    }];
//
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(38*SCALE_W);
        make.right.equalTo(self).offset(-38*SCALE_W);
        make.top.equalTo(self.contentView.mas_bottom).offset(-1);
        make.height.mas_offset(1);
    }];
    

}
-(void)reloadCellByDic:(copayerSignModel *)dic row:(NSInteger)row nowRow:(NSInteger)nowRow{
    _indexLB.text =[NSString stringWithFormat:@"%ld",row+1];
    if (row <=nowRow) {
        [_statusImage setImage:[UIImage imageNamed:@"sharecircleblue"]];
        _indexLB.textColor =BLUELB;
        _addressLB.textColor =BLACKLB;
        _nameLB.textColor =BLACKLB;
        if (row==0) {
            _topGrayLine.hidden=YES;
            _topBlueLine.hidden =YES;
            _bottomBlueLine.hidden=NO;
            _bottomGrayLine.hidden =YES;
        }else{
            _topGrayLine.hidden =YES;
            _bottomGrayLine.hidden =YES;
            _topBlueLine.hidden=NO;
            _bottomBlueLine.hidden=NO;
        }
        if (row ==nowRow) {
            _bottomGrayLine.hidden=NO;
        }
    }else{
        [_statusImage setImage:[UIImage imageNamed:@"sharecirclegray"]];
        _indexLB.textColor = LIGHTGRAYLB;
        _addressLB.textColor =LIGHTGRAYLB;
        _nameLB.textColor =LIGHTGRAYLB;
        _topGrayLine.hidden=NO;
        _bottomGrayLine.hidden=NO;
    }
    _nameLB.text=dic.name;
    _addressLB.text =[NSString stringWithFormat:@"%@",dic.address];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
