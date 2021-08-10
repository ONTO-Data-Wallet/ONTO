//
//  AppHelper.h
//  NongShiTong
//
//  Created by  on 16/11/9.
//  Copyright © 2016年 sf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
extern NSString *CertificatePString_1;
extern NSString *CertificateString_1;
@interface AppHelper : NSObject

//判断是否为手机号
+ (BOOL)valiMobile:(NSString *)mobile;

//判断是否空字符串
+ (BOOL)isBlankString:(NSString *)string;

+ (BOOL)isBlankArray:(NSArray *)array;

//判断网址是否有效
+ (BOOL)validateHttp:(NSString *) textString;

//判断身份证是否规范
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;

//生成随机数 n到m
+(int)getRandomNumber:(int)from to:(int)to;

//16进制颜色转换
+ (UIColor *) colorWithHexString: (NSString *)color;

////带风火轮的数据请求
//+(void)RequestWithUrl:(NSString *)url Parameter:(NSMutableDictionary *)parameter message:(NSString *)msg View:(UIView *)view Success:(void (^)(NSDictionary *successDic))success Failure:(void (^)(NSError *failureError))failure;

//MD5加密
+ (NSString *)md5:(NSString *)str;

////带秘钥的MD5加密
//+ (NSString *)md5WithKey:(NSString *)str;
//
////MBProgressHUD的2秒提示框
//+(void)MBProgressHUDAlertWithMessage:(NSString *)message View:(UIView *)currentView;

//消息提示
+(void) AlertMessage:(NSString *) str;

//float四舍五入
+ (NSString *)decimalwithFormat:(NSString *)format  floatV:(float)floatV;

//修正图片上传旋转90度问题
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//固定宽度计算文本高度
+(float)labelWithSting:(NSString *)theContent andWidth:(float)theWidth andFontSize:(float)theSize;

//将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)htmlEntityDecode:(NSString *)string;

//正则表达式检测
+ (BOOL)checkTelNumber:(NSString *) telNumber;
+ (BOOL)checkPhoneNumber:(NSString *) phoneNumber;
+ (BOOL)checkPassword:(NSString *) password;
+ (BOOL)checkUserName : (NSString *) userName;
+ (BOOL)checkUserName1 : (NSString *) userName;
+ (BOOL)checkUserIdCard: (NSString *) idCard;
+ (BOOL)checkURL : (NSString *) url;
+ (BOOL)checkUnString : (NSString *) strS;
+ (BOOL)checkPostalCode : (NSString *) postalCode;
+ (BOOL)checkQQ : (NSString *) qqNum;
+ (BOOL)checkEmail : (NSString *) emailNo;

+ (BOOL)checkAllNumber : (NSString *) numberString;
/** 正则匹配身份证 */
+ (BOOL)checkIDcardNum : (NSString *) numberString;
// 纯汉字
+ (BOOL) deptNameInputShouldChinese:(NSString*)string;
+ (BOOL)dateCheck:(NSString *)date;//日期正则 YYYY-MM-YY

/** 正则匹配店铺名称 */
+ (BOOL)checkMerchantName : (NSString *) merchantName;
/** 正则匹配邀请码格式 *///有问题
+ (BOOL)checkInvitecode : (NSString *) inviteCode;
/** 正则匹配姓名格式 */
+ (BOOL)checkPeopleName : (NSString *) peopleName;

//中文\数字\字母
+ (BOOL)checkName : (NSString *)name;
@end
