 //
//  ViewController.m
//  ONTO
//
//  Created by Zeus.Zhang on 2018/1/31.
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

#import "ViewController.h"
#import "IdentityViewController.h"
#import "MineViewController.h"
#import "HomeViewController.h"
#import "CapitalViewController.h"
#import "ImportSuccessViewController.h"
#import "BackupViewController.h"
#import "IDViewController.h"
//#import <MiniVisionAuthorization/MiniVisionAuthorization.h>
#import "LaunchIntroductionView.h"
#import "SecurityViewController.h"
#import "ONTODAppController.h"
#import "ONTODAppHomeController.h"
#import "ONTO-Swift.h"

@interface ViewController ()
@property(nonatomic, strong) MGPopController *netnoticepop;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * bgImage = [[UIImageView alloc]init];
    bgImage.image = [UIImage imageNamed:@"LaunchImage"];
    [self.view addSubview:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self getConfig];
    // Do any additional setup after loading the view, typically from a nib.
}

+ (void)gotoGuideVC {
}

- (void)getConfig
{
    
    MBProgressHUD *hub=[ToastUtil showMessage:@"" toView:nil];
    NSString *urlStr = Ongamount_query;
    [[CCRequest shareInstance]
     requestWithURLStringNoLoading:urlStr MethodType:MethodTypeGET Params:nil Success:^(id responseObject,
                                                                                        id responseOriginal) {
//         [MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
         
         [hub hideAnimated:YES];
         
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

             [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%lf",
                                                              [[responseObject valueForKey:@"Fee"]
                                                               doubleValue]
                                                              / 1000000000] forKey:FEE];
             [[NSUserDefaults standardUserDefaults]
              setValue:[NSString stringWithFormat:@"%@", [responseObject valueForKey:@"LoginTimeout"]] forKey:LOGOUTTIME];
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"TestnetAddr"] forKey:TESTNETADDR];
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"OntPassAddr"] forKey:ONTPASSADDRSS];
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"NetName"] forKey:NETNAME];
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"PumpkinCodeHash"] forKey:PUMPKINHASH];
             
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"DragonCodeHash"] forKey:DRAGONCODEHASH];
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"GetDragonListUrl"] forKey:DRAGONLISTURL];
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"PreActionNetAddr"] forKey:PRENODE];
             
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"TokenList"]  forKey:TOKENLIST];
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"DefaultTokenList"]  forKey:DEFAULTTOKENLIST];
             
             [[NSUserDefaults standardUserDefaults]
              setValue:[[responseObject valueForKey:@"PumpkinContract"] valueForKey:@"gas_price"] forKey:PUMPKINGASPRICE];
             [[NSUserDefaults standardUserDefaults]
              setValue:[[responseObject valueForKey:@"PumpkinContract"] valueForKey:@"gas_limit"] forKey:PUMPKINGASLIMIT];
             
             [[NSUserDefaults standardUserDefaults]
              setValue:[[responseObject valueForKey:@"Shuftipro"] valueForKey:@"amount"] forKey:SHIFTIAMOUT];
             [[NSUserDefaults standardUserDefaults]
              setValue:[[responseObject valueForKey:@"Shuftipro"] valueForKey:@"assetName"] forKey:SHIFTIASSETNAME];
             [[NSUserDefaults standardUserDefaults]
              setValue:[[responseObject valueForKey:@"Shuftipro"] valueForKey:@"toAddress"] forKey:SHUFTIADDRESS];
             [[NSUserDefaults standardUserDefaults]
              setBool:[[responseObject valueForKey:@"Shuftipro"] valueForKey:@"pay"] ? YES : NO forKey:SHUFTINEEDPAY];
             
             [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"mobile"];
             [[NSUserDefaults standardUserDefaults]
              setValue:[[responseObject valueForKey:@"OntIdContract"] valueForKey:@"gas_price"] forKey:ONTIDGASPRICE];
             [[NSUserDefaults standardUserDefaults]
              setValue:[[responseObject valueForKey:@"OntIdContract"] valueForKey:@"gas_limit"] forKey:ONTIDGASLIMIT];
             [[NSUserDefaults standardUserDefaults]
              setValue:[[responseObject valueForKey:@"OntIdContract"] valueForKey:@"gas_price"] forKey:ASSETGASPRICE];
             [[NSUserDefaults standardUserDefaults]
              setValue:[[responseObject valueForKey:@"OntIdContract"] valueForKey:@"gas_limit"] forKey:ASSETGASLIMIT];
             
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"GasPriceMax"] forKey:GASPRICEMAX];
             
             [[NSUserDefaults standardUserDefaults]
              setBool:[responseObject valueForKey:@"IsClaimOngSelfPay"] ? YES : NO forKey:ISONGSELFPAY];
             
             [[NSUserDefaults standardUserDefaults]
              setValue:[responseObject valueForKey:@"MinClaimableOng"] forKey:MINCLAIMABLEONG];
             [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"MinUnboundOng"] forKey:MINUNBOUNDONG];
             
             
         });

         [_netnoticepop dismiss];
         
         [self ConfigtouchID];
     }Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
