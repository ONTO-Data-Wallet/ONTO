//
//  HYKeyboard.h
//
//   SDKVersion 1.3 last update 2017-04-27
//  Created by ycy on 2012-02-24.
//  Copyright 2012 www.bangcle.com. All rights reserved.
//

#import <UIKit/UIKit.h>


//======================================================================================================================================================================================================
//
typedef enum _HYKeyboardType
{
    /**显示安全键盘类型默认值 */
	HYKeyboardTypeNone = 0,
    /**安全键盘数字输入类型 */
	HYKeyboardTypeNumber = 1 << 0,
    /**安全键盘字母输入类型 */
	HYKeyboardTypeLetter = 1 << 1,
    /**安全键盘符号输入类型 */
	HYKeyboardTypeSymbol = 1 << 2
}HYKeyboardType;

typedef enum _HYSecureType
{
    /**安全键盘加密类型默认值，SM4 */
    HYSecureTypeNone = 0,
    /**安全键盘加密类型，AES*/
    HYSecureTypeAES = 1 << 0,
    
}HYSecureType;

//======================================================================================================================================================================================================
//

@protocol HYKeyboardDelegate <NSObject>
/**安全键盘点击确定回调方法,输入的内容以NSArray返回
 @textField 传入的宿主输入框对象
 @arrayText安全键盘输入的内容，NSString单个对象的Array
 */
-(void)inputOverWithTextField:(UITextField*)textField inputArrayText:(NSArray*)arrayText;
/**安全键盘点击确定回调方法,输入的内容以NSString返回
 @textField 传入的宿主输入框对象
 @text安全键盘输入的内容，NSString
 */
-(void)inputOverWithTextField:(UITextField*)textField inputText:(NSString*)text;
/**安全键盘输入内容变化的回调方法,输入的内容以NSString返回
 @textField 传入的宿主输入框对象
 @text安全键盘输入的内容，NSString
 */
-(void)inputOverWithChange:(UITextField*)textField changeText:(NSString*)text;

@end

@interface HYKeyboard : UIViewController

/**弹出安全键盘的宿主控制器*/
@property (nonatomic, assign) UIViewController * hostViewController;
/**弹出安全键盘的宿主输入框*/
@property (nonatomic, assign) UITextField * hostTextField;
/**背景提示*/
@property (nonatomic, copy)   NSString * stringPlaceholder;

/**是否输入内容加密*/
@property (nonatomic, assign) BOOL secure;

/**是否输出内容为密文，默认为NO，不输出为密文*/
@property (nonatomic, assign) BOOL hasOutSecure;

/**hostTextField输入框同步更新，用*填充*/
@property (nonatomic, assign) BOOL synthesize;
/**是否清空输入框内容*/
@property (nonatomic, assign) BOOL shouldClear;
/**输入框输入的最大长度*/
@property (nonatomic, assign) int intMaxLength;
/**安全键盘输入类型*/
@property (nonatomic, assign) HYKeyboardType keyboardType;
/**已有的内容NSArray保存*/
@property (nonatomic, retain) NSMutableArray * arrayText;
/**已有的内容，必须在设置secure,hasOutSecure,setSecureType,setSecureAESKey属性之后调用*/
@property (nonatomic, retain) NSString * contentText;

/**安全键盘事件回调，必须实现HYKeyboardDelegate内的其中一个*/
@property (nonatomic, weak) id<HYKeyboardDelegate> keyboardDelegate;

/**是否设置按钮无按压和动画效果*/
@property (nonatomic, assign) BOOL btnPressAnimation;

/**是否设置按钮随机变化*/
@property (nonatomic, assign) BOOL btnrRandomChange;

/**是否显示密码明文动画*/
@property (nonatomic, assign) BOOL shouldTextAnimation;

/**更新安全键盘输入类型*/
- (void)shouldRefresh:(HYKeyboardType)type;

/**设置安全键盘输入显示明文动画时间间隔，以秒为单位*/
- (void)setTextAnimationSecond:(NSTimeInterval)animationSecond;

/**设置安全键盘加密类型，默认为SM4加解密*/
- (void)setSecureType:(HYSecureType)type;

/**设置安全键盘AES加解密密钥,为空或者不设置都为SDK默认密钥*/
- (void)setSecureAESKey:(NSString*)secureKey;

/**设置安全键盘SM4加解密密钥,为空或者不设置都为SDK默认密钥*/
- (void)setSecureSM4Key:(NSString*)secureKey;

/**设置安全键盘右下角完成按钮的文本*/
- (void)setDoneText:(NSString*)doneText;

/**设置安全键盘左上角文本*/
- (void)setTitleText:(NSString*)titleText;

@end










