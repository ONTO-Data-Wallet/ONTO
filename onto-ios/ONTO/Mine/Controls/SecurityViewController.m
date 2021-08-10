//
//  SecurityViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/6/29.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "SecurityViewController.h"
#import "YZAuthID.h"
#import "ViewController.h"
#import "DIManageViewController.h"
#import "WalletManageViewController.h"
@interface SecurityViewController ()

@property (weak, nonatomic) IBOutlet UIButton *ontIdUnlockB;
@property (weak, nonatomic) IBOutlet UIButton *walletUnlockB;
@property (nonatomic, copy) NSString *blueimageStr;
@property (weak, nonatomic) IBOutlet UIButton *touchBtn;

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self authVerification];
    if (LL_iPhoneX) {
        _blueimageStr = @"faceidblue";
    }else{
        _blueimageStr = @"touchidblue";
    }
    
    [self.ontIdUnlockB setTitle:Localized(@"ONTIDUnLock") forState:UIControlStateNormal];
    [self.walletUnlockB setTitle:Localized(@"WalletUnLock") forState:UIControlStateNormal];
    [self.touchBtn setImage:[UIImage imageNamed:_blueimageStr] forState:UIControlStateNormal];
}

- (IBAction)touchIdClick:(id)sender{
    [self authVerification];
}

- (IBAction)ontIDUnlockClick:(id)sender {
    
    DIManageViewController *vc = [[DIManageViewController alloc] init];
    vc.isOntIdLogin = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)walletIDUnlockClick:(id)sender {
    
    DIManageViewController *vc = [[DIManageViewController alloc] init];
    vc.isWalletLogin = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)authVerification {
    
    YZAuthID *authID = [[YZAuthID alloc] init];
    
    [authID yz_showAuthIDWithDescribe:nil BlockState:^(YZAuthIDState state, NSError *error) {
        
        if (state == YZAuthIDStateNotSupport) { // 不支持TouchID/FaceID
            DebugLog(@"对不起，当前设备不支持指纹/面部ID");
            [self verifySuccess];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISTOUCHIDON];

        } else if(state == YZAuthIDStateFail) { // 认证失败
            DebugLog(@"指纹/面部ID不正确，认证失败");

        } else if(state == YZAuthIDStateTouchIDLockout) {   // 多次错误，已被锁定
            DebugLog(@"多次错误，指纹/面部ID已被锁定，请到手机解锁界面输入密码");
        } else if (state == YZAuthIDStateSuccess) { // TouchID/FaceID验证成功
            DebugLog(@"认证成功！");
            
            [self verifySuccess];
        }
        
    }];
}

- (void)verifySuccess{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.isNeedPrensentLogin = YES;
    
    if (_isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
   
    }else{
       
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:IDENTITY_EXISIT]) {
            [ViewController gotoIdentityVC];
//        }
//
//        else {
//            [ViewController gotoHomeVC];
//        }
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
