//
//  AppHelper.m
//  NongShiTong
//
//  Created by  on 16/11/9.
//  Copyright © 2016年 sf. All rights reserved.
//

#import "AppHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation AppHelper
NSString *CertificatePString_1 = @"qL";
NSString *CertificateString_1 = @"F4z20WKL/irIxJjG1H/FwInXWL1f5T/bbOe0TxkWfXNBi1pI2CJV7DMIx4  \
\
oDrUbR2Vh3ZunwGHozpOR4eo/WFwRoFtaSRhRoQdDdqStpkjDwVdAC8d6CFgNMKO  \
\
O+tBteb5WyjEaqULcU8lzDsN5xK+uRXhmii6uQ00mlT7m/HLh80xAZLCcXD9F5oC  \
\
dhFCfTEFw0dJclsLOBVIqDhlBwbsfxZx19XLx7bOteIA/AB2dWxMLgnhqPk8pXDU  \
\
JDTknbOUs+KV2R+gLv0nrzrrcF58cdxP4xn2FOzaG3XGjF7cIFjGp+WWZWCAlqly  \
\
M/2Cp5MRSo+z";  \
//是否为手机号
+ (BOOL)valiMobile:(NSString *)mobile{
    if (mobile.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        || ([regextestcm evaluateWithObject:mobile] == YES)
        || ([regextestct evaluateWithObject:mobile] == YES)
        || ([regextestcu evaluateWithObject:mobile] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }

}


//判断是否空字符串
+ (BOOL)isBlankString:(NSString *)string
{
    
    if (string == nil)
    {
        return YES;
    }
    
    if (string == NULL)
    {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]])
    {
        
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        return YES;
    }
    
    return NO;
    
}

//判断是否空数组
+ (BOOL)isBlankArray:(NSArray *)array
{
    if (array == nil)
    {
        return YES;
    }
    
    if (array == NULL)
    {
        return YES;
    }
    
    if ([array isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    return NO;
    
}

//判断网址是否合法
+ (BOOL)validateHttp:(NSString *) textString
{
    NSString* number=@"^([w-]+.)+[w-]+(/[w-./?%&=]*)?$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}


#pragma mark - 身份证识别
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

//生成随机数
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
}


#pragma mark -setBorderWithView
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

#pragma mark -colorWithHexString 16进制颜色转换
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

////带风火轮的网络请求封装
//+(void)RequestWithUrl:(NSString *)url Parameter:(NSMutableDictionary *)parameter message:(NSString *)msg View:(UIView *)view Success:(void (^)(NSDictionary *))success Failure:(void (^)(NSError *))failure
//{
//    __block MBProgressHUD *HUD;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
//        HUD.mode = MBProgressHUDModeIndeterminate;
//        if (msg != nil) {            
//            HUD.labelText = msg;
//        }
//    });
//    
//    
////    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"];
//    if([cookiesdata length]) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//        
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//            NSLog(@"cookie----------%@",cookie);
//        }
//    }
//    
////    NSArray *againCookie = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
//    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 20;
//    //    [manager.requestSerializer setValue:<#(nullable NSString *)#> forHTTPHeaderField:<#(nonnull NSString *)#>]
//    [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [HUD hide:YES];
//        });
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        
//        if (success) {
//            success(dic);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [HUD hide:YES];
//            if (failure) {
//                failure(error);
//            }
//        });
//        
//    }];
//    
//}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//+ (NSString *)md5WithKey:(NSString *)str{
//    NSString *md5key = [Account getOnKeychainUtilsWithName:@"md5key"];
//    str = [NSString stringWithFormat:@"%@%@",str,md5key];
//    return [self md5:str];
//}
//
////MBProgressHUD的2秒提示框
//+(void)MBProgressHUDAlertWithMessage:(NSString *)message View:(UIView *)currentView
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        MBProgressHUD *HUD = [[MBProgressHUD alloc]init];
//        [currentView addSubview:HUD];
//        HUD.detailsLabelText = message;
//        //    HUD.labelText = message;
//        HUD.mode = MBProgressHUDModeText;
//        [HUD showAnimated:YES whileExecutingBlock:^{
//            sleep(2);
//        } completionBlock:^{
//            [HUD removeFromSuperview];
//        }];
//    });
//}

//消息提示
+(void)AlertMessage:(NSString *) str{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:str delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    });
}

+ (NSString *)decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

//修正图片上传旋转90度问题
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation ==UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform =CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


//固定宽度计算文本高度
+(float)labelWithSting:(NSString *)theContent andWidth:(float)theWidth andFontSize:(float)theSize{
    float returnF = 0;
    UILabel *tempLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, theWidth, 2000)];
    [tempLab setText:nil];
    [tempLab setText:theContent];
    [tempLab setNumberOfLines:0];
    [tempLab setFont:[UIFont systemFontOfSize:theSize]];
    [tempLab sizeToFit];
    CGRect starRect = tempLab.frame;
    starRect.size.width = theWidth;
    returnF = starRect.size.height;
    
    return returnF;
}

