//
//  ONTODAppSectionTitleTableViewCell.m
//  ONTO
//
//  Created by onchain on 2019/5/21.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppSectionTitleTableViewCell.h"
#import <Masonry/Masonry.h>
#import <YYKit.h>
#import "Config.h"

@interface ONTODAppSectionTitleTableViewCell ()
{
    
}
@property(nonatomic,strong)UILabel           *titleLabel;
@end
@implementation ONTODAppSectionTitleTableViewCell
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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.height.mas_equalTo(20);
    }];
    
}

#pragma mark - Private
-(void)p_initUI
{
    [self addSubview:self.titleLabel];
}

#pragma mark - Properties
-(UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#677578"];
        _titleLabel.text = Localized(@"DappDappList");
    }
    return _titleLabel;
}

@end
