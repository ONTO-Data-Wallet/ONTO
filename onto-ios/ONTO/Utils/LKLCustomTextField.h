//
//  LKLCustomTextField.h
//  LakalaClient
//
//  Created by Apple on 2017/12/27.
//  Copyright © 2017年 LR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKLCustomTextField : UITextField
@property(nonatomic,assign)int leftPadding;
@property(nonatomic,assign)int titleFont;
@property(nonatomic,assign)int clearMode;
-(instancetype)initWithFrame:(CGRect)frame withLeftPadding:(int)leftPadding withFont:(int)font clearMode:(BOOL)clearMode;
@end
