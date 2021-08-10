//
//  AnimationView.m
//  ONTO
//
//  Created by 张超 on 2018/3/9.
/*
 * **************************************************************************************
 *  Copyright © 2014-2018 Ontology Foundation Ltd.
 *  All rights reserved.
 *
 *  This software is supplied only under the terms of a license agreement,
 *  nondisclosure agreement or other written agreement with Ontology Foundation Ltd.
 *  Use, redistribution or other disclosure of any parts of this
 *  software is prohibited except in accordance with the terms of such written
 *  agreement with Ontology Foundation Ltd. This software is confidential
 *  and proprietary information of Ontology Foundation Ltd.
 *
 * **************************************************************************************
 *///

#import "AnimationView.h"
#import "Config.h"

@implementation AnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static int i = 20;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bg =[[UIImageView alloc]initWithFrame:frame];
        bg.image =[UIImage imageNamed:@"cycle_bg"];
        [self addSubview:bg];
        
        self.imageV = [[UIImageView alloc] initWithFrame:frame];
        self.imageV.image = [UIImage imageNamed:@"cycle_line"];
        [self addSubview:self.imageV];
        
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.timeL = [[UILabel alloc] init];
//        self.timeL.text = @"20s";
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.font = [UIFont systemFontOfSize:24];
        self.timeL.textColor = [UIColor colorWithHexString:@"#35BFDF"];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"20s"];
        [str addAttribute:NSFontAttributeName value:K16FONT range:NSMakeRange(str.length - 1, 1)];
        self.timeL.attributedText = str;
        [self addSubview:self.timeL];
        
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self startAnimation];
    }
      i = 20;
    return self;
}

- (void)startAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [_imageV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (void)timerAction {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ds",i]];
    [str addAttribute:NSFontAttributeName value:K16FONT range:NSMakeRange(str.length - 1, 1)];
    self.timeL.attributedText = str;
    i--;
    if (i==0) {
        [self.timer invalidate];
      
        if(_callback) {
            _callback();
        }
    }
}

- (void)A_stopAnimation {
    [self.timer invalidate];
      i = 20;
    CFTimeInterval pauseTime = self.imageV.layer.timeOffset;
    
    //2.计算出开始时间
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    
    [self.imageV.layer setTimeOffset:0];
    [self.imageV.layer setBeginTime:begin];
    
    self.imageV.layer.speed = 1;
   
}



@end
