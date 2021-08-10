//
//  NotificationCell.m
//  ONTO
//
//  Created by 赵伟 on 2018/4/18.
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

#import "NotificationCell.h"
#import "UIView+Scale.h"
#import "Config.h"
#import "VerifiedClaimModel.h"
@implementation NotificationCell

- (void)awakeFromNib {

    [super awakeFromNib];
    // Initialization code
    [_cerImage scaleFrameBaseWidth];
    [_cerLabel scaleFrameBaseWidth];
    [_issuerLabel scaleFrameBaseWidth];
    [_issuer scaleFrameBaseWidth];
    [_dotImage scaleFrameBaseWidth];
    [_lineImage scaleFrameBaseWidth];

    _dotImage.layer.cornerRadius = 3 * SCALE_W;
    _dotImage.layer.masksToBounds = YES;

}

- (void)configWithModel:(id)data {

    if ([data isKindOfClass:[VerifiedClaimModel class]]) {
        VerifiedClaimModel *model = data;
//        NSString *timeString = model.CreateTime;
//        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//        [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        NSDate *timeDate = [formatter1 dateFromString:timeString];
        NSInteger timeInterval = model.CreateTime;
        _cerLabel.text = [NSString stringWithFormat:@"%@", model.Description];
        _issuerLabel.text = [NSString stringWithFormat:@"%@", [self updateTimeForRow:timeInterval]];
        _issuer.text = [NSString stringWithFormat:@"From: %@", model.IssuerName];

        if ([[model.Status description] isEqualToString:@"1"]) {
            _cerImage.image = [UIImage imageNamed:@"Cer_Accept"];
        } else {
            _cerImage.image = [UIImage imageNamed:@"Cer_Gray"];
        }

        if ([[[NSUserDefaults standardUserDefaults] valueForKey:model.ClaimId] isEqualToString:@"1"]) {
            _dotImage.hidden = NO;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISNOTIFICATION];
        } else {
            _dotImage.hidden = YES;
        }
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        if ([[(NSDictionary *) data allKeys] containsObject:@"language"]) {
            //系统通知

            _cerLabel.text = [data valueForKey:@"title"];
            _issuer.text = [data valueForKey:@"content"];

            NSString *timetemp = [[data valueForKey:@"createTime"] stringValue];
            NSString *time = [timetemp substringWithRange:NSMakeRange(0, [timetemp length] - 3)];
            _issuerLabel.text = [self updateTimeForRow:[time doubleValue]];

            if ([[[NSUserDefaults standardUserDefaults] valueForKey:[[data valueForKey:@"createTime"] stringValue]]
                isEqualToString:@"1"]) {
                _dotImage.hidden = NO;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISNOTIFICATION];
            } else {
                _dotImage.hidden = YES;
            }

        } else if ([[(NSDictionary *) data allKeys] containsObject:@"send"]) {
            //转账通知

//
            if ([[data valueForKey:@"genre"] isEqualToString:@"ONT"]) {
                _cerLabel.text =
                    [NSString stringWithFormat:@"发送%@ %@%@", [data valueForKey:@"num"], [data valueForKey:@"genre"], @"成功"];
            } else {

                NSDecimalNumber *decimalONG = [[NSDecimalNumber alloc] initWithString:[data valueForKey:@"num"]];
                NSDecimalNumber *decimalONGDivide = [decimalONG decimalNumberByDividingBy:ONG_PRECISION_STR];
                _cerLabel.text = [NSString stringWithFormat:@"发送%@ %@%@",
                    [Common divideAndReturnPrecision9Str:[data valueForKey:@"num"]], [data valueForKey:@"genre"], @"成功"];
            }

            _issuer.text = [NSString stringWithFormat:@"支付给%@", [data valueForKey:@"get"]];
            _issuerLabel.text = [self updateTimeForRow:[[data valueForKey:@"createTime"] doubleValue]];
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:[data valueForKey:@"createTime"]]
                isEqualToString:@"1"]) {
                _dotImage.hidden = NO;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISNOTIFICATION];
            } else {
                _dotImage.hidden = YES;
            }

        } else {

            NSString *timeString = [Common getTimeFromTimestamp:[[data valueForKey:@"CreateTime"] stringValue]];
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate *timeDate = [formatter1 dateFromString:timeString];
            NSInteger timeInterval = [[NSNumber numberWithDouble:[timeDate timeIntervalSince1970]] integerValue];

            _cerLabel.text = [data valueForKey:@"Title"];
            _issuerLabel.text = [self updateTimeForRow:timeInterval];
            _issuer.text = [data valueForKey:@"Content"];

            if ([[[NSUserDefaults standardUserDefaults] valueForKey:[[data valueForKey:@"CreateTime"] stringValue]]
                isEqualToString:@"1"]) {
                _dotImage.hidden = NO;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISNOTIFICATION];
            } else {
                _dotImage.hidden = YES;
            }
        }

    }

    if (_dotImage.hidden == YES) {
        _cerLabel.frame = CGRectMake(24, 18, 226, 21);;
    }

}

//createTimeString为后台传过来的13位纯数字时间戳

- (NSString *)updateTimeForRow:(NSInteger)createTimeString {

    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = createTimeString;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
//    SecondsAgo = "秒前";
//    MinutesAgo = "分钟前";
//    HoursAgo = "小时前";
//    DaysAgo = "天前";
//    MonthAgo = "月前";
//    YearsAgo = "年前";
    NSInteger sec = time / 60 + 1;
    if (sec < 60) {
        return [NSString stringWithFormat:@"%ld %@", sec, Localized(@"MinutesAgo")];
    }
//    Localized(@"MinutesAgo")
//    Localized(@"SecondsAgo")


    // 秒转小时
    NSInteger hours = time / 3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld %@", hours, Localized(@"HoursAgo")];
    }
    //秒转天数
    NSInteger days = time / 3600 / 24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld %@", days, Localized(@"DaysAgo")];
    }
    //秒转月
    NSInteger months = time / 3600 / 24 / 30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld %@", months, Localized(@"MonthAgo")];
    }
    //秒转年
    NSInteger years = time / 3600 / 24 / 30 / 12;
    return [NSString stringWithFormat:@"%ld %@", years, Localized(@"YearsAgo")];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
