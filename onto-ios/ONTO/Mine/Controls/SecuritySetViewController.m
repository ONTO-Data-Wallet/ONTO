//
//  SecuritySetViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/6/29.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "SecuritySetViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "YZAuthID.h"
@interface SecuritySetViewController ()

@property (weak, nonatomic) IBOutlet UILabel *securityL;
@property (weak, nonatomic) IBOutlet UILabel *switchL;
@property (weak, nonatomic) IBOutlet UISwitch *myswitch;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *bottomL;
@property (nonatomic, copy) NSString *blueimageStr;
@property (nonatomic, copy) NSString *grayimageStr;

@end

@implementation SecuritySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if (LL_iPhoneX) {
        _blueimageStr = @"faceidblue";
        _grayimageStr = @"faceidgray";
        
    }else{
        _blueimageStr = @"touchidblue";
        _grayimageStr = @"touchId";
        
    }
    [self configNav];

    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            DebugLog(@"系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)");
        });
        
        return;
    }
}

- (void)configNav {
//    TouchID = "指纹ID";
//    FaceID = "面容 ID";
//    Afterverify = "验证您的％@后，\n您可以使用它快速安全地登录ONTO。";
//    TouchIDis = "%@仅适用于此设备";
    
    NSString *typeStr =  LL_iPhoneX? Localized(@"FaceID"):Localized(@"TouchID");
    [self setNavTitle:typeStr];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    self.securityL.text =  [NSString stringWithFormat:Localized(@"Afterverify"),typeStr];
    self.switchL.text = [NSString stringWithFormat:Localized(@"TouchIDLoginONTO"),typeStr];
    self.bottomL.text = [NSString stringWithFormat:Localized(@"TouchIDis"),typeStr];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:ISTOUCHIDON]==YES) {
        _myswitch.on = YES;
        self.typeImage.image = [UIImage imageNamed:_blueimageStr];
    }else{
        _myswitch.on = NO;
        self.typeImage.image = [UIImage imageNamed:_grayimageStr];
    }
}

- (IBAction)mysiwtchAction:(UISwitch *)sender {
    if (sender.on == NO) {
        self.typeImage.image = [UIImage imageNamed:_grayimageStr];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISTOUCHIDON];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        appDelegate.isNeedPrensentLogin = NO;
    }else{


        [self authVerification];
    }
}

#pragma mark - 验证TouchID/FaceID
- (void)authVerification {
    
    YZAuthID *authID = [[YZAuthID alloc] init];
    NSString *typeStr =  LL_iPhoneX? Localized(@"FaceID"):Localized(@"TouchID");

    [authID yz_showAuthIDWithDescribe:nil BlockState:^(YZAuthIDState state, NSError *error) {

        if (state == YZAuthIDStateNotSupport){
            //没有设置密码,id
            
            MGPopController *pop = [[MGPopController alloc] initWithTitle:typeStr message:Localized(@"SettingTouchID") image:nil];
            //         Please Go to “Setting>Touch ID” on your device, to active it first.
//
            MGPopAction *action1 =   [MGPopAction actionWithTitle:Localized(@"Cancel") action:^{
                
            }];
            
            action1.titleColor =[UIColor colorWithHexString:@"#6A797C"];
            
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

            }];
            
            action.titleColor =  [UIColor redColor];
            
            [pop addAction:action1];
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            
            self.typeImage.image = [UIImage imageNamed:_grayimageStr];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISTOUCHIDON];
            self.myswitch.on = NO;
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            appDelegate.isNeedPrensentLogin = NO;
        }else if (state == YZAuthIDStateSuccess) {
            // TouchID/FaceID验证成功
            DebugLog(@"认证成功！");
                    self.typeImage.image = [UIImage imageNamed:_blueimageStr];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISTOUCHIDON];
                self.myswitch.on = YES;
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
           appDelegate.isNeedPrensentLogin = YES;
            
    }else{
          self.typeImage.image = [UIImage imageNamed:_grayimageStr];
          [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISTOUCHIDON];
          self.myswitch.on = NO;
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        appDelegate.isNeedPrensentLogin = NO;
      }
        
    }];
}

- (void)navLeftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)biologicalRecognitionResult:(void (^)(BOOL success, NSError *error))result{
    
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
        LAContext *context = [[LAContext alloc] init];
        /**
         需要先判断是否支持识别
         *LAPolicyDeviceOwnerAuthentication 手机密码的验证方式
         *LAPolicyDeviceOwnerAuthenticationWithBiometrics 指纹的验证方式，使用这种方式需要设置 context.localizedFallbackTitle = @""; 否则在验证失败时会出现点击无响应的“输入密码”按钮
         */
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            /**
             需要先判断是否支持指纹或者Face ID识别后，才能判断是什么类型的识别方式
             */
            NSString *localizedReason = @"指纹登录";
            
            if (@available(iOS 11.0, *)) {
                if (context.biometryType == LABiometryTypeTouchID) {
                    
                }else if (context.biometryType == LABiometryTypeFaceID){
                    localizedReason = @"Face ID登录";
                }
            }
            
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReason reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    DebugLog(@"--------识别成功");
                }else{
                    if (error.code != 2) {
                        
                    }
                }
            }];
        }
    }else {
        DebugLog(@"你的设备不支持指纹识别");
    }

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
