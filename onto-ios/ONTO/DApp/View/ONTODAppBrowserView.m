//
//  ONTODAppBrowserView.m
//  ONTO
//
//  Created by onchain on 2019/5/9.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppBrowserView.h"
#import "ONTODAppHistoryTableViewCell.h"
#import "ONTODAppHistoryListModel.h"
#import <Masonry/Masonry.h>
#import <YYKit.h>
#import "Config.h"
#import "FileManager.h"

#define HISTORY_LISTS @"HistoryLists"
#define Cell_Height 67.5

@interface ONTODAppBrowserView ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,strong)UIView           *searchBgView;
@property(nonatomic,strong)UIImageView      *iconImageView;
@property(nonatomic,strong)UITextField      *contentTextField;
@property(nonatomic,strong)UIButton         *clearHistoryButton;
@property(nonatomic,strong)UITableView      *historyTableView;
@property(nonatomic,strong)UIButton         *cancelButton;
@property(nonatomic,strong)NSMutableArray   *historyModelList;
@end
@implementation ONTODAppBrowserView
#pragma mark - Init
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self p_initSetting];
        [self p_initData];
        [self p_initUI];
        [self p_initObserver];
    }
    return self;
}

#pragma mark - Layout
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(45);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBgView).offset(15);
        make.top.equalTo(self.searchBgView).offset(14.5);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.searchBgView).offset(13.5);
        make.height.mas_equalTo(18.5);
        make.right.equalTo(self.searchBgView).offset(-15);
    }];
    
    [self.clearHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-90);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.contentTextField.mas_bottom).offset(30);
        make.right.equalTo(self).offset(-20);
        make.bottom.mas_equalTo(self.clearHistoryButton.mas_top).offset(-20);
    }];

    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_right).offset(30);
        make.top.equalTo(self.searchBgView).offset(13.5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(21);
    }];
}

#pragma mark - Private
-(void)p_initSetting
{
    
}

-(void)p_initUI
{
    [self addSubview:self.historyTableView];
    [self addSubview:self.searchBgView];
    [self.searchBgView addSubview:self.iconImageView];
    [self.searchBgView addSubview:self.contentTextField];
    [self addSubview:self.cancelButton];
    [self addSubview:self.clearHistoryButton];
}

-(void)p_initData
{
    self.historyModelList = [[FileManager sharedInstance] readFileWithKey:HISTORY_LISTS];
}

-(void)p_initObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardAction:(NSNotification*)sender
{
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if([sender.name isEqualToString:UIKeyboardWillShowNotification])
    {
        self.clearHistoryButton.bottom = [value CGRectValue].size.height-20;
    }
    else
    {
        self.clearHistoryButton.top = self.historyTableView.bottom+20;
    }
}

-(void)p_clearHistorySlot:(UIButton*)button
{
    [[FileManager sharedInstance] removeFileOfListWithKey:HISTORY_LISTS];
    self.historyModelList = [NSMutableArray array];
    [self.historyTableView reloadData];
}

-(void)p_cancelSlot:(UIButton*)button
{
    [self.contentTextField resignFirstResponder];
    [self p_viewDisappearAnimation];
}

-(void)p_viewAppearAnimation
{
    self.cancelButton.left = self.right+self.cancelButton.width;
    self.cancelButton.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{

        self.searchBgView.right = self.right-70;
        
        self.cancelButton.left = self.searchBgView.right+20;

        self.searchBgView.right = self.cancelButton.left-20;
        
        self.searchBgView.left = self.left+20;
        
        self.searchBgView.width = self.searchBgView.width-50;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)p_viewDisappearAnimation
{
    [UIView animateWithDuration:0.2 animations:^{

        self.searchBgView.right = self.right-20;
        
        self.searchBgView.left = self.left+20;
        
        self.searchBgView.width = self.width-40;
        
        self.cancelButton.left = self.right+self.cancelButton.width;
        
    } completion:^(BOOL finished) {
        self.cancelButton.hidden = YES;
    }];
}

-(void)p_createHeadView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _historyTableView.width, 20)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3.5, 100, 16.5)];
    titleLabel.text = Localized(@"DappSearchHistoryTitle");;
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [headerView addSubview:titleLabel];
    _historyTableView.tableHeaderView = headerView;
}

