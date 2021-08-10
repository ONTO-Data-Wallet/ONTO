//
//  ONTODAppHomeController.m
//  ONTO
//
//  Created by onchain on 2019/5/20.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHomeController.h"
#import "ONTODAppHomeView.h"
#import "ONTODAppHomeRootModel.h"
#import "CCRequest.h"
#import "ONTODAppController.h"//H5落地页
#import "ONTODAppBrowserController.h"//浏览器搜索
#import "ONTODAppHomeAlertView.h"//免责声明

@interface ONTODAppHomeController ()<ONTODAppHomeViewDelegate,ONTODAppHomeAlertViewDelegate>
{
    NSString              *_urlStr;
}
@property(nonatomic,strong)ONTODAppHomeView       *homeView;
@end
@implementation ONTODAppHomeController
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_initSetting];
    [self p_initUI];
    [self p_requestData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;

}

#pragma mark - Private Method
-(void)p_initSetting
{
    [self p_settingNavShow];
}

-(void)p_initUI
{
    [self.view addSubview:self.homeView];
}

-(void)p_settingNavShow
{
    [self setNavTitle:Localized(@"Discovery")];

    //Right
    [self p_creatRightItem];
 
}

-(void)p_creatRightItem
{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton addTarget:self action:@selector(p_searchButtonSlot:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:[UIImage imageNamed:@"DApp_Search"] forState:UIControlStateNormal];
    [searchButton sizeToFit];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    self.navigationItem.rightBarButtonItems  = @[searchItem];
}

-(NSString*)p_getLanguageSetting
{
    NSString *urlStr = @"https://service.aappstore.net/api/zh-CN/ont-index";
    if ([[Common getUserLanguage]isEqualToString:@"en"])
    {
        urlStr = @"https://service.aappstore.net/api/en/ont-index";
    }
    return urlStr;
}

-(void)p_requestData
{
    MBProgressHUD *hub=[ToastUtil showMessage:@"" toView:nil];
//    NSString *urlStr = @"https://service.aappstore.net/api/en/ont-index";
    NSString *urlStr = [self p_getLanguageSetting];
    [[CCRequest shareInstance] requestWithURLString1:urlStr MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal) {
        [hub hideAnimated:YES];
        [self.homeView stopRefreshWithisMore:YES];
        //success
        NSString *msgStr = responseOriginal[@"msg"];
        if ([msgStr isEqualToString:@"success"])
        {
            ONTODAppHomeRootModel *rootModel = [ONTODAppHomeRootModel organizeData:responseOriginal[@"data"]];
            [self.homeView refreshTableViewWithModel:rootModel];
        }
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        [hub hideAnimated:YES];
        [self.homeView stopRefreshWithisMore:YES];
    }];
}

#pragma mark - Slots
-(void)p_searchButtonSlot:(UIButton*)button
{
    [self.navigationController pushViewController:[[ONTODAppBrowserController alloc] init] animated:YES];
}

#pragma mark - View Delegate
- (void)tableViewRefreshWithDirectionType:(AONTODAppHomeViewDirectionType)type AndView:(ONTODAppHomeView*)view
{
    if (type==ONTODAppHomeView_pullDown)
    {
        //Request
        [self p_requestData];
    }
}

- (void)enterWebviewWithUrl:(NSString*)urlStr
{
    _urlStr = urlStr;
    
    [ONTODAppHomeAlertView CreatWalletTipsAlertViewWithDelegate:self];
}

-(void)alertViewAcceptedBtnSlot:(ONTODAppHomeAlertView*)alertView
{
    [self.navigationController pushViewController:[[ONTODAppController alloc] initWithUrlStr:_urlStr] animated:YES];
}

#pragma mark - Properties
-(ONTODAppHomeView*)homeView
{
    if (!_homeView)
    {
        _homeView = [[ONTODAppHomeView alloc] initWithFrame:CGRectMake(0, LL_StatusBarAndNavigationBarHeight, self.view.width, self.view.height-LL_StatusBarAndNavigationBarHeight-LL_TabbarHeight)];
        _homeView.delegate = self;
    }
    return _homeView;
}



@end
