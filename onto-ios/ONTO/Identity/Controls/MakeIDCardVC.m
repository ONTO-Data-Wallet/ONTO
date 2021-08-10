//
//  MakeIDCardVC.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/22.
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

#import "MakeIDCardVC.h"
#import "EditView.h"
#import "MakeIDCell.h"
#import "CCRequest.h"
#import "IDCardViewController.h"
#import "WebIdentityViewController.h"
#import "OTAlertView.h"
#import "ClaimViewController.h"


@interface MakeIDCardVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *realDataArray;

@property (nonatomic, copy) NSArray *claimsArray;
@property (weak, nonatomic) IBOutlet UIButton *generationBtn;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *headersubLabel;
@property (nonatomic, copy) NSArray *modelArr;
@property (nonatomic, assign) NSInteger status;


@end

@implementation MakeIDCardVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setTable];
    [self configNav];
    [self configUI];
   
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [self getData];
    
}

- (void)getData{
    
    _claimsArray = @[@"claim:employment_authentication",@"claim:linkedin_authentication",@"claim:github_authentication"];
    
    _generationBtn.backgroundColor = [UIColor grayColor];
    _generationBtn.enabled = NO;
     _modelArr = @[];
    NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
                             @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
                             @"ClaimContext":@"",
                             @"Status":@[@"1",@"2"],
                             @"BeginTime":@"",
                             @"EndTime":@""};
    DebugLog(@"!!!%@",params);
    [[CCRequest shareInstance] requestWithURLString:Brief_query MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        NSArray *dataArr = [responseObject valueForKey:@"ClaimList"];
        for (int i=0;i<dataArr.count;i++) {
        
            if ([[(NSDictionary*)dataArr[i] valueForKey:@"ClaimContext"] isEqualToString:@"claim:employment_authentication"]) {
                if ([[[(NSDictionary*)dataArr[i] valueForKey:@"Status"] stringValue]isEqualToString:@"1"]) {
                     [_dataArray setObject:@"claim:employment_authentication" atIndexedSubscript:0];
                }
                
//                [_dataArray setObject:@"claim:employment_authentication" atIndexedSubscript:0];
            }
            
            if ([[(NSDictionary*)dataArr[i] valueForKey:@"ClaimContext"] isEqualToString:@"claim:github_authentication"]) {
                if ([[[(NSDictionary*)dataArr[i] valueForKey:@"Status"] stringValue]isEqualToString:@"1"]) {
                   [_dataArray setObject:@"claim:github_authentication" atIndexedSubscript:2];
                }
                _status = [[(NSDictionary*)dataArr[i] valueForKey:@"Status"] integerValue];
            }
            
            if ([[(NSDictionary*)dataArr[i] valueForKey:@"ClaimContext"] isEqualToString:@"claim:linkedin_authentication"]) {
                if ([[[(NSDictionary*)dataArr[i] valueForKey:@"Status"] stringValue]isEqualToString:@"1"]) {
                      [_dataArray setObject:@"claim:linkedin_authentication" atIndexedSubscript:1];
                }
            }
    }
        
        _realDataArray = [NSMutableArray arrayWithArray:_dataArray];
        
        for (int i=0; i<_dataArray.count; i++) {

            if (![_dataArray[i] isEqualToString:@"0"]) {
                _generationBtn.backgroundColor = [UIColor colorWithHexString:@"#127EB6"];
                _generationBtn.enabled = YES;
            }
        }
        
        
        [self.myTable reloadData];
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        
    }];
}

- (void)configUI{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    _generationBtn.layer.masksToBounds = YES;
    _generationBtn.layer.cornerRadius = 25;
    [_generationBtn setTitle:Localized(@"MakeCardTitle") forState:UIControlStateNormal];
    _headerLabel.text =Localized(@"SlectClaims");
    _headersubLabel.text =Localized(@"AtLeastAone");
    
}

- (IBAction)generateAction:(id)sender {
    
    [self makeCard];
    
}

- (void)makeCard{
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_dataArray];
    
    for (int i=(int)arr.count-1; i>=0; i--) {

        if ([arr[i] isEqualToString:@"0"]) {
            [arr removeObjectAtIndex:i];
        }
    }

    
    if (arr.count==1) {

        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Selecttwo") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }
    
    NSDictionary *params ;
    
    if (_cardID) {
        params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
                   @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
                   @"ClaimContextList":arr,
                   @"CardId":_cardID
                   };
    }else{
        
        params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
                   @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
                   @"ClaimContextList":arr,
                   };
    }
    
    DebugLog(@"!!!%@",params);
    
    [[CCRequest shareInstance] requestWithURLString: _cardID? Claimcard_update:Claimcard_generate MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {

        IDCardViewController *vc = [[IDCardViewController alloc]init];
        vc.CardId = [responseObject valueForKey:@"CardId"];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {

    }];
}

- (void)configNav {
    [self setNavTitle:Localized(@"MakeCardTitle")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTable{
    
    _dataArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0"]];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    [self setExtraCellLineHidden:self.myTable];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"MakeIDCell";
    //通过xib的名称加载自定义的cell
    MakeIDCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
   }

    [cell setWithIndex:indexPath withArr:_dataArray];
    cell.selectBtn.tag = indexPath.section;
    [cell.selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.notReceiveBtn.tag = indexPath.section+10;
    [cell.notReceiveBtn addTarget:self action:@selector(notReceiveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    return cell;
}

- (void)selectBtnAction:(UIButton *)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
    MakeIDCell *cell = [self.myTable cellForRowAtIndexPath: indexPath];
    
    if ([_dataArray[indexPath.section] isEqualToString:@"0"]) {
        cell.selectBtn.selected = YES;
        _dataArray[indexPath.section] = _claimsArray[sender.tag];
        
        if (sender.tag==0) {

        }
    }else{
        cell.selectBtn.selected = NO;
        _dataArray[indexPath.section] = @"0";
        cell.notReceiveBtn.hidden =YES;
    }
    
    for (int i=0; i<_dataArray.count; i++) {

        if ([_dataArray[i] isEqualToString:@"0"]) {
            
            _generationBtn.backgroundColor = [UIColor grayColor];
            _generationBtn.enabled = NO;
            
        }

    }
    
    for (int i=0; i<_dataArray.count; i++) {
        
        if (![_dataArray[i] isEqualToString:@"0"]) {

                    _generationBtn.backgroundColor = [UIColor colorWithHexString:@"#127EB6"];
                    _generationBtn.enabled = YES;
        
                }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
}

/**
 *  选中Cell的时候调用
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_realDataArray[indexPath.section] isEqualToString:@"0"]) {
         WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
        if (indexPath.section==0) {
          
            
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"NOEmploymentcer") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            return;
            
        }else if (indexPath.section==1){
                webVC.identityType =  (IdentityType)indexPath.section;
            }
            else if (indexPath.section==2){
                webVC.identityType =  (IdentityType)indexPath.section;
            }
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        ClaimViewController *vc = [[ClaimViewController alloc]init];
        vc.isPending = NO;
        vc.claimContext = _dataArray[indexPath.section];
        vc.stauts = _status;

        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
   
   
}
- (void)notReceiveBtnAction:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag-10];
    WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
    
    if (indexPath.section==0) {
     
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"NOEmploymentcer") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
        
    }else
        if (indexPath.section==1){
            webVC.identityType =  (IdentityType)indexPath.section;
        }
        else if (indexPath.section==2){
            webVC.identityType =  (IdentityType)indexPath.section;
        }
    [self.navigationController pushViewController:webVC animated:YES];
}



@end