//         [MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
         
         [hub hideAnimated:YES];
         
         [_netnoticepop dismiss];
         
         NSString * title;
         NSString * btnTitle;
         if ([ENORCN isEqualToString:@"cn"]) {
             title = @"    网络不给力,请检查网络设置";
             btnTitle = @"重试";
         }else{
             title = @"    Network error, please check your network.";
             btnTitle = @"Try Again";
         }
         __weak __typeof(self)weakSelf = self;
         _netnoticepop = [[MGPopController alloc] initWithTitle:@"" message:title image:nil];
         MGPopAction *action = [MGPopAction actionWithTitle:btnTitle action:^{
             [weakSelf getConfig];
         }];
         action.titleColor = MainColor;
         [_netnoticepop addAction:action];
         [_netnoticepop show];
         _netnoticepop.showCloseButton = NO;
     }];
}


- (void)ConfigtouchID
{
    [Common initUserLanguage];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:ISTOUCHIDON] == YES) {
        
        APP_DELEGATE.isNeedPrensentLogin = YES;
        UINavigationController
        *nav = [[UINavigationController alloc] initWithRootViewController:[[SecurityViewController alloc] init]];
        
        APP_DELEGATE.window.rootViewController = nav;
        
    } else {
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:IDENTITY_EXISIT]) {
            [ViewController gotoIdentityVC];
//        } else {
//            [ViewController gotoHomeVC];
//        }
    }
    
    //默认的身份勾选
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:SELECTINDEX];
    if ([Common isBlankString:str]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:SELECTINDEX];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"USD" forKey:UNIT];
//    [Common initUserLanguage];
    
    //引导页
    [LaunchIntroductionView  sharedWithImages:@[@"welcome_bg1.png",
                                                @"welcome_bg1.png"]
                                        First:@[Localized(@"welcome_1_title"),Localized(@"welcome_2_title")]
                                       Second:@[Localized(@"welcome_1_content"),Localized(@"welcome_2_content")]];
    
}

+ (void)gotoHomeVC {
    
    HomeViewController *vc = [[HomeViewController alloc] init];

    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    APP_DELEGATE.window.rootViewController = nav;
    
}

