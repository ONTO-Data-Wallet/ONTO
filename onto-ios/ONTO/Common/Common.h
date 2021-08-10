//
//  Common.h
//  ONTO
//
//  Created by Zeus.Zhang on 2018/2/1.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EasyShowView.h"
#import <CloudrailSI/CloudrailSI.h>
typedef void(^leftButton)(NSString * string);
typedef void(^rightButton)(NSString * string);
@interface Common : NSObject

/**
 将指定的视图转换为图片

 @param sourceView 视图
 @return 图片
 */
+ (UIImage *)getImageWithSourceView:(UIView *)sourceView;

/**
 舒适化app语言
 */
+ (void)initUserLanguage;

/**
 获取当前app语言

 @return 当前多语言
 */
+ (NSString *)getUserLanguage;

/**
 获取当前汇率
 
 @return
 */
+ (NSString *)getUNIT;
/**
 调用系统相机

 @param viewController 调用的VC
 */
+ (void)takePhoto:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)viewController;

/**
 调用相册

 @param viewController 调用的VC
 @param edit 是否可裁剪
 */
+ (void)choosePhoto:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)viewController allowsEdit:(BOOL)edit;

/**
 设置textfiled组件左边偏移量

 @param textField textfield
 @param width 偏移量
 */
+ (void)setTextFieldLeftPadding:(UITextField *)textField width:(CGFloat)width;

/**
 获取当前设备的唯一标示码

 @return 标示码
 */
+ (NSString *)getUniqueDeviceIdentifierAsString;

/**
 获取Appname

 @return appName
 */
+ (NSString *)getAppName;

/**
 将string时间转换为date

 @param string 被转换的时间串
 @param formatStr 转换的格式
 @return date
 */
+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)formatStr;

/**
 将date转换为时间串

 @param date 被转换的date
 @param formatStr 转换的格式
 @return 时间串
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)formatStr;

/**
 找出某字符的位置

 @param string 原字符
 @param str 查找的字符
 @return 位置
 */
+ (NSUInteger)getLocationFrom:(NSString *)string withStr:(NSString *)str;

/**
 截屏
 */
+ (void)getScreenWindow;

/**
 字典转字符串

 @param dic 字典
 @return 字符串
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

/**
 json字符串转字典

 @param jsonString json
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 判断字符串是否为空
 */
+ (BOOL)isBlankString:(NSString *)aStr;

+ (BOOL)dx_isNullOrNilWithObject:(id)object;

/**
 判断是否更新

 @return bool
 */
+ (BOOL)isFirstLauch;

/**
 数字加，

 @param num 传入数字
 @return 加，数字
 */
+ (NSString *)countNumAndChangeformat:(NSString *)num;
/**
  数字加
  
  @param  time 传入时间戳
  @return 当地时间
  */
+ (NSString *)getTimeFromTimestamp:(NSString *)time;

// 时间格式
+ (NSString *)newGetTimeFromTimestamp:(NSString *)time;
//存下当前时间戳和密码
+ (void)setTimestampwithPassword:(NSString *)password WithOntId:(NSString *)ontId;

//存加密信息
+ (void)setEncryptedContent:(NSString *)encryptedContent WithKey:(NSString *)key;

//获取加密信息
+ (NSString *)getEncryptedContent:(NSString *)key;

//删除加密信息
+ (void)deleteEncryptedContent:(NSString *)key;

//删所有keychain加密信息
+ (void)removeKeyChain;

//判断身份是否过期
+ (BOOL)judgeisExpireWithOntId:(NSString *)ontId;
//判断密码是否匹配
+ (BOOL)judgePasswordisMatchWithPassWord:(NSString *)password WithOntId:(NSString *)ontId;

+ (NSDictionary *)claimdencode:(NSString *)base64String;

+ (NSString *)getNowTimeTimestamp;

+ (long)getboxTimestamp;
//密码转义
+ (NSString *)transferredMeaning:(NSString *)password;

