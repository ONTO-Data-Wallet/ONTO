//
//  ONTODAppChangeWalletAlertView.m
//  ONTO
//
//  Created by Apple on 2019/5/16.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppChangeWalletAlertView.h"

#import <Masonry/Masonry.h>
#import <YYKit.h>
#import "Config.h"

#define VIEW_EDGE 15
#define VIEW_HEIGHT 232
#define VIEW_Y ([UIScreen mainScreen].bounds.size.height-VIEW_HEIGHT)/2
#define VIEW_WIDTH  [UIScreen mainScreen].bounds.size.width-2*VIEW_EDGE

@interface ONTODAppChangeWalletAlertView ()
{
    NSString           *_titleStr;
}
@property(nonatomic,strong)UILabel          *titleLabel;
@property(nonatomic,strong)UIButton         *closeButton;
@property(nonatomic,strong)UIButton         *createButton;
@property(nonatomic,strong)UIButton         *inputButton;
@property(nonatomic,strong)UIView           *bgView;
@end
@implementation ONTODAppChangeWalletAlertView
#pragma mark - Init
+(ONTODAppChangeWalletAlertView *)CreatWalletTipsAlertView
{
    return [[ONTODAppChangeWalletAlertView alloc] init];
}

#pragma mark - Private
-(instancetype)init
{
    CGRect viewFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (self = [super initWithFrame:viewFrame])
    {
        [self p_initSetting];
        [self p_initData];
        [self p_initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //        CGRect viewFrame = CGRectMake(VIEW_EDGE, VIEW_Y, VIEW_WIDTH, VIEW_HEIGHT);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(VIEW_EDGE);
        make.top.mas_equalTo(VIEW_Y);
        make.right.equalTo(self).offset(-VIEW_EDGE);
//        make.height.mas_equalTo(VIEW_HEIGHT);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(20);
        make.top.equalTo(self.bgView).offset(29);
        make.width.mas_equalTo(166);
//        make.height.mas_equalTo(59);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-20);
        make.top.equalTo(self.bgView).offset(38);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(42);
        make.right.equalTo(self.bgView).offset(-20);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
    }];
    
}

#pragma mark - Private
-(void)p_initSetting
{
    self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.8];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)setIsDapp:(BOOL)isDapp {
    _isDapp = isDapp;
    [self p_initData];
}
-(void)p_initData
{
    if (_isDapp) {
        
        _titleStr = Localized(@"ChangeWalletDApp");
    }else{
        _titleStr = Localized(@"DappChangeWalletTitle");
    }
    self.titleLabel.text = _titleStr;
}

-(void)p_initUI
{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.closeButton];
    [self.bgView addSubview:self.createButton];
//    [self.bgView addSubview:self.inputButton];
}

-(void)p_removeFromSuperView
{
    [self removeFromSuperview];
}

//Button Slots
-(void)p_closeSlot:(UIButton*)button
{
    [self p_removeFromSuperView];
}


-(void)p_createSlot:(UIButton*)button
{
    [self p_removeFromSuperView];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(walletTipsAlertChangeBtnSlot:)])
    {
        [self.delegate walletTipsAlertChangeBtnSlot:self];
    }
}

#pragma mark - Properties
-(UIView*)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.clipsToBounds = YES;
        _bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _bgView.layer.cornerRadius = 10;
    }
    return _bgView;
}

-(UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:21];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(UIButton*)createButton
{
    if (!_createButton)
    {
        _createButton = [[UIButton alloc] init];
        [_createButton setTitle:Localized(@"DappChangeWalletTitle") forState:UIControlStateNormal];
        _createButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_createButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _createButton.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        _createButton.clipsToBounds = YES;
        _createButton.layer.cornerRadius = 5;
        [_createButton setEnlargeEdge:25];
        [_createButton addTarget:self action:@selector(p_createSlot:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createButton;
}

-(UIButton*)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"DApp_Close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(p_closeSlot:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