-(void)p_initHistoryListModelWithTitle:(NSString*)title AndUrl:(NSString*)url
{
    NSDictionary *modelDict = @{@"historyTitle":title,@"historyUrlStr":url};
    
    [self.historyModelList addObject:modelDict];
    
    [self.historyTableView reloadData];
    
    [[FileManager sharedInstance] writeFileOfModel:[ONTODAppHistoryListModel modelWithJSON:modelDict] WithKey:HISTORY_LISTS];
    
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self p_viewAppearAnimation];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self p_viewDisappearAnimation];
    
    if (textField.text.length>0)
    {
        [self p_initHistoryListModelWithTitle:textField.text AndUrl:textField.text];
        
        //Enter H5
        if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppBrowserEnterWebWithUrlStr:)])
        {
            [self.delegate ONTODAppBrowserEnterWebWithUrlStr:textField.text];
        }
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self p_viewDisappearAnimation];
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Cell_Height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cell_identifier = @"cell_identifier";
    ONTODAppHistoryTableViewCell * historyCell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
    if (!historyCell)
    {
        historyCell = [[ONTODAppHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
    }
    
    if ([indexPath row]<self.historyModelList.count)
    {
        ONTODAppHistoryListModel *model =  [ONTODAppHistoryListModel modelWithJSON:self.historyModelList[[indexPath row]]];
        [historyCell setCellShowWithModel:model];
    }
    
    return historyCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]<self.historyModelList.count)
    {
        ONTODAppHistoryListModel *model =  [ONTODAppHistoryListModel modelWithJSON:self.historyModelList[[indexPath row]]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppBrowserEnterWebWithUrlStr:)])
        {
            [self.delegate ONTODAppBrowserEnterWebWithUrlStr:model.historyUrlStr];
        }
    }
}

#pragma mark - Properties
-(UIView*)searchBgView
{
    if (!_searchBgView)
    {
        _searchBgView = [[UIView alloc] init];
        _searchBgView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        _searchBgView.clipsToBounds = YES;
        _searchBgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
        _searchBgView.layer.cornerRadius = 5.0;
        _searchBgView.layer.borderWidth = 0.5;
    }
    return _searchBgView;
}

-(UIImageView*)iconImageView
{
    if (!_iconImageView)
    {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"DApp_Search"];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

-(UITextField*)contentTextField
{
    if (!_contentTextField)
    {
        _contentTextField = [[UITextField alloc] init];
        _contentTextField.placeholder = Localized(@"DappBrowserPlaceholder");
        _contentTextField.textColor = [UIColor colorWithHexString:@"#000000"];
        _contentTextField.font = [UIFont systemFontOfSize:13];
        _contentTextField.delegate = self;
        _contentTextField.returnKeyType = UIReturnKeySearch;
    }
    return _contentTextField;
}

-(UIButton*)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:Localized(@"DappCancelButtonTitle") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(p_cancelSlot:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.hidden = YES;
    }
    return _cancelButton;
}

-(UIButton*)clearHistoryButton
{
    if (!_clearHistoryButton)
    {
        _clearHistoryButton = [[UIButton alloc] init];
        _clearHistoryButton.clipsToBounds = YES;
        _clearHistoryButton.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        _clearHistoryButton.layer.cornerRadius = 15;
        [_clearHistoryButton setTitle:Localized(@"DappBrowserButtonTitle") forState:UIControlStateNormal];
        _clearHistoryButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_clearHistoryButton setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        [_clearHistoryButton addTarget:self action:@selector(p_clearHistorySlot:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearHistoryButton;
}

-(UITableView*)historyTableView
{
    if (!_historyTableView)
    {
        _historyTableView = [[UITableView alloc] init];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 10);
        _historyTableView.showsVerticalScrollIndicator = NO;
        _historyTableView.separatorStyle = UITableViewCellEditingStyleNone;
        [self p_createHeadView];
    }
    return _historyTableView;
}

-(NSMutableArray*)historyModelList
{
    if (!_historyModelList)
    {
        _historyModelList = [NSMutableArray array];
    }
    return _historyModelList;
}

#pragma mark - Dealloc
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
