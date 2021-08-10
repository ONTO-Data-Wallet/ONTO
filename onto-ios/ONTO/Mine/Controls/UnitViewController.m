//
//  UnitViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/28.
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

#import "UnitViewController.h"
#import "SettingSelectCell.h"
#import "ViewController.h"

@interface UnitViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *unit;

@end

@implementation UnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    self.unit = [Common getUNIT];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)configUI {
    
    [self setNavTitle:Localized(@"CurrencyUnit")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    [self setNavRightImageIcon:nil Title:Localized(@"YES")];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
        //        if (KIsiPhoneX) {
        //            make.top.equalTo(self.view).offset(88);
        //        } else {
        //            make.top.equalTo(self.view).offset(64);
        //        }
    }];
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightAction {
    
    if ([self.unit isEqualToString:[Common getUNIT]]) {
        
        
    } else {
        
        [[NSUserDefaults standardUserDefaults]setObject:self.unit forKey:UNIT];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    SettingSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SettingSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.row == 1) {
        [cell fillTitle:Localized(@"CNY") select:[self.unit isEqualToString:@"CNY"]];
    } else if (indexPath.row == 0) {
        [cell fillTitle:Localized(@"USD") select:[self.unit isEqualToString:@"USD"]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DebugLog(@"%@",self.unit);
    if (indexPath.row == 1) {
        if ([self.unit isEqualToString:@"USD"]) {
            self.unit = @"CNY";
            [self.tableView reloadData];
        }
    } else {
        if ([self.unit isEqualToString:@"CNY"]) {
            self.unit = @"USD";
            [self.tableView reloadData];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

