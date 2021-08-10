//
//  Common.m
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

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <SAMKeychain/SAMKeychain.h>
#import "Config.h"
#import "SFHFKeychainUtils.h"
#import "NBPhoneNumberUtil.h"
#import "NS+BTCBase58.h"
@implementation Common

+ (UIImage *)getImageWithSourceView:(UIView *)sourceView {
  UIGraphicsBeginImageContext(sourceView.bounds.size);
  [sourceView.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return viewImage;
}

+ (void)initUserLanguage {
  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
  if ([userDefault boolForKey:FIRSTINITLANGUAGE]) {

  } else {
    [userDefault setBool:YES forKey:FIRSTINITLANGUAGE];
    NSString *language = [NSLocale preferredLanguages][0];
    if ([language hasPrefix:@"zh-Hans"]) {
      [userDefault setValue:@"zh-Hans" forKey:HomeLanguage];
    } else {
      [userDefault setValue:@"en" forKey:HomeLanguage];
    }
    [userDefault synchronize];
  }
}

+ (NSString *)getUserLanguage {
  return [[NSUserDefaults standardUserDefaults] valueForKey:HomeLanguage];
}

+ (NSString *)getUNIT {
  return [[NSUserDefaults standardUserDefaults] valueForKey:UNIT];
}

+ (void)takePhoto:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)viewController {
  [self acquireVideoAuth:^(BOOL grant) {
    if (grant) {
      if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.delegate = viewController;
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.allowsEditing = YES;
        [(UIViewController *) viewController presentViewController:cameraUI animated:YES completion:nil];
      } else {
        UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"" message:@"摄像头不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction
            *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:alertAction];
        [APP_DELEGATE.window.rootViewController presentViewController:alert animated:YES completion:nil];
      }
    }
  }];
}

+ (void)choosePhoto:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)viewController allowsEdit:(BOOL)edit {
  PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
  if (author == PHAuthorizationStatusRestricted ||
      author == PHAuthorizationStatusDenied) {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"获取授权" message:[NSString stringWithFormat:@"您已关闭了相册访问，请前往（设置-隐私-照片-%@）", @"111"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:alertAction];
    [APP_DELEGATE.window.rootViewController presentViewController:alert animated:YES completion:nil];
  } else {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      picker.delegate = viewController;
      picker.allowsEditing = edit;
      [(UIViewController *) viewController presentViewController:picker animated:YES completion:nil];
    } else {
      UIAlertController *alert =
          [UIAlertController alertControllerWithTitle:@"" message:@"无法访问相册" preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction
          *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
      [alert addAction:alertAction];
      [APP_DELEGATE.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
  }
}

+ (void)acquireVideoAuth:(void (^)(BOOL grant))block {
  [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (granted) {
        block(YES);
      } else {
        UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"获取授权" message:[NSString stringWithFormat:@"您已关闭了相机访问，请前往（设置-隐私-相机-%@）", @"111"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction
            *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:alertAction];
        [APP_DELEGATE.window.rootViewController presentViewController:alert animated:YES completion:nil];
        block(NO);
      }
    });
  }];
}

+ (void)setTextFieldLeftPadding:(UITextField *)textField width:(CGFloat)width {
  CGRect frame = textField.frame;
  frame.size.width = width;
  UIView *leftView = [[UIView alloc] initWithFrame:frame];
  textField.leftViewMode = UITextFieldViewModeAlways;
  textField.leftView = leftView;
}

+ (NSString *)getUniqueDeviceIdentifierAsString {
  NSString *appName = [self getAppName];
  NSString *strApplicationUUID = [SAMKeychain passwordForService:appName account:@"incoding"];
  if (strApplicationUUID == nil) {
    strApplicationUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSError *error = nil;
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = appName;
    query.account = @"incoding";
    query.password = strApplicationUUID;
    query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
    [query save:&error];
  }
  return strApplicationUUID;
}

