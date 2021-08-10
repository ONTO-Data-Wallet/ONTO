//
//  BrowserView.m
//  ONTO
//
//  Created by Zeus.Zhang on 2018/2/22.
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

#import "BrowserView.h"
#import "ToastUtil.h"
#import "Common.h"
#import "Config.h"
@implementation BrowserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.wkWebView];
    
    }
    return self;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        configuration.preferences = [WKPreferences new];
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        configuration.preferences.javaScriptEnabled = YES;
        
        configuration.userContentController = [[WKUserContentController alloc] init];
        [configuration.userContentController addScriptMessageHandler:self name:@"getWalletDataStr"];
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.frame configuration:configuration];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        NSString *webPath = [[NSBundle mainBundle] pathForResource:@"js" ofType:nil];
        [_wkWebView loadFileURL:[NSURL fileURLWithPath:[webPath stringByAppendingPathComponent:@"test.html"]] allowingReadAccessToURL:[NSURL fileURLWithPath:webPath]];
        
       
    }
    return _wkWebView;
}


#pragma mark WKWebViewDelegate
/**
 webview加载完成
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DebugLog(@"js finish！！！");
    if (_callbackJSFinish) {
        _callbackJSFinish();
        
    }
}

/**
 webview开始加载
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    DebugLog(@"js start！！！");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    DebugLog(@"js didFailNavigation！！！");
}
/**
 webview拦截alert
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    DebugLog(@"alert%@",message);
    completionHandler();
}

/**
 webview拦截Confirm
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    DebugLog(@"confirm%@",message);
    completionHandler(YES);
}

/**
 webview拦截Prompt
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    [self savePrompt:prompt];
    completionHandler(@"123");
}

/**
 webview拦截js方法
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    DebugLog(@"message:%@",message);
}

#pragma mark handlePrompt
- (void)savePrompt:(NSString *)prompt {
    _callbackPrompt(prompt);
    if ([prompt hasPrefix:@"Ont://"]) {
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        prompt = [prompt substringFromIndex:6];
        _callbackPrompt(prompt);
        
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
           
        }else{
            
            if ([[obj valueForKey:@"error"] integerValue] == 52000) {
                
                return;
            }
            
            if ([[obj valueForKey:@"error"] integerValue] == 53000) {
                return;
            }
        }
        
    }
    
}


@end









