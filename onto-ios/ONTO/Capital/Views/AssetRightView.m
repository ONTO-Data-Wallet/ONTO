//
//  AssetRightView.m
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

#import "AssetRightView.h"
#import "Config.h"
#import "AssetRightCell.h"

@implementation AssetRightView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self handleData];
        [self configUI];
        [self configTap];
    }
    return self;
}

- (void)handleData {
    self.dataArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    DebugLog(@"%@",self.dataArray);
    [self.tableV reloadData];
}

- (void)configUI {
    [self addSubview:self.tableV];
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX);
        make.right.bottom.top.mas_equalTo(self);
    }];
}

- (void)configTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)hideSelf:(UITapGestureRecognizer *)tap {
    
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.center =  CGPointMake(self.center.x + kScreenWidth, self.center.y);
        
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
    if (indexPath.section == 1) {

            if (indexPath.row == 0){
            [cell fillImage:@"Me_wm" Title:Localized(@"CreateWallet") Small:YES];
        }
        else if (indexPath.row == 1){
            [cell fillImage:@"ONTSend-SAO" Title:Localized(@"ImportWallet") Small:YES];
        }
    } else {
        [cell fillImage:[NSString stringWithFormat:@"随机icon%ld",(long)(indexPath.row+1)%5+1] Title:[self.dataArray[indexPath.row] valueForKey:@"label"] Small:NO];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArray.count;//根据account计算
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50.0f;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] init];
    footerV.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 1.0f;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  

    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.center =  CGPointMake(self.center.x + kScreenWidth, self.center.y) ;
    } completion:^(BOOL finished) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#4d4d4d30"];
        
    }];
    if (_callBack) {
        _callBack(indexPath);
    }
}

- (void)show {
    
    DebugLog(@"selfcenterx = %f windowx=%f",self.center.x,self.center.y);
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{

         self.center =  CGPointMake(kScreenWidth/2, kScreenHeight/2);
        
    } completion:^(BOOL finished) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#4d4d4d30"];
        
    }];
    [self handleData];
//  [_tableV reloadData];
}













@end