+ (NSString *)getAppName {
  NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
  return [infoDic objectForKey:@"CFBundleDisplayName"];
}

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)formatStr {
  NSDateFormatter *format = [[NSDateFormatter alloc] init];
  [format setDateFormat:formatStr];
  return [format dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)formatStr {
  NSDateFormatter *format = [[NSDateFormatter alloc] init];
  [format setDateFormat:formatStr];
  return [format stringFromDate:date];
}

+ (NSUInteger)getLocationFrom:(NSString *)string withStr:(NSString *)str {
  NSRange range;
  range = [string rangeOfString:str];
  if (range.location != NSNotFound) {
    return range.location;
  } else {
    return 0;
  }
}

+ (void)getScreenWindow {
  UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];

  UIGraphicsBeginImageContext(screenWindow.frame.size);

  [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];

  UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
  NSError *parseError = nil;
  NSData
      *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

  // fix bugs: ODM-144 iOS：导出ONTID有问题
  // https://stackoverflow.com/questions/19651009/how-to-prevent-nsjsonserialization-from-adding-extra-escapes-in-url

  // NSJSONSerialization converts a URL string from http://... to http:\/\/... remove the extra escapes
  NSString *jsonDataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSString *jsonDataStrWithoutEscape = [jsonDataStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
  return jsonDataStrWithoutEscape;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
  if (jsonString == nil) {
    return nil;
  }
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSError *err;
  NSDictionary
      *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
  if (err) {
    return nil;
  }
  return dic;
}

+ (BOOL)isBlankString:(NSString *)aStr {
  if (!aStr) {
    return YES;
  }
  if ([aStr isKindOfClass:[NSNull class]]) {
    return YES;
  }
    NSString * str = [NSString stringWithFormat:@"%@",aStr];
  if (!str.length) {
    return YES;
  }
  NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  NSString *trimmedStr = [str stringByTrimmingCharactersInSet:set];
  if (!trimmedStr.length) {
    return YES;
  }
  return NO;
}

+ (BOOL)dx_isNullOrNilWithObject:(id)object; {
  if (object == nil || [object isEqual:[NSNull null]]) {
    return YES;
  } else if ([object isKindOfClass:[NSString class]]) {
    if ([object isEqualToString:@""]) {
      return YES;
    } else {
      return NO;
    }
  } else if ([object isKindOfClass:[NSNumber class]]) {
    if ([object isEqualToNumber:@0]) {
      return YES;
    } else {
      return NO;
    }
  }

  return NO;
}

+ (BOOL)isFirstLauch {
  //获取当前版本号
  NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
  NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
  //获取上次启动应用保存的appVersion
  NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
  //版本升级或首次登录
  if (version == nil || ![version isEqualToString:currentAppVersion]) {
    [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
  } else {
    return NO;
  }
}

// TODO: 感觉有现成的方法，没必要手写
+ (NSString *)countNumAndChangeformat:(NSString *)num {
  if ([num rangeOfString:@"."].location != NSNotFound) {
    NSString *losttotal = [NSString stringWithFormat:@"%.2f", [num floatValue]];//小数点后只保留两位
    NSArray *array = [losttotal componentsSeparatedByString:@"."];
    //小数点前:array[0]
    //小数点后:array[1]
    int count = 0;
    num = array[0];
    long long int a = num.longLongValue;
    while (a != 0) {
      count++;
      a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
      count -= 3;
      NSRange rang = NSMakeRange(string.length - 3, 3);
      NSString *str = [string substringWithRange:rang];
      [newstring insertString:str atIndex:0];
      [newstring insertString:@"," atIndex:0];
      [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    NSMutableString *newString = [NSMutableString string];
    newString = [NSMutableString stringWithFormat:@"%@.%@", newstring, array[1]];
    return newString;
  } else {
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0) {
      count++;
      a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
      count -= 3;
      NSRange rang = NSMakeRange(string.length - 3, 3);
      NSString *str = [string substringWithRange:rang];
      [newstring insertString:str atIndex:0];
      [newstring insertString:@"," atIndex:0];
      [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
  }
}

+ (NSString *)getNowTimeTimestamp {

  //现在时间,你可以输出来看下是什么格式
  NSDate *datenow = [NSDate date];
  NSString *timeSp = [NSString stringWithFormat:@"%ld", (long) [datenow timeIntervalSince1970]];
  return timeSp;

}
+ (long)getboxTimestamp{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld000", (long) [datenow timeIntervalSince1970]];
    return [timeSp longValue];
}
+ (NSString *)getTimeFromTimestamp:(NSString *)time {

  //将对象类型的时间转换为NSDate类型
  NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];

  //设置时间格式
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
  [formatter setTimeZone:timeZone];
  [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

  //将时间转换为字符串
  NSString *timeStr = [formatter stringFromDate:myDate];
    if ([timeStr hasPrefix:@"1970"]) {
        return @"";
    }
  return timeStr;

}

+ (NSString *)newGetTimeFromTimestamp:(NSString *)time {
  //将对象类型的时间转换为NSDate类型

    if ([time containsString:@"opt"]) {
        return @"";
    }
  NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];

  //设置时间格式
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
  [formatter setTimeZone:timeZone];
  [formatter setDateFormat:@"MM/dd/YYYY HH:mm:ss"];

  //将时间转换为字符串
  NSString *timeStr = [formatter stringFromDate:myDate];
    if ([timeStr hasPrefix:@"1970"]) {
        return @"";
    }
  return timeStr;

}

+ (void)setTimestampwithPassword:(NSString *)password WithOntId:(NSString *)ontId {

  NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
  NSTimeInterval a = [dat timeIntervalSince1970];
  NSString *timeString = [NSString stringWithFormat:@"%f", a];
//存下时间戳和密码 ps:由于以ontid为标示存了devicecode,所以在Ontid前加一个t为标示
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:password forKey:@"password"];
  [dic setValue:timeString forKey:@"time"];

//  [SFHFKeychainUtils storeUsername:ontId andPassword:password forServiceName:@"ONTO" updateExisting:YES error:nil];

  [[NSUserDefaults standardUserDefaults] setValue:dic forKey:[NSString stringWithFormat:@"t%@", ontId]];

}

+ (NSString *)getEncryptedContent:(NSString *)key {

  return [SFHFKeychainUtils getPasswordForUsername:key andServiceName:@"ONTO" error:nil];
}

+ (void)setEncryptedContent:(NSString *)password WithKey:(NSString *)key {

  [SFHFKeychainUtils storeUsername:key andPassword:password forServiceName:@"ONTO" updateExisting:YES error:nil];
}

+ (void)deleteEncryptedContent:(NSString *)key {

  [SFHFKeychainUtils deleteItemForUsername:key andServiceName:@"ONTO" error:nil];
}

+ (void)removeKeyChain {

  [SFHFKeychainUtils purgeItemsForServiceName:@"ONTO" error:nil];

}

+ (BOOL)judgeisExpireWithOntId:(NSString *)ontId {

  NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"t%@", ontId]];

  NSString *timeTemple = [dic valueForKey:@"time"];
  NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
  NSTimeInterval nowTimeTemple = [dat timeIntervalSince1970];

  NSInteger expiretime = 20;
  if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGOUTTIME] isNotBlank]) {
    expiretime = [[[NSUserDefaults standardUserDefaults] valueForKey:LOGOUTTIME] intValue];
  }

  if (nowTimeTemple - [timeTemple integerValue] > 10000000) {
    return YES;
  } else {
    return NO;
  }

  return YES;
}

