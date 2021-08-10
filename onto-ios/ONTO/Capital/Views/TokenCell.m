//
//  TokenCell.m
//  ONTO
//
//  Created by Apple on 2019/1/4.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "TokenCell.h"
#import "config.h"
@implementation TokenCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _tokenImage = [[UIImageView alloc]init];
    [self addSubview:_tokenImage];
    
    _nameLB = [[UILabel alloc]init];
    _nameLB.text = @"ONT";
    _nameLB.textAlignment = NSTextAlignmentLeft;
    _nameLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self addSubview:_nameLB];
    
    _typeLB = [[UILabel alloc]init];
    _typeLB.text = @"OEP-8";
    _typeLB.alpha = 0.7;
    _typeLB.textAlignment = NSTextAlignmentLeft;
    _typeLB.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [self addSubview:_typeLB];
    
    _showButton = [[UISwitch alloc]init];
    _showButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [self addSubview:_showButton];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self addSubview:line];
    
    [_tokenImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(10);
        make.width.height.mas_offset(50);
    }];
    
    [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tokenImage.mas_right).offset(10);
        make.top.equalTo(self).offset(15);
    }];
    
    [_typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLB);
        make.top.equalTo(_nameLB.mas_bottom).offset(7);
    }];
    
    [_showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_offset(1);
        make.bottom.equalTo(self);
    }];
    
    
}
-(void)reloadCellByDic:(NSDictionary*)dic{
    
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *walletDic = [Common dictionaryWithJsonString:jsonStr];
    NSMutableArray *showArray = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@%@",walletDic[@"address"],TOKENLISTSHOW]];
    NSArray * defaultTokenArray = [[NSUserDefaults standardUserDefaults]valueForKey:DEFAULTTOKENLIST];
    _nameLB.text = dic[@"ShortName"];
    if ([dic[@"ShortName"] isEqualToString:@"ONT"] || [dic[@"ShortName"] isEqualToString:@"ONG"]  ) {
        _typeLB.hidden = YES;
        _showButton.hidden = YES;
        _tokenImage.image = [UIImage imageNamed:dic[@"picImage"]];
        [_nameLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(27);
        }];
    }else if ([dic[@"ShortName_1"] isEqualToString:@"PUMPKIN"] || [dic[@"ShortName_1"] isEqualToString:@"HyperDragons"]){
        _nameLB.text = dic[@"ShortName_1"];
        _typeLB.hidden = NO;
        _typeLB.text = dic[@"Type"];
        _tokenImage.image = [UIImage imageNamed:dic[@"picImage"]];
        if (showArray.count>0) {
            for (NSDictionary * showDic in showArray) {
                if ([dic[@"ShortName"] isEqualToString:showDic[@"AssetName"]]) {
                    if ([showDic[@"isShow"] isEqualToString:@"0"]) {
                        [_showButton setOn:YES];
                    }else{
                        [_showButton setOn:NO];
                    }
                }
            }
        }else{
            [_showButton setOn:NO];
        }
    } else{
        BOOL isDefault = NO;
        if (defaultTokenArray.count > 0) {
            for (NSDictionary * defaultDic in defaultTokenArray) {
                if ([dic[@"ShortName"] isEqualToString:defaultDic[@"ShortName"]] ) {
                    isDefault = YES;
                    _typeLB.hidden = NO;
                    _showButton.hidden = YES;
                    if ([dic[@"ShortName"] isEqualToString:@"PAX"])
                    {
                        _tokenImage.image = [UIImage imageNamed:@"DApp_Pax"];
                    }
                    else
                    {
                        [_tokenImage sd_setImageWithURL:[NSURL URLWithString:dic[@"Logo"]]];
                    }
                    _typeLB.hidden = YES;
                    [_nameLB mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self).offset(27);
                    }];
                }
            }
        }
        
        if (!isDefault) {
            _typeLB.hidden = NO;
            _showButton.hidden = NO;
            [_tokenImage sd_setImageWithURL:[NSURL URLWithString:dic[@"Logo"]]];
            _typeLB.text = dic[@"Type"];
            if (showArray.count>0) {
                for (NSDictionary * showDic in showArray) {
                    if ([dic[@"ShortName"] isEqualToString:showDic[@"AssetName"]]) {
                        if ([showDic[@"isShow"] isEqualToString:@"0"]) {
                            [_showButton setOn:YES];
                        }else{
                            [_showButton setOn:NO];
                        }
                    }
                }
            }else{
                [_showButton setOn:NO];
            }
        }
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
