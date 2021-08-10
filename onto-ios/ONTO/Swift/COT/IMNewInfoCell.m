//
//  IMNewInfoCell.m
//  ONTO
//
//  Created by Apple on 2018/8/13.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "IMNewInfoCell.h"
#import "Config.h"
@implementation IMNewInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _leftLB = [[UILabel alloc]initWithFrame:CGRectMake(34.5*SCALE_W, 15*SCALE_W, SYSWidth/2 -34.5*SCALE_W, 16*SCALE_W)];
        _leftLB.textColor = [UIColor colorWithHexString:@"#8C9AAB"];
        _leftLB.font =[UIFont systemFontOfSize:14];
        _leftLB.textAlignment =NSTextAlignmentLeft;
        [self addSubview:_leftLB];
        
        _rightLB = [[UILabel alloc]initWithFrame:CGRectMake(SYSWidth/2, 15*SCALE_W, SYSWidth/2 -34.5*SCALE_W, 16*SCALE_W)];
        _rightLB.textColor = [UIColor colorWithHexString:@"#3D5777"];
        _rightLB.font =[UIFont systemFontOfSize:14];
        _rightLB.textAlignment =NSTextAlignmentRight;
        [self addSubview:_rightLB];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(34.5*SCALE_W, 39*SCALE_W -1, SYSWidth -69*SCALE_W, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E2EAF2"];
        [self addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