+ (void)gotoIdentityVC
{
    //首页
    IDViewController *identityVC = [[IDViewController alloc] init];
    BaseNavigationViewController* identityNav = [[BaseNavigationViewController alloc] initWithRootViewController:identityVC];
    
    //钱包
    CapitalViewController *capitalVC = [[CapitalViewController alloc] init];
    BaseNavigationViewController *capitalNav = [[BaseNavigationViewController alloc] initWithRootViewController:capitalVC];
    
    //DApp游戏
    ONTODAppHomeController *dappVC = [[ONTODAppHomeController alloc] init];
    BaseNavigationViewController *dappNav = [[BaseNavigationViewController alloc] initWithRootViewController:dappVC];
    
    //个人中心
    MineViewController *mineVC = [[MineViewController alloc] init];
    BaseNavigationViewController *mineNav = [[BaseNavigationViewController alloc] initWithRootViewController:mineVC];
    
    UITabBarController *controlTab = [[UITabBarController alloc] init];
//    controlTab.viewControllers = [NSArray arrayWithObjects:identityNav,capitalNav,dappNav,mineNav,nil];
    controlTab.viewControllers = [NSArray arrayWithObjects:capitalNav,identityNav,dappNav,mineNav,nil];
    
    [BaseViewController setTabbarItemWithItemTitle:TABONETITLE ItemTitleColor:TABONECOLOR ItemTitleColorSelected:TABONECOLORSELECTED ItemTitleFont:TabTitleFont ItemImage:TABTWOIMAGE ItemImageSelected:TABTWOIMAGESELECTED AtIndex:0 SourceTabbar:controlTab];
    
    [BaseViewController setTabbarItemWithItemTitle:TABTWOTITLE ItemTitleColor:TABTWOCOLOR ItemTitleColorSelected:TABTWOCOLORSELECTED ItemTitleFont:TabTitleFont ItemImage:TABONEIMAGE ItemImageSelected:TABONEIMAGESELECTED AtIndex:1 SourceTabbar:controlTab];
    
//    [BaseViewController setTabbarItemWithItemTitle:TABTHREETITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTHREECOLORSELECTED ItemTitleFont:K12FONT ItemImage:DAPPUNSELECTEDIMAGE ItemImageSelected:DAPPSELECTEDIMAGE AtIndex:2 SourceTabbar:controlTab];
    
    [BaseViewController setTabbarItemWithItemTitle:TABTHREETITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTHREECOLORSELECTED ItemTitleFont:TabTitleFont ItemImage:DAPPUNSELECTEDIMAGE ItemImageSelected:DAPPSELECTEDIMAGE AtIndex:2 SourceTabbar:controlTab];
    
    [BaseViewController setTabbarItemWithItemTitle:TABFOURTITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTHREECOLORSELECTED ItemTitleFont:TabTitleFont ItemImage:TABTHREEIMAGE ItemImageSelected:TABTHREEIMAGESELECTED AtIndex:3 SourceTabbar:controlTab];
    
//    controlTab.selectedIndex = 1;//创建ONT ID 停留在ONT ID界面
    
    APP_DELEGATE.window.rootViewController = controlTab;
    
    
}

+ (void)selectIdentityVC
{
    //首页
    IDViewController *identityVC = [[IDViewController alloc] init];
    BaseNavigationViewController* identityNav = [[BaseNavigationViewController alloc] initWithRootViewController:identityVC];
    
    //钱包
    CapitalViewController *capitalVC = [[CapitalViewController alloc] init];
    BaseNavigationViewController *capitalNav = [[BaseNavigationViewController alloc] initWithRootViewController:capitalVC];
    
    //DApp游戏
    ONTODAppHomeController *dappVC = [[ONTODAppHomeController alloc] init];
    BaseNavigationViewController *dappNav = [[BaseNavigationViewController alloc] initWithRootViewController:dappVC];
    
    //个人中心
    MineViewController *mineVC = [[MineViewController alloc] init];
    BaseNavigationViewController *mineNav = [[BaseNavigationViewController alloc] initWithRootViewController:mineVC];
    
    UITabBarController *controlTab = [[UITabBarController alloc] init];
    //    controlTab.viewControllers = [NSArray arrayWithObjects:identityNav,capitalNav,dappNav,mineNav,nil];
    controlTab.viewControllers = [NSArray arrayWithObjects:capitalNav,identityNav,dappNav,mineNav,nil];
    
    [BaseViewController setTabbarItemWithItemTitle:TABONETITLE ItemTitleColor:TABONECOLOR ItemTitleColorSelected:TABONECOLORSELECTED ItemTitleFont:TabTitleFont ItemImage:TABTWOIMAGE ItemImageSelected:TABTWOIMAGESELECTED AtIndex:0 SourceTabbar:controlTab];
    
    [BaseViewController setTabbarItemWithItemTitle:TABTWOTITLE ItemTitleColor:TABTWOCOLOR ItemTitleColorSelected:TABTWOCOLORSELECTED ItemTitleFont:TabTitleFont ItemImage:TABONEIMAGE ItemImageSelected:TABONEIMAGESELECTED AtIndex:1 SourceTabbar:controlTab];
    
    //    [BaseViewController setTabbarItemWithItemTitle:TABTHREETITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTHREECOLORSELECTED ItemTitleFont:K12FONT ItemImage:DAPPUNSELECTEDIMAGE ItemImageSelected:DAPPSELECTEDIMAGE AtIndex:2 SourceTabbar:controlTab];
    
    [BaseViewController setTabbarItemWithItemTitle:TABTHREETITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTHREECOLORSELECTED ItemTitleFont:TabTitleFont ItemImage:DAPPUNSELECTEDIMAGE ItemImageSelected:DAPPSELECTEDIMAGE AtIndex:2 SourceTabbar:controlTab];
    
    [BaseViewController setTabbarItemWithItemTitle:TABFOURTITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTHREECOLORSELECTED ItemTitleFont:TabTitleFont ItemImage:TABTHREEIMAGE ItemImageSelected:TABTHREEIMAGESELECTED AtIndex:3 SourceTabbar:controlTab];
    
    controlTab.selectedIndex = 1;//创建ONT ID 停留在ONT ID界面
    
    APP_DELEGATE.window.rootViewController = controlTab;
    
    
}

