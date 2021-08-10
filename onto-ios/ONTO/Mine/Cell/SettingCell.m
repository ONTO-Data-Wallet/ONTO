//
//  SettingCell.m
//  ONTO
//
//  Created by 张超 on 2018/3/12.
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

#import "SettingCell.h"
#import "Config.h"

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleL = [[UILabel alloc] init];
        self.titleL.font = K17FONT;
        self.titleL.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.centerY.mas_equalTo(self.contentView);
        }];
        // 6 11.5
        _imageV   = [[UIImageView alloc] init];
        _imageV.image = [UIImage imageNamed:@"JT"];
        [self.contentView addSubview:_imageV];
        
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(6, 11.5));
            make.centerY.mas_equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-25);
        }];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
        [self.contentView addSubview:lineV];
        
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@1);
            make.right.bottom.mas_equalTo(self.contentView);
            make.left.equalTo(self.titleL).offset(0);
        }];
    }
    return self;
}

- (void)fillTitle:(NSString *)title {
    self.titleL.text = title;
}

@end
