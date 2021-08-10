//
//  shareManagerCell.m
//  ONTO
//
//  Created by Apple on 2018/7/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "shareManagerCell.h"
#import "Config.h"
@implementation shareManagerCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        [self setUpAllChildView];
    }
    return self;
}
-(void)setUpAllChildView{
    _typeImage =[[UIImageView alloc]init];
    _typeImage.image =[UIImage imageNamed:@"newWallet"];
    [self addSubview:_typeImage];
    
    _typeLB =[[UILabel alloc]init];
    _typeLB.textAlignment =NSTextAlignmentCenter;
    _typeLB.numberOfLines =0;
    _typeLB.textColor = BLACKLB;
    _typeLB.font =[UIFont systemFontOfSize:12];
    _typeLB.text =@"Wallet One Wallet One";
    [self addSubview:_typeLB];
    
    [self layoutUI];
}
-(void)layoutUI{
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20*SCALE_W);
        make.centerX.equalTo(self);
        make.width.height.mas_offset(63*SCALE_W);
    }];
    
    [_typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeImage.mas_bottom).offset(7*SCALE_W);
        make.centerX.equalTo(self);
        make.width.mas_offset(80*SCALE_W);
        
    }];
}
-(void)sizeToFitHeight:(NSString *)string{
    NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize size=[string boundingRectWithSize:CGSizeMake(80*SCALE_W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    [_typeLB mas_updateConstraints:^(MASConstraintMaker *make) {
        if (size.height >30) {
            make.height.mas_offset(30);
        }else{
            make.height.mas_offset(size.height+5);
        }
        
    }];
}
@end
