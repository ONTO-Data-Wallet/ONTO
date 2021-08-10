//
//  AuthInfoViewController.m
//  ONTO
//
//  Created by Apple on 2018/6/14.
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

#import "AuthInfoViewController.h"
#import "RealNameViewController.h"
#import "ONTO-Swift.h"
#import "BackupV.h"
@interface AuthInfoViewController ()

@end

@implementation AuthInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNav];
    [self createUI];
}

-(void)createNav{
    
     [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    if ([_typeString isEqualToString:Localized(@"IM_Introduce")]) {
         [self setNavTitle:Localized(@"IM_GLOBAL")];
    }else if ([_typeString isEqualToString:Localized(@"shangtangInfo")]) {
        [self setNavTitle:Localized(@"sensetime")];
    }else if ([_typeString isEqualToString:Localized(@"Shufti_Introduce")]) {
        [self setNavTitle:Localized(@"SHUFTIPRO")];
         [self setNavLeftImageIcon:[UIImage imageNamed:@"cotback"] Title:Localized(@"Back")];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                          NSFontAttributeName : [UIFont systemFontOfSize:21 weight:UIFontWeightBold],
                                                                          NSKernAttributeName : @3
                                                                          }];
    }else {
        [self setNavTitle:Localized(@"Authorization")];
    }
   
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI{
    
    UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake((SYSWidth-180*SCALE_W)/2, 72*SCALE_W, 180*SCALE_W, 48*SCALE_W)];
  
    image.image =[UIImage imageNamed:_typeImage];
    [self.view addSubview:image];
//    CGSize strSize = [_typeString boundingRectWithSize:CGSizeMake(SYSWidth -72*SCALE_W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;

    UILabel * authInfoLB =[[UILabel alloc]init];
//                           WithFrame:CGRectMake(36*SCALE_W, 210*SCALE_W, SYSWidth -72*SCALE_W, strSize.height)];
    [self.view addSubview:authInfoLB];

 
    authInfoLB.text = _typeString;
    authInfoLB.textColor = LIGHTTEXTCOLOR;
    authInfoLB.numberOfLines =0;
    authInfoLB.textAlignment =NSTextAlignmentLeft;
    authInfoLB.font =[UIFont systemFontOfSize:14];
    if ([_typeString isEqualToString:Localized(@"IM_Introduce")]||[_typeString isEqualToString:Localized(@"shangtangInfo")]) {
        image.frame = CGRectMake((SYSWidth-180*SCALE_W)/2, 75*SCALE_W, 225*SCALE_W, 127*SCALE_W);
        image.centerX = self.view.centerX;
        [Common setLabelSpace:authInfoLB withValue:_typeString withFont:[UIFont systemFontOfSize:13]];
    }
    if ([_typeString isEqualToString:Localized(@"Shufti_Introduce")]) { //Shufti_Introduce
        image.frame = CGRectMake((SYSWidth-180*SCALE_W)/2, 95*SCALE_W, 180*SCALE_W, 60*SCALE_W);
        image.centerX = self.view.centerX;
    }
    if(kScreenWidth==320){
        
        authInfoLB.font =[UIFont systemFontOfSize:11];
        [Common setLabelSpace:authInfoLB withValue:_typeString withFont:[UIFont systemFontOfSize:10]];

    }
    
    [authInfoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*SCALE_W);
        make.right.mas_equalTo(-30*SCALE_W);
        make.top.mas_equalTo(image.mas_bottom).offset(40);
    }];
    
    UIButton *getAuthBtn =[[UIButton alloc]init];
    if ([_typeString isEqualToString:Localized(@"Shufti_Introduce")]) {
        authInfoLB.textColor = [UIColor blackColor];
        
        getAuthBtn.backgroundColor =[UIColor colorWithHexString:@"#000000"];
        [getAuthBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [getAuthBtn setTitle:Localized(@"ShuftiGETCERT") forState:UIControlStateNormal];
        getAuthBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        [getAuthBtn.titleLabel changeSpace:0 wordSpace:3];
        [getAuthBtn addTarget:self action:@selector(getAuth) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:getAuthBtn];
        [getAuthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(58*SCALE_W);
            make.right.equalTo(self.view).offset(-58*SCALE_W);
            make.height.mas_offset(60*SCALE_W);
            if (KIsiPhoneX) {
                make.bottom.equalTo(self.view).offset(- 40*SCALE_W - 34);
            }else{
                make.bottom.equalTo(self.view).offset(- 40*SCALE_W );
            }
        }];
        
    }else{
        getAuthBtn.frame = KIsiPhoneX ? CGRectMake(0, SYSHeight-48*SCALE_W-88-34, SYSWidth, 48*SCALE_W) : CGRectMake(0, SYSHeight-48-64, SYSWidth, 48);
        getAuthBtn.backgroundColor =[UIColor colorWithHexString:@"#EDF2F5"];
        [getAuthBtn setTitleColor:[UIColor colorWithHexString:@"#29A6FF"] forState:UIControlStateNormal];
        [getAuthBtn setTitle:Localized(@"getAuthCert") forState:UIControlStateNormal];
        getAuthBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        [getAuthBtn addTarget:self action:@selector(getAuth) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:getAuthBtn];
    }
    
}




