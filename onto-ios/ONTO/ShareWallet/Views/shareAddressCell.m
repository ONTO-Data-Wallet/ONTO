//
//  shareAddressCell.m
//  ONTO
//
//  Created by Apple on 2018/7/10.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "shareAddressCell.h"
#import "Config.h"
@implementation shareAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createAddressUI];
    }
    return self;
}
-(void)createAddressUI{
    UIImageView* leftImage =[[UIImageView alloc]initWithFrame:CGRectMake(24*SCALE_W, 13.5*SCALE_W, 6*SCALE_W, 6*SCALE_W)];
    leftImage.backgroundColor =BLUELB;
    leftImage.layer.cornerRadius =3*SCALE_W;
    [self addSubview:leftImage];
    
    _nameLB =[[UILabel alloc]initWithFrame:CGRectMake(35*SCALE_W, 7.5*SCALE_W, SYSWidth-59*SCALE_W, 18*SCALE_W)];
    _nameLB.textColor = BLACKLB ;
    _nameLB.textAlignment =NSTextAlignmentLeft;
    _nameLB.font =[UIFont systemFontOfSize:14];
    [self addSubview:_nameLB];
    
    _addressLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 7.5*SCALE_W+22*SCALE_W, SYSWidth-48*SCALE_W, 18*SCALE_W)];
    _addressLB.textColor = BLACKLB ;
    _addressLB.textAlignment =NSTextAlignmentLeft;
    _addressLB.font =[UIFont systemFontOfSize:12];
    [self addSubview:_addressLB];
    
    _rightImage =[[UIImageView alloc]initWithFrame:CGRectMake(SYSWidth-40*SCALE_W, 8.5*SCALE_W, 16*SCALE_W, 16*SCALE_W)];
    _rightImage.image =[UIImage imageNamed:@"sharelight_gray"];
    _rightImage.hidden=YES;
    [self addSubview:_rightImage];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
