//
//  AboutUsViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/4/12.
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

#import "AboutUsViewController.h"
#import "WebIdentityViewController.h"
@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, copy)NSArray *titleArray;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNav];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homeBack_X"]];
    _versionLabel.text = [NSString stringWithFormat:@"ONTO %@ %@",Localized(@"Version"),[self currentVersion]];

    
    self.myTable.delegate=self;
    self.myTable.dataSource=self;
    self.titleArray = @[Localized(@"AboutONTO"),Localized(@"SupportandFeedback"),Localized(@"Email")];
    self.myTable.scrollEnabled = NO;
}

- (void)configNav {
    [self setNavTitle:Localized(@"AboutUs")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}

- (void)navLeftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(NSString * )currentVersion{
    
    NSString *key = @"CFBundleShortVersionString";
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[key];
    return currentVersion;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"disturbcell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"disturbcell"];
        
    }
    
    cell.accessoryType =indexPath.row==2?UITableViewCellAccessoryNone: UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titleArray[indexPath.row];
    if (indexPath.row==2) {
        cell.detailTextLabel.text = @"contact@onto.app";

    }
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:17];

    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.titleArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    if (section==2) {
//        return 0.1;
//    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row==0) {
        WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
        
        vc.introduce = [NSString stringWithFormat:@"https://onto.app/%@",ENORCN];

        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row==1) {
        WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
        
        vc.introduce = [NSString stringWithFormat:@"https://discordapp.com/invite/4TQujHj/%@",ENORCN];

        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

//让tableView分割线居左的代理方法
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
//    {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
//    {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
//    {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
