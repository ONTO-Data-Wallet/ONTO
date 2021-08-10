//
//  ONTODAppHomeRecommendCollecViewCell.m
//  ONTO
//
//  Created by onchain on 2019/5/20.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHomeRecommendCollecViewCell.h"
#import "UIImageView+WebCache.h"
#import "ONTODAppHomeAppModel.h"
#import <Masonry/Masonry.h>
#import <YYKit.h>

@interface ONTODAppHomeRecommendCollecViewCell ()
{
    
}
@property(nonatomic,strong)UIImageView          *imageView;
@property(nonatomic,strong)UILabel              *titleLabel;
@end
@implementation ONTODAppHomeRecommendCollecViewCell
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_offset(75);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.height.mas_offset(24);
    }];
    
}

#pragma mark - Private
-(void)p_initSetting
{
    
}

-(void)p_initUI
{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
}

#pragma mark - Public
-(void)refreshCollectCellModel:(ONTODAppHomeAppModel*)model
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.name;
}

#pragma mark - Properties
-(UIImageView*)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 6;
    }
    return _imageView;
}

-(UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:10];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#010101"];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}



@end