+ (BOOL)judgePasswordisMatchWithPassWord:(NSString *)password WithOntId:(NSString *)ontId {
  NSString *savePassword = [Common getEncryptedContent:ontId];
  if ([password isEqualToString:savePassword]) {
    return YES;
  } else {
    return NO;
  }
}

+ (NSDictionary *)claimdencode:(NSString *)base64String {

  NSString *string = base64String;
  NSArray *aArray = [string componentsSeparatedByString:@"."];
  NSString *claimStr = aArray[1];
  NSData *data =
      [[NSData alloc] initWithBase64EncodedString:claimStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
  NSString *string1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  string1 = [string1 stringByReplacingOccurrencesOfString:@"@context" withString:@"context"];
  NSDictionary *dic = [Common dictionaryWithJsonString:string1];

//  NSString *Blockchain_proof = aArray[3];
//  NSData *dataBlockchain_proof = [[NSData alloc]
//      initWithBase64EncodedString:Blockchain_proof options:NSDataBase64DecodingIgnoreUnknownCharacters];
//  NSString *string2 = [[NSString alloc] initWithData:dataBlockchain_proof encoding:NSUTF8StringEncoding];
//  NSDictionary *dicBlockchain_proof = [Common dictionaryWithJsonString:string2];

  NSMutableDictionary *claimDic = [NSMutableDictionary dictionary];
  [claimDic setObject:dic forKey:@"claim"];

  return claimDic;
}

+ (NSString *)transferredMeaning:(NSString *)password {
  NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
  return [data base64EncodedStringWithOptions:0];
}

+ (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineSpacing = lineSpace; // 调整行间距
  NSRange range = NSMakeRange(0, [string length]);
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
  return attributedString;

}

+ (NSString *)base64EncodeString:(NSString *)string {

  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

  return [data base64EncodedStringWithOptions:0];

}

//字符串解码

+ (NSString *)stringEncodeBase64:(NSString *)base64 {

  NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:base64 options:0];

  NSString *base64Decoded = [[NSString alloc] initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];

  return base64Decoded;

}

+ (NSMutableArray *)getRandomArrFrome:(NSArray *)arr {

  NSMutableArray *nutableArray = [[NSMutableArray alloc] initWithArray:arr];
  int i = (int) [nutableArray count];
  while (--i > 0) {

    int j = rand() % (i + 1);
    [nutableArray exchangeObjectAtIndex:i withObjectAtIndex:j];

  }

  return nutableArray;

}

+ (NSString *)dislodgeNumericcharacte:(NSString *)string {

  NSString *searchString =
      [[string componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]]
          componentsJoinedByString:@""];

  return searchString;

}

+ (BOOL)isValidateEmail:(NSString *)email {

//  NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    // 增加长域名
    NSString *emailRegex = @"^[A-Z0-9a-z._%+-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", emailRegex];
    return [emailTest evaluateWithObject:email];

}

