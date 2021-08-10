//
//  LanguageViewController.m
//  ONTO
//
//  Created by 张超 on 2018/3/12.
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

#import "LanguageViewController.h"
#import "SettingSelectCell.h"
#import "ViewController.h"

@interface LanguageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *languageStr;

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    self.languageStr = [Common getUserLanguage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)configUI {

    [self setNavTitle:Localized(@"Language")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
//    [self setNavRightImageIcon:nil Title:Localized(@"YES")];
    
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
    
    if ([self.languageStr isEqualToString:[Common getUserLanguage]]) {
        
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:self.languageStr forKey:HomeLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ViewController gotoIdentityVC];
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
    if (indexPath.row == 0) {
        [cell fillTitle:@"简体中文" select:[self.languageStr isEqualToString:@"zh-Hans"]];
    } else if (indexPath.row == 1) {
        [cell fillTitle:@"English" select:[self.languageStr isEqualToString:@"en"]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    DebugLog(@"%@",self.languageStr);
    if (indexPath.row == 0) {
        if ([self.languageStr isEqualToString:@"en"]) {
            self.languageStr = @"zh-Hans";
            [self.tableView reloadData];
        }
    } else {
        if ([self.languageStr isEqualToString:@"zh-Hans"]) {
            self.languageStr = @"en";
            [self.tableView reloadData];
        }
    }
    
    if ([self.languageStr isEqualToString:[Common getUserLanguage]]) {
        
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:self.languageStr forKey:HomeLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ViewController gotoIdentityVC];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
