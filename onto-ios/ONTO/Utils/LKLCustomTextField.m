//
//  LKLCustomTextField.m
//  LakalaClient
//
//  Created by Apple on 2017/12/27.
//  Copyright © 2017年 LR. All rights reserved.
//

#import "LKLCustomTextField.h"
#import "Config.h"
@implementation LKLCustomTextField

-(instancetype)initWithFrame:(CGRect)frame withLeftPadding:(int)leftPadding withFont:(int)font clearMode:(BOOL)clearMode{
    if (self = [super initWithFrame:frame]) {

        self.leftPadding =leftPadding;
        self.titleFont =font;
        self.clearMode =clearMode;
        [self placeholderRectForBounds:frame];
        [self textRectForBounds:frame];
        [self editingRectForBounds:frame];
        [self drawPlaceholderInRect:frame];
    }
    return self;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController*menuController = [UIMenuController sharedMenuController];
    
    if(menuController) {
        
        [UIMenuController sharedMenuController].menuVisible=NO;
        
    }
    
    return NO;
    
}
//控制清除按钮的位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect clearRect   =CGRectMake(bounds.origin.x + bounds.size.width - 20, bounds.origin.y + (bounds.size.height -16)/2, 16, 16);
    CGRect noClearRect =CGRectMake(bounds.origin.x + bounds.size.width , bounds.origin.y + bounds.size.height , 0, 0);
    return self.clearMode == YES ? clearRect : noClearRect;
}
//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect clearRect =CGRectMake(bounds.origin.x+self.leftPadding +22, bounds.origin.y+4, bounds.size.width-self.leftPadding-22 - 20 , bounds.size.height);
    CGRect noClearRect =CGRectMake(bounds.origin.x+self.leftPadding +22, bounds.origin.y+4, bounds.size.width-self.leftPadding  , bounds.size.height);
    return self.clearMode == YES ? clearRect:noClearRect;//更好理解些
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect clearRect =CGRectMake(bounds.origin.x+self.leftPadding+22, bounds.origin.y, bounds.size.width -self.leftPadding-22- 20 , bounds.size.height);
    CGRect noClearRect =CGRectMake(bounds.origin.x+self.leftPadding+22, bounds.origin.y, bounds.size.width -self.leftPadding-22 , bounds.size.height);
    return self.clearMode == YES ? clearRect:noClearRect;//更好理解些
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect clearRect   =CGRectMake(bounds.origin.x +self.leftPadding+22, bounds.origin.y, bounds.size.width-self.leftPadding-22- 20  , bounds.size.height);
    CGRect noClearRect =CGRectMake(bounds.origin.x+self.leftPadding+22, bounds.origin.y, bounds.size.width -self.leftPadding-22 , bounds.size.height);
    return self.clearMode == YES ? clearRect:noClearRect;
}
//控制左视图位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x , bounds.origin.y, 22, 22);
}

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    [[UIColor orangeColor] setFill];
    
//    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
    [[self placeholder] drawInRect:rect withAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#9b9b9b" ],NSFontAttributeName:[UIFont systemFontOfSize:self.titleFont]}];
}
@end
