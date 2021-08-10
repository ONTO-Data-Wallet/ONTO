//
//  IMNewDetailCell.m
//  ONTO
//
//  Created by Apple on 2018/8/13.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "IMNewDetailCell.h"
#import "Config.h"
@implementation IMNewDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _topLB = [[UILabel alloc]initWithFrame:CGRectMake(32*SCALE_W, 17*SCALE_W, SYSWidth -48*SCALE_W, 16*SCALE_W)];
        _topLB.textColor = [UIColor colorWithHexString:@"#6A797C"];
        _topLB.font =[UIFont systemFontOfSize:14];
        _topLB.textAlignment =NSTextAlignmentLeft;
        [self addSubview:_topLB];
        
        _bottomLB = [[UILabel alloc]initWithFrame:CGRectMake(32*SCALE_W , 40*SCALE_W, SYSWidth -48*SCALE_W, 34*SCALE_W)];
        _bottomLB.textColor = [UIColor colorWithHexString:@"#2B4040"];
        _bottomLB.numberOfLines =0;
        _bottomLB.font =[UIFont systemFontOfSize:14];
        _bottomLB.textAlignment =NSTextAlignmentLeft;
        [self addSubview:_bottomLB];
        
        _rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(SYSWidth -32*SCALE_W, 17*SCALE_W, 16*SCALE_W, 16*SCALE_W)];
        [_rightBtn setImage:[UIImage imageNamed:@"IdRight"] forState:UIControlStateNormal];
        _rightBtn.hidden =YES;
        [self addSubview:_rightBtn];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(32*SCALE_W, 80*SCALE_W -1, SYSWidth -32*SCALE_W, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F6F8F9"];
        [self addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
