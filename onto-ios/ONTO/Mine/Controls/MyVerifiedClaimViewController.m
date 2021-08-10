//
//  MyVerifiedClaimViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/10.
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

#import "MyVerifiedClaimViewController.h"
#import "PendingViewController.h"
#import "IdentityViewController.h"

@interface MyVerifiedClaimViewController ()

@end

@implementation MyVerifiedClaimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNav];
//
    PendingViewController *vc1 = [[PendingViewController alloc] init];
//    vc1.verfiedClaimType = PendingType;
    vc1.title = Localized(@"PendingVerifiel");
    
    PendingViewController *vc2 = [[PendingViewController alloc] init];
    vc2.title = Localized(@"HistoryVerifiel");
    vc2.verfiedClaimType = HistroryType;
    self.viewControllers = @[vc1, vc2];
    __weak typeof(self) weakself = self;
    
    //如果是在ME页面点击进入
    if (_isMine) {
        [self selectNext];
    }
    
    vc1.returnValueBlock = ^(void){
        
        [weakself selectNext];
        
    };
    
    
    vc2.returnValueBlock = ^(void){
        
//       [self selectPrevious];
        IdentityViewController *IDVC = [[IdentityViewController alloc]init];
        [self.navigationController pushViewController:IDVC animated:YES];
        
    };
    
   
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)configNav {
    [self setNavTitle:Localized(@"Myverifledclaim")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
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
