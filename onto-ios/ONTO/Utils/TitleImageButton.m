//
//  TitleImageButton.m
//  ONTO
//
//  Created by Apple on 2018/10/18.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "TitleImageButton.h"
#import "ONTO-Swift.h"
@implementation TitleImageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightBold];
        self.titleLabel.textColor =[UIColor blackColor];
        [self.titleLabel changeSpace:0 wordSpace:3*SCALE_W];
        self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.bounds.size.width+2, 0, self.imageView.bounds.size.width);
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.bounds.size.width+3, 0, self.imageView.bounds.size.width);
    // button图片的偏移量
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width);
}

@end
