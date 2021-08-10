//
//  NotificationViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/4/18.
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

#import "NotificationViewController.h"
#import "UIView+Scale.h"
#import "CCRequest.h"
#import "UITableView+EmptyData.h"
#import "VerifiedClaimModel.h"
#import <MJExtension/MJExtension.h>
#import "PendCell.h"
#import "ClaimViewController.h"
#import "NotificationCell.h"
#import "UIView+Scale.h"
#import "DataBase.h"
#import "ClaimModel.h"
#import "WebIdentityViewController.h"

@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSMutableArray *modelArr;
@property (nonatomic, copy) NSArray *noticeArr;


@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ISNOTIFICATION];
//[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCaliamNotication) name:NOTIFICATION_SOCKET_GETCLAIM object:nil];
    [self setTable];
    [self configNav];
}

-(void)dealloc {
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
//- (void)getCaliamNotication{
//
//  __block NotificationViewController/*主控制器*/ *weakSelf = self;
//
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [weakSelf getData];
//        NSLog(@"1");
//    });
//
//    [self.myTable reloadData];
//
//}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getData];
    
 
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ISNOTIFICATION];
    [self.myTable reloadData];
}

- (void)getData{
    
    NSMutableArray *arr = [[DataBase sharedDataBase] getNotificationArr];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (ClaimModel *model in arr) {

        NSDictionary *dic = [Common dictionaryWithJsonString:model.Content];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:@"claim:employment_authentication" forKey:@"ClaimContext"];
        [dic2 setValue:[dic valueForKey:@"ClaimId"] forKey:@"ClaimId"];
        [dic2 setValue:[dic valueForKey:@"IssuerName"] forKey:@"IssuerName"];
        [dic2 setValue:[dic valueForKey:@"Description"] forKey:@"Description"];
        [dic2 setValue:model.status forKey:@"Status"];
        [dic2 setValue:[[[dic valueForKey:@"Claim"] valueForKey:@"Metadata"]valueForKey:@"CreateTime"] forKey:@"CreateTime"];
        [dataArr addObject:dic2];
        
    }
    _modelArr= [VerifiedClaimModel mj_objectArrayWithKeyValuesArray:dataArr];
    
    [_modelArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults]valueForKey:SYSTEMNOTIFICATIONLIST]];
    [_modelArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults]valueForKey:MYCHECKTRANSFER]];
    
    
    [self.myTable reloadData];
    
    
//    NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
//                             @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
//                             @"NoticeType":@"",
//                             @"Status":@[@"1",@"2",@"4"],
//                             @"BeginTime":@"",
//                             @"EndTime":@"",
////                             @"pageSize":@(100),@"pageNumber":@(1)
//                             };
//
//    NSLog(@"!!!%@",params);
//    [[CCRequest shareInstance] requestWithURLString:Notice_query MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
//
//        NSArray *dataArr = [responseObject valueForKey:@"ClaimList"];
//        _modelArr= [VerifiedClaimModel mj_objectArrayWithKeyValuesArray:dataArr];
//        [_modelArr addObjectsFromArray:[responseObject valueForKey:@"SystemInfoList"]];
//        [self.myTable reloadData];
//
//    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
//
//    }];
}

