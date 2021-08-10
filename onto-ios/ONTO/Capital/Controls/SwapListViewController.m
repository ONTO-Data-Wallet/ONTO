//
//  SwapListViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/16.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "SwapListViewController.h"
#import "SwapListDetailViewController.h"
#import "SwapListCell.h"
#import <MJRefresh/MJRefresh.h>
#import "SwapExplainViewController.h"
@interface SwapListViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)NSMutableArray   *dataArray;
@property(nonatomic,strong)UIButton         *createBtn;
@property(nonatomic,strong)NSTimer          *timer;
@property(nonatomic,copy)NSString           *ontNumber;
@property(nonatomic,assign)NSInteger        page;
@property(nonatomic,assign)BOOL             isDraging;
@end

@implementation SwapListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createNav];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    self.isDraging =YES;
    _page= 1;
    _dataArray = [[NSMutableArray alloc] init];
    [self handleData];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page =1;
        [_dataArray removeAllObjects];
        [self handleData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self handleData];
    }];
    
}
static NSString * extracted() {
    return New_txnstate;
}
-(void)handleData{
    NSString *jsonstr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonstr];
    
    NSString *address = dict[@"address"];
    
    NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@%@",dict[@"address"],ALLSWAP]];
    DebugLog(@"allArray=%@",allArray);
    if (_dataArray.count ==0) {
        [_dataArray addObjectsFromArray:allArray];
    }else{
        if (allArray.count>0) {
            for (NSDictionary *dic in allArray) {
                BOOL isHave =NO;
                for (NSDictionary *newDic in _dataArray) {
                    if ([newDic[@"neo_txnhash"] isEqualToString:dic[@"neo_txnhash"]]) {
                        isHave =YES;
                    }
                }
                if (isHave ==NO) {
                    [_dataArray addObject:dic];
                }
            }
        }
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%ld",extracted(),address,@30,_page];
    
    [[CCRequest shareInstance] requestWithURLString1:urlStr MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal) {
        DebugLog(@"hhh=%@",responseObject);
        
        [self endRefresh];
        if (_page ==1) {
             [self addObjectFromArray:responseObject[@"TxnList"]];
//            [_dataArray addObjectsFromArray:responseObject[@"TxnList"]];

        }else{
            if ([responseObject[@"TxnList"] count]==0) {
                _page --;
            }
             [self addObjectFromArray:responseObject[@"TxnList"]];
//            [_dataArray addObjectsFromArray:responseObject[@"TxnList"]];
        }
        DebugLog(@"_dataArray=%@",_dataArray);
        [_tableView reloadData];
    }Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
         [self endRefresh];
        [_tableView reloadData];
    }];
}
-(void)addObjectFromArray:(NSArray*)array{
    if (_dataArray.count ==0) {
        [_dataArray addObjectsFromArray:array];
    }else{
        if (array.count>0) {
            NSArray * ceshiArr =[NSArray arrayWithArray:_dataArray];
            for (NSDictionary *dic in array) {
                BOOL isHave =NO;
                NSDictionary *sameDic =[NSDictionary dictionary];
                
                for (NSDictionary *newDic in ceshiArr) {
                    if ([newDic[@"neo_txnhash"] isEqualToString:dic[@"neo_txnhash"]]) {
                        isHave =YES;
                        sameDic =[newDic copy];
                    }
                }
                if (isHave ==NO) {
                    [_dataArray addObject:dic];
                }else{
                    [_dataArray removeObject:sameDic];
                    [_dataArray addObject:dic];
                }
            }
        }
    }
}

-(void)createUI{
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.createBtn];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84*SCALE_W;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"swapList";
    SwapListCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SwapListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    NSDictionary* dic =_dataArray[indexPath.row];
    [cell reloadCellByDic:dic];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 60*SCALE_W)];

    UIView *bgV1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 45*SCALE_W)];
    bgV1.backgroundColor =[UIColor colorWithHexString:@"#F4FCFD"];
    [bgV addSubview:bgV1];
    
    UIImageView* image =[[UIImageView alloc]initWithFrame:CGRectMake(16*SCALE_W, 11.5*SCALE_W, 22*SCALE_W, 22*SCALE_W)];
    image.image=[UIImage imageNamed:@"swapnotice"];
    [bgV1 addSubview:image];
    
    NSMutableAttributedString *pwdString = [[NSMutableAttributedString alloc] initWithString:Localized(@"swapAlert")];
    if (![[Common getUserLanguage]isEqualToString:@"en"]) {
        [pwdString addAttribute:NSForegroundColorAttributeName value:BLACKLB range:NSMakeRange(0, pwdString.length)];
        [pwdString addAttribute:NSForegroundColorAttributeName value:BLUELB range:NSMakeRange(pwdString.length -27, 19)];
    }else{
        [pwdString addAttribute:NSForegroundColorAttributeName value:BLACKLB range:NSMakeRange(0, pwdString.length -11)];
        [pwdString addAttribute:NSForegroundColorAttributeName value:BLUELB range:NSMakeRange(pwdString.length -12, 12)];
    }
    
    UILabel * lb=[[UILabel alloc]initWithFrame:CGRectMake(46*SCALE_W, 0, SYSWidth -62*SCALE_W, 45*SCALE_W)];
    lb.numberOfLines =0;
    lb.font =[UIFont systemFontOfSize:12];
    lb.attributedText =pwdString;
    lb.textAlignment =NSTextAlignmentLeft;
    [bgV1 addSubview:lb];
    
    return bgV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60*SCALE_W;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    SwapListDetailViewController *vc =[[SwapListDetailViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
-(void)createNav{
    [self setTitle:Localized(@"MainNetONTTokenSwap")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    
}
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight-49-64) style:UITableViewStyleGrouped];
        if (KIsiPhoneX) {
            _tableView.frame =CGRectMake(0, 0, SYSWidth, SYSHeight-49-64-34-24);
        }
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =[UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.delegate =self;
        _tableView.dataSource =self;
    }
    return _tableView;
}
-(UIButton*)createBtn{
    if (!_createBtn) {
        _createBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, SYSHeight-64-49, SYSWidth, 49)];
        if (KIsiPhoneX) {
            _createBtn.frame =CGRectMake(0, SYSHeight-64-49-34-24, SYSWidth, 49);
        }
        [_createBtn setTitle:Localized(@"Swap") forState:UIControlStateNormal];
        [_createBtn setTitleColor:BLUELB forState:UIControlStateNormal];
        _createBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
        [_createBtn addTarget:self action:@selector(createbtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}

- (void)createbtnClick{
    SwapExplainViewController *vc = [[SwapExplainViewController alloc]init];
    vc.NET5 = self.NET5;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)endRefresh{
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
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
