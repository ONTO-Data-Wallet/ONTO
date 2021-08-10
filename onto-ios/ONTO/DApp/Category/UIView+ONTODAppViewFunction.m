//
//  UIView+ONTODAppViewFunction.m
//  ONTO
//
//  Created by onchain on 2019/5/14.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "UIView+ONTODAppViewFunction.h"

@implementation UIView (ONTODAppViewFunction)

- (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData
    *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonDataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonDataStrWithoutEscape = [jsonDataStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return jsonDataStrWithoutEscape;
}

- (NSString *)base64EncodeString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)stringEncodeBase64:(NSString *)base64
{
    NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSString *base64Decoded = [[NSString alloc] initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    
    return base64Decoded;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
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

@end
