//
//  ShareWalletDetailViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/10.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ShareWalletDetailViewController.h"

@interface ShareWalletDetailViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)NSMutableArray   *dataArray;
@property(nonatomic,strong)NSDictionary     *walletDic;

@property(nonatomic,strong)UIView           *tableHeaderV;
@end

@implementation ShareWalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    self.walletDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    self.dataArray =self.walletDic[@"coPayers"];
    [self createUI];
    [self createNav];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68*SCALE_W;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"cellDetail";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UILabel *nameLB =[[UILabel alloc]initWithFrame:CGRectMake(25*SCALE_W, 10*SCALE_W, SYSWidth-50*SCALE_W, 22*SCALE_W)];
        nameLB.textColor =BLACKLB;
        nameLB.tag=100;
        nameLB.textAlignment =NSTextAlignmentLeft;
        nameLB.font =[UIFont systemFontOfSize:17];
        [cell.contentView addSubview:nameLB];
        
        UILabel *addressLB =[[UILabel alloc]initWithFrame:CGRectMake(25*SCALE_W, 39*SCALE_W, SYSWidth-50*SCALE_W, 14*SCALE_W)];
        addressLB.textColor =BLACKLB;
        addressLB.tag =1000;
        addressLB.textAlignment =NSTextAlignmentLeft;
        addressLB.font =[UIFont systemFontOfSize:12];
        [cell.contentView addSubview:addressLB];
        
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(25*SCALE_W, 68*SCALE_W-1, SYSWidth-50*SCALE_W, 1)];
        line.backgroundColor =LINEBG;
        [cell.contentView addSubview:line];
    }
    NSDictionary *dic =self.dataArray[indexPath.row];
    UILabel* name = (UILabel*)[cell.contentView viewWithTag:100];
    name.text =dic[@"name"];
    
    UILabel* address =(UILabel*)[cell.contentView viewWithTag:1000];
    address.text =[NSString stringWithFormat:@"%@ %@",Localized(@"shareAddress"),dic[@"address"]];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 30*SCALE_W)];
    
    UILabel * CopayersLB =[[UILabel alloc]initWithFrame:CGRectMake(25*SCALE_W, 0, SYSWidth/2-25*SCALE_W, 20*SCALE_W)];
    CopayersLB.textAlignment =NSTextAlignmentLeft;
    CopayersLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    CopayersLB.textColor =BLACKLB;
    CopayersLB.text = Localized(@"Copayers");
    [bgV addSubview:CopayersLB];
    
    UILabel * ruleLB =[[UILabel alloc]initWithFrame:CGRectMake(SYSWidth/2, 0, SYSWidth/2-25*SCALE_W, 20*SCALE_W)];
    ruleLB.textAlignment =NSTextAlignmentRight;
    ruleLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    ruleLB.textColor =BLACKLB;
    ruleLB.text = [NSString stringWithFormat:Localized(@"shareRule"),[self.walletDic[@"requiredNumber"] integerValue],[self.walletDic[@"totalNumber"]integerValue]];
    [bgV addSubview:ruleLB];
    return bgV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*SCALE_W;
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
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.tableHeaderView = self.tableHeaderV;
    }
    return _tableView;
}
-(UIView*)tableHeaderV{
    if (!_tableHeaderV) {
        _tableHeaderV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 305*SCALE_W)];
        
        UILabel * nameLB =[[UILabel alloc]initWithFrame:CGRectMake(0, 15*SCALE_W, SYSWidth, 24*SCALE_W)];
        nameLB.textAlignment =NSTextAlignmentCenter;
        nameLB.textColor =BLACKLB;
        nameLB.font =[UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        nameLB.text =self.walletDic[@"sharedWalletName"];
        [_tableHeaderV addSubview:nameLB];
        
        UIImageView * qrImage =[[UIImageView alloc]initWithFrame:CGRectMake(SYSWidth/2-80*SCALE_W, 59*SCALE_W, 160*SCALE_W, 160*SCALE_W)];
        qrImage.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:self.walletDic[@"sharedWalletAddress"] logoImageName:@"" logoScaleToSuperView:0.25 withWallet:NO];
        [_tableHeaderV addSubview:qrImage];
        
//        UILabel * addressLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 240*SCALE_W, SYSWidth-119*SCALE_W, 14*SCALE_W)];
//        addressLB.textAlignment =NSTextAlignmentLeft;
//        addressLB.textColor =[UIColor colorWithHexString:@"#6A797C"];
//        addressLB.font =[UIFont systemFontOfSize:12];
//        addressLB.text =Localized(@"shareWalletAddress");
//        [_tableHeaderV addSubview:addressLB];
        
        NSString * addressString =self.walletDic[@"sharedWalletAddress"];
        CGSize strSize = [addressString sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        
        UIButton * copyBtn =[[UIButton alloc]initWithFrame:CGRectMake(50*SCALE_W + strSize.width, 240*SCALE_W, 15*SCALE_W, 15*SCALE_W)];
        [copyBtn setEnlargeEdge:25];
        [copyBtn setImage:[UIImage imageNamed:@"gray9"] forState:UIControlStateNormal];
        [_tableHeaderV addSubview:copyBtn];
        [copyBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [self showHint:Localized(@"WalletCopySuccess")];
             [Common showToast:Localized(@"WalletCopySuccess")];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = addressString;
        }];
        
        UILabel *addressLB1 =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 240*SCALE_W, SYSWidth-78*SCALE_W, 16*SCALE_W)];
        addressLB1.text =addressString;
        addressLB1.font =[UIFont systemFontOfSize:12];
        addressLB1.textColor =BLACKLB;
        addressLB1.textAlignment =NSTextAlignmentCenter;
        [_tableHeaderV addSubview:addressLB1];
        
//        UILabel * keyLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 291*SCALE_W, SYSWidth-119*SCALE_W, 14*SCALE_W)];
//        keyLB.textAlignment =NSTextAlignmentLeft;
//        keyLB.textColor =[UIColor colorWithHexString:@"#6A797C"];
//        keyLB.font =[UIFont systemFontOfSize:12];
//        keyLB.text =Localized(@"publicKeys");
//        [_tableHeaderV addSubview:keyLB];
//
//        CGSize strSize1 = [[NSString stringWithFormat:@"%@",Localized(@"publicKeys")] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
//
//        UIButton * copyBtn1 =[[UIButton alloc]initWithFrame:CGRectMake(36*SCALE_W + strSize1.width, 291*SCALE_W, 15*SCALE_W, 15*SCALE_W)];
//        [copyBtn1 setImage:[UIImage imageNamed:@"gray9"] forState:UIControlStateNormal];
//        [_tableHeaderV addSubview:copyBtn1];
//
//        UILabel *keyLB2 =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 309*SCALE_W, SYSWidth-88*SCALE_W, 32*SCALE_W)];
//        keyLB2.text =@"sagdsgvdsgdsgvasgsdgadfgvdfgvdf";
//        keyLB2.numberOfLines =0;
//        keyLB2.font =[UIFont systemFontOfSize:12];
//        keyLB2.textColor =BLACKLB;
//        keyLB2.textAlignment =NSTextAlignmentLeft;
//        [_tableHeaderV addSubview:keyLB2];
        
    }
    return _tableHeaderV;
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
