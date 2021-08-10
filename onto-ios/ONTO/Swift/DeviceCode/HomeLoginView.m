//
//  HomeLoginView.m
//  ONTO
//
//  Created by Apple on 2018/9/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "HomeLoginView.h"
#import "Config.h"
@implementation HomeLoginView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight - 49)];
    if (self) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    self.backgroundColor = [UIColor redColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
