//
//  KeyStoreBackupVC.m
//  ONTO
//
//  Created by 赵伟 on 24/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "KeyStoreBackupVC.h"
#import "KeyStoreQRViewController.h"
#import "KeyStoreFileViewController.h"
#import "ViewController.h"
#import "ONTO-Swift.h"
@interface KeyStoreBackupVC ()

@end

@implementation KeyStoreBackupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configUI];
}

- (void)configUI{
    KeyStoreFileViewController *vc1 = [[KeyStoreFileViewController alloc] init];
    vc1.title = Localized(@"Keystorefile");
    vc1.identityDic = _identityDic;
    vc1.isWallet = _isWallet;
    
    ONTOWIFExportViewController * wifVc = [ONTOWIFExportViewController alloc];
    wifVc.defaultDic = _identityDic;
    wifVc.passwordString = _passwordString;
    wifVc.title = @"WIF";
    
    KeyStoreQRViewController *vc2 = [[KeyStoreQRViewController alloc] init];
    vc2.title = Localized(@"QRCode");
    vc2.isWallet = _isWallet;
    vc2.identityDic = _identityDic;
    vc2.name = _name;
    self.viewControllers = @[vc1,wifVc,vc2];
    [self configNav];
    
    MGPopController *pop = [[MGPopController alloc] initWithTitle:@"" message:Localized(@"Donttakescreenshots") image:[UIImage imageNamed:@"notice_light_gray"]];
    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
        
    }];
    action.titleColor =MainColor;
    
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
    
    
    
    if (_isFix) {
//        [self setSegmentControlTop];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)configNav {

    
    [self setNavTitle:_isWallet?Localized(@"ExporttKeystore1"): Localized(@"ExporttKeystore")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    
}

- (void)navLeftAction {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@A",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]]==NO&&_isWallet==NO) {
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"BackUpNotice") message:@"" image:nil];
        MGPopAction *action1 =   [MGPopAction actionWithTitle:Localized(@"Later") action:^{
            
            if (_isFirstIdentity==YES) {
                
                [ViewController gotoIdentityVC];
                
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:[NSString stringWithFormat:@"%@A",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]];
            }
            
            
        }];
        
        action1.titleColor =[UIColor colorWithHexString:@"#6A797C"];
     
        
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"%@A",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]];
            if (_isFirstIdentity==YES) {
                
                [ViewController gotoIdentityVC];
                
            }else{
    
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
           
        }];
        action.titleColor =  [UIColor redColor] ;
        
        [pop addAction:action];
           [pop addAction:action1];
        [pop show];
        pop.showCloseButton = NO;
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