+ (UIImage *)scaleToIMImageFromImage:(UIImage *)image {
  if (!image) {
    return nil;
  }

  CGFloat width = image.size.width;
  CGFloat height = image.size.height;
  CGSize size;

  const CGFloat TheWith = 1280;
  if (width > TheWith) {
    height = height / (width / TheWith);
    width = TheWith;
  }

  size = CGSizeMake(width, height);

  UIGraphicsBeginImageContext(size);
  [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  if (!newImage) {
    return image;
  }
  return newImage;
}

+ (void)setLabelSpace:(UILabel *)label withValue:(NSString *)str withFont:(UIFont *)font {
  NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
  paraStyle.lineBreakMode = 0;
  paraStyle.alignment = NSTextAlignmentLeft;
  paraStyle.lineSpacing = 5; //设置行间距
  paraStyle.hyphenationFactor = 1.0;
  paraStyle.firstLineHeadIndent = 0.0;
  paraStyle.paragraphSpacingBefore = 0.0;
  paraStyle.headIndent = 0;
  paraStyle.tailIndent = 0;
  //设置字间距 NSKernAttributeName:@1.5f
  NSDictionary
      *dic = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paraStyle, NSKernAttributeName: @0.2f
  };

  NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
  label.attributedText = attributeStr;
}

+ (BOOL)includeChinese:(NSString *)str {
  for (int i = 0; i < [str length]; i++) {
    int a = [str characterAtIndex:i];
    if (a > 0x4e00 && a < 0x9fff) {
      return YES;
    }
  }
  return NO;
}

// 读取本地JSON文件
+ (NSDictionary *)readLocalFileWithcode:(NSString *)codevalue {
  // 获取文件路径
  NSString *path = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"json"];
  // 将文件数据化
  NSData *data = [[NSData alloc] initWithContentsOfFile:path];
  // 对数据进行JSON格式化并返回字典形式
  NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

  NSDictionary *dic = [NSDictionary dictionary];

  for (NSDictionary *dic1 in arr) {
    if ([dic1[@"code"] isEqualToString:codevalue]) {
      dic = dic1;
    }
  }
  return dic;
}

// 根据国家name读取本地locale
+ (NSString *)getLocalWithcountryName:(NSString *)name {
  // 获取文件路径
  NSString *path = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"json"];
  // 将文件数据化
  NSData *data = [[NSData alloc] initWithContentsOfFile:path];
  // 对数据进行JSON格式化并返回字典形式
  NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

  NSDictionary *dic = [NSDictionary dictionary];

  for (NSDictionary *dic1 in arr) {
    if ([dic1[@"zh"] isEqualToString:name]) {
      dic = dic1;
    } else if ([dic1[@"en"] isEqualToString:name]) {
      dic = dic1;
    }
  }
  NSString *locale = dic[@"locale"];

  return locale;
}

//移除最后一个字符串
+ (NSString *)removeLastOneChar:(NSString *)origin {
  NSString *cutted;
  if ([origin length] > 0) {
    cutted = [origin substringToIndex:([origin length] - 1)];// 去掉最后一个","
  } else {
    cutted = origin;
  }
  return cutted;
}

+ (NSString *)getJsLocaleWithcode:(NSString *)codevalue {

  NSDictionary *dic = [Common readLocalFileWithcode:codevalue];
  NSString *name = dic[@"locale"];

  return name;
}

+ (NSString *)getcountryNameWithlocale:(NSString *)localevalue {

  NSDictionary *dic = [Common readLocalFileWithLocal:localevalue];
  NSString *name = @"";
  if ([[Common getUserLanguage] isEqualToString:@"en"]) {
    name = dic[@"en"];
  } else {
    name = dic[@"zh"];
  }
  return name;
}

// 读取本地JSON文件
+ (NSDictionary *)readLocalFileWithLocal:(NSString *)local {

  // 获取文件路径
  NSString *path = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"json"];

  // 将文件数据化
  NSData *data = [[NSData alloc] initWithContentsOfFile:path];

  // 对数据进行JSON格式化并返回字典形式
  NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

  NSDictionary *dic = [NSDictionary dictionary];

  for (NSDictionary *dic1 in arr) {
    if ([dic1[@"locale"] isEqualToString:local]) {
      dic = dic1;
    }
  }
  return dic;

}

+ (BOOL)validateNumber:(NSString *)number {
  BOOL res = YES;
  NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
  int i = 0;
  while (i < number.length) {
    NSString *string = [number substringWithRange:NSMakeRange(i, 1)];
    NSRange range = [string rangeOfCharacterFromSet:tmpSet];
    if (range.length == 0) {
      res = NO;
      break;
    }
    i++;
  }
  return res;
}

