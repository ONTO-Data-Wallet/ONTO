//
//  ImportSuccessViewController.m
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

#import "ImportSuccessViewController.h"
#import "ViewController.h"
#import "ImportViewController.h"
#import "DIManageViewController.h"
#import "HomeViewController.h"
#import "IDViewController.h"
@interface ImportSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *managerBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *alertL;
@property (weak, nonatomic) IBOutlet UILabel *noteL;
@property (weak, nonatomic) IBOutlet UIImageView *noteIV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;


@end

@implementation ImportSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
    [self configNav];
}

- (void)configNav {
    [self setNavTitle:self.isWallect ? Localized(@"ImportDigitalWallet") : Localized(@"ImportDigitalIdentity")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"")];
}

- (void)navLeftAction {
    //    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)configUI {
    
    [self.managerBtn setTitle:self.isWallect ? Localized(@"ManagerWallet") : Localized(@"ManagerIdentity") forState:UIControlStateNormal];
    self.contentL.text = self.isWallect ? Localized(@"ImportSuccessWallet") : Localized(@"ImportSuccessContent");
    self.alertL.text = self.isWallect ? Localized(@"ImportSuccessWalletAlert") : Localized(@"ImportSuccessAlert");
    self.noteL.text = Localized(@"Note");
    if (_isFailure) {

        self.imageV.image = [UIImage imageNamed:@"createFail"];
        [self.managerBtn setTitle:Localized(@"ImportAgain") forState:UIControlStateNormal];
        self.alertL.text = Localized(@"CreateFailed");
        self.alertL.textColor = [UIColor colorWithHexString:@"#6A797C"];

    }else{
        
        self.alertL.text = Localized(@"Done");
        self.alertL.textColor = [UIColor colorWithHexString:@"#6A797C"];
        self.imageV.image = [UIImage imageNamed:@"createSucess"];
        [self.managerBtn setTitle:Localized(@"Next") forState:UIControlStateNormal];
        
    }
}

- (IBAction)managerAction:(id)sender {
    if (self.isFailure) {
        
        [self.navigationController popViewControllerAnimated:YES];

    } else {
        
        
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[DIManageViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
            else if ([controller isKindOfClass:[IDViewController class]])
            {
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISFIRST_BACKUP];
               [[NSUserDefaults standardUserDefaults] synchronize];
               [ViewController gotoIdentityVC];
            }
            else
            {
                //发送刷新钱包界面的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh_Home" object:nil];
               [self.navigationController popToRootViewControllerAnimated:YES];
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
