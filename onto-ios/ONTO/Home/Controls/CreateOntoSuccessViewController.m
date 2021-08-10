//
//  CreateOntoSuccessViewController.m
//  ONTO
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "CreateOntoSuccessViewController.h"
#import "KeyStoreFileViewController.h"
#import "DIManageViewController.h"
#import "ViewController.h"
@interface CreateOntoSuccessViewController ()

@end

@implementation CreateOntoSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:Localized(@"CREATENEWONTID")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@""] Title:@""];
    [self setNavRightImageIcon:[UIImage imageNamed:@""] Title:@""];
    if KIsiPhone5 {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#000000"],
                                                                          NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]
                                                                          }];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#000000"],
                                                                          NSFontAttributeName : [UIFont systemFontOfSize:20 weight:UIFontWeightBold],
                                                                          NSKernAttributeName: @1
                                                                          }];
    }
    
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"ONTOS"];
    [self.view addSubview:image];
    
    UILabel * nameLB = [[UILabel alloc]init];
    nameLB.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:IDENTITY_NAME]];
    nameLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [nameLB changeSpace:0 wordSpace:1];
    nameLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLB];
    
    UILabel * ontLB = [[UILabel alloc]init];
    ontLB.text = Localized(@"newLoginID");
    ontLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium  ];
    [ontLB changeSpace:0 wordSpace:1];
    ontLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:ontLB];
    
    UILabel * ontLBD = [[UILabel alloc]init];
    ontLBD.text = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
    ontLBD.numberOfLines = 0;
    ontLBD.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium  ];
    [ontLBD changeSpace:0 wordSpace:1];
    ontLBD.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:ontLBD];
    
    UILabel * whatLB = [[UILabel alloc]init];
    whatLB.text = Localized(@"ONTIDInfo");
    whatLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [whatLB changeSpace:0 wordSpace:1];
    whatLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:whatLB];
    
    UILabel * ONTOInfo = [[UILabel alloc]init];
    ONTOInfo.text = Localized(@"ONTIDDec");
    ONTOInfo.numberOfLines = 0;
    ONTOInfo.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [ONTOInfo changeSpace:2 wordSpace:1];
    ONTOInfo.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:ONTOInfo];
    
    UIButton * backupBtn = [[UIButton alloc]init];
    [backupBtn setTitle:Localized(@"BACKUP") forState:UIControlStateNormal];
    [backupBtn setTitleColor:[UIColor colorWithHexString:@"#216ed5"] forState:UIControlStateNormal];
    backupBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [backupBtn.titleLabel changeSpace:0 wordSpace:3];
    [self.view addSubview:backupBtn];
    
    UIButton * startBtn =[[UIButton alloc]init];
    startBtn.backgroundColor = [UIColor blackColor];
    [startBtn setTitle:Localized(@"OntSTART") forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [startBtn.titleLabel changeSpace:0 wordSpace:3];
    [self.view addSubview:startBtn];
    
    [backupBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSString *str = [Common getEncryptedContent:APP_ACCOUNT];
        NSDictionary *jsDic = [Common dictionaryWithJsonString:str];
        NSDictionary *dic = [NSMutableArray arrayWithArray:jsDic[@"identities"]][
                                                                                 [[NSMutableArray arrayWithArray:jsDic[@"identities"]] count] - 1];
        
        KeyStoreFileViewController *vc = [[KeyStoreFileViewController alloc] init];
        vc.identityDic = dic;
        vc.isWallet = NO;
        vc.isFirstIdentity = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [startBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if ( _isIdentity) {
            //资产账户导入成功跳转到资产根页
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            
            if (_isFirst) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISFIRST_BACKUP];
                [[NSUserDefaults standardUserDefaults] synchronize];
//                [ViewController gotoIdentityVC];
                [ViewController selectIdentityVC];
                
            } else {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[DIManageViewController class]]) {
                        DIManageViewController *vc = (DIManageViewController *) controller;
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
        }
    }];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_offset(70*SCALE_W);
        make.top.equalTo(self.view).offset(35*SCALE_W);
    }];
    
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(image.mas_bottom).offset(15*SCALE_W);
        
    }];
    
    [ontLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(38*SCALE_W);
        make.top.equalTo(nameLB.mas_bottom).offset(20*SCALE_W);
    }];
    
    [ontLBD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(38*SCALE_W);
        make.right.equalTo(self.view).offset(-38*SCALE_W);
        make.top.equalTo(ontLB.mas_bottom).offset(5*SCALE_W);
    }];
    
    [whatLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        
        if KIsiPhone5 {
            make.top.equalTo(ontLBD.mas_bottom).offset(40*SCALE_W);
        }else{
            make.top.equalTo(ontLBD.mas_bottom).offset(50*SCALE_W);
        }
            
    }];
    
    [ONTOInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(38*SCALE_W);
        make.right.equalTo(self.view).offset(-38*SCALE_W);
        
        if KIsiPhone5 {
            make.top.equalTo(whatLB.mas_bottom).offset(15*SCALE_W);
        }else{
            make.top.equalTo(whatLB.mas_bottom).offset(20*SCALE_W);
        }
    }];
    
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(58*SCALE_W);
        make.right.equalTo(self.view).offset(-58*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34 - 40*SCALE_W);
        }else if (KIsiPhone5){
            make.bottom.equalTo(self.view).offset(-30*SCALE_W);
        }
        else{
            make.bottom.equalTo(self.view).offset(-40*SCALE_W);
        }
    }];
    
    [backupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(58*SCALE_W);
        make.right.equalTo(self.view).offset(-58*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
        
        if KIsiPhone5 {
            make.bottom.equalTo(startBtn.mas_top).offset(-5*SCALE_W);
        }else{
            make.bottom.equalTo(startBtn.mas_top).offset(-10*SCALE_W);
        }
    }];
    
    
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
