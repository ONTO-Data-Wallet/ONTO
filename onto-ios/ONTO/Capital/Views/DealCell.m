//
//  DealCell.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/24.
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

#import "DealCell.h"
#import "Common.h"
#import "Config.h"
@implementation DealCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)setModel:(TradeModel *)model {

  self.addressL.text = model.receiveaddress;
  self.timeL.text = [self getTimeFromTimestamp:model.createTimeLong];

  // 状态标志 0：Pending, 1：Success, 2：Fail
  if ([model.issuccess isEqualToString:@"1"]) {

    self.statusL.text = Localized(@"TransactionSuccess");

  } else if ([model.issuccess isEqualToString:@"0"]) {

    self.statusL.text = Localized(@"TransactionFailure");

  } else {

    self.statusL.text = Localized(@"Processing");
  }

  if (!_isONG) {

    if ([model.receiveaddress isEqualToString:model.myaddress]) {
      self.amountL.text =
//          [NSString stringWithFormat:@"+%@", [NSString stringWithFormat:@"%ld", [model.amoutStr longValue]]];
        [NSString stringWithFormat:@"+%@", model.amoutStr];
      self.amountL.textColor = [UIColor colorWithHexString:@"#8DD63E"];
    } else if ([model.sendaddress isEqualToString:model.myaddress]) {
      self.amountL.text =
//          [NSString stringWithFormat:@"-%@", [NSString stringWithFormat:@"%ld", [model.amoutStr longValue]]];
        [NSString stringWithFormat:@"-%@", model.amoutStr];
    }
    if ([model.sendaddress isEqualToString:model.receiveaddress]) {
      self.amountL.text =
//          [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%ld", [model.amoutStr longValue]]];
        [NSString stringWithFormat:@"%@", model.amoutStr];
      self.amountL.textColor = [UIColor colorWithHexString:@"#868686"];
    }
  } else {
    if ([model.receiveaddress isEqualToString:model.myaddress]) {

      self.amountL.text = [NSString stringWithFormat:@"+%@", [Common getPrecision9Str:model.amoutStr]];
      self.amountL.textColor = [UIColor colorWithHexString:@"#8DD63E"];

    } else if ([model.sendaddress isEqualToString:model.myaddress]) {

      self.amountL.text = [NSString stringWithFormat:@"-%@", [Common getPrecision9Str:model.amoutStr]];
    }

    if ([model.sendaddress isEqualToString:model.receiveaddress]) {

      self.amountL.text = [NSString stringWithFormat:@"%@", [Common getPrecision9Str:model.amoutStr]];
      self.amountL.textColor = [UIColor colorWithHexString:@"#868686"];

    }
  }
}

- (NSString *)getTimeFromTimestamp:(NSString *)timeq {

  //将对象类型的时间转换为NSDate类型

  double time = [timeq doubleValue] / 1000;

  NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time];

  //设置时间格式

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

  [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

  //将时间转换为字符串

  NSString *timeStr = [formatter stringFromDate:myDate];

  return timeStr;

}

@end
