//
//  ONTODAppBrowserController.m
//  ONTO
//
//  Created by onchain on 2019/5/9.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppBrowserController.h"
#import "ONTODAppBrowserView.h"
//#import "ONTODAppWebContentController.h"
#import "ONTODAppController.h"

@interface ONTODAppBrowserController ()<ONTODAppBrowserViewDelegate>
{
    
}
@property(nonatomic,strong)ONTODAppBrowserView         *browserSearchView;
@end
@implementation ONTODAppBrowserController
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_initSetting];
    [self p_initUI];
}

#pragma mark - Private
-(void)p_initSetting
{
    [self setNavTitle:Localized(@"DappBrowser")];
    
    [self setNavLeftImageIcon:[UIImage imageNamed:@"cotback"] Title:Localized(@"Back")];
}

-(void)p_initUI
{
    [self.view addSubview:self.browserSearchView];
}

//over write
-(void)navLeftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Delegate
-(void)ONTODAppBrowserEnterWebWithUrlStr:(NSString*)urlStr
{
//    [self.navigationController pushViewController:[[ONTODAppWebContentController alloc] initWithContentUrlStr:urlStr] animated:YES];
    
    [self.navigationController pushViewController:[[ONTODAppController alloc] initWithUrlStr:urlStr] animated:YES];
    
}

#pragma mark - Properties
-(ONTODAppBrowserView*)browserSearchView
{
    if (!_browserSearchView)
    {
        _browserSearchView = [[ONTODAppBrowserView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
        _browserSearchView.delegate = self;
    }
    return _browserSearchView;
}

@end
