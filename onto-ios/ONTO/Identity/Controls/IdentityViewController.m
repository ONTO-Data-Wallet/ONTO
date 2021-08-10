//
//  IdentityViewController.m
//  OnChain
//
//  Created by 赵伟 on 2018/3/8.
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

#import "IdentityViewController.h"
#import "IndentityCell.h"
#import "UIView+Scale.h"
#import "WebIdentityViewController.h"
#import "CCRequest.h"
#import <MJExtension/MJExtension.h>
#import "IdentityModel.h"
#import "ClaimViewController.h"
#import "RealNameViewController.h"

@interface IdentityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, copy) NSArray *modelArr1;
@property (nonatomic, strong)NSTimer * timer;

@end

@implementation IdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = Localized(@"AddVerfied");
    [self setTable];
    [self configNav];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self getData:NO];
    _timer =  [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //销毁定时器
    [_timer invalidate];
    _timer = nil;
    
}

- (void)function:(NSTimer*)timer{
    [self getData:YES];
    
    DebugLog(@"调用");
    
}

- (void)configNav {
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData:(BOOL)isRepeats{
    
    NSString *deviceCode = [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_CODE];
    [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:DEVICE_CODE];
    NSDictionary *params = @{@"ontId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],@"deviceCode":deviceCode,@"pageNumber":@(1),@"pageSize":@(10),@"language":ENORCNDAXIE};
    DebugLog(@"!!!%@",params);
    [[CCRequest shareInstance] requestWithURLString:Trustanchor_query MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        
        NSArray *dataArr = [responseObject valueForKey:@"TrustAnchorList"];
        NSArray *arr= [IdentityModel mj_objectArrayWithKeyValuesArray:dataArr];
        
       
        if (isRepeats==YES) {
            
            for (IdentityModel *model in arr) {
                if ([[model IssuedFlag] integerValue]!=2) {     
                    
                    [_timer invalidate];
                    _timer = nil;
                }
                
            }
        }
        
        _modelArr1 =@[@[arr[4]],@[arr[0],arr[1],arr[2],arr[3]]];
        [self.myTable reloadData];
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        
    }];
    
}

- (void)setTable{
    
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    [self setExtraCellLineHidden:self.myTable];
    self.myTable.backgroundColor = TABLEBACKCOLOR;
    
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return 1;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 58*([[UIScreen mainScreen] bounds].size.width/375);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"IndentityCell";
    //通过xib的名称加载自定义的cell
    IndentityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    
    [cell setwithIndex:indexPath];
    
        if ([[(IdentityModel*)_modelArr1[indexPath.section][indexPath.row] IssuedFlag] integerValue] ==1) {
            cell.cerImage.image = [UIImage imageNamed:@"RZ"];
        }
        if ([[(IdentityModel*)_modelArr1[indexPath.section][indexPath.row] IssuedFlag] integerValue] ==2||[[(IdentityModel*)_modelArr1[indexPath.section][indexPath.row] IssuedFlag] integerValue] ==9) {
            cell.cerImage.image = [UIImage imageNamed:@"wait"];
            CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
            animation.fromValue = [NSNumber numberWithFloat:0.f];
            animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
            animation.duration  = 1;
            animation.autoreverses = NO;
            animation.fillMode =kCAFillModeForwards;
            animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
            [cell.cerImage.layer addAnimation:animation forKey:nil];
        }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        
      if  ([[(IdentityModel*)_modelArr1[indexPath.section][indexPath.row] IssuedFlag] integerValue] == 9){
          
                  ClaimViewController *claimVC = [[ClaimViewController alloc]init];
                  claimVC.claimContext =  @"claim:cfca_authentication";
                  claimVC.isPending = YES;
                  claimVC.stauts = 4;
                  [self.navigationController pushViewController:claimVC animated:YES];
          
       
          
      }else if ([[(IdentityModel*)_modelArr1[indexPath.section][indexPath.row] IssuedFlag] integerValue] == 1){
          
          ClaimViewController *claimVC = [[ClaimViewController alloc]init];
          claimVC.claimContext =  @"claim:cfca_authentication";
          claimVC.isPending = NO;
          claimVC.stauts = 1;
          [self.navigationController pushViewController:claimVC animated:YES];
          
      }else{
          
          RealNameViewController *vc = [[RealNameViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
          
      }
        
    }else{
        
        if ([[(IdentityModel*)_modelArr1[indexPath.section][indexPath.row] IssuedFlag] integerValue] == 1) {
            
            ClaimViewController *claimVC = [[ClaimViewController alloc]init];
            claimVC.claimContext =  [(IdentityModel*)_modelArr1[indexPath.section][indexPath.row] ClaimContext];
            claimVC.isPending = NO;
            claimVC.stauts = 1;
            [self.navigationController pushViewController:claimVC animated:YES];
            
        }else{
            
            WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
            webVC.identityType =  (IdentityType)indexPath.row;
            [self.navigationController pushViewController:webVC animated:YES];
            
        }
    }
    
    
    
    
}

//让tableView分割线居左的代理方法

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 58)];//创建一个视图
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 14, 230, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Heiti SC" size:13];
    headerLabel.text = section==0?Localized(@"Realname"):Localized(@"Social");
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

@end