+ (void)gotoCapitalVC
{
    //首页
    IDViewController *identityVC = [[IDViewController alloc] init];
    BaseNavigationViewController* identityNav = [[BaseNavigationViewController alloc] initWithRootViewController:identityVC];
    
    //钱包
    CapitalViewController *capitalVC = [[CapitalViewController alloc] init];
    BaseNavigationViewController *capitalNav = [[BaseNavigationViewController alloc] initWithRootViewController:capitalVC];
    
    //DApp游戏
    ONTODAppHomeController *dappVC = [[ONTODAppHomeController alloc] init];
    BaseNavigationViewController *dappNav = [[BaseNavigationViewController alloc] initWithRootViewController:dappVC];
    
    //个人中心
    MineViewController *mineVC = [[MineViewController alloc] init];
    BaseNavigationViewController *mineNav = [[BaseNavigationViewController alloc] initWithRootViewController:mineVC];
    
    UITabBarController *controlTab = [[UITabBarController alloc] init];
//    controlTab.viewControllers = [NSArray arrayWithObjects:identityNav,capitalNav,dappNav,mineNav,nil];
    controlTab.viewControllers = [NSArray arrayWithObjects:capitalNav,identityNav,dappNav,mineNav,nil];
    
    [BaseViewController setTabbarItemWithItemTitle:TABONETITLE ItemTitleColor:TABONECOLOR ItemTitleColorSelected:TABONECOLORSELECTED ItemTitleFont:K12FONT ItemImage:TABONEIMAGE ItemImageSelected:TABONEIMAGESELECTED AtIndex:0 SourceTabbar:controlTab];
    
    [BaseViewController setTabbarItemWithItemTitle:TABTWOTITLE ItemTitleColor:TABTWOCOLOR ItemTitleColorSelected:TABTWOCOLORSELECTED ItemTitleFont:K12FONT ItemImage:TABTWOIMAGE ItemImageSelected:TABTWOIMAGESELECTED AtIndex:1 SourceTabbar:controlTab];
    
    [BaseViewController setTabbarItemWithItemTitle:TABTHREETITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTWOCOLORSELECTED ItemTitleFont:K12FONT ItemImage:DAPPUNSELECTEDIMAGE ItemImageSelected:DAPPSELECTEDIMAGE AtIndex:2 SourceTabbar:controlTab];
    
    [BaseViewController setTabbarItemWithItemTitle:TABFOURTITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTHREECOLORSELECTED ItemTitleFont:K12FONT ItemImage:TABTHREEIMAGE ItemImageSelected:TABTHREEIMAGESELECTED AtIndex:3 SourceTabbar:controlTab];
    APP_DELEGATE.window.rootViewController = controlTab;
    
    controlTab.selectedIndex = 0;
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    
}

+ (void)gotoBackupVC {
    BackupViewController *vc = [[BackupViewController alloc] initWithNibName:@"BackupViewController" bundle:nil];
    vc.isHideLeft = YES;
    BaseNavigationViewController *backNav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    APP_DELEGATE.window.rootViewController = backNav;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
