//
//  NewSettingViewController.m
//  ONTO
//
//  Created by 张超 on 2018/3/29.
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

#import "NewSettingViewController.h"
#import "SettingCell.h"
#import "LanguageViewController.h"
#import "NetworkViewController.h"
#import "UnitViewController.h"
#import "SecuritySetViewController.h"

@interface NewSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation NewSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];

}

- (void)configUI {
    
    [self setNavTitle:Localized(@"SysSetting")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
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
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    if (indexPath.row == 0) {
        [cell fillTitle:Localized(@"Language")];
    } else if (indexPath.row == 1) {
        [cell fillTitle:Localized(@"Network")];
        
        cell.accessoryType =UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults]valueForKey:NETNAME];
        cell.imageV.hidden = YES;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }else if (indexPath.row == 2) {
//        [cell fillTitle:Localized(@"CurrencyUnit")];
        [cell fillTitle:Localized(@"SecuritySetting")];

    }
    
    
    return cell;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:17];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LanguageViewController *vc = [[LanguageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
//        NetworkViewController *vc = [[NetworkViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
//        UnitViewController *vc = [[UnitViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        SecuritySetViewController *vc = [[SecuritySetViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
