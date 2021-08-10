//
//  PendingViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/10.
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

#import "PendingViewController.h"
#import "UIView+Scale.h"
#import "CCRequest.h"
#import "UITableView+EmptyData.h"
#import "VerifiedClaimModel.h"
#import <MJExtension/MJExtension.h>
#import "PendCell.h"
#import "ClaimViewController.h"
#import "CYLTableViewPlaceHolder.h"
#import "WeChatStylePlaceHolder.h"
#import "ClaimModel.h"
#import "DataBase.h"
//#import "NotificationCell.h"

@interface PendingViewController ()<UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate,WeChatStylePlaceHolderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, copy) NSArray *modelArr;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation PendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTable];
    [self configNav];

    [self configUI];
}

- (UIView *)makePlaceHolderView {
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}

- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.myTable.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}

- (void)emptyOverlayClicked:(id)sender{
    
    
}

- (void)configUI{
    [_selectBtn setTitle:_verfiedClaimType==0?Localized(@"ViewHistory"):Localized(@"NewClaim") forState:UIControlStateNormal];
    _selectBtn.layer.masksToBounds = YES;
    _selectBtn.layer.cornerRadius = 1;

    [_selectBtn setBackgroundColor:[UIColor colorWithHexString:@"#1a78bb"]];
    [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)selectAction:(id)sender {
    __weak typeof(self) weakself = self;
    
    if (weakself.returnValueBlock) {
        //将自己的值传出去，完成传值
        weakself.returnValueBlock();
    }

    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getData];
    
}

- (void)getData{
    
    _modelArr = @[];
    NSMutableArray *arr = [[DataBase sharedDataBase] getAllClaim];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (ClaimModel *model in arr) {
        
        NSDictionary *dic = [Common dictionaryWithJsonString:model.Content];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        
      NSDictionary *claimDic = [[Common claimdencode:[dic valueForKey:@"EncryptedOrigData"]] valueForKey:@"claim"];
        
        [dic2 setValue:[claimDic valueForKey:@"context"] forKey:@"ClaimContext"];
        [dic2 setValue:[claimDic valueForKey:@"jti"] forKey:@"ClaimId"];
        [dic2 setValue:[[claimDic valueForKey:@"clm"]valueForKey:@"IssuerName"] forKey:@"IssuerName"];
        [dic2 setValue:[dic valueForKey:@"Description"] forKey:@"Description"];
        [dic2 setValue:model.status forKey:@"Status"];
        [dic2 setValue:[Common getTimeFromTimestamp:[claimDic valueForKey:@"exp"]]  forKey:@"CreateTime"];
        [dataArr addObject:dic2];
        
    }
    
    if (_modelArr.count==0) {
                self.selectBtn.hidden = NO;
                    }else{
                self.selectBtn.hidden = YES;
                    }
    _modelArr= [VerifiedClaimModel mj_objectArrayWithKeyValuesArray:dataArr];
    [self.myTable cyl_reloadData];
    
    
//        _modelArr = @[];
//    NSArray *statusArr = _verfiedClaimType==0 ?@[@"4"]:@[@"1",@"2"];
//    if (_verfiedClaimType ==ALLType) {
//        statusArr = @[];
//    }
//
//    NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
//                                 @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
//                                 @"ClaimContext":@"",
//                                 @"Status":statusArr,
//                                 @"BeginTime":@"",
//                                 @"EndTime":@""};
//        NSLog(@"!!!%@",params);
//        [[CCRequest shareInstance] requestWithURLString:Brief_query MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
//
//            NSArray *dataArr = [responseObject valueForKey:@"ClaimList"];
//            _modelArr= [NSArray arrayWithArray:[VerifiedClaimModel mj_objectArrayWithKeyValuesArray:dataArr]];
//
//            if (_modelArr.count==0) {
//                self.selectBtn.hidden = NO;
//            }else{
//                 self.selectBtn.hidden = YES;
//
//            }
//
//            [self.myTable cyl_reloadData];
//
//
//
//        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
//
//        }];
}

