//
//  PendCell.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/15.
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

#import "PendCell.h"
#import "UIView+Scale.h"
#import "Config.h"
#import "VerifiedClaimModel.h"
#import "FrameAccessor.h"

@implementation PendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_cerImage scaleFrameBaseWidth];
    [_cerLabel scaleFrameBaseWidth];
    [_issuerLabel scaleFrameBaseWidth];
    [_issuer scaleFrameBaseWidth];
    [_pendingImage scaleFrameBaseWidth];
    [_historyImage scaleFrameBaseWidth];

}

-(void)configWithModel:(VerifiedClaimModel*)model{
    
//    NSString *timeString = model.CreateTime;
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSDate *timeDate = [formatter1 dateFromString:timeString];
//    NSInteger timeInterval = model.CreateTime;
    _cerLabel.text =  [NSString stringWithFormat:@"%@",model.Description];
    
    
    _issuerLabel.text =[Common getTimeFromTimestamp:[NSString stringWithFormat:@"%ld",model.CreateTime]];
    _issuer.text =[NSString stringWithFormat:@"Issuer: %@",model.IssuerName];
    
 
//    可信声明状态 4:待确认 1:已确认接收 2:已拒绝接收
    
    //已接收
    if ([[model.Status description]isEqualToString:@"1"]) {
        _cerImage.image = [UIImage imageNamed:@"Cer_Accept"];
        _historyImage.image = [UIImage imageNamed:@"Cer"];
        _historyImage.hidden = NO;
        _statusLabel.hidden = YES;
        
    }
    //待接收
    else if ([[model.Status description]isEqualToString:@"4"]) {
        
        _cerImage.image = [UIImage imageNamed:@"Cer_Gray"];
        _historyImage.image = [UIImage imageNamed:@"reject"];
        _statusLabel.text = Localized(@"Pending");
        
    }
    //拒绝
    else if ([[model.Status description]isEqualToString:@"2"]) {
         _cerImage.image = [UIImage imageNamed:@"Cer_Gray"];
         _historyImage.image = [UIImage imageNamed:@"reject"];
        _statusLabel.text = Localized(@"Canceled");

      
    }
    
//    if ([[model.Status description]isEqualToString:@"4"]){
//        _pendingImage.centerY = self.height/2;
//        _issuerLabel.hidden = YES;
//    }
}

- (NSString *)updateTimeForRow:(NSInteger )createTimeString {
    
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
    NSInteger sec = time/60+1;
    if (sec<60) {
        
        return [NSString stringWithFormat:@"%ld %@",sec,Localized(@"MinutesAgo")];
        
    }
    
    //    Localized(@"MinutesAgo")
    //    Localized(@"SecondsAgo")
    
    
    
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld %@",hours,Localized(@"HoursAgo")];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld %@",days,Localized(@"DaysAgo")];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld %@",months,Localized(@"MonthAgo")];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld %@",years,Localized(@"YearsAgo")];
}
@end