+ (NSString *)hexStringFromString:(NSString *)string {

  NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
  Byte *bytes = (Byte *) [myD bytes];
  //下面是Byte 转换为16进制。
  NSString *hexStr = @"";
  for (int i = 0; i < [myD length]; i++) {
    NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i] & 0xff];///16进制数
    if ([newHexStr length] == 1)
      hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
    else
      hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
  }
  return hexStr;

}
+ (BOOL)checkPhone:(NSString *)phone regin:(NSString *)regin {

  NBPhoneNumberUtil *instance = [NBPhoneNumberUtil sharedInstance];
  NBPhoneNumber *myNumber = [instance parse:phone defaultRegion:regin error:nil];
  return [instance isValidNumberForRegion:myNumber regionCode:regin];

}

+ (UIImage *)fixOrientation:(UIImage *)aImage {

  UIImage *portraitImage = [[UIImage alloc] initWithCGImage:aImage.CGImage
                                                      scale:1.0
                                                orientation:UIImageOrientationUp];
  return portraitImage;

}

+ (NSString *)getONGMul10_9Str:(NSString *)ongStr {
  if ([Common isStringEmpty:ongStr]) {
    return nil;
  }
  NSDecimalNumber *decimalONG = [[NSDecimalNumber alloc] initWithString:ongStr];
  NSDecimalNumber *multiplicand = [NSDecimalNumber decimalNumberWithString:ONG_PRECISION_STR];
  NSDecimalNumber *decimalONG10_9 = [decimalONG decimalNumberByMultiplyingBy:multiplicand];
  NSString *decimalONG10_9_str = decimalONG10_9.stringValue;
  return decimalONG10_9_str;
}
+ (NSString *)getOEP4Str:(NSString *)amountStr Decimals:(int)Decimals {
    if ([Common isStringEmpty:amountStr]) {
        return nil;
    }
    NSDecimalNumber *decimalONG = [[NSDecimalNumber alloc] initWithString:amountStr];
    NSMutableString *DecimalsString = [NSMutableString stringWithFormat:@"%@", @"1"];
    for (int i =0; i<Decimals; i++) {
        [DecimalsString insertString:@"0" atIndex:1];
    }
    NSString * str = [NSString stringWithFormat:@"%@",DecimalsString    ];
    NSDecimalNumber *multiplicand = [NSDecimalNumber decimalNumberWithString:str];
    NSDecimalNumber *decimalOEP4= [decimalONG decimalNumberByMultiplyingBy:multiplicand];
    NSString *decimalOEP4_str = decimalOEP4.stringValue;
    NSLog(@"decimalOEP4_str=%@",decimalOEP4_str);
    return decimalOEP4_str;
}
+ (NSString *)getOEP4ZeroStr:(NSString *)amountStr Decimals:(int)Decimals {
    if ([Common isStringEmpty:amountStr]) {
        return nil;
    }
    NSMutableString *DecimalsString = [NSMutableString stringWithFormat:@"%@", @"0."];
    for (int i =0; i<Decimals; i++) {
        [DecimalsString insertString:@"0" atIndex:2];
    }
    NSString * str = [NSString stringWithFormat:@"%@",DecimalsString    ];
    return str;
}
+ (NSString *)getMoney:(NSString *)amount Exchange:(NSString *)exchange {
  if ([Common isStringEmpty:amount] || [Common isStringEmpty:exchange]) {
    return nil;
  }
  NSDecimalNumber *d_amount = [[NSDecimalNumber alloc] initWithString:amount];
  NSDecimalNumber *d_exchange = [[NSDecimalNumber alloc] initWithString:exchange];
  NSDecimalNumberHandler *roundDown = [NSDecimalNumberHandler
      decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2
                          raiseOnExactness:NO
                           raiseOnOverflow:NO
                          raiseOnUnderflow:NO
                       raiseOnDivideByZero:YES];
  NSDecimalNumber *money = [d_amount decimalNumberByMultiplyingBy:d_exchange withBehavior:roundDown];
  return money.stringValue;
}

+ (NSString *)divideAndReturnPrecision8Str:(NSString *)nep5Str {
  if ([Common isStringEmpty:nep5Str]) {
    return nep5Str;
  }

  //服务器数据应该默认的就是精度为9，所以不需要在format一下，但是这里保险起见，还是保持原来的逻辑，再次确保精度为9。

  NSDecimalNumberHandler *roundDown = [NSDecimalNumberHandler
      decimalNumberHandlerWithRoundingMode:NSRoundDown scale:9
                          raiseOnExactness:NO
                           raiseOnOverflow:NO
                          raiseOnUnderflow:NO
                       raiseOnDivideByZero:YES];

  NSDecimalNumber *decimalONG = [[NSDecimalNumber alloc] initWithString:nep5Str];
  NSDecimalNumber *decimalMultiplicand = [NSDecimalNumber decimalNumberWithString:NEP5_PRECISION_STR];
  NSDecimalNumber *decimalONGDivide = [decimalONG decimalNumberByDividingBy:decimalMultiplicand withBehavior:roundDown];
  return decimalONGDivide.stringValue;
}
+ (BOOL)isStringEmpty:(NSString *)text {
  if (!text || [text isEqualToString:@""] || !text.isNotBlank || text.length <= 0) {
    return YES;
  }
  return NO;
}

