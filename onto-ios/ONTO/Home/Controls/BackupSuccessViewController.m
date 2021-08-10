//
//  BackupSuccessViewController.m
//  ONTO
//
//  Created by 张超 on 2018/3/11.
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

#import "BackupSuccessViewController.h"
#import "BackView.h"
#import "ViewController.h"
#import "DIManageViewController.h"
#import "IdentityViewController.h"

@interface BackupSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *alertL;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *firstVerficationBtn;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end

@implementation BackupSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNav];
    [self configUI];
    
}


- (void)configNav {
    [self setNavTitle:_isWallet?Localized(@"WalletBackup"):Localized(@"DigitalBackup")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}

- (void)navLeftAction {
        [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)configUI {

    self.nextBtn.layer.cornerRadius = 1;
    self.nextBtn.layer.masksToBounds = YES;
    [self.nextBtn setTitle:Localized(@"Next") forState:UIControlStateNormal];
    
    self.firstVerficationBtn.layer.cornerRadius = 25;
    self.firstVerficationBtn.layer.masksToBounds = YES;
    [self.firstVerficationBtn setTitle:Localized(@"Verifyclaim") forState:UIControlStateNormal];
    if (self.isWallet) {
        self.firstVerficationBtn.hidden = YES;
    }
    
    self.titleL.text = _isWallet?Localized(@"WalletBackup"):Localized(@"DigitalBackup");
    self.alertL.text = Localized(@"Complete");
    
    self.welcomeLabel.text = Localized(@"welcome");
    self.subLabel.text = Localized(@"welcome_tip");
    if (_isImport==YES) {
        _firstVerficationBtn.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (IBAction)nextAction:(id)sender {
    if (self.isWallet||_isIdentity) {
        //资产账户导入成功跳转到资产根页 
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:ISFIRST_BACKUP]) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[DIManageViewController class]]) {
                    DIManageViewController *vc =(DIManageViewController *)controller;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        } else {
            //第一次备份成功后跳转
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISFIRST_BACKUP];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ViewController gotoIdentityVC];
        }
    }
}
- (IBAction)firstAction:(id)sender {
    
    IdentityViewController *vc = [[IdentityViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
