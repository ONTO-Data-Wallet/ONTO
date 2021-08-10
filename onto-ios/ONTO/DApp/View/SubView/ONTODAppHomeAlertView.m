//
//  ONTODAppHomeAlertView.m
//  ONTO
//
//  Created by onchain on 2019/5/22.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHomeAlertView.h"
#import <Masonry/Masonry.h>
#import <YYKit.h>
#import "Config.h"

#define VIEW_EDGE 15
#define VIEW_HEIGHT 352
#define VIEW_WIDTH  [UIScreen mainScreen].bounds.size.width-2*VIEW_EDGE
@interface ONTODAppHomeAlertView ()
{
    
}
@property(nonatomic,strong)UIView           *bgView;
@property(nonatomic,strong)UILabel          *titleLabel;
@property(nonatomic,strong)UIButton         *closeButton;
@property(nonatomic,strong)YYLabel          *contentLabel;
@property(nonatomic,strong)UIButton         *acceptButton;
@property(nonatomic,strong)UIButton         *cancelButton;
@end
@implementation ONTODAppHomeAlertView
#pragma mark - Init
+(ONTODAppHomeAlertView *)CreatWalletTipsAlertViewWithDelegate:(id<ONTODAppHomeAlertViewDelegate>)delegate
{
    return [[ONTODAppHomeAlertView alloc] initWithDelegate:delegate];
}

#pragma mark - Private
-(instancetype)initWithDelegate:(id<ONTODAppHomeAlertViewDelegate>)delegate
{
    CGRect viewFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (self = [super initWithFrame:viewFrame])
    {
        self.delegate = delegate;
        [self p_initSetting];
        [self p_initData];
        [self p_initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(VIEW_EDGE);
        make.height.mas_equalTo(VIEW_HEIGHT);
        make.right.equalTo(self).offset(-VIEW_EDGE);
        make.bottom.equalTo(self).offset(-120);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(35);
        make.right.equalTo(self.bgView.mas_right).offset(-20);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.closeButton.mas_left).offset(-20);
        make.top.equalTo(self.bgView.mas_top).offset(29);
        make.height.mas_equalTo(30);
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(25);
//        make.bottom.equalTo(self.bgView.mas_bottom).offset(-100);
        make.right.equalTo(self.bgView.mas_right).offset(-20);
        make.height.mas_equalTo(130);
    }];
    
    [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.bgView.mas_right).offset(-20);
        make.height.mas_equalTo(42);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(20);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.bgView.mas_right).offset(-20);
        make.height.mas_equalTo(42);
        make.top.equalTo(self.acceptButton.mas_bottom).offset(20);
//        make.bottom.equalTo(self.bgView.mas_bottom).offset(-10);
    }];
    
}

#pragma mark - Private
-(void)p_initSetting
{
    self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.8];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)p_initData
{
    
}

-(void)p_initUI
{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.closeButton];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.acceptButton];
    [self.bgView addSubview:self.cancelButton];
    
}

-(void)p_removeFromSuperView
{
    [self removeFromSuperview];
}

#pragma mark - Slots
-(void)p_closeSlot:(UIButton*)button
{
    [self p_removeFromSuperView];
    
}

-(void)p_acceptSlot:(UIButton*)button
{
    [self p_removeFromSuperView];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(alertViewAcceptedBtnSlot:)])
    {
        [self.delegate alertViewAcceptedBtnSlot:self];
    }
}

-(void)p_cancelSlot:(UIButton*)button
{
     [self p_removeFromSuperView];
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
        _titleLabel.text = Localized(@"DappStatementTitle");
    }
    return _titleLabel;
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

-(YYLabel*)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        _contentLabel.font = [UIFont systemFontOfSize:18];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = Localized(@"DappStatement");
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    }
    return _contentLabel;
}

-(UIButton*)acceptButton
{
    if (!_acceptButton)
    {
        _acceptButton = [[UIButton alloc] init];
        [_acceptButton setTitle:Localized(@"DappStatementAgree") forState:UIControlStateNormal];
        _acceptButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_acceptButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _acceptButton.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        _acceptButton.clipsToBounds = YES;
        _acceptButton.layer.cornerRadius = 5;
        [_acceptButton addTarget:self action:@selector(p_acceptSlot:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptButton;
}

-(UIButton*)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:Localized(@"DappStatementCancel") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _cancelButton.clipsToBounds = YES;
        _cancelButton.layer.cornerRadius = 5;
        [_cancelButton addTarget:self action:@selector(p_cancelSlot:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}



@end

