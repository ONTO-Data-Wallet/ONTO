//
//  ManageShareWalletViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/30.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ManageShareWalletViewController.h"

@interface ManageShareWalletViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)UIButton         *createBtn;
@property(nonatomic,strong)UIView           *topView;
@end

@implementation ManageShareWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNav];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.createBtn];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr =self.dic[@"coPayers"];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*SCALE_W;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId =@"cellID";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(25*SCALE_W, 16*SCALE_W, 8*SCALE_W, 8*SCALE_W)];
        image.image =[UIImage imageNamed:@"8ptdot"];
        [cell.contentView addSubview:image];
        
        UILabel *name =[[UILabel alloc]initWithFrame:CGRectMake(40*SCALE_W, 12*SCALE_W, SYSWidth -40*SCALE_W, 16*SCALE_W)];
        name.textColor =BLACKLB;
        name.tag =1000;
        name.textAlignment =NSTextAlignmentLeft;
        name.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [cell.contentView addSubview:name];
        
        UILabel *address =[[UILabel alloc]initWithFrame:CGRectMake(40*SCALE_W, 33*SCALE_W, SYSWidth -40*SCALE_W, 16*SCALE_W)];
        address.textColor =[UIColor colorWithHexString:@"#001C00"];
        address.tag =10000;
        address.textAlignment =NSTextAlignmentLeft;
        address.font =[UIFont systemFontOfSize:12 ];
        [cell.contentView addSubview:address];
        
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(25*SCALE_W, 60*SCALE_W-1, SYSWidth -50*SCALE_W, 1)];
        line.backgroundColor =LINEBG;
        [cell.contentView addSubview:line];
    }
    NSArray *arr =self.dic[@"coPayers"];
    NSDictionary* coDic =arr[indexPath.row];
    UILabel* nameLB =(UILabel*)[cell.contentView viewWithTag:1000];
    nameLB.text =coDic[@"name"];
    
    UILabel* addressLB =(UILabel*)[cell.contentView viewWithTag:10000];
    addressLB.text =[NSString stringWithFormat:@"%@ %@",Localized(@"shareAddress"),coDic[@"address"]];
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
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight-64-48) style:UITableViewStylePlain];
        if (KIsiPhoneX) {
            _tableView.frame =CGRectMake(0, 0, SYSWidth, SYSHeight-64-34-24-48);
        }
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.backgroundColor =[UIColor whiteColor];
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.tableHeaderView =self.topView;
    }
    return _tableView;
}

