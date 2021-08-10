//
//  STNumberLabel.h
//  STNumberLabel
//
//  Created by sluin on 16/3/3.
//  Copyright © 2016年 SunLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STNumberLabel : UILabel

@property (assign, nonatomic) BOOL isHighlight;

- (instancetype)initWithFrame:(CGRect)frame number:(int)iNumber;

@end
