//
//  WalletAddressCell.m
//  ONTO
//
//  Created by Apple on 2018/9/25.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "WalletAddressCell.h"
#import "Config.h"
@implementation WalletAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createWalletUI];
    }
    return self;
}
-(void)createWalletUI{
    _nameField =[[UITextField alloc]initWithFrame:CGRectMake(24*SCALE_W, 7.5*SCALE_W, SYSWidth-48*SCALE_W, 33*SCALE_W)];
    _nameField.tag =1000;
    _nameField.textColor =BLACKLB;
    _nameField.font =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameField];
    
    _keyField =[[UITextField alloc]initWithFrame:CGRectMake(24*SCALE_W, 7.5*SCALE_W+38.5*SCALE_W, SYSWidth-48*SCALE_W, 33*SCALE_W)];
    _keyField.tag =10000;
    _keyField.text = @"";
    _keyField.placeholder  =Localized(@"sharePublicKey");
    _keyField.textColor =BLACKLB;
    _keyField.font =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_keyField];
    
    for (int i=1; i<3; i++) {
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(24*SCALE_W, 38.5*SCALE_W*i, SYSWidth-48*SCALE_W, 1)];
        line.backgroundColor =LINEBG;
        [self.contentView addSubview:line];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
