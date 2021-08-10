//
//  SwapListViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/16.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "SwapListDetailViewController.h"
#import "SwapListDetailCell.h"
@interface SwapListDetailViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)NSArray          *titleArray;
@end

@implementation SwapListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray =@[Localized(@"authStatus"),Localized(@"RequestAmount"),Localized(@"SwapAmount"),Localized(@"RequestTime"),Localized(@"SwapTime"),Localized(@"addressLB")];
    [self createUI];
    [self createNav];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*SCALE_W;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"swapListDetail";
    SwapListDetailCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SwapListDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row ==1 || indexPath.row ==2) {
        cell.ONTLB.hidden =NO;
    }
    cell.titleLB.text =self.titleArray[indexPath.row];
    return cell;
}
-(void)createNav{
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    
}
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight-64) style:UITableViewStylePlain];
        if (KIsiPhoneX) {
            _tableView.frame =CGRectMake(0, 0, SYSWidth, SYSHeight-64-34-24);
        }
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =[UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.delegate =self;
        _tableView.dataSource =self;
    }
    return _tableView;
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