+ (NSString *)divideAndReturnPrecision9Str:(NSString *)ongStr {
  if ([Common isStringEmpty:ongStr]) {
    return ongStr;
  }

  //服务器数据应该默认的就是精度为9，所以不需要在format一下，但是这里保险起见，还是保持原来的逻辑，再次确保精度为9。

  NSDecimalNumberHandler *roundDown = [NSDecimalNumberHandler
      decimalNumberHandlerWithRoundingMode:NSRoundDown scale:9
                          raiseOnExactness:NO
                           raiseOnOverflow:NO
                          raiseOnUnderflow:NO
                       raiseOnDivideByZero:YES];

  NSDecimalNumber *decimalONG = [[NSDecimalNumber alloc] initWithString:ongStr];
  NSDecimalNumber *decimalMultiplicand = [NSDecimalNumber decimalNumberWithString:ONG_PRECISION_STR];
  NSDecimalNumber *decimalONGDivide = [decimalONG decimalNumberByDividingBy:decimalMultiplicand withBehavior:roundDown];
     NSString * str = decimalONGDivide.stringValue;
    if([str rangeOfString:@"."].location !=NSNotFound)
    {
        NSLog(@"yes");
        NSArray * arr = [str componentsSeparatedByString:@"."];
        str =[self addzeroToDecimal:arr[0] dotStr:arr[1] Decimal:9];
    }
    else
    {
        NSLog(@"no");
        str=  [self addzeroToDecimal:str Decimal:9];
        
    }
    return str;
}
// 固定到9位精度，也可以去掉末尾多余的0
+ (NSString *)getPrecision9Str:(NSString *)ongStr {
  if ([Common isStringEmpty:ongStr]) {
    return nil;
  }
  //默认就应该是9位精度，decimalONG也可以去掉多余小数点
  NSDecimalNumberHandler *roundDown = [NSDecimalNumberHandler
      decimalNumberHandlerWithRoundingMode:NSRoundDown scale:9
                          raiseOnExactness:NO
                           raiseOnOverflow:NO
                          raiseOnUnderflow:NO
                       raiseOnDivideByZero:YES];
  NSDecimalNumber *decimalONG = [[NSDecimalNumber alloc] initWithString:ongStr];
  NSDecimalNumber *roundONG = [decimalONG decimalNumberByRoundingAccordingToBehavior:roundDown];
    NSString * str = roundONG.stringValue;

    return str;
}

// 固定到精度，也可以去掉末尾多余的0
+ (NSString *)getPrecision9Str:(NSString *)amountStr Decimal:(int)Decimal{
    if ([Common isStringEmpty:amountStr]) {
        return nil;
    }
    NSDecimalNumberHandler *roundDown = [NSDecimalNumberHandler
                                         decimalNumberHandlerWithRoundingMode:NSRoundDown scale:Decimal
                                         raiseOnExactness:NO
                                         raiseOnOverflow:NO
                                         raiseOnUnderflow:NO
                                         raiseOnDivideByZero:YES];
    NSDecimalNumber *decimalamountStr = [[NSDecimalNumber alloc] initWithString:amountStr];
    NSDecimalNumber *rounddecimalamountStr = [decimalamountStr decimalNumberByRoundingAccordingToBehavior:roundDown];
    NSString * str = rounddecimalamountStr.stringValue;
    if([str rangeOfString:@"."].location !=NSNotFound)
    {
        NSLog(@"yes");
        NSArray * arr = [str componentsSeparatedByString:@"."];
        str =[self addzeroToDecimal:arr[0] dotStr:arr[1] Decimal:Decimal];
    }
    else
    {
        NSLog(@"no");
       str=  [self addzeroToDecimal:str Decimal:Decimal];
        
    }

    return str;
}
+(NSString*)addzeroToDecimal:(NSString*)amountString dotStr:(NSString*)dotStr Decimal:(int)Decimal{
    NSMutableString *DecimalsString = [NSMutableString stringWithFormat:@"%@", @""];
    for (int i =0; i<Decimal - dotStr.length; i++) {
        [DecimalsString insertString:@"0" atIndex:0];
    }
    NSString * str = [NSString stringWithFormat:@"%@.%@%@",amountString,dotStr,DecimalsString];
    return str;
}
+(NSString *)addzeroToDecimal:(NSString*)amountString Decimal:(int)Decimal{
    if ([Common isStringEmpty:amountString]) {
        return nil;
    }
    NSMutableString *DecimalsString = [NSMutableString stringWithFormat:@"%@", @"."];
    for (int i =0; i<Decimal; i++) {
        [DecimalsString insertString:@"0" atIndex:1];
    }
    NSString * str = [NSString stringWithFormat:@"%@%@",amountString, DecimalsString];
    NSLog(@"decimalOEP4_str=%@",str);
    return str;
}
+ (NSString *)getshuftiStr:(NSString *)conversionValue{
    
    NSDecimalNumber *fee = [[NSDecimalNumber alloc] initWithString:conversionValue];
    NSDecimalNumber *decimalMultiplicand = [NSDecimalNumber decimalNumberWithString:ONG_PRECISION_STR];
    NSDecimalNumber *decimalFeeDivide = [fee decimalNumberByDividingBy:decimalMultiplicand];
    return decimalFeeDivide.stringValue;

}
+ (NSString *)getRealFee:(NSString *)gasPrice GasLimit:(NSString *)gasLimit {

  if ([Common isStringEmpty:gasPrice] || [Common isStringEmpty:gasLimit]) {
    return nil;
  }

  NSDecimalNumber *decimalGasPrice = [[NSDecimalNumber alloc] initWithString:gasPrice];
  NSDecimalNumber *decimalGasLimit = [[NSDecimalNumber alloc] initWithString:gasLimit];
  NSDecimalNumber *decimalFee = [decimalGasPrice decimalNumberByMultiplyingBy:decimalGasLimit];
  NSDecimalNumber *decimalMultiplicand = [NSDecimalNumber decimalNumberWithString:ONG_PRECISION_STR];
  NSDecimalNumber *decimalFeeDivide = [decimalFee decimalNumberByDividingBy:decimalMultiplicand];
  return decimalFeeDivide.stringValue;

}

