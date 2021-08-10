//
//  ShareWalletCell.m
//  ONTO
//
//  Created by Apple on 2018/7/9.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ShareWalletCell.h"
#import "Config.h"
@implementation ShareWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createWalletUI];
    }
    return self;
}
-(void)createWalletUI{
    _titleLB =[[UILabel alloc]init];
//    _titleLB.text = @"Shared Wallet Name";
    _titleLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _titleLB.textAlignment =NSTextAlignmentLeft;
    _titleLB.textColor =BLACKLB ;
    [self.contentView addSubview:_titleLB];
    
    _nameField =[[UITextField alloc]init];
    _nameField.font =[UIFont systemFontOfSize:14];
    _nameField.textColor =BLACKLB;
    _nameField.hidden =YES;
//    _nameField.placeholder =Localized(@"ShareWalletNamePlaceholder");
    [self.contentView addSubview:_nameField];
    
    [_totalNumField removeFromSuperview];
    _totalNumField =[[UITextField alloc]init];
    _totalNumField.font =[UIFont systemFontOfSize:14];
    _totalNumField.textColor =BLACKLB;
    _totalNumField.hidden =YES;
    _totalNumField.userInteractionEnabled =NO;
//    _totalNumField.placeholder =Localized(@"ShareSelect");
    [self.contentView addSubview:_totalNumField];
    
    [_requiredNumField removeFromSuperview];
    _requiredNumField =[[UITextField alloc]init];
    _requiredNumField.font =[UIFont systemFontOfSize:14];
    _requiredNumField.textColor =BLACKLB;
    _requiredNumField.hidden =YES;
    _requiredNumField.userInteractionEnabled =NO;
//    _requiredNumField.placeholder =Localized(@"ShareSelect");
    [self.contentView addSubview:_requiredNumField];
    
    _addressField =[[UITextField alloc]init];
    _addressField.font =[UIFont systemFontOfSize:14];
    _addressField.textColor =BLACKLB;
    _addressField.hidden =YES;
    _addressField.userInteractionEnabled =NO;
    _addressField.placeholder =Localized(@"ShareAdd");
    [self.contentView addSubview:_addressField];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(24*SCALE_W, 68*SCALE_W, SYSWidth -48*SCALE_W, 1)];
    line.backgroundColor =LINEBG;
    [self.contentView addSubview:line];
    
    _rightImage =[[UIImageView alloc]init];
    _rightImage.image =[UIImage imageNamed:@"sharelight_gray"];
    [self.contentView addSubview:_rightImage];
    
    [self masonryUI];
    
}
-(void)masonryUI{
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20*SCALE_W);
        make.left.equalTo(self.contentView).offset(24*SCALE_W);
        make.right.equalTo(self.contentView).offset(-24*SCALE_W);
    }];
    
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(46*SCALE_W);
        make.left.equalTo(self.contentView).offset(24*SCALE_W);
        make.right.equalTo(self.contentView).offset(-24*SCALE_W);
    }];
    
    [_totalNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(46*SCALE_W);
        make.left.equalTo(self.contentView).offset(24*SCALE_W);
        make.right.equalTo(self.contentView).offset(-24*SCALE_W);
    }];
    
    [_requiredNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(46*SCALE_W);
        make.left.equalTo(self.contentView).offset(24*SCALE_W);
        make.right.equalTo(self.contentView).offset(-24*SCALE_W);
    }];
    
    [_addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(46*SCALE_W);
        make.left.equalTo(self.contentView).offset(24*SCALE_W);
        make.right.equalTo(self.contentView).offset(-24*SCALE_W);
    }];
    
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameField.mas_centerY);
        make.right.equalTo(self.contentView).offset(-24*SCALE_W);
        make.height.width.mas_offset(16*SCALE_W);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
