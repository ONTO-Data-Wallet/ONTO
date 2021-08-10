//
//  ONTODAppWebView.m
//  ONTO
//
//  Created by onchain on 2019/5/8.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppWebView.h"
#import <WebKit/WebKit.h>
#import <YYKit.h>
#import "UIView+ONTODAppViewFunction.h"

@interface ONTODAppWebView ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
{
    NSString          *_reloadstr;
}
@property(nonatomic,strong)WKWebView               *pWebView;
@property(nonatomic,strong)WKWebViewConfiguration  *webConfig;
@property(nonatomic,strong)NSURL                   *nomalUrl;
@property(nonatomic,strong)UIProgressView          *progressView;
@end
@implementation ONTODAppWebView
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self p_initSetting];
        [self p_initUI];
    }
    return self;
}

#pragma mark - Private
-(void)p_initSetting
{

}

-(void)p_initUI
{
    [self addSubview:self.pWebView];
    [self addSubview:self.progressView];
}

- (void)p_setupPostMessageScript
{
    NSString *source = @"window.originalPostMessage = window.postMessage;"
    "window.postMessage = function(message, targetOrigin, transfer) {"
    "window.webkit.messageHandlers.JSCallback.postMessage(message);"
    "if (typeof targetOrigin !== 'undefined') {"
    "window.originalPostMessage(message, targetOrigin, transfer);"
    "}"
    "};";
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:false];
    [self.pWebView.configuration.userContentController addUserScript:script];
    [self.pWebView evaluateJavaScript:source completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        
        
    }];
}

- (void)p_postMessage:(NSString *)message
{
    NSDictionary *eventInitDict = @{
                                    @"data": message,
                                    };
    NSString *source = [NSString
                        stringWithFormat:@"document.dispatchEvent(new MessageEvent('message', %@));",
                        [self dictionaryToJson:eventInitDict]
                        ];
    
    [self.pWebView evaluateJavaScript:source completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

//Handle Message
- (void)p_handleMessage:(NSString *)prompt
{
    if (![prompt containsString:@"params="]) return;
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    
    NSString *base64decodeString = [self stringEncodeBase64:resultStr];
    NSDictionary *resultDic = [self dictionaryWithJsonString:[base64decodeString stringByRemovingPercentEncoding]];
    if (resultDic[@"action"])
    {
        if ([resultDic[@"action"] isEqualToString:@"login"])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppWebView:messageOfLoginWithDict:)])
            {
                [self.delegate ONTODAppWebView:self.pWebView messageOfLoginWithDict:resultDic];
            }
        }
        else if ([resultDic[@"action"] isEqualToString:@"invoke"])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppWebView:messageOfInvokeWithDict:)])
            {
                [self.delegate ONTODAppWebView:self.pWebView messageOfInvokeWithDict:resultDic];
            }
        }
        else if ([resultDic[@"action"] isEqualToString:@"getAccount"])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppWebView:messageOfGetAccountWithDict:)])
            {
                [self.delegate ONTODAppWebView:self.pWebView messageOfGetAccountWithDict:resultDic];
            }
        }
        else if ([resultDic[@"action"] isEqualToString:@"invokeRead"])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppWebView:messageOfInvokeReadWithDict:)])
            {
                [self.delegate ONTODAppWebView:self.pWebView messageOfInvokeReadWithDict:resultDic];
            }
        }
        else if ([resultDic[@"action"] isEqualToString:@"invokePasswordFree"])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppWebView:messageOfInvokePasswordFreeWithDict:)])
            {
                [self.delegate ONTODAppWebView:self.pWebView messageOfInvokePasswordFreeWithDict:resultDic];
            }
        }
        
    }
}

#pragma mark - Public
-(void)setNormalUrlstr:(NSString*)urlStr
{
    assert(urlStr);
    
    self.nomalUrl = [NSURL URLWithString:urlStr];
    
    [self.pWebView loadRequest:[NSURLRequest requestWithURL:self.nomalUrl]];
    
}

-(void)webViewGoBack
{
    [self.pWebView goBack];
}

-(BOOL)isCanGoBack
{
    return [self.pWebView canGoBack];
}

-(void)sendMessageToWeb:(NSDictionary *)dic
{
    NSString * jsonString = [self dictionaryToJson:dic];
    NSString *encodedURL = [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *base64String = [self base64EncodeString:encodedURL];
    NSString *jsStr = [NSString stringWithFormat:@"%@",base64String ];
    [self p_postMessage:jsStr];
}

-(void)reloadWebView
{
    [self.pWebView reload];
}

#pragma mark - Delegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (!_reloadstr)
    {
        _reloadstr= @"_reloadstr";
        [self p_setupPostMessageScript];
    }
    
    self.progressView.hidden = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppWebView:didFinishNavigation:)])
    {
        [self.delegate ONTODAppWebView:webView didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppWebView:decidePolicyForNavigationAction:)])
    {
        [self.delegate ONTODAppWebView:webView decidePolicyForNavigationAction:navigationAction];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.progressView.hidden = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppWebView:didStartProvisionalNavigation:)])
    {
        [self.delegate ONTODAppWebView:webView didStartProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    self.progressView.hidden = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ONTODAppWebView:didFailNavigation:withError:)])
    {
        [self.delegate ONTODAppWebView:webView didFailNavigation:navigation withError:error];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"JSCallback"])
    {
        if ([message.body isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        [self p_handleMessage:message.body];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - Observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress = self.pWebView.estimatedProgress;
        if (self.progressView.progress == 1)
        {
            [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:nil];
        }
    }
}

#pragma mark - Properties
-(WKWebViewConfiguration*)webConfig
{
    if (!_webConfig)
    {
        _webConfig = [[WKWebViewConfiguration alloc] init];
        _webConfig.preferences = [[WKPreferences alloc]init];
        _webConfig.preferences.minimumFontSize = 10;
        _webConfig.preferences.javaScriptEnabled = YES;
        _webConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _webConfig.userContentController = [[WKUserContentController alloc]init];
        _webConfig.processPool = [[WKProcessPool alloc]init];
        
    }
    return _webConfig;
}

-(WKWebView*)pWebView
{
    if (!_pWebView)
    {
        _pWebView = [[WKWebView alloc] initWithFrame:self.bounds configuration:self.webConfig];
        _pWebView.UIDelegate = self;
        _pWebView.navigationDelegate = self;
        _pWebView.scrollView.showsVerticalScrollIndicator = NO;
        [_pWebView.configuration.userContentController addScriptMessageHandler:self name:@"JSCallback"];
        [_pWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _pWebView;
}

-(UIProgressView*)progressView
{
    if (!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
        _progressView.backgroundColor = [UIColor colorWithHexString:@"#32A4BE"];
        _progressView.tintColor = [UIColor colorWithHexString:@"#35BFDF"];
    }
    return _progressView;
}

#pragma mark - Dealloc
-(void)dealloc
{
    [self.pWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.pWebView.configuration.userContentController removeScriptMessageHandlerForName:@"JSCallback"];
    [self.pWebView.configuration.userContentController removeAllUserScripts];
}

@end
