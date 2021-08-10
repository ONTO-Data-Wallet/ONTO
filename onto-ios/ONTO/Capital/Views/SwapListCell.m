//
//  SwapListCell.m
//  ONTO
//
//  Created by Apple on 2018/7/16.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "SwapListCell.h"
#import "Config.h"
#import "Common.h"
@implementation SwapListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _moneyNumLB =[[UILabel alloc]initWithFrame:CGRectMake(16*SCALE_W, 10*SCALE_W, SYSWidth/2-16*SCALE_W, 22*SCALE_W)];
    _moneyNumLB.textAlignment =NSTextAlignmentLeft;
    _moneyNumLB.textColor =BLACKLB;
    _moneyNumLB.font =[UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _moneyNumLB.text =@"100 ONT";
    [self addSubview:_moneyNumLB];
    
    _timeLB =[[UILabel alloc]initWithFrame:CGRectMake(SYSWidth/2, 12*SCALE_W, SYSWidth/2-16*SCALE_W, 18*SCALE_W)];
    _timeLB.font =[UIFont systemFontOfSize:14];
    _timeLB.textAlignment =NSTextAlignmentRight;
    _timeLB.textColor =LIGHTGRAYLB;
    _timeLB.text =@"06/28/2018 13:33";
    [self addSubview:_timeLB];
    
    _addressLB =[[UILabel alloc]initWithFrame:CGRectMake(16*SCALE_W, 52*SCALE_W, SYSWidth/2+32*SCALE_W, 18*SCALE_W)];
    _addressLB.font =[UIFont systemFontOfSize:14];
    _addressLB.textAlignment =NSTextAlignmentLeft;
    _addressLB.textColor =LIGHTGRAYLB;
    _addressLB.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _addressLB.text = [NSString stringWithFormat:@"%@ dt42qsesfsdfsdfsdfsdzsfdsfsdffor30d",Localized(@"shareAddress")];//@"Address: dt42qsesfsdfd…for30d";
    [self addSubview:_addressLB];
    
    _statusLB =[[UILabel alloc]initWithFrame:CGRectMake(SYSWidth/2+48*SCALE_W, 52*SCALE_W, SYSWidth/2-60*SCALE_W, 18*SCALE_W)];
    _statusLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _statusLB.textAlignment =NSTextAlignmentRight;
    _statusLB.textColor =[UIColor colorWithHexString:@"#8DD63E"];
    _statusLB.text =@"success";
    _statusLB.hidden =YES;
    [self addSubview:_statusLB];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(16*SCALE_W, 84*SCALE_W-1, SYSWidth-32*SCALE_W, 1)];
    line.backgroundColor =LINEBG;
    [self addSubview:line];
    
}
-(void)reloadCellByDic:(NSDictionary *)dic {
    if ([dic[@"assetname"] isEqualToString:@"ont"]) {
        _moneyNumLB.text =[NSString stringWithFormat:@"%d %@",[dic[@"amount"]intValue],@"ONT" ];
    }else{
        _moneyNumLB.text =[NSString stringWithFormat:@"%@ %@",dic[@"amount"],@"ONG" ];
    }
    
    _timeLB.text =[Common newGetTimeFromTimestamp:dic[@"confirmtime"]];
    
    NSString *jsonstr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonstr];
    
    NSString *address = dict[@"address"];
    _addressLB.text = [NSString stringWithFormat:@"%@ %@",Localized(@"shareAddress"),address];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