//调整lable行间距
+ (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;

// 固定到9位精度，也可以去掉末尾多余的0
+ (NSString *)getPrecision9Str:(NSString *)conversionValue;
+ (NSString *)getPrecision9Str:(NSString *)amountStr Decimal:(int)Decimal;
+ (NSString *)getshuftiStr:(NSString *)conversionValue;
// 固定到8位精度，也可以去掉末尾多余的0
+ (NSString *)divideAndReturnPrecision8Str:(NSString *)nep5Str;
//乘以10^9以后，返回String
+ (NSString *)getONGMul10_9Str:(NSString *)ongStr;
+ (NSString *)getOEP4Str:(NSString *)amountStr Decimals:(int)Decimals;
+ (NSString *)getOEP4ZeroStr:(NSString *)amountStr Decimals:(int)Decimals ;
+ (NSString *)getPayMoney:(NSString*)payMoney;
// GasLimit * gasPrice / 10^9
+ (NSString *)getRealFee:(NSString *)gasPrice GasLimit:(NSString *)gasLimit;

+ (NSString *)getAllFee:(NSString*)originalFee gasPrice:(NSString *)gasPrice GasLimit:(NSString *)gasLimit;
+ (BOOL)isEnoughOng:(NSString *)ong fee:(NSString *)fee;
// 判断未解绑ONG是否足够提取
+ (bool)isEnoughUnboundONG:(NSString *)unboundOng;

// 判断可声明ONG是否足够提取
+ (bool)isEnoughClaimableONG:(NSString *)claimableOng;

// 判断String是否是nil，@""，空白
+ (BOOL)isStringEmpty:(NSString *)text;

// 计算金钱
+ (NSString *)getMoney:(NSString *)amount Exchange:(NSString *)exchange;

//除以10^9以后，数字后面保留九位小数
+ (NSString *)divideAndReturnPrecision9Str:(NSString *)ongStr;

//把字符串转成Base64编码

+ (NSString *)base64EncodeString:(NSString *)string;
//字符串解码
+ (NSString *)stringEncodeBase64:(NSString *)base64;
//打乱数组顺序
+ (NSMutableArray *)getRandomArrFrome:(NSArray *)arr;

+ (NSString *)dislodgeNumericcharacte:(NSString *)string;
//验证邮箱是否正确
+ (BOOL)isValidateEmail:(NSString *)email;

//压缩图片
+ (UIImage *)scaleFromImage:(UIImage *)image;

+ (UIImage *)scaleToIMImageFromImage:(UIImage *)image;

//设置行间距
+ (void)setLabelSpace:(UILabel *)label withValue:(NSString *)str withFont:(UIFont *)font;
//判断是否为中文
+ (BOOL)isChinese:(NSString *)str;

//国家代码 获取
+ (NSDictionary *)readLocalFileWithcode:(NSString *)codevalue;
+ (NSString *)getJsLocaleWithcode:(NSString *)codevalue;
+ (NSString *)getcountryNameWithlocale:(NSString *)localevalue;
// 根据国家name读取本地locale
+ (NSString *)getLocalWithcountryName:(NSString *)name;

+ (BOOL)validateNumber:(NSString *)number;

+ (UIImage *)rotationImage:(UIImageView *)imageView;

+ (NSString *)hexStringFromString:(NSString *)string;


+ (BOOL)checkPhone:(NSString *)phone regin:(NSString *)regin;
+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;

// 吐司
+ (void)showToast:(NSString *)text;
//富文本
+ (NSMutableAttributedString *)attrString:(NSString *)string width:(CGFloat)width font:(UIFont *)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace;

+ (CGSize)attrSizeString:(NSString *)string width:(CGFloat)width font:(UIFont *)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace;

+ (NSString *)downloadFile:(NSString *)fileName dropbox:(CRDropbox *)dropbox;

+ (void)addAlertTitle:(NSString *)title message:(NSString*)message buttonString:(NSString*)buttonString buttonBlock:(leftButton)buttonBlock;

+ (NSString*)authMoreLeftString:(NSString*)leftString numString:(NSString*)numString;
//+ (void)addAlertTitle:(NSString *)title message:(NSString*)message leftString:(NSString*)leftString rightString:(NSString*)rightString leftBlock:(leftButton)leftBlock rightBlock:(rightButton)rightBlock;
+ (NSString*)ownerTobase58:(NSString*)string;

+ (NSString*)convertToJsonData:(NSDictionary*)dic;
+ (NSString *)decodeString:(NSString*)encodedString;

// 是否登录 ONTID
+ (BOOL)userLogin;

// 展示错误信息
+ (void) showErrorMsg:(NSString*)errorInfo ;
NS_INLINE id _Nullable tryBlock(void(^_Nonnull tryBlock)(void)) {
  @try {
    tryBlock();
  } @catch (NSException *exception) {
    return exception;
  } @catch (CRError *ue) {
    return ue;
  } @catch (id ue) {
    return ue;
  }
  return nil;
}


@end
