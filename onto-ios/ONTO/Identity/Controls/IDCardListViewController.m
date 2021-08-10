//
//  IDCardListViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/5/2.
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

#import "IDCardListViewController.h"
#import "IDCardCell.h"
#import "IDCardViewController.h"
#import "MakeIDCardVC.h"
#import "WaitingViewController.h"
#import "RealNameViewController.h"


@interface IDCardListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, copy) NSArray *modelArr;

@end

@implementation IDCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTable];
    [self configNav];

}

- (void)configNav {
    [self setNavTitle:Localized(@"MakeidentityCardTitle")];
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
    [self setExtraCellLineHidden:self.myTable];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCardList];

}

- (void)getCardList{
    
    NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
                             @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE]};
    DebugLog(@"!!!%@",params);
    [[CCRequest shareInstance] requestWithURLStringNoLoading:claimcard_query MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        _modelArr = responseObject;
        [self.myTable reloadData];
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        
    }];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 87*[[UIScreen mainScreen] bounds].size.width/375;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"IDCardCell";
    //通过xib的名称加载自定义的cell
    IDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }

    if (indexPath.section==0) {
        if (_modelArr.count>0) {
            //已创建卡片
             cell.selectImage.hidden = NO;
             cell.nameLabel.text = Localized(@"Seniordeveloper");
//             cell.dataLabel.text = [_modelArr[0] valueForKey:@"CreateTime"] ;
            cell.dataLabel.text =  [Common getTimeFromTimestamp:[[_modelArr[0] valueForKey:@"CreateTime"] stringValue]];

             //根据当地时间把时间戳转为当地时间

        }else{
             //未创建卡片
             cell.JTIMage.hidden = NO;
             cell.nameLabel.text = Localized(@"Seniordeveloper");
             cell.dataLabel.text = Localized(@"Trustcard");
        }
    }
  else  if (indexPath.section==1) {
         cell.nameLabel.text = Localized(@"Realname");
         cell.dataLabel.text = Localized(@"Comingsoon");
         cell.iconImage.image = [UIImage imageNamed:@"Realname"];
  }  else  if (indexPath.section==2) {
      cell.nameLabel.text =Localized(@"SocialTalent");
      cell.dataLabel.text = Localized(@"Comingsoon");
      cell.iconImage.image = [UIImage imageNamed:@"Social"];

  }
      return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section==0) {
        if (_modelArr.count>0) {

            IDCardViewController *vc = [[IDCardViewController alloc]init];
            vc.isMaked = YES;
            vc.CardId = [_modelArr[0] valueForKey:@"CardId"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{

            MakeIDCardVC *mcVC = [[MakeIDCardVC alloc]init];
            [self.navigationController pushViewController:mcVC animated:YES];
        }
    } else if (indexPath.section == 1) {
        RealNameViewController *vc = [[RealNameViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 2) {
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

//    if (section==0) {
//        return 16;
//    }
    return 16;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;

}

//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 58)];//创建一个视图
    return headerView;

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