- (void)configNav {
    [self setNavTitle:Localized(@"NotificationCentre")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTable{
    
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
//    [self setExtraCellLineHidden:self.myTable];
    self.myTable.separatorStyle = NO;
}

//- (void)setExtraCellLineHidden: (UITableView *)tableView{
//
//    UIView *view =[ [UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//    [tableView setTableHeaderView:view];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.separatorInset = UIEdgeInsetsMake(0, 24* SCALE_W, 0, 0);
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    //缩进50pt
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //      [tableView tableViewDisplayWitMsg:Localized(@"NoClaims") ifNecessaryForRowCount:_modelArr.count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //    if (section==0) {
    //        return 1;
    //    }
  
    [tableView tableViewDisplayWitMsg:Localized(@"NONotification") ifNecessaryForRowCount:_modelArr.count];
    return _modelArr.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    return 74*([[UIScreen mainScreen] bounds].size.width/375);
    return 75*([[UIScreen mainScreen] bounds].size.width/375);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"NotificationCell";
    //通过xib的名称加载自定义的cell
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    
    //    [cell setwithIndex:indexPath];
    [cell configWithModel:_modelArr[indexPath.row]];

    return cell;
}

- (void)rejectBtnClick:(UIButton *)sender{
    
    //    "OwnerOntId":"",
    //    "DeviceCode":"",
    //    "ClaimId":"",
    //    "TxnId":"",
    //    "ConfirmFlag":true
    //    BOOL ConfirmFlag = true;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ClaimViewController*claimVC = [[ClaimViewController alloc] init];
    if ([_modelArr[indexPath.row] isKindOfClass:[VerifiedClaimModel class]]) {
        

        {
            
            if ([[(VerifiedClaimModel*)_modelArr[indexPath.row] Status] integerValue] == 1) {
                
                ClaimViewController *claimVC = [[ClaimViewController alloc]init];
                claimVC.claimContext =  [(VerifiedClaimModel*)_modelArr[indexPath.section] ClaimContext];
                claimVC.isPending = NO;
                claimVC.stauts = 1;
                [self.navigationController pushViewController:claimVC animated:YES];
            }else if ([[(VerifiedClaimModel*)_modelArr[indexPath.row] Status] integerValue] == 2) {
                
                //            WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
                //            webVC.identityType =  (IdentityType)indexPath.row;
                //            [self.navigationController pushViewController:webVC animated:YES];
                
                ClaimViewController *claimVC = [[ClaimViewController alloc]init];
                claimVC.claimContext =  [(VerifiedClaimModel*)_modelArr[indexPath.row] ClaimContext];
                claimVC.isPending = NO;
                claimVC.stauts = 2;
                [self.navigationController pushViewController:claimVC animated:YES];
                
            }else if ([[(VerifiedClaimModel*)_modelArr[indexPath.row] Status] integerValue] == 4) {
                
                //            WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
                //            webVC.identityType =  (IdentityType)indexPath.row;
                //            [self.navigationController pushViewController:webVC animated:YES];
                
                ClaimViewController *claimVC = [[ClaimViewController alloc]init];
                claimVC.claimContext =  [(VerifiedClaimModel*)_modelArr[indexPath.row] ClaimContext];
                claimVC.isPending = YES;
                claimVC.stauts = 4;
                [self.navigationController pushViewController:claimVC animated:YES];
            }
        }
        
        
//        claimVC.claimId = [(VerifiedClaimModel*)_modelArr[indexPath.row] ClaimId];
//        claimVC.isPending = [[(VerifiedClaimModel*)_modelArr[indexPath.row] Status] isEqual:@(4)]||[[(VerifiedClaimModel*)_modelArr[indexPath.row] Status] isEqual:@(9)]?YES:NO;
//        claimVC.stauts = [[(VerifiedClaimModel*)_modelArr[indexPath.row] Status] integerValue];
//
//        [self.navigationController pushViewController:claimVC animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:[(VerifiedClaimModel*)_modelArr[indexPath.row] ClaimId]];
        
    }else if ([_modelArr[indexPath.row] isKindOfClass:[NSDictionary class]]){
        //系统通知
        if ([[(NSDictionary*)_modelArr[indexPath.row] allKeys]containsObject:@"language"]){
            
            WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
            vc.verifyUrl = [_modelArr[indexPath.row] valueForKey:@"url"];
            [self.navigationController pushViewController:vc animated:YES];
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:[[_modelArr[indexPath.row] valueForKey:@"createTime"] stringValue]];
            
            [self.myTable reloadData];
            
        }
        //转账通知
      else  if ([[(NSDictionary*)_modelArr[indexPath.row] allKeys]containsObject:@"send"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:[_modelArr[indexPath.row]valueForKey:@"createTime"]];
            [self.myTable reloadData];
            WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
            vc.transaction = [_modelArr[indexPath.row] valueForKey:@"txhash"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:[_modelArr[indexPath.row]valueForKey:@"CreateTime"]];
            [self.myTable reloadData];
        }
    }

}

//让tableView分割线居左的代理方法

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 12;
    }
    return 3;
    
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
//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 58)];//创建一个视图
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 14, 230, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Heiti SC" size:13];
    //    headerLabel.text = section==0?Localized(@"Realname"):Localized(@"Social");
    //        headerLabel.text = Localized(@"Digitalidentitylist");
    [headerView addSubview:headerLabel];
    return headerView;
    
}
@end
