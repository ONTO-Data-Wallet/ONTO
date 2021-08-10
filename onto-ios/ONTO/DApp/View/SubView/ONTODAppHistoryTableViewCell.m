//
//  ONTODAppHistoryTableViewCell.m
//  ONTO
//
//  Created by onchain on 2019/5/9.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHistoryTableViewCell.h"
#import <Masonry/Masonry.h>
#import <YYKit.h>

@interface ONTODAppHistoryTableViewCell ()
{
    
}
@property(nonatomic,strong)UILabel         *titleLabel;
@property(nonatomic,strong)UILabel         *contentLabel;
@end
@implementation ONTODAppHistoryTableViewCell
#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self p_initSetting];
        [self p_initUI];
    }
    return self;
}

#pragma mark - Layout
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(21);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(16.5);
    }];
    
}

#pragma mark - Private
-(void)p_initSetting
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)p_initUI
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
}

#pragma mark - Public
-(void)setCellShowWithModel:(ONTODAppHistoryListModel*)model
{
    self.titleLabel.text = model.historyTitle;
    self.contentLabel.text = model.historyUrlStr;
}

#pragma mark - Properties
-(UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    }
    return _titleLabel;
}

-(UILabel*)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#e6e6e6"];
    }
    return _contentLabel;
}

@end
