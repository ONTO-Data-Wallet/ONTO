//
//  ShuftiProDetailViewController.m
//  ONTO
//
//  Created by Apple on 2018/11/8.
//  Copyright © 2018 Zeus. All rights reserved.
//



#import "ShuftiProDetailViewController.h"
#import "IMNewInfoCell.h"
#import "IMNewDetailCell.h"
#import "ClaimModel.h"
#import "DataBase.h"
#import "WebIdentityViewController.h"
@interface ShuftiProDetailViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *dataContentArray;
@property(nonatomic,strong)NSMutableArray *infoArray;
@property(nonatomic,strong)NSMutableArray *infoContentArray;
@property(nonatomic,strong)NSDictionary *claimDic;
@property(nonatomic,strong)NSDictionary *contentDic;
@property(nonatomic,strong)NSMutableDictionary *showDic;
@property(nonatomic,strong)UIButton *arrowBtn;
@property(nonatomic,strong)NSDictionary * ChargeInfo;
@end

@implementation ShuftiProDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];// claim:idm_passport_authentication
    ClaimModel *model = [[DataBase sharedDataBase]getCalimWithClaimContext:self.claimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
    if ([Common isBlankString:model.OwnerOntId]) {
        [self getData];
    } else{
        [self handleData:[Common dictionaryWithJsonString:model.Content]];
    }
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#000000"],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:21 weight:UIFontWeightBold],
                                                                      NSKernAttributeName: @2
                                                                      }];
}
-(void)createUI{
    [self setNavTitle:Localized(@"newClaimDetails")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"cotback"] Title:Localized(@"Back")];
    
    _showDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"select", nil];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight - 64) style:UITableViewStyleGrouped];
    if (KIsiPhoneX) {
        _tableView.frame =CGRectMake(0, 0, SYSWidth, SYSHeight - 88 -34);
    }
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.showsVerticalScrollIndicator =NO;
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView *logoV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 96*SCALE_W)];
    UIImageView * logoImage =[[UIImageView alloc]initWithFrame:CGRectMake(70*SCALE_W, 30*SCALE_W, SYSWidth -140*SCALE_W, 36*SCALE_W)];
    logoImage.image =[UIImage imageNamed:@"Ontoloogy Attested"];
    [logoV addSubview:logoImage];
    _tableView.tableFooterView = logoV;
}
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSArray *arr =_infoArray[0];
        return arr.count;
    }
    return [self.dataContentArray[section] count];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        UIView *v1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 220*SCALE_W)];
        
        UIImageView* image =[[UIImageView alloc]initWithFrame:CGRectMake(17.5*SCALE_W, 0, SYSWidth -35*SCALE_W, 210*SCALE_W)];
        image.image =[UIImage imageNamed:@"SBG"];
        image.userInteractionEnabled =YES;
        [v1 addSubview:image];
        
        UILabel *name =[[UILabel alloc]initWithFrame:CGRectMake(17*SCALE_W, 75*SCALE_W, 200*SCALE_W, 24*SCALE_W)];
        name.textAlignment =NSTextAlignmentLeft;
        name.textColor =[UIColor whiteColor];
        name.font =[UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
        name.text =self.contentDic[@"Name"];
        [image addSubview:name];
        
        UIImageView *typeImage =[[UIImageView alloc]initWithFrame:CGRectMake(17*SCALE_W, 152*SCALE_W, 24*SCALE_W, 24*SCALE_W)];
        
        
        [image addSubview:typeImage];
        
        UILabel* type =[[UILabel alloc]initWithFrame:CGRectMake(51*SCALE_W, 148*SCALE_W, 200*SCALE_W, 16*SCALE_W)];
        type.textColor =[UIColor whiteColor];
        type.textAlignment =NSTextAlignmentLeft;
        type.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        
        [image addSubview:type];
        
        UILabel* typeCert =[[UILabel alloc]initWithFrame:CGRectMake(51*SCALE_W, 164*SCALE_W, 200*SCALE_W, 16*SCALE_W)];
        typeCert.textColor =[UIColor whiteColor];
        typeCert.textAlignment =NSTextAlignmentLeft;
        typeCert.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        typeCert.text = Localized(@"IMCertification");
        [image addSubview:typeCert];
        
        if ([self.claimContext isEqualToString:@"claim:sfp_passport_authentication"]) {
            typeImage.image =[UIImage imageNamed:@"IMbluepassport"];
            if (![[Common getUserLanguage]isEqualToString:@"en"]) {
                type.text = Localized(@"IM_PassportCert");
                type.frame =CGRectMake(51*SCALE_W, 156*SCALE_W, 200*SCALE_W, 16*SCALE_W);
                typeCert.hidden =YES;
            }else{
                type.text = Localized(@"IM_Passport");
            }
            
        }else if ([self.claimContext isEqualToString:@"claim:sfp_idcard_authentication"]){
            typeImage.image =[UIImage imageNamed:@"IMblueid"];
            if (![[Common getUserLanguage]isEqualToString:@"en"]) {
                type.text = Localized(@"IM_IDCardCert");
                type.frame =CGRectMake(51*SCALE_W, 156*SCALE_W, 200*SCALE_W, 16*SCALE_W);
                typeCert.hidden =YES;
            }else{
                type.text = Localized(@"IM_IDCard");
            }
        }else{
            typeImage.image =[UIImage imageNamed:@"IMbluedrive"];
            if (![[Common getUserLanguage]isEqualToString:@"en"]) {
                type.text = Localized(@"IM_DriverLicenseCert");
                type.frame =CGRectMake(51*SCALE_W, 156*SCALE_W, 200*SCALE_W, 16*SCALE_W);
                typeCert.hidden =YES;
            }else{
                type.text = Localized(@"IM_DriverLicense");
            }
        }
        _arrowBtn =[[UIButton alloc]initWithFrame:CGRectMake((SYSWidth - 35*SCALE_W)/2 - 8*SCALE_W, 186*SCALE_W, 16*SCALE_W, 16*SCALE_W)];
        [_arrowBtn setEnlargeEdge:20];
        [image addSubview:_arrowBtn];
        if ([_showDic[@"select"] isEqualToString:@"1"]) {
            [_arrowBtn setImage:[UIImage imageNamed:@"IMdropdown"] forState:UIControlStateNormal];
        }else{
            [_arrowBtn setImage:[UIImage imageNamed:@"IMdropup"] forState:UIControlStateNormal];
        }
        [_arrowBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            if ([_showDic[@"select"] isEqualToString:@"1"]) {
                [_showDic setValue:@"0" forKey:@"select"];
                [_arrowBtn setImage:[UIImage imageNamed:@"IMdropup"] forState:UIControlStateNormal];
            }else{
                [_showDic setValue:@"1" forKey:@"select"];
                [_arrowBtn setImage:[UIImage imageNamed:@"IMdropdown"] forState:UIControlStateNormal];
            }
            [_tableView reloadData];
        }];
        return v1;
    }else{
        UIView *v2 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 40*SCALE_W)];
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 40*SCALE_W)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setImage:[UIImage imageNamed:@"cotlink"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#29A6FF"] forState:UIControlStateNormal];
        [btn setTitle:Localized(@"WhatSfp") forState:UIControlStateNormal   ];
        [v2 addSubview:btn];
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            WebIdentityViewController *VC= [[WebIdentityViewController alloc]init];
            if ([ENORCN isEqualToString:@"cn"]) {
//                VC.introduce = @"https://shuftipro.com";
                VC.introduce = @"https://info.onto.app/#/detail/82";
            }else{
//                VC.introduce = @"https://m.tuoniaox.com/news/p-263000.html";
                VC.introduce = @"https://info.onto.app/#/detail/83";
            }
            
            [self.navigationController pushViewController:VC animated:YES];
            
        }];
        return v2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 220*SCALE_W;
    }return 40*SCALE_W;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([_showDic[@"select"] isEqualToString:@"1"]){
            return 0;
        }else{
            return 39*SCALE_W;
        }
    }
    return 80*SCALE_W;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        IMNewInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (cell ==nil) {
            cell = [[IMNewInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        if ([_showDic[@"select"]isEqualToString:@"1"]) {
            cell.hidden =YES;
        }else{
            cell.hidden =NO;
        }
        
        cell.leftLB.text = _infoArray[indexPath.section][indexPath.row];
        if ([cell.leftLB.text isEqualToString:@"IDDocNumber"]) {
            NSString * str = _infoContentArray[indexPath.section][indexPath.row];
            NSMutableString * str1 = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", str]];
            [str1 replaceCharactersInRange:NSMakeRange(str.length - 4, 4) withString:@"****"];
            NSString * str12 = [NSString stringWithFormat:@"%@",str1];
            cell.rightLB.text = str12;
        }else{
            cell.rightLB.text = _infoContentArray[indexPath.section][indexPath.row];
        }
        return cell;
    }else{
        IMNewDetailCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellDetail"];
        if (cell ==nil) {
            cell =[[IMNewDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellDetail"];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        
        cell.topLB.text = _dataArray[indexPath.section][indexPath.row];
        cell.bottomLB.text = _dataContentArray[indexPath.section][indexPath.row];
        if (indexPath.row ==0) {
            cell.bottomLB.textColor =[UIColor colorWithHexString:@"#196BD8"];
            cell.bottomLB.font =[UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        }else{
            cell.bottomLB.textColor =[UIColor colorWithHexString:@"#2B4040"];
        }
        if (indexPath.row ==4 || indexPath.row == 1) {
            cell.rightBtn.hidden =NO;
            [cell.rightBtn setImage:[UIImage imageNamed:@"candy_right_arrow"] forState:UIControlStateNormal];
    
        }else{
            cell.rightBtn.hidden = YES;
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==4) {
        WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
        vc.transaction = self.dataContentArray[1][4];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
        if (_ChargeInfo.count==0) {
            return;
        }
        vc.transaction = _ChargeInfo[@"TxnHash"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)getData{
    
    NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
                             @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
                             @"ClaimId":self.claimId?self.claimId:@"",
                             @"ClaimContext":self.claimContext,
                             @"Status":@"9"
                             };
    DebugLog(@"!!!%@",params);
    
    [[CCRequest shareInstance] requestWithURLString:Claim_query MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        
        DebugLog(@"ceshi=%@",responseObject);
        if ([responseObject[@"EncryptedOrigData"] isEqualToString:@""]) {
            return ;
        }
        //实名认证本地化
        ClaimModel *model = [[ClaimModel alloc] init];
        model.OwnerOntId = [[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID];
        model.ClaimContext = self.claimContext;
        model.Content = [Common dictionaryToJson:responseObject];
        model.status =@"1";
        [[DataBase sharedDataBase] addClaim:model isSoket:NO];
        
        
        NSDictionary* dic =[Common claimdencode:responseObject[@"EncryptedOrigData"]];
        NSDictionary* dic1=dic[@"claim"];
        DebugLog(@"dic->%@",dic);
        //删除后台数据库操作
        NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],
                                 @"DeviceCode":[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
                                 @"ClaimId":dic1[@"jti"]
                                 };
        DebugLog(@"!!!%@",params);
        [[CCRequest shareInstance] requestWithURLString:LocalizationConfirm MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
            
            
        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
            
            
        }];
        
        //            ClaimModel *model2 = [[DataBase sharedDataBase]getCalimWithClaimContext:self.claimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
        
        //        }
        
        [self handleData:responseObject];
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        
    }];
}

- (void)handleData:(NSDictionary*)responseObject{
    DebugLog(@"responseObject=%@",responseObject);
    DebugLog(@"data=%@",[Common claimdencode:[responseObject valueForKey:@"EncryptedOrigData"]]);
    self.claimDic= [[Common claimdencode:[responseObject valueForKey:@"EncryptedOrigData"]] valueForKey:@"claim"];
    DebugLog(@"claimDic%@",self.claimDic);
    _claimId = [self.claimDic valueForKey:@"jti"];
    
    _ChargeInfo = responseObject[@"ChargeInfo"];
    self.contentDic = [self.claimDic valueForKey:@"clm"];
    
    _dataArray =[NSMutableArray array];
    _dataContentArray =[NSMutableArray array];
    _infoArray = [NSMutableArray array];
    _infoContentArray =[NSMutableArray array];
    [_infoArray addObject:[self.contentDic allKeys]];
    [_infoContentArray addObject:[self.contentDic allValues]];
    
    [_dataArray addObject:[self.contentDic allKeys]];
    [_dataContentArray addObject:[self.contentDic allValues]];
    //       _contentValueArr =[NSMutableArray arrayWithArray:[contentDic allValues]];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_dataArray[0]];
    
    for (int i=0; i<[arr count]; i++) {
        if ([arr[i] isEqualToString:@"IdNumber"]||[arr[i] isEqualToString:@"IssuerName"]) {
            [(NSMutableArray*)arr removeObjectAtIndex:i];
        }
    }
    
    [_dataArray replaceObjectAtIndex:0 withObject:arr];
    NSString * feeStr ;
    if (_ChargeInfo.count>0) {
     feeStr  = [NSString stringWithFormat:@"%@ ONG",[Common getshuftiStr:_ChargeInfo[@"Amount"]]];
    }else{
        feeStr  = @"0 ONG";
    }
   
    if ([Common isBlankString:[responseObject valueForKey:@"TxnHash"]]) {
        
        
        NSArray *arrKey= @[Localized(@"authStatus"),Localized(@"SFee"),Localized(@"COTCreated"),Localized(@"COTExpireTime")];
        NSArray *arrValue =@[Localized(@"IMSuccess"),feeStr,[NSString stringWithFormat:@"%@",[Common getTimeFromTimestamp:[[self.claimDic valueForKey:@"iat"] stringValue]]],[Common getTimeFromTimestamp:[[self.claimDic valueForKey:@"exp"] stringValue]]];
        [_dataArray addObject:arrKey];
        [_dataContentArray addObject:arrValue];
        
    }else{
        
        NSString *TxnHash = [Common isBlankString:[responseObject valueForKey:@"TxnHash"]]?@"":[responseObject valueForKey:@"TxnHash"];
        NSArray *arrKey= @[Localized(@"authStatus"),Localized(@"SFee"),Localized(@"COTCreated"),Localized(@"COTExpireTime"),Localized(@"COTBlockchain")];
        
        NSArray *arrValue = @[Localized(@"IMSuccess"),feeStr,[Common getTimeFromTimestamp:[[self.claimDic valueForKey:@"iat"] stringValue]],[Common getTimeFromTimestamp:[[self.claimDic valueForKey:@"exp"] stringValue]],TxnHash];
        
        [_dataArray addObject:arrKey];
        [_dataContentArray addObject:arrValue];
    }
    
    
    
    [_tableView reloadData];
    
    
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


