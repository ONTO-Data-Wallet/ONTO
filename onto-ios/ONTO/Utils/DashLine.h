//
//  DashLine.h
//  ONTO
//
//  Created by Apple on 2018/7/17.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashLine : UIView
@property(nonatomic,assign)CGFloat lineLength;
@property(nonatomic,assign)CGFloat lineSpacing;
@property(nonatomic,strong)UIColor*  lineColor;
@property(nonatomic,assign)CGFloat   height;
- (instancetype)initWithFrame:(CGRect)frame withLineLength:(CGFloat)lineLength withLineSpacing:(CGFloat)lineSpacing withLineColor:(UIColor *)lineColor;
@end