- (void)configNav {
    [self setNavTitle:Localized(@"Myverifledclaim")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
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
//      [tableView tableViewDisplayWitMsg:Localized(@"NoClaims") ifNecessaryForRowCount:_modelArr.count];
    return _modelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //    if (section==0) {
    //        return 1;
    //    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return 74*([[UIScreen mainScreen] bounds].size.width/375);
        return 75*([[UIScreen mainScreen] bounds].size.width/375);

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"PendCell";
    //通过xib的名称加载自定义的cell
    PendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    
//    [cell setwithIndex:indexPath];
    [cell configWithModel:_modelArr[indexPath.section]];
  
    
//    if (_verfiedClaimType==1) {
//        cell.pendingImage.hidden = YES;
//    }
//   else {
//        cell.historyImage.hidden = YES;
//    }
    
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
//    ClaimViewController*backupVC = [[ClaimViewController alloc] init];
//    backupVC.claimId = [(VerifiedClaimModel*)_modelArr[indexPath.section] ClaimId];
//    backupVC.isPending = [[(VerifiedClaimModel*)_modelArr[indexPath.section] Status] isEqual:@(4)]||[[(VerifiedClaimModel*)_modelArr[indexPath.section] Status] isEqual:@(9)]?YES:NO;
//     backupVC.stauts = [[(VerifiedClaimModel*)_modelArr[indexPath.section] Status] integerValue];
//    [self.navigationController pushViewController:backupVC animated:YES];
    if ([[(VerifiedClaimModel*)_modelArr[indexPath.section] ClaimContext] isEqualToString:@"claim:cfca_authentication"]) {
        
        if  ([[(VerifiedClaimModel*)_modelArr[indexPath.section] Status] integerValue] == 9){
            
            ClaimViewController *claimVC = [[ClaimViewController alloc]init];
            claimVC.claimContext =  @"claim:cfca_authentication";
            claimVC.isPending = YES;
            claimVC.stauts = 4;
            [self.navigationController pushViewController:claimVC animated:YES];
            
        }else if ([[(VerifiedClaimModel*)_modelArr[indexPath.section] Status] integerValue] == 1){
            
            ClaimViewController *claimVC = [[ClaimViewController alloc]init];
            claimVC.claimContext =  @"claim:cfca_authentication";
            claimVC.isPending = NO;
            claimVC.stauts = 1;
            [self.navigationController pushViewController:claimVC animated:YES];
            
        }
//        else{
//
//            RealNameViewController *vc = [[RealNameViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }
        
    }else{
        
        if ([[(VerifiedClaimModel*)_modelArr[indexPath.section] Status] integerValue] == 1) {
            
            ClaimViewController *claimVC = [[ClaimViewController alloc]init];
            claimVC.claimContext =  [(VerifiedClaimModel*)_modelArr[indexPath.section] ClaimContext];
            claimVC.isPending = NO;
            claimVC.stauts = 1;
            [self.navigationController pushViewController:claimVC animated:YES];
            
        }else if ([[(VerifiedClaimModel*)_modelArr[indexPath.section] Status] integerValue] == 2) {
            
//            WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
//            webVC.identityType =  (IdentityType)indexPath.row;
//            [self.navigationController pushViewController:webVC animated:YES];
            
            ClaimViewController *claimVC = [[ClaimViewController alloc]init];
            claimVC.claimContext =  [(VerifiedClaimModel*)_modelArr[indexPath.section] ClaimContext];
            claimVC.isPending = NO;
            claimVC.stauts = 2;
            [self.navigationController pushViewController:claimVC animated:YES];
        }else
//        if ([[(VerifiedClaimModel*)_modelArr[indexPath.section] Status] integerValue] == 4)
        {
            
            //            WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
            //            webVC.identityType =  (IdentityType)indexPath.row;
            //            [self.navigationController pushViewController:webVC animated:YES];
            
            ClaimViewController *claimVC = [[ClaimViewController alloc]init];
            claimVC.claimContext =  [(VerifiedClaimModel*)_modelArr[indexPath.section] ClaimContext];
            claimVC.isPending = YES;
            claimVC.stauts = 4;
            [self.navigationController pushViewController:claimVC animated:YES];
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 16;
    }
    return 8;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
