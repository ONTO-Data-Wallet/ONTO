//
//  LivingActionImageView.m
//  LivingApp
//
//  Created by junyufr on 2017/4/6.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import "LivingActionImageView.h"
#import <UIKit/UIKit.h>

@implementation LivingActionImageView
{
    NSTimer *_animTimer;
    NSArray* _images;
    NSUInteger _pos;
}

-(void)setImages:(NSArray *)images
{
    _images = images;
    _pos = 0;
    [self runAnim];
}

-(NSArray*)images
{
    return _images;
}

-(void)runAnim
{
    if (_animTimer)
    {
        return;
    }
    //动作帧频率
    _animTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(updateDisplay) userInfo:nil repeats:YES];
}

-(void)updateDisplay
{
    [self setNeedsDisplay];
    if (_images && _images.count > 0)
    {
        _pos++;
        _pos%=_images.count;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGSize size = self.frame.size;
    if (_images && _images.count > _pos)
    {
        [[_images objectAtIndex:_pos] drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }
}

@end
