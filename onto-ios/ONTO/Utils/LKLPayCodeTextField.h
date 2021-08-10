//
//  LKLPayCodeTextField.h
//  LakalaClient
//
//  Created by Apple on 2017/10/12.
//  Copyright © 2017年 LR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKLForbidPasteTextField.h"

/** 实时获取当前已输入的支付密码 **/
// 说明：currentInputString 只表示当前输入到密码框中的字符，如果不符合规则或删除字符的情况， currentInputString = @"";
typedef void(^LKLPayCodeTextFieldCurrentBlock)(NSString *currentPayCodeString, NSString *currentInputString);
/** 输入完成后回调 **/
typedef void(^LKLPayCodeTextFieldFinishedBlock)(NSString *payCodeString);

@interface LKLPayCodeTextField : UIView

@property (nonatomic, assign) BOOL isChangeTextFieldNum;    // 是否动态变更输入长度（需设置在 textFieldNum 前有效，默认NO）
@property (nonatomic, assign) NSInteger textFieldNum;       // 输入支付码长度
@property (nonatomic, strong) UIColor  *borderColor;        // 设置边框颜色

@property (nonatomic, assign) CGFloat   borderSpace;        // 边框间距（只在 JJCPayCodeTextFieldTypeSpaceBorder 下有效）

@property (nonatomic, copy)   NSString *payCodeString;      // 真实支付码(未输入完全时，则是当前已输入的支付密码)
@property (nonatomic, assign) BOOL      isShowTrueCode;     // 是否显示 明文（默认NO）
@property (nonatomic, copy)   NSString *ciphertext;         // 密文字符样式(仅限一个字符，且需要在 addSubViews 前设置)

@property (nonatomic, strong) LKLForbidPasteTextField *textField;         // 调用LKL键盘
@property (nonatomic, assign) BOOL      isPSW;     // 是否密码（默认NO）
@property (nonatomic, copy) LKLPayCodeTextFieldCurrentBlock currentBlock;
@property (nonatomic, copy) LKLPayCodeTextFieldFinishedBlock finishedBlock;





- (instancetype)initWithFrame:(CGRect)frame;
/** 清除已输入的支付密码 **/
- (void)clearKeyCode;

@end
