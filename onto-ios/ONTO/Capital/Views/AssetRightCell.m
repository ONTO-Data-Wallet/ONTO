//
//  AssetRightCell.m
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

#import "AssetRightCell.h"
#import "Config.h"
#import "UIView+Scale.h"

@implementation AssetRightCell

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
        self.imageV = [[UIImageView alloc] init];
        self.imageV.image = [UIImage imageNamed:@"asset_icon2"];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageV];
        
        self.titleL = [[UILabel alloc] init];
        self.titleL.font = [UIFont systemFontOfSize:14*SCALE_W];
        self.titleL.textColor = [UIColor colorWithHexString:@"#868686"];
        self.titleL.text = @"Alice";
        [self.contentView addSubview:self.titleL];
        
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(39, 39));
            make.centerY.mas_equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
        }];
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageV.mas_right).offset(20);
            make.centerY.mas_equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)fillImage:(NSString *)imageStr Title:(NSString *)title Small:(BOOL)isSmall {
    self.imageV.image = [UIImage imageNamed:imageStr];
    self.titleL.text = title;
    self.imageV.contentMode = UIViewContentModeCenter;
//    self.imageV.contentMode = UIViewContentModeLeft;

    if (isSmall) {
        [self.imageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(self.contentView).offset(27);
        }];
    } else {
        [self.imageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(self.contentView).offset(27);
        }];
    }
}

@end