//将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

+ (BOOL)checkPhoneNumber:(NSString *) phoneNumber{
    NSString *pattern = @"^(0\\d{2}-\\d{8}(-\\d{1,4})?)|(0\\d{3}-\\d{7,8}(-\\d{1,4})?)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return isMatch;
}


/** 正则匹配手机号 */
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    //^(0|\\+)?(86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$
    //^1+[3578]+\\d{9}
    //NSString *pattern = @"^(0|\\+)?(86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    
    NSString *pattern = @"^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    if (telNumber.length != 11) {
        return NO;
    }
    return isMatch;
}

/**  正则使用方法
 if (![AppHelper checkUserName1:self.info_tf.text]) {
    [AppHelper AlertMessage:@"所输昵称应为2-16位字符"];
    self.info_tf.text = @"";
    return;
 } 
 */

/** 正则匹配用户密码8-20位数字 字母 特殊字符组合 */
+ (BOOL)checkPassword:(NSString *) password
{
//    NSString *pattern = @"^(?![0-9]+$)|(?![a-zA-Z]+$)|[a-zA-Z0-9]{8,20}";/** 正则匹配用户密码8-20位数字和字母组合 */
    NSString *pattern = @"(?!^[0-9]+$)(?!^[A-z]+$)(?!^[^A-z0-9]+$)^.{8,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

/** 正则匹配用户姓名,4-16位的中文或英文 */
+ (BOOL)checkUserName : (NSString *) userName
{
    //^[a-zA-Z\u4E00-\u9FA5]{2,20}
    NSString *pattern = @"^([\\w\\d]{4,16})|([\u4e00-\u9fa5]{2,8})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}
/** 正则匹配用户姓名,2-16位的中文或英文 */
+ (BOOL)checkUserName1 : (NSString *) userName
{
    //^[a-zA-Z\u4E00-\u9FA5]{2,20}
    NSString *pattern = @"^([\\w\\d]{2,16})|([\u4e00-\u9fa5]{2,8})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}
/** 正则匹配用户身份证号 */
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}
/** 正则匹配URL */
+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}
//禁止输入含有^%&',;=?$\"等字符
+ (BOOL)checkUnString : (NSString *) strS{
    NSString *pattern = @"[^%&',;=?$\x22]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:strS];
    return isMatch;
}
/** 正则匹配邮政编码 */
+ (BOOL)checkPostalCode : (NSString *) postalCode{
    NSString *pattern = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:postalCode];
    return isMatch;
}

/** 正则匹配qq格式 */
+ (BOOL)checkQQ : (NSString *) qqNum{
    NSString *pattern = @"[1-9][0-9]{4,14}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:qqNum];
    return isMatch;
}

/** 正则匹配邮箱格式 */
+ (BOOL)checkEmail : (NSString *) emailNo{
    NSString *pattern = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:emailNo];
    return isMatch;
}

/** 正则匹配纯数字 */
+ (BOOL)checkAllNumber : (NSString *) numberString{
    NSString *pattern = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:numberString];
    return isMatch;
}
/** 正则匹配身份证 */
+ (BOOL)checkIDcardNum : (NSString *) numberString{
    NSString *pattern = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:numberString];
    return isMatch;
}

/** 正则匹配店铺名称 */
+ (BOOL)checkMerchantName : (NSString *) merchantName{
    NSString *pattern = @"[A-Za-z0-9\u4e00-\u9fa5\\·\\•]{7,32}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:merchantName];
    return isMatch;
}
/** 正则匹配姓名格式 *///有问题 
+ (BOOL)checkPeopleName : (NSString *) peopleName{
    NSString *pattern = @"[\u4e00-\u9fa5\\·\\•]{2,64}";
    
   // @"(?!^[u4e00-\u9fa5]+$)^.{0,}$"
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:peopleName];
    return isMatch;
}

/** 正则匹配日期格式 */
+ (BOOL)dateCheck:(NSString *)date{
    NSString *pattern = @"[0-9]{4}-[0-9]{2}-[0-9]{2}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:date];
    return isMatch;
}
/** 正则匹配邀请码格式 *///有问题
+ (BOOL)checkInvitecode : (NSString *) inviteCode{
    NSString *pattern = @"[0-9]{6,8}$";
    
    // @"(?!^[u4e00-\u9fa5]+$)^.{0,}$"
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:inviteCode];
    return isMatch;
}
//中文\数字\字母
+ (BOOL)checkName:(NSString *)name{
    NSString *regex = @"[A-Za-z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:name];
    return isMatch;
}
+(BOOL)deptNameInputShouldChinese:(NSString *)string{
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}



@end
