//
//  ONTODAppWebContentController.m
//  ONTO
//
//  Created by onchain on 2019/5/8.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppWebContentController.h"
#import "ONTODAppWebView.h"

@interface ONTODAppWebContentController ()<ONTODAppWebViewDelegate>
{
    NSString          *_urlStr;
}
@property(nonatomic,strong)ONTODAppWebView        *dAppWebView;
@end
@implementation ONTODAppWebContentController
#pragma mark - Init
-(instancetype)initWithContentUrlStr:(NSString*)urlStr
{
    self = [super init];
    if (self)
    {
        _urlStr = urlStr;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_initSetting];
    [self p_initUI];
    [self p_initData];
}

#pragma mark - Private
-(void)p_initSetting
{
    [self setNavTitle:Localized(@"Discovery")];
    
    [self setNavLeftImageIcon:[UIImage imageNamed:@"cotback"] Title:Localized(@"Back")];
    
}

-(void)p_initUI
{
    [self.view addSubview:self.dAppWebView];
}

-(void)p_initData
{
    [self.dAppWebView setNormalUrlstr:_urlStr];
}

//over write
-(void)navLeftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Delegate
-(void)ONTODAppWebView:(WKWebView*)webView didFinishNavigation:(WKNavigation *)navigation
{

}

-(void)ONTODAppWebView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
{

}

-(void)ONTODAppWebView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

-(void)ONTODAppWebView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

#pragma mark - Properties
-(ONTODAppWebView*)dAppWebView
{
    if (!_dAppWebView)
    {
        _dAppWebView = [[ONTODAppWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
        _dAppWebView.delegate = self;
    }
    return _dAppWebView;
}

@end
