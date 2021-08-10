//
//  IDCardViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/26.
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

#import "IDCardViewController.h"
#import "CardDetailCell.h"
#import "CardModel.h"
#import <MJExtension/MJExtension.h>
#import "ZYInputAlertView.h"
#import "ShareView.h"
#import "MakeIDCardVC.h"
#import "ClaimViewController.h"
#import "WebIdentityViewController.h"
#import "FrameAccessor.h"


@interface IDCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (nonatomic, copy) NSArray *modelArr;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;

@end

@implementation IDCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNav];
    [self configUI];

    [self getData];
}

- (void)getData{
    NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
                             @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
                             @"CardId":_CardId
                             };
    DebugLog(@"!!!%@",params);
    [[CCRequest shareInstance] requestWithURLString:Ontpassclaimcardquery MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        
        _dataDic = responseObject;
        _mainLabel.text = [_dataDic valueForKey:@"TemplateName"];
        _subLabel.text = [Common getTimeFromTimestamp:[_dataDic valueForKey:@"CreateTime"]];
        NSArray *dataArr = [_dataDic valueForKey:@"ClaimList"];
        NSMutableArray *newArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            NSMutableDictionary *newDic =[NSMutableDictionary dictionaryWithDictionary:[dic valueForKey:@"Content"]];
            [newDic setValue:[dic valueForKey:@"Context"] forKey:@"Context"];
            [newArr addObject:newDic];
        }
        _modelArr= newArr;
        [self.myTable reloadData];
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
}
- (IBAction)updateClick:(id)sender {
    
    MakeIDCardVC *mcVC = [[MakeIDCardVC alloc]init];
    mcVC.cardID = [_dataDic valueForKey:@"CardId"];
    [self.navigationController pushViewController:mcVC animated:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    if (_isMaked==NO) {
        // 禁用返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}


-(void)setNavLeftImageIcon:(UIImage *)imageIcon Title:(NSString *)title{
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, StatusBarHeight, 70, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = NAVFONT;
    button.titleLabel.numberOfLines = 0;
    [button setImage:imageIcon forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, button.frame.size.width - imageIcon.size.width - 20)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:button];
    _updateBtn.centerY = button.centerY;
    _updateBtn.right = kScreenWidth;
}

- (void)navLeftAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)shareAction:(id)sender {
    
    ShareView *view = [[ShareView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 300)];

    [view setCallBack:^(NSInteger tag) {
        if (tag==1) {
            [self sendEmail];
        }else  if (tag==2) {
            
        }else  if (tag==3) {
            
        }
        
    }];

    [view show];
       
}
- (IBAction)verifyAction:(id)sender {
    
    WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
    vc.verifyUrl = [_dataDic valueForKey:@"VerifyUrl"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)sendEmail{
    
    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
    alertView.confirmBgColor = [UIColor colorWithHexString:@"#2295d4"];
    alertView.placeholder = @"";
    [alertView confirmBtnClickBlock:^(NSString *inputString) {
        NSDictionary *params = @{@"Email":inputString,
                                 @"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
                                 @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
                                 @"CardId":[_dataDic valueForKey:@"CardId"],
                                 @"VerifyUrl":[_dataDic valueForKey:@"VerifyUrl"],
                                 };
        DebugLog(@"!!!%@",params);
        [[CCRequest shareInstance] requestWithURLString:Email_Send MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
            
//            [self showHint:Localized(@"SendEmailSuccess")];
            [Common showToast:Localized(@"SendEmailSuccess")];
        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
//             [self showHint:Localized(@"SendEmailFailed")];
            [Common showToast:Localized(@"SendEmailFailed")];
        }];
    }];
    [alertView show];
}

- (void)configNav {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [self setNavTitle:Localized(@"KownMore")];
    
//    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    BOOL isVC = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isVC animated:YES];
}

- (void)configUI{
    
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    self.myTable.layer.masksToBounds = YES;
    self.myTable.layer.cornerRadius = 5;
    [self setExtraCellLineHidden:self.myTable];
    [self setExtraCellLineHidden:self.myTable];
    _shareBtn.layer.cornerRadius = 25;
    _shareBtn.layer.masksToBounds = YES;
    
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
 
    
   
    
    [_updateBtn setTitle:Localized(@"Update") forState:UIControlStateNormal];
    
    [_verifyBtn setTitle:Localized(@"VerifyONChain") forState:UIControlStateNormal];
    [_shareBtn setTitle:Localized(@"Share") forState:UIControlStateNormal];
    
    
    if (_isMaked==YES) {
        self.loadingView.hidden = YES;
        return;
    }
    __block IDCardViewController/*主控制器*/ *weakSelf = self;
    [self.view bringSubviewToFront:self.loadingView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        weakSelf.loadingView.hidden = YES;
    });
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return _modelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 125;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CardDetailCell";
    //通过xib的名称加载自定义的cell
    CardDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
            [cell configWithModel:_modelArr[indexPath.section]];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClaimViewController *vc =[[ClaimViewController alloc]init];
    vc.isPending = NO;
    vc.stauts = 1;
    vc.claimContext = [[_dataDic valueForKey:@"ClaimList"][indexPath.section] valueForKey:@"Context"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
  
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;
    
    
    
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
    //    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 14, 230, 20)];
    //    headerLabel.backgroundColor = [UIColor clearColor];
    //    headerLabel.font = [UIFont fontWithName:@"Heiti SC" size:13];
    //    //    headerLabel.text = section==0?Localized(@"Realname"):Localized(@"Social");
    //    //        headerLabel.text = Localized(@"Digitalidentitylist");
    //    [headerView addSubview:headerLabel];
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
