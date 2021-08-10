//
//  PwdEnterView.m
//  ONTO
//
//  Created by Zeus.Zhang on 2018/2/14.
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

#import "PwdEnterView.h"
#import "Config.h"
#import "HYKeyboard.h"
#import "UIView+Banner.h"

#define KEYBOARD_NIB_PATH @"BangcleSafeKeyBoard.bundle/resources/HYKeyboard"

#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 15  //密码个数
#define K_Field_Height 40  //每一个输入框的高度等于当前view的高度
#define LineWidth (kScreenWidth - 56 - 210) / 5

@interface PwdEnterView ()
{
    HYKeyboard*keyboard;
    NSString*inputText;
}
@property (nonatomic, strong) NSMutableArray *dotArray;



@end

@implementation PwdEnterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initPwdTextField];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self initPwdTextField];
        
    }
    return self;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 56, K_Field_Height)];
        
        //输入的文字颜色为白色
//        _textField.textColor = [UIColor blackColor];
        //输入框光标的颜色为白色
//        _textField.tintColor = [UIColor blackColor];
        
        if(_isIdentity==YES){
            _textField.keyboardType = UIKeyboardTypeNumberPad;
        }else{
//            _textField.delegate = self;
        }

        _textField.secureTextEntry = YES;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
        _textField.textColor = [UIColor colorWithHexString:@"#6A797C"];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth - 56, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E9EDEF"];
         [self addSubview:line];
        
    }
    return _textField;
}

- (void)textFieldDidChange:(UITextField *)textField
{

    
    if(_isIdentity==YES){
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }else{
        
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
        
        
        for (UIView *dotView in self.dotArray) {
            dotView.hidden = YES;
        }
        for (int i = 0; i < textField.text.length; i++) {
            ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
        }
        DebugLog(@"输入完毕");
//        [textField resignFirstResponder];
        _callbackPwd(textField.text);
        
    }
    
}

- (void)initPwdTextField {
    CGFloat width = 35;
    
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i+1) * width + i * LineWidth, 0, LineWidth, K_Field_Height)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + i * (width + LineWidth) + width / 2 - 5, K_Field_Height / 2 - 5, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa"];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        [self.dotArray addObject:dotView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + i *(width + LineWidth), CGRectGetMaxY(self.textField.frame) - 1, width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0"];
        [self addSubview:line];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        DebugLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

- (void)clearPassword
{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [textField resignFirstResponder];
    //具体调用显示安全键盘位置根据项目的实际情况调整，此处只是作为demo演示
//    [self showSecureKeyboardAction];
    return NO;
}
/**初始化安全键盘*/
- (void)showSecureKeyboardAction{
    
    if (keyboard) {
        [keyboard.view removeFromSuperview];
        keyboard.view =nil;
        keyboard=nil;
    }
    
    keyboard = [[HYKeyboard alloc] initWithNibName:KEYBOARD_NIB_PATH bundle:nil];
    /**弹出安全键盘的宿主控制器，不能传nil*/
    keyboard.hostViewController = [self getCurrentViewController];
    /**是否设置按钮无按压和动画效果*/
    //    keyboard.btnPressAnimation=YES;
    /**是否设置按钮随机变化*/
    keyboard.btnrRandomChange=YES;
    /**是否显示密码明文动画*/
    keyboard.shouldTextAnimation=YES;
    /**安全键盘事件回调，必须实现HYKeyboardDelegate内的其中一个*/
    keyboard.keyboardDelegate=self;
    /**弹出安全键盘的宿主输入框，可以传nil*/
    keyboard.hostTextField = self.textField;
    /**是否输入内容加密*/
    keyboard.secure = YES;
    //设置加密类型，分为AES和SM42种类型，默认为SM4
    //    [keyboard setSecureType:HYSecureTypeAES];
    //    keyboard.arrayText = [NSMutableArray arrayWithArray:contents];//把已输入的内容以array传入;
    /**输入框已有的内容*/
    keyboard.contentText=inputText;
    keyboard.synthesize = YES;//hostTextField输入框同步更新，用*填充
    /**是否清空输入框内容*/
    keyboard.shouldClear = YES;
    /**背景提示*/
    keyboard.stringPlaceholder = self.textField.placeholder;
    keyboard.intMaxLength = 15;//最大输入长度
    keyboard.keyboardType = HYKeyboardTypeNone;//输入框类型
    /**更新安全键盘输入类型*/
    [keyboard shouldRefresh:HYKeyboardTypeNone];
    keyboard.btnrRandomChange = NO;
    //    [keyboard setTextAnimationSecond:0.8];//默认不设置，动画时长为1秒
    //--------添加安全键盘到ViewController---------
    
//    [[self getCurrentViewController].view addSubview:keyboard.view];
//    [[self getCurrentViewController].view bringSubviewToFront:keyboard.view];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            
            
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                    [window addSubview:keyboard.view];
                    [window bringSubviewToFront:keyboard.view];
                
                break;
            }
        }
        
    
        
        //            [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //                self.backgroundView.alpha = 1.0f;
        //                self.actionSheetView.frame = CGRectMake(0, self.frame.size.height-self.actionSheetView.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
        //            } completion:nil];
    }];
    
    
    CGRect rect1=keyboard.view.frame;
    rect1.size.width=[self getCurrentViewController].view.frame.size.width;
    keyboard.view.frame=rect1;
    rect1.origin.y= [self getCurrentViewController].view.frame.size.height+10;
      keyboard.view.frame=rect1;
    
    
    //安全键盘显示动画
    CGRect rect=keyboard.view.frame;
    rect.size.width=[self getCurrentViewController].view.frame.size.width;
    keyboard.view.frame=rect;
    //显示输入框动画
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.2f];
    rect.origin.y=[self getCurrentViewController].view.frame.size.height-keyboard.view.frame.size.height;
    keyboard.view.frame=rect;
    [UIView commitAnimations];
}