+ (NSString *)getPayMoney:(NSString*)payMoney {
    
    if ([Common isStringEmpty:payMoney]) {
        return @"";
    }
    
    NSDecimalNumber *decimalpayMoney = [[NSDecimalNumber alloc] initWithString:payMoney];
    NSDecimalNumber *decimalMultiplicand = [NSDecimalNumber decimalNumberWithString:ONG_PRECISION_STR];
    NSDecimalNumber *decimalFeeDivide = [decimalpayMoney decimalNumberByDividingBy:decimalMultiplicand];
    return decimalFeeDivide.stringValue;
    
}
+ (NSString *)getAllFee:(NSString*)originalFee gasPrice:(NSString *)gasPrice GasLimit:(NSString *)gasLimit{
    if ([Common isStringEmpty:originalFee] || [Common isStringEmpty:gasPrice] || [Common isStringEmpty:gasLimit]) {
        return nil;
    }
    
    NSDecimalNumber *decimalOriginalFee = [[NSDecimalNumber alloc] initWithString:originalFee];
    NSDecimalNumber *decimalGasLimit = [[NSDecimalNumber alloc] initWithString:gasLimit];
    NSDecimalNumber *decimalGasPrice = [[NSDecimalNumber alloc] initWithString:gasPrice];
    NSDecimalNumber *decimalCharge = [decimalGasPrice decimalNumberByMultiplyingBy:decimalGasLimit];
    NSDecimalNumber *decimalFee = [decimalOriginalFee decimalNumberByAdding:decimalCharge];
    NSDecimalNumber *decimalMultiplicand = [NSDecimalNumber decimalNumberWithString:ONG_PRECISION_STR];
    NSDecimalNumber *decimalFeeDivide = [decimalFee decimalNumberByDividingBy:decimalMultiplicand];
    return decimalFeeDivide.stringValue;
}
+(BOOL)isEnoughOng:(NSString*)ong fee:(NSString*)fee
{
    NSDecimalNumber *decimalUnboundOng = [[NSDecimalNumber alloc] initWithString:ong];
    NSDecimalNumber *decimalMinUnboundOng = [[NSDecimalNumber alloc] initWithString:fee];
    
    NSComparisonResult result = [decimalUnboundOng compare:decimalMinUnboundOng];
    if (result == NSOrderedDescending) {
        return true;
    } else {
        return false;
    }
}
+ (bool)isEnoughUnboundONG:(NSString *)unboundOng {
  if ([Common isStringEmpty:unboundOng]) {
    return false;
  }
  NSDecimalNumber *decimalUnboundOng = [[NSDecimalNumber alloc] initWithString:unboundOng];
  NSString *minUnboundOng = [[[NSUserDefaults standardUserDefaults] valueForKey:MINUNBOUNDONG] stringValue];
  NSDecimalNumber *decimalMinUnboundOng = [[NSDecimalNumber alloc] initWithString:minUnboundOng];

  NSComparisonResult result = [decimalUnboundOng compare:decimalMinUnboundOng];
  if (result == NSOrderedDescending) {
    return true;
  } else {
    return false;
  }
}

