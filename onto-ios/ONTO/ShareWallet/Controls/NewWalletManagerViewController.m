//
//  NewWalletManagerViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/30.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "NewWalletManagerViewController.h"
#import "ManageShareWalletViewController.h"
#import "ManageNormalWalletViewController.h"
@interface NewWalletManagerViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView       *tableView;
@property(nonatomic,strong)NSMutableArray    *dataArray;
@end

@implementation NewWalletManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createNav];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}
-(void)getData{
    self.dataArray =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:ALLASSET_ACCOUNT]] ;;
    [self.tableView reloadData];
}
-(void)createUI{
    [self.view addSubview:self.tableView];
}
-(void)createNav{
    [self setNavTitle:Localized(@"Walletmanage")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83*SCALE_W;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId =@"managerCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        UILabel * nameLB =[[UILabel alloc]initWithFrame:CGRectMake(16*SCALE_W, 20*SCALE_W, SYSWidth-40*SCALE_W, 26*SCALE_W)];
        nameLB.tag =1000;
        nameLB.text =@"Wallet Two";
        nameLB.textAlignment =NSTextAlignmentLeft;
        nameLB.textColor =BLACKLB   ;
        nameLB.font =[UIFont systemFontOfSize:24];
        [cell.contentView addSubview:nameLB];
        
        UILabel * addressLB =[[UILabel alloc]initWithFrame:CGRectMake(16*SCALE_W, 52*SCALE_W, SYSWidth-40*SCALE_W, 14*SCALE_W)];
        addressLB.tag =10000;
        addressLB.text =@"Address: TA6LmKTxUEWkUSsazszNqS1DVZfB1DuhRp";
        addressLB.textAlignment =NSTextAlignmentLeft;
        addressLB.textColor =LIGHTGRAYLB   ;
        addressLB.font =[UIFont systemFontOfSize:12];
        [cell.contentView addSubview:addressLB];
        
        UIImageView *rightImage =[[UIImageView alloc]initWithFrame:CGRectMake(SYSWidth -33*SCALE_W, 33.5*SCALE_W, 16*SCALE_W, 16*SCALE_W)];
        rightImage.image =[UIImage imageNamed:@"sharelight_gray"];
        [cell.contentView addSubview:rightImage];
        
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(16*SCALE_W, 83*SCALE_W-1, SYSWidth-16*SCALE_W, 1)];
        line.backgroundColor =LINEBG;
        [cell.contentView addSubview:line];
    }
    NSDictionary *dic =self.dataArray[indexPath.row];
    UILabel *nameLBDetail =(UILabel*)[cell.contentView viewWithTag:1000];
    UILabel *addressLBDetail =(UILabel*)[cell.contentView viewWithTag:10000];
    if ([dic isKindOfClass:[NSDictionary class]] &&dic[@"label"]) {
        nameLBDetail.text =dic[@"label"];
        addressLBDetail.text =[NSString stringWithFormat:@"%@ %@",Localized(@"shareAddress"),dic[@"address"]];
    }else{
        nameLBDetail.text =dic[@"sharedWalletName"];
        addressLBDetail.text =[NSString stringWithFormat:@"%@ %@",Localized(@"shareAddress"),dic[@"sharedWalletAddress"]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic =self.dataArray[indexPath.row];
    if ([dic isKindOfClass:[NSDictionary class]] && dic[@"label"]) {
        ManageNormalWalletViewController * vc =[[ManageNormalWalletViewController alloc]init];
        vc.dic =dic;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ManageShareWalletViewController *vc =[[ManageShareWalletViewController alloc]init];
        vc.dic =dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight-64) style:UITableViewStylePlain];
        if (KIsiPhoneX) {
            _tableView.frame =CGRectMake(0, 0, SYSWidth, SYSHeight-64-34-24);
        }
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.backgroundColor =[UIColor whiteColor];
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource =self;
    }
    return _tableView;
}
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
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
