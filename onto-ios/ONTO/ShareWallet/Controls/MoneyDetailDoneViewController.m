//
//  MoneyDetailViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "MoneyDetailDoneViewController.h"
#import "ShareWalletDetailCell.h"
#import <MJRefresh/MJRefresh.h>
#import "ShareWalletPayDetailViewController.h"
#import "WebIdentityViewController.h"
@interface MoneyDetailDoneViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIView         *emptyV;
@property (nonatomic,copy)NSString         *nowTimeString;
@property (nonatomic,assign)BOOL           isDraging;
@property (nonatomic,assign)BOOL           isUp;
@property (nonatomic,strong)NSTimer        *timer;
@property(nonatomic,strong)MBProgressHUD            *hub;
@end

@implementation MoneyDetailDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)getData{
    self.isUp =NO;
    self.nowTimeString =[NSString stringWithFormat:@"%@",[Common getNowTimeTimestamp]];
    self.isDraging =YES;
    [self netRequest];
    
}
-(void)netRequest{
    self.isDraging =YES;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@",CapitalURL,CheckCompleteTrade,_address,self.isONT? @"ont":@"ong",@20,self.nowTimeString ];
    
    [[CCRequest shareInstance] requestWithURLString1:urlStr MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal) {
        self.isDraging =NO;
        [_hub hideAnimated:YES];
        if (![Common dx_isNullOrNilWithObject:responseOriginal]
            && [[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[responseOriginal valueForKey:@"error"]]];
            return;
            
        }
        NSArray * arr =[responseObject valueForKey:@"TxnList"];
        if (arr.count>0) {
            NSDictionary* dic=arr.lastObject;
            self.nowTimeString =dic[@"TxnTime"];
        }
        
        if (self.isUp == NO) {
            self.dataArray=  [NSMutableArray arrayWithArray:[responseObject valueForKey:@"TxnList"]] ;
        }else{
            BOOL isSame =NO;
            if (_dataArray.count>0) {
                NSArray * newArray=[responseObject valueForKey:@"TxnList"];
                if (newArray.count==0) {
                    [self endRefresh];
                    return;
                }
                NSDictionary * newModel =newArray[0];
                for (NSDictionary * model in self.dataArray) {
                    if ([model[@"TxnHash"] isEqualToString:newModel[@"TxnHash"]]) {
                        isSame =YES;
                    }
                }
                if (isSame ==NO) {
                    [self.dataArray addObjectsFromArray:newArray];
                }
            }
        }
        if (self.dataArray.count ==0) {
            //            self.emptyV.hidden =NO;
            _tableView.tableHeaderView =self.emptyV;
        }else{
            //            self.emptyV.hidden =YES;
            _tableView.tableHeaderView =nil;
        }
        [_tableView  reloadData];
        self.isUp =NO;
        [_timer invalidate];
        _timer =nil;
        _timer =  [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(function) userInfo:nil repeats:YES];
        [self endRefresh];
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        [_hub hideAnimated:YES];
        if (self.dataArray.count ==0) {
            _tableView.tableHeaderView =self.emptyV;
        }else{
            _tableView.tableHeaderView =nil;
        }
        [self endRefresh];
        self.isDraging =NO;
        [Common showToast:Localized(@"NetworkAnomaly")];
    }];
}
-(void)function{
    
    if (self.isDraging ==YES) {
        return;
    }
    self.nowTimeString =[NSString stringWithFormat:@"%@",[Common getNowTimeTimestamp]];
    self.isUp =NO;
    [self netRequest];
}
- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}
-(void)viewWillAppear:(BOOL)animated{
    _hub=[ToastUtil showMessage:@"" toView:nil];
    [self getData];
    if (_dataArray.count>0) {
        [_tableView reloadData];
    }
    [_timer invalidate];
    _timer = nil;
    _timer =  [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(function) userInfo:nil repeats:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_hub hideAnimated:YES];
    [_timer invalidate];
    _timer = nil;
}
-(void)createUI{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 10*SCALE_W, SYSWidth, SYSHeight-49-64-225*SCALE_W) style:UITableViewStylePlain];
    if (KIsiPhoneX) {
        _tableView.frame =CGRectMake(0, 10*SCALE_W, SYSWidth, SYSHeight-49-64-34-24-225*SCALE_W);
    }
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator =NO;
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isUp =NO;
        self.nowTimeString =[NSString stringWithFormat:@"%@",[Common getNowTimeTimestamp]];
        [self getData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.isUp =YES;
        [self netRequest];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84*SCALE_W;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId =@"shareDetail";
    ShareWalletDetailCell * cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[ShareWalletDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *dic =_dataArray[indexPath.row];
    NSDictionary *tradeDic =dic[@"TransferList"][0];

     NSString * moneyStr;
  
    
    cell.redDot.hidden =YES;

    cell.addressLB.text =[NSString stringWithFormat:@"%@",tradeDic[@"ToAddress"]];
    if([self.address isEqualToString:tradeDic[@"ToAddress"]]){
        moneyStr  =self.isONT? [NSString stringWithFormat:@"+%ld ",[tradeDic[@"Amount"] integerValue] ]:[NSString stringWithFormat:@"+%@ ",tradeDic[@"Amount"]];
        cell.moneyNumLB.textColor = [UIColor colorWithHexString:@"#8DD63E"];
    } else if ([tradeDic[@"ToAddress"] isEqualToString:tradeDic[@"FromAddress"]]) {
        
        moneyStr  =self.isONT? [NSString stringWithFormat:@"%ld ",[tradeDic[@"Amount"] integerValue] ]:[NSString stringWithFormat:@"%@ ",tradeDic[@"Amount"]];
        cell.moneyNumLB.textColor = [UIColor colorWithHexString:@"#868686"];
        
    }else{
        
        moneyStr  =self.isONT? [NSString stringWithFormat:@"-%ld ",[tradeDic[@"Amount"] integerValue] ]:[NSString stringWithFormat:@"-%@ ",tradeDic[@"Amount"]];
        cell.moneyNumLB.textColor = [UIColor colorWithHexString:@"#868686"];
        
    }
    
    
    
    CGSize strSize = [moneyStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]}];
    cell.moneyNumLB.frame =CGRectMake(16*SCALE_W, 10*SCALE_W, strSize.width, 22*SCALE_W);
    cell.moneyNumLB.text =moneyStr;
    
    cell.timeLB.text =[Common newGetTimeFromTimestamp:[NSString stringWithFormat:@"%ld",[dic[@"TxnTime"] longValue]]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary* model =self.dataArray[indexPath.row];
//    ShareWalletPayDetailViewController *vc=[[ShareWalletPayDetailViewController alloc]init];
//    vc.isONT =self.isONT;
//    vc.address =self.address;
//    vc.dic =model;
//    vc.isComplete =YES;
//    [self.navigationController pushViewController:vc animated:YES];
    WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
    vc.transaction = [self.dataArray[indexPath.row] valueForKey:@"TxnHash"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UIView*)emptyV{
    if (!_emptyV) {
        _emptyV =[[UIView alloc]initWithFrame:CGRectMake(0, 0*SCALE_W, SYSWidth, 191*SCALE_W)];
        _emptyV.backgroundColor =[UIColor whiteColor];
        
        UIImageView* image =[[UIImageView alloc]initWithFrame:CGRectMake((SYSWidth-101*SCALE_W)/2, 63*SCALE_W, 101*SCALE_W, 101*SCALE_W)];
        image.image =[UIImage imageNamed:@"noData"];
        [_emptyV addSubview:image];
        
        UILabel* lb =[[UILabel alloc]initWithFrame:CGRectMake(0, 173*SCALE_W, SYSWidth, 17*SCALE_W)];
        lb.textAlignment =NSTextAlignmentCenter;
        lb.textColor =LIGHTGRAYLB    ;
        lb.font =[UIFont systemFontOfSize:14];
        lb.text =Localized(@"ListNoRecord");
        [_emptyV addSubview:lb];
        
        
    }
    return _emptyV;
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
