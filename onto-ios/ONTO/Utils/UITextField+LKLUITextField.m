//
//  UITextField+LKLUITextField.m
//  LakalaClient
//
//  Created by Apple on 2017/9/26.
//  Copyright © 2017年 LR. All rights reserved.
//

#import "UITextField+LKLUITextField.h"
#import <YYKit/YYKit.h>
#import "Config.h"
@implementation UITextField (LKLUITextField)
-(void)setTextFieldPlaceholderString:(NSString *)placeholderString leftImageView:(UIImage *)leftImageView paddingLeft:(int)paddingLeft {
    NSAttributedString *loginPlaceholerString = [[NSAttributedString alloc] initWithString:placeholderString attributes:
                                                 @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#9b9b9b" ],NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                   }];
    UIImageView *loginLeftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 22)];
    loginLeftImage.image = leftImageView;
    self.leftViewMode=UITextFieldViewModeAlways;
    self.leftView = loginLeftImage;
    self.clearButtonMode = YES;
    self.font = [UIFont systemFontOfSize:16];
    [self setValue:[NSNumber numberWithInt:paddingLeft] forKey:@"paddingLeft"];
    [self placeholderRectForBounds:CGRectMake(paddingLeft, 0, SYSWidth, 60)];
    self.leftViewMode=UITextFieldViewModeAlways;
    self.attributedPlaceholder = loginPlaceholerString;
    
}

@end
