//
//  ShareWalletDetailCell.m
//  ONTO
//
//  Created by Apple on 2018/7/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ShareWalletDetailCell.h"
#import "Config.h"
@implementation ShareWalletDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
- (void)createUI {
    NSString *moneyStr = @"100 ONT";
    CGSize strSize =
        [moneyStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]}];
    _moneyNumLB = [[UILabel alloc]
        initWithFrame:CGRectMake(16 * SCALE_W, 10 * SCALE_W, strSize.width + 20 * SCALE_W, 22 * SCALE_W)];
    _moneyNumLB.textAlignment = NSTextAlignmentLeft;
    _moneyNumLB.textColor = BLACKLB;
    _moneyNumLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _moneyNumLB.text = moneyStr;
    [self addSubview:_moneyNumLB];

    //    _redDot =[[UIImageView alloc]init];
    //    _redDot.backgroundColor =[UIColor colorWithHexString:@"#E76982"];
    //    _redDot.layer.cornerRadius=3.5*SCALE_W;
    //    [self.contentView addSubview:_redDot];
    //    [_redDot mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(_moneyNumLB.mas_right).offset(2.5*SCALE_W);
    //        make.bottom.equalTo(_moneyNumLB.mas_top).offset(5*SCALE_W);
    //        make.width.height.mas_offset(7*SCALE_W);
    //    }];


    _timeLB = [[UILabel alloc]
        initWithFrame:CGRectMake(SYSWidth / 2, 12 * SCALE_W, SYSWidth / 2 - 16 * SCALE_W, 18 * SCALE_W)];
    _timeLB.font = [UIFont systemFontOfSize:14];
    _timeLB.textAlignment = NSTextAlignmentRight;
    _timeLB.textColor = LIGHTGRAYLB;
    _timeLB.text = @"06/28/2018 13:33";
    [self addSubview:_timeLB];

    _addressLB = [[UILabel alloc]
        initWithFrame:CGRectMake(16 * SCALE_W, 52 * SCALE_W, SYSWidth / 2 + 32 * SCALE_W, 18 * SCALE_W)];
    _addressLB.font = [UIFont systemFontOfSize:14];
    _addressLB.textAlignment = NSTextAlignmentLeft;
    _addressLB.textColor = LIGHTGRAYLB;
    _addressLB.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _addressLB.text =
        [NSString stringWithFormat:@"%@ dt42qsesfsdfd…for30d", Localized(@"shareAddress")];//@"Address: dt42qsesfsdfd…for30d";
    [self addSubview:_addressLB];

    UIImageView *rightImage = [[UIImageView alloc]
        initWithFrame:CGRectMake(SYSWidth - 32 * SCALE_W, 60 * SCALE_W, 16 * SCALE_W, 16 * SCALE_W)];
    rightImage.image = [UIImage imageNamed:@"sharelight_gray"];
    [self addSubview:rightImage];
    //    _statusLB =[[UILabel alloc]initWithFrame:CGRectMake(SYSWidth/2+48*SCALE_W, 52*SCALE_W, SYSWidth/2-60*SCALE_W, 18*SCALE_W)];
    //    _statusLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    //    _statusLB.textAlignment =NSTextAlignmentRight;
    //    _statusLB.textColor =[UIColor colorWithHexString:@"#8DD63E"];
    //    _statusLB.text =@"success";
    //    [self addSubview:_statusLB];

    UIView
        *line = [[UIView alloc] initWithFrame:CGRectMake(16 * SCALE_W, 84 * SCALE_W - 1, SYSWidth - 32 * SCALE_W, 1)];
    line.backgroundColor = LINEBG;
    [self addSubview:line];

}
- (void)reloadCell:(ShareTradeModel *)model isONT:(BOOL)isONT {
    NSString *moneyStr =
        isONT ? [NSString stringWithFormat:@"%@ ", model.amount] : [Common divideAndReturnPrecision9Str:model.amount];

    CGSize strSize =
        [moneyStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]}];

    _moneyNumLB.frame = CGRectMake(16 * SCALE_W, 10 * SCALE_W, strSize.width, 22 * SCALE_W);
    _moneyNumLB.text = moneyStr;
    _addressLB.text = [NSString stringWithFormat:@"%@", model.receiveaddress];
    _timeLB.text = [Common newGetTimeFromTimestamp:[NSString stringWithFormat:@"%lld",
                                                                              [model.createtimestamp longLongValue]
                                                                                  / 1000]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
