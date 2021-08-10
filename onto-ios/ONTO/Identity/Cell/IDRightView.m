//
//  IDRightView.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/26.
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

#import "IDRightView.h"
#import "Config.h"
#import "AssetRightCell.h"
@implementation IDRightView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self configTap];
    }
    return self;
}

- (void)configUI {

     _titleArray = @[@[Localized(@"MakeidentityCardTitle"),Localized(@"IDClaimNotice")],@[Localized(@"IDCreateIdentity"),Localized(@"IDImportIdentity")]];
    _imageArray = @[@[@"Identities _Apply",@"Identities _cn"],@[@"Identities _ai",@"Identities _ii"]];
    [self addSubview:self.tableV];
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX);
        make.right.bottom.top.mas_equalTo(self);
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCaliamNotication) name:NOTIFICATION_SOCKET_GETCLAIM object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutAction) name:NOTIFICATION_SOCKET_LOGOUT object:nil];
}

- (void)logoutAction{
    
    _imageArray = @[@[@"Identities _Apply",@"Identities _cn"],@[@"Identities _ai",@"Identities _ii"]];
    [_tableV reloadData];
}

- (void)getCaliamNotication{
    
    _imageArray = @[@[@"Identities _Apply",@"Identities _cn1"],@[@"Identities _ai",@"Identities _ii"]];
    
    [_tableV reloadData];
}

- (void)configTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)hideSelf:(UITapGestureRecognizer *)tap {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
 
        self.center =  CGPointMake(self.center.x + kScreenWidth, self.center.y) ;
    } completion:^(BOOL finished) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#4d4d4d30"];
        
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (UITableView *)tableV {
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.delegate = self;
        _tableV.dataSource = self;
    }
    return _tableV;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"rightCellid";
    AssetRightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[AssetRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
   
    [cell fillImage:_imageArray[indexPath.section][indexPath.row] Title:_titleArray[indexPath.section][indexPath.row] Small:YES];
  
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [_titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_titleArray[section] count];
    
}

//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] init];
    if (section==1) {
        headerView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    }
    return headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] init];
    footerV.backgroundColor = [UIColor whiteColor];
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 40;
    }
    
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 1.0f;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
     
        self.center =  CGPointMake(self.center.x + kScreenWidth, self.center.y);
        
    } completion:^(BOOL finished) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#4d4d4d30"];
    }];
    
    if (indexPath.section==0&&indexPath.row==1) {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
        AssetRightCell *cell = [_tableV cellForRowAtIndexPath: indexPath1];
        [cell fillImage:@"Identities _cn" Title:Localized(@"IDClaimNotice") Small:YES];
    }
        if (_callBack) {
        _callBack(indexPath);
    }
    
      _imageArray = @[@[@"Identities _Apply",@"Identities _cn"],@[@"Identities _ai",@"Identities _ii"]];
    [self.tableV reloadData];
}

- (void)show {

    
    DebugLog(@"selfcenterx = %f windowx=%f",self.center.x,[UIApplication sharedApplication].keyWindow.center.x);
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        
    self.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        
    } completion:^(BOOL finished) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#4d4d4d30"];
        
    }];
    [_tableV reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