-(UIViewController *)getCurrentViewController{
    
//    UIResponder *next = [self nextResponder];
//    do {
//        if ([next isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)next;
//        }
//        next = [next nextResponder];
//    } while (next != nil);
//    return nil;
    
    {
        UIViewController *result = nil;
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        if (window.windowLevel != UIWindowLevelNormal) {
            NSArray *windows = [[UIApplication sharedApplication] windows];
            
            for (UIWindow *temWin in windows) {
                if (temWin.windowLevel == UIWindowLevelNormal) {
                    window = temWin;
                    break;
                }
            }
        }
        
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nestResponder = [frontView nextResponder];
        if ([nestResponder isKindOfClass:[UIViewController class]]) {
            result = nestResponder;
        } else {
            result = window.rootViewController;
        }
        return result;
    }
    
}
#pragma mark--关闭键盘回调
//输入的内容以NSArray返回
//-(void)inputOverWithTextField:(UITextField *)textField inputArrayText:(NSArray *)arrayText
//{
//    contents=arrayText;//接收输入内容
//
//    [self hiddenKeyboardView];
//}
/**安全键盘点击确定回调方法,输入的内容以NSString返回
 @textField 传入的宿主输入框对象
 @text安全键盘输入的内容，NSString
 */
-(void)inputOverWithTextField:(UITextField *)textField inputText:(NSString *)text
{
    inputText=text;
    self.textField.text = text;
    [self hiddenKeyboardView];
}

-(void)inputOverWithChange:(UITextField *)textField changeText:(NSString *)text
{
     inputText=text;
     self.textField.text = text;
    [self textFieldDidChange:self.textField];
    
//    if (textField.text.length == kDotCount) {
//        [textField resignFirstResponder];
        _callbackPwd(textField.text);
//        [self hiddenKeyboardView];
//    }
}

-(void)hiddenKeyboardView
{
    //隐藏输入框动画
    [ UIView animateWithDuration:0.3 animations:^
     {
         CGRect rect=keyboard.view.frame;
         rect.origin.y=[self getCurrentViewController].view.frame.size.height+10;
         keyboard.view.frame=rect;
         
     }completion:^(BOOL finished){
         
         [keyboard.view removeFromSuperview];
         keyboard.keyboardDelegate=nil;
         keyboard.view =nil;
         keyboard=nil;
     }];
}

#pragma mark - Dealloc
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
