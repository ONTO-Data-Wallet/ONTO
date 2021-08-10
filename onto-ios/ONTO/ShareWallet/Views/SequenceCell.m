//
//  SequenceCell.m
//  ONTO
//
//  Created by Apple on 2018/7/18.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "SequenceCell.h"
#import "Config.h"
@implementation SequenceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    UIImageView *numImage =[[UIImageView alloc]initWithFrame:CGRectMake(20*SCALE_W, 11*SCALE_W, 17*SCALE_W, 17*SCALE_W)];
    numImage.image =[UIImage imageNamed:@"sharecircleblue"];
    [self addSubview:numImage];
    
    _numLB =[[UILabel alloc]initWithFrame:CGRectMake(20*SCALE_W, 11*SCALE_W, 17*SCALE_W, 17*SCALE_W)];
    _numLB.textColor =BLUELB;
    _numLB.textAlignment =NSTextAlignmentCenter;
    _numLB.text=@"1";
    _numLB.font =[UIFont systemFontOfSize:12 ];
    [self addSubview:_numLB];
    
    _nameLB =[[UILabel alloc]initWithFrame:CGRectMake(41*SCALE_W, 12*SCALE_W, SYSWidth-61*SCALE_W, 15*SCALE_W)];
    _nameLB.textAlignment =NSTextAlignmentLeft;
    _nameLB.textColor =BLACKLB;
    _nameLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _nameLB.text =@"Zhao";
    [self addSubview:_nameLB];
    
    _addressLB =[[UILabel alloc]initWithFrame:CGRectMake(41*SCALE_W, 33*SCALE_W, SYSWidth-61*SCALE_W, 15*SCALE_W)];
    _addressLB.textAlignment =NSTextAlignmentLeft;
    _addressLB.textColor =BLACKLB;
    _addressLB.font =[UIFont systemFontOfSize:12];
    _addressLB.text =[NSString stringWithFormat:@"%@ %@",Localized(@"shareAddress"),@"12DfP6nSw1ZCJwJiqjEYHVxwfoz2y2MKmv"];
    [self addSubview:_addressLB];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 60*SCALE_W-1, SYSWidth, 1)];
    line.backgroundColor =LINEBG;
    [self addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
