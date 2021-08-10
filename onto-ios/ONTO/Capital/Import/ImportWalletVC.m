//
//  ImportWalletVC.m
//  ONTO
//
//  Created by 赵伟 on 24/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "ImportWalletVC.h"
#import "MnemonicImportVC.h"
#import "KeystoreImportVC.h"
#import "ImportViewController.h"

@interface ImportWalletVC ()

@property (nonatomic,strong)KeystoreImportVC *vc2;

@end

@implementation ImportWalletVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    MnemonicImportVC *vc1 = [[MnemonicImportVC alloc] init];
    vc1.walletType = 1;
    vc1.title = Localized(@"Mnenomic");
    self.vc2 = [[KeystoreImportVC alloc] init];
    self.vc2.isIdentity = NO;
    self.vc2.title = Localized(@"Keystore");
    
//    MnemonicImportVC *vc3 = [[MnemonicImportVC alloc] init];
//    vc3.walletType = 2;
//    vc3.title = Localized(@"PrivateKey");
    
    MnemonicImportVC *vc4 = [[MnemonicImportVC alloc] init];
     vc4.walletType = 3;
    vc4.title = @"WIF";
    
    self.viewControllers = @[vc1,self.vc2,vc4];
    self.segmentBorderColor = [UIColor colorWithHexString:@"#2B4045"];
    self.segmentTitleColor = [UIColor colorWithHexString:@"#0AA5C9"];


}

- (void)configNav {
    
    [self setNavTitle:Localized(@"ImportWallet")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    [self setNavRightImageIcon:[UIImage imageNamed:@"Asset_scan"] Title:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //DApp导入钱包适配错误-bug
    self.navigationController.navigationBar.translucent = NO;


}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //DApp导入钱包适配错误-bug
    self.navigationController.navigationBar.translucent = YES;
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightAction {
                NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"CameraRights") message:@"" preferredStyle: UIAlertControllerStyleAlert];
    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
                    }]];
                    //弹出提示框；
                    [self presentViewController:alert animated:true completion:nil];
    
                    return;
                }
                ImportViewController *vc = [[ImportViewController alloc] init];
                //        vc.isVerb = YES;
                vc.isImportWallet = YES;
    vc.isKeyStore = YES;
       [vc setCallback:^(NSString *stringValue) {
        self.vc2.mytextView.text = stringValue;
           [self selectNext];
       }];
    
                [self.navigationController pushViewController:vc animated:YES];
   
}

@end
