//
//  SwapListDetailCell.m
//  ONTO
//
//  Created by Apple on 2018/7/16.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "SwapListDetailCell.h"
#import "Config.h"
@implementation SwapListDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _titleLB =[[UILabel alloc]initWithFrame:CGRectMake(32*SCALE_W, 25*SCALE_W, SYSWidth - 64*SCALE_W, 18*SCALE_W)];
    _titleLB.textAlignment =NSTextAlignmentLeft;
    _titleLB.text =@"状态";
    _titleLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _titleLB.textColor =[UIColor colorWithHexString:@"#6A797C"];
    [self addSubview:_titleLB];
    
    _contentLB =[[UILabel alloc]initWithFrame:CGRectMake(32*SCALE_W, 48*SCALE_W, SYSWidth-64*SCALE_W, 19*SCALE_W)];
    _contentLB.textAlignment =NSTextAlignmentLeft;
    _contentLB.text =@"失败";
    _contentLB.font =[UIFont systemFontOfSize:16];
    _contentLB.textColor =[UIColor colorWithHexString:@"#6A797C"];
    [self addSubview:_contentLB];
    
    _ONTLB =[[UILabel alloc]initWithFrame:CGRectMake(SYSWidth- 32*SCALE_W-40*SCALE_W, 48*SCALE_W, 40*SCALE_W, 19*SCALE_W)];
    _ONTLB.textAlignment =NSTextAlignmentRight;
    _ONTLB.font =[UIFont systemFontOfSize:16];
    _ONTLB.text =@"ONT";
    _ONTLB.hidden =YES;
    _ONTLB.textColor =[UIColor colorWithHexString:@"#6A797C"];
    [self addSubview:_ONTLB];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(32*SCALE_W, 80*SCALE_W-1, SYSWidth-32*SCALE_W, 1)];
    line.backgroundColor =LINEBG;
    [self addSubview:line];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
