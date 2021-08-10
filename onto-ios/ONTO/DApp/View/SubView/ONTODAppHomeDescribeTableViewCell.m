//
//  ONTODAppHomeDescribeTableViewCell.m
//  ONTO
//
//  Created by onchain on 2019/5/21.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHomeDescribeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ONTODAppHomeAppModel.h"
#import "Config.h"
#import <Masonry/Masonry.h>
#import <YYKit.h>

@interface ONTODAppHomeDescribeTableViewCell ()
{
    ONTODAppHomeAppModel          *_homeModel;
}
@property(nonatomic,strong)UIImageView         *bgImageView;
@property(nonatomic,strong)UILabel             *titleLabel;
@property(nonatomic,strong)UILabel             *contentLabel;
@property(nonatomic,strong)UIButton            *enterButton;
@end
@implementation ONTODAppHomeDescribeTableViewCell
#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.width.mas_offset(75);
        
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(2);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_right).offset(14);
        make.top.equalTo(self).offset(4);
        make.right.equalTo(self.enterButton.mas_left).offset(-10);
        make.height.mas_equalTo(12);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_right).offset(14);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.right.equalTo(self).offset(-19);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
}

#pragma mark - Private
-(void)p_initUI
{
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.enterButton];
    [self addSubview:self.contentLabel];
}

//slots
-(void)p_enterSlot:(UIButton*)button
{
    NSString *urlStr = _homeModel.link;
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterDappGameWithUrlStr:)])
    {
        [self.delegate enterDappGameWithUrlStr:urlStr];
    }
}

#pragma mark - Public
-(void)refreshCellWtihModel:(ONTODAppHomeAppModel*)model
{
    _homeModel = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:_homeModel.image]];
    self.titleLabel.text = _homeModel.name;
    self.contentLabel.text = _homeModel.tagline;
    [self.enterButton setTitle:_homeModel.category_name forState:UIControlStateNormal];
}

#pragma mark - Properties
-(UIImageView*)bgImageView
{
    if (!_bgImageView)
    {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.clipsToBounds = YES;
        _bgImageView.layer.cornerRadius = 6;
    }
    return _bgImageView;
}

-(UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#010101"];
//        _titleLabel.text = @"Axie Infinity";
    }
    return _titleLabel;
}

-(UIButton*)enterButton
{
    if (!_enterButton)
    {
        _enterButton = [[UIButton alloc] init];
        _enterButton.clipsToBounds = YES;
        _enterButton.backgroundColor = [UIColor clearColor];
        _enterButton.layer.cornerRadius = 8;
        _enterButton.layer.borderWidth = 1;
        _enterButton.layer.borderColor = [UIColor colorWithHexString:@"#BABABA"].CGColor;
        [_enterButton setTitle:@"GAME" forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:9];
        [_enterButton setTitleColor:[UIColor colorWithHexString:@"#BABABA"] forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(p_enterSlot:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

-(UILabel*)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont boldSystemFontOfSize:12];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#677578"];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLabel;
}

@end
