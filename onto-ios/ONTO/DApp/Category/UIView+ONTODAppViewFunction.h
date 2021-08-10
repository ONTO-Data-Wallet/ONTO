//
//  UIView+ONTODAppViewFunction.h
//  ONTO
//
//  Created by onchain on 2019/5/14.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ONTODAppViewFunction)

- (NSString *)dictionaryToJson:(NSDictionary *)dic;

- (NSString *)base64EncodeString:(NSString *)string;

- (NSString *)stringEncodeBase64:(NSString *)base64;

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