-(void)getAuth{
    //Identity Mind
    if ([_typeString isEqualToString:Localized(@"IM_Introduce")]) {
        
//        NationSelectViewController*vc =[[NationSelectViewController alloc]init];
//        vc.modelArr = self.modelArr;
//        vc.typeString = @"IM";
//        [self.navigationController pushViewController:vc animated:YES];
        
        for (IdentityModel * model in self.modelArr) {
            if ([model.ClaimContext isEqualToString:@"claim:idm_idcard_authentication"]) {
                NSString * str = [NSString stringWithFormat:@"%@",model.ChargeInfo.Amount];
                NSString * str1 = [NSString stringWithFormat:@"%@",model.ChargeInfo.Charge];
                if ([str1 isEqualToString:@""]|| [str1 intValue] == 0) {
                    NationSelectViewController*vc =[[NationSelectViewController alloc]init];
                    vc.modelArr = self.modelArr;
                    vc.typeString = @"IM";
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    NSString * allFee = [Common getAllFee:str gasPrice:model.ChargeInfo.GasPrice GasLimit:model.ChargeInfo.GasLimit];
                    NSString *titleStr = [NSString stringWithFormat:Localized(@"ShuftiInfo"),allFee];
                    BackupV * v = [[BackupV alloc]initWithTitle:titleStr imageString:@"dropLater" leftButtonString:Localized(@"BACK") rightButtonString:Localized(@"GOON")];
                    v.callleftback = ^(NSString *string) {
                        [self.navigationController popViewControllerAnimated:YES];
                    };
                    v.callback = ^(NSString *string) {
                        NationSelectViewController*vc =[[NationSelectViewController alloc]init];
                        vc.modelArr = self.modelArr;
                        vc.typeString = @"IM";
                        [self.navigationController pushViewController:vc animated:YES];
                    };
                    [v show];
                }
            }
        }
        
       //Shufti
    }else if ([_typeString isEqualToString:Localized(@"Shufti_Introduce")]){
        
        for (IdentityModel * model in self.modelArr) {
            if ([model.ClaimContext isEqualToString:@"claim:sfp_idcard_authentication"]) {
                NSString * str = [NSString stringWithFormat:@"%@",model.ChargeInfo.Amount];
                NSString * str1 = [NSString stringWithFormat:@"%@",model.ChargeInfo.Charge];
                if ([str1 isEqualToString:@""]|| [str1 intValue] == 0) {
                    NationSelectViewController*vc =[[NationSelectViewController alloc]init];
                    vc.modelArr = self.modelArr;
                    vc.typeString = @"Shufti";
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    NSString * allFee = [Common getAllFee:str gasPrice:model.ChargeInfo.GasPrice GasLimit:model.ChargeInfo.GasLimit];
                    NSString *titleStr = [NSString stringWithFormat:Localized(@"ShuftiInfo"),allFee];
                    BackupV * v = [[BackupV alloc]initWithTitle:titleStr imageString:@"dropLater" leftButtonString:Localized(@"BACK") rightButtonString:Localized(@"GOON")];
                    v.callleftback = ^(NSString *string) {
                        [self.navigationController popViewControllerAnimated:YES];
                    };
                    v.callback = ^(NSString *string) {
                        NationSelectViewController*vc =[[NationSelectViewController alloc]init];
                        vc.modelArr = self.modelArr;
                        vc.typeString = @"Shufti";
                        [self.navigationController pushViewController:vc animated:YES];
                    };
                    [v show];
                }
            }
        }
        
        
    }else{ //CFCA
            if ([_chargeModel.ClaimContext isEqualToString:@"claim:cfca_authentication"] || [_chargeModel.ClaimContext isEqualToString:@"claim:sensetime_authentication"]) {
                NSString * str = [NSString stringWithFormat:@"%@",_chargeModel.ChargeInfo.Amount];
                NSString * str1 = [NSString stringWithFormat:@"%@",_chargeModel.ChargeInfo.Charge];
                
                
                if ([str1 isEqualToString:@""]|| [str1 intValue] == 0) {
                    RealNameViewController * vc =[[RealNameViewController alloc]init];
                    vc.claimImage =self.claimImage;
                    vc.chargeModel=self.chargeModel;
                    if ([_typeString isEqualToString:Localized(@"shangtangInfo")] ) {
                        vc.isCFCA = NO;
                    }else{
                        vc.isCFCA = YES;
                    }
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    NSString * allFee = [Common getAllFee:str gasPrice:_chargeModel.ChargeInfo.GasPrice GasLimit:_chargeModel.ChargeInfo.GasLimit];
                    NSString *titleStr = [NSString stringWithFormat:Localized(@"ShuftiInfo"),allFee];
                    BackupV * v = [[BackupV alloc]initWithTitle:titleStr imageString:@"dropLater" leftButtonString:Localized(@"BACK") rightButtonString:Localized(@"GOON")];
                    v.callleftback = ^(NSString *string) {
                        [self.navigationController popViewControllerAnimated:YES];
                    };
                    v.callback = ^(NSString *string) {
                        RealNameViewController * vc =[[RealNameViewController alloc]init];
                        vc.claimImage =self.claimImage;
                        if ([_typeString isEqualToString:Localized(@"shangtangInfo")] ) {
                            vc.isCFCA = NO;
                        }else{
                            vc.isCFCA = YES;
                        }
                        vc.chargeModel=self.chargeModel;
                        [self.navigationController pushViewController:vc animated:YES];
                    };
                    [v show];
                }
            }
        
    }
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