+ (bool)isEnoughClaimableONG:(NSString *)claimableOng {
  if ([Common isStringEmpty:claimableOng]) {
    return false;
  }
  NSDecimalNumber *decimalClaimableOng = [[NSDecimalNumber alloc] initWithString:claimableOng];
  NSString *minClaimableOng = [[[NSUserDefaults standardUserDefaults] valueForKey:MINCLAIMABLEONG] stringValue];
  NSDecimalNumber *decimalMinClaimableOng = [[NSDecimalNumber alloc] initWithString:minClaimableOng];

  NSComparisonResult result = [decimalClaimableOng compare:decimalMinClaimableOng];
  if (result == NSOrderedDescending) {
    return true;
  } else {
    return false;
  }
}

+ (void)showToast:(NSString *)text {
  [EasyTextView showText:text config:^EasyTextConfig * {

    EasyTextConfig *config = [EasyTextConfig shared];
    config.bgColor = [UIColor colorWithRed:25 / 255.0 green:107 / 255.0 blue:216 / 255.0 alpha:0.8];
    config.shadowColor = [UIColor clearColor];
    config.titleColor = [UIColor whiteColor];
    config.titleFont = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    config.animationType = TextAnimationTypeFade;
    config.statusType = TextStatusTypeBottom;
    return config;
  }];
}
+ (NSMutableAttributedString *)attrString:(NSString *)string width:(CGFloat)width font:(UIFont *)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace {
  NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
  paragraphStyle.lineSpacing = lineSpace;
  NSMutableAttributedString *attributedString =
      [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSKernAttributeName: @(wordSpace)}];
  [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,
                                                                                                      string.length)];
  return attributedString;
}

+ (CGSize)attrSizeString:(NSString *)string width:(CGFloat)width font:(UIFont *)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace {
  NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
  paragraphStyle.lineSpacing = lineSpace;
  NSMutableAttributedString *attributedString =
      [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSKernAttributeName: @(wordSpace)}];
  [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,
                                                                                                      string.length)];

  CGSize attrSize =
      [attributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
          | NSStringDrawingUsesFontLeading context:nil].size;
  return attrSize;
}

+(NSString*)downloadFile:(NSString*)fileName dropbox:(CRDropbox *)dropbox{
    
    NSMutableData* data = [[NSMutableData alloc] init];
    NSString *pathToFile=fileName;
    
    NSInputStream* stream = [dropbox downloadFileWithPath:pathToFile];
    uint8_t byteBuffer[4096];
    [stream open];
    while (stream.hasBytesAvailable)
    {
        NSInteger bytesRead = [stream read:byteBuffer maxLength:sizeof(byteBuffer)]; //max len must match buffer size
        [data appendBytes:byteBuffer length:bytesRead];
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
+ (NSString*)authMoreLeftString:(NSString*)leftString numString:(NSString*)numString;{
    return [NSString stringWithFormat:leftString,numString];
}
+(void)addAlertTitle:(NSString *)title message:(NSString *)message buttonString:(NSString *)buttonString buttonBlock:(leftButton)buttonBlock{
    MGPopController *pop = [[MGPopController alloc] initWithTitle:title message:nil image:nil];
    MGPopAction *action =   [MGPopAction actionWithTitle:buttonString action:^{
        buttonBlock(@"");
    }];
    action.titleColor =MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
}
+ (NSString*)ownerTobase58:(NSString*)string{
    NSData * ttdata = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base58String = [ttdata base58String];
    NSLog(@"%@",base58String);
    
    NSString * hexString = [self hexStringFromString:base58String];
    NSLog(@"hexString=%@",hexString);
    return hexString;
}
+ (NSString*)convertToJsonData:(NSDictionary*)dic{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

// 是否登录 ONTID
+ (BOOL)userLogin {
    NSString *ontID = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
    if ([self isBlankString:ontID]) {
        return NO;
    }else {
        return YES;
    }
}
//URLDEcode
+ (NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSLog(@"%@",decodedString);
    return decodedString;
}

+(void)showErrorMsg:(NSString*)errorInfo {
    MGPopController *pop = [[MGPopController alloc] initWithTitle:errorInfo message:nil image:nil];
    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
        
    }];
    action.titleColor =MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
}
//+(void)addAlertTitle:(NSString *)title message:(NSString *)message leftString:(NSString *)leftString rightString:(NSString *)rightString leftBlock:(leftButton)leftBlock rightBlock:(rightButton)rightBlock{
//    MGPopController *pop = [[MGPopController alloc] initWithTitle:title message:nil image:nil];
//    MGPopAction *action =   [MGPopAction actionWithTitle:leftString action:^{
//        leftBlock(@"");
//    }];
//    action.titleColor =MainColor;
//    [pop addAction:action];
//    [pop show];
//    pop.showCloseButton = NO;
//}
@end