-(UIButton*)createBtn{
    if (!_createBtn) {
        _createBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, SYSHeight-64-48, SYSWidth, 48)];
        if (KIsiPhoneX) {
            _createBtn.frame =CGRectMake(0, SYSHeight-64-48-34-24, SYSWidth, 48);
        }
        [_createBtn setTitle:[NSString stringWithFormat:@" %@",Localized(@"Delete")] forState:UIControlStateNormal];
        [_createBtn setImage:[UIImage imageNamed:@"newDelete"] forState:UIControlStateNormal];
        [_createBtn setTitleColor:BLACKLB forState:UIControlStateNormal];
        _createBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
        [_createBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            NSMutableArray * arr =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:ALLASSET_ACCOUNT]] ;;
                if ([[[Common dictionaryWithJsonString:[Common getEncryptedContent:ASSET_ACCOUNT]
                       ]valueForKey:@"sharedWalletAddress"] isEqualToString:self.dic[@"sharedWalletAddress"]]) {
                    
                    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletCanNotDeleted") message:nil image:nil];
                    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                        
                    }];
                    action.titleColor =MainColor;
                    [pop addAction:action];
                    [pop show];
                    pop.showCloseButton = NO;
                    return;
                }
                
                MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"ShareWalletDelete") message:nil image:nil];
                MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                    //删除数据，和删除动画
                    [arr removeObject:self.dic];
                    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:ALLASSET_ACCOUNT];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                MGPopAction *action1 =   [MGPopAction actionWithTitle:Localized(@"Cancel") action:^{
                }];
                action.titleColor =MainColor;
                [pop addAction:action];
                [pop addAction:action1];
                [pop show];
                pop.showCloseButton = NO;
        }];
    }
    return _createBtn;
}
-(UIView*)topView{
    if (!_topView) {
        _topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 346*SCALE_W)];
        _topView.backgroundColor =[UIColor whiteColor];
        
        UILabel *nameLB =[[UILabel alloc]initWithFrame:CGRectMake(0, 40*SCALE_W, SYSWidth, 24*SCALE_W)];
        nameLB.font =[UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
        nameLB.textAlignment =NSTextAlignmentCenter;
        nameLB.textColor =BLACKLB;
        nameLB.text =_dic[@"sharedWalletName"];
        [_topView addSubview:nameLB];
        
        UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(SYSWidth/2-50*SCALE_W, 104*SCALE_W, 100*SCALE_W, 100*SCALE_W)];
        image.image =[UIImage imageNamed:@"shareTu"];
        [_topView addSubview:image];
        
        NSString * addressString =self.dic[@"sharedWalletAddress"];
        
        UIButton * copyBtn =[[UIButton alloc]initWithFrame:CGRectMake(SYSWidth -33*SCALE_W, 274*SCALE_W, 16*SCALE_W, 16*SCALE_W)];
        [copyBtn setEnlargeEdge:25];
        [copyBtn setImage:[UIImage imageNamed:@"gray9"] forState:UIControlStateNormal];
        [_topView addSubview:copyBtn];
        [copyBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [self showHint:Localized(@"WalletCopySuccess")];
            [Common showToast:Localized(@"WalletCopySuccess")];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = addressString;
        }];
        
        UILabel *addressLB =[[UILabel alloc]initWithFrame:CGRectMake(17*SCALE_W, 254*SCALE_W, SYSWidth-60*SCALE_W, 16*SCALE_W)];
        addressLB.text =Localized(@"shareAddress");
        addressLB.font =[UIFont systemFontOfSize:14];
        addressLB.textColor =LIGHTGRAYLB;
        addressLB.textAlignment =NSTextAlignmentLeft;
        [_topView addSubview:addressLB];
        
        UILabel *addressLB1 =[[UILabel alloc]initWithFrame:CGRectMake(17*SCALE_W, 274*SCALE_W, SYSWidth-60*SCALE_W, 16*SCALE_W)];
        addressLB1.text =addressString;
        addressLB1.font =[UIFont systemFontOfSize:14];
        addressLB1.textColor =BLACKLB;
        addressLB1.textAlignment =NSTextAlignmentLeft;
        [_topView addSubview:addressLB1];
        
        UILabel * CopayersLB =[[UILabel alloc]initWithFrame:CGRectMake(17*SCALE_W, 321*SCALE_W, SYSWidth/2-17*SCALE_W, 20*SCALE_W)];
        CopayersLB.textAlignment =NSTextAlignmentLeft;
        CopayersLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        CopayersLB.textColor =LIGHTGRAYLB;
        CopayersLB.text = [NSString stringWithFormat:@"%@:",Localized(@"Copayers")];
        [_topView addSubview:CopayersLB];
        
        UILabel * ruleLB =[[UILabel alloc]initWithFrame:CGRectMake(SYSWidth/2, 321*SCALE_W, SYSWidth/2-17*SCALE_W, 20*SCALE_W)];
        ruleLB.textAlignment =NSTextAlignmentRight;
        ruleLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        ruleLB.textColor =BLACKLB;
        ruleLB.text = [NSString stringWithFormat:Localized(@"shareRule"),[self.dic[@"requiredNumber"] integerValue],[self.dic[@"totalNumber"]integerValue]];
        [_topView addSubview:ruleLB];
    }
    return _topView;
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
