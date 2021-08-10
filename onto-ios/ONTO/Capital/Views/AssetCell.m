//
//  AssetCell.m
//  ONTO
//
//  Created by 张超 on 2018/3/24.
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

#import "AssetCell.h"
#import "Config.h"
#import "BaseBorderCell.h"

@implementation AssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(NSString *)name amount:(NSString *)amount type:(NSString *)type tokenArray:(NSMutableArray *)tokenArray{
    
    NSArray * defaultTokenArray = [[NSUserDefaults standardUserDefaults]valueForKey:DEFAULTTOKENLIST];

    if ([name isEqualToString:ONTNEP5]) {
        self.titleL.text = name;
        self.moneyL.text = [Common divideAndReturnPrecision8Str:amount];
        [self.weizhi setConstant:31];
        self.typeL.hidden = YES;
    } else if ([name isEqualToString:@"ONG"]) {
        self.titleL.text = name;
        self.typeL.text = @"0.00";
        [self.weizhi setConstant:31];
        self.moneyL.text = [Common getPrecision9Str:amount];
        if ([self.moneyL.text isEqualToString:@"0"]) {
            self.moneyL.text = ONG_ZERO;
        }
    }else if ([name isEqualToString:@"totalpumpkin"]) {
        self.moneyL.text = amount;
        self.titleL.text = @"PUMPKIN";
        self.typeL.hidden = YES;
        [self.weizhi setConstant:31];
        
    }else if ([name isEqualToString:@"HyperDragons"]) {
        self.moneyL.text = amount;
        self.titleL.text = @"HyperDragons";
        self.typeL.hidden = YES;
        [self.weizhi setConstant:31];
        
    }else if ([name isEqualToString:@"ONT"]) {
        self.moneyL.text = [Common countNumAndChangeformat:amount];
        self.titleL.text = name;
        self.typeL.text = type;
    }else {
        if (tokenArray.count > 0) {
            
            for (NSDictionary * dic in tokenArray) {
                if ([name isEqualToString:dic[@"ShortName"]]) {
                    self.moneyL.text = [Common getPrecision9Str:amount Decimal:[dic[@"Decimals"] intValue]];
                    if ([self.moneyL.text isEqualToString:@"0"]) {
                        self.moneyL.text = [Common getOEP4ZeroStr:@"0" Decimals:[dic[@"Decimals"] intValue]];
                    }
                }
                
            }
        }
        if (defaultTokenArray.count > 0) {
            
            for (NSDictionary * dic in defaultTokenArray) {
                if ([name isEqualToString:dic[@"ShortName"]]) {
                    self.moneyL.text = [Common getPrecision9Str:amount Decimal:[dic[@"Decimals"] intValue]];
                    if ([self.moneyL.text isEqualToString:@"0"]) {
                        self.moneyL.text = [Common getOEP4ZeroStr:@"0" Decimals:[dic[@"Decimals"] intValue]];
                    }
                }
                
            }
        }
        self.titleL.text = name;
        self.typeL.text = type;
    }
}

- (NSString *)toExponent:(double)d rms:(unsigned)n {
    if (n == 0) {
        return nil;
    }
    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
    CFNumberFormatterRef customCurrencyFormatter = CFNumberFormatterCreate
        (NULL, currentLocale, kCFNumberFormatterCurrencyStyle);
    NSString *s_n = @"#";
    if (n > 1) {
        for (int j = 0; j < n; j++) {
            NSString *temp = s_n;
            if (j == 0) {
                s_n = [temp stringByAppendingString:@"."];
            } else {
                s_n = [temp stringByAppendingString:@"0"];
            }

        }

    }
    CFNumberFormatterSetFormat(customCurrencyFormatter, (CFStringRef) s_n);

    double i = 1;
    int exponent = 0;
    while (1) {
        i = i * 10;
        exponent++;
        if (d < i) {
            break;
        }
    }
    double n1 = d * 10 / i;

    CFNumberRef number1 = CFNumberCreate(NULL, kCFNumberDoubleType, &n1);
    CFStringRef string1 = CFNumberFormatterCreateStringWithNumber
        (NULL, customCurrencyFormatter, number1);

    NSString *result =
        [NSString stringWithFormat:@"%s E%d", CFStringGetCStringPtr(string1, CFStringGetSystemEncoding()), exponent];

    CFRelease(currentLocale);
    CFRelease(customCurrencyFormatter);
    CFRelease(number1);
    CFRelease(string1);

    return result;

}

@end
