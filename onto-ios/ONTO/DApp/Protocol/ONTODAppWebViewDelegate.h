//
//  ONTODAppWebViewProtocol.h
//  ONTO
//
//  Created by onchain on 2019/5/8.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WKWebView;
@class WKNavigation;
@class WKNavigationAction;
@protocol ONTODAppWebViewDelegate <NSObject>
@optional
-(void)ONTODAppWebView:(WKWebView*)webView didFinishNavigation:(WKNavigation *)navigation;

-(void)ONTODAppWebView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction;

-(void)ONTODAppWebView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;

-(void)ONTODAppWebView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;

//login
-(void)ONTODAppWebView:(WKWebView *)webView messageOfLoginWithDict:(NSDictionary*)dict;

//getAccount
-(void)ONTODAppWebView:(WKWebView *)webView messageOfGetAccountWithDict:(NSDictionary*)dict;

//invoke
-(void)ONTODAppWebView:(WKWebView *)webView messageOfInvokeWithDict:(NSDictionary*)dict;

//invokeRead
-(void)ONTODAppWebView:(WKWebView *)webView messageOfInvokeReadWithDict:(NSDictionary*)dict;

//invokePasswordFree
-(void)ONTODAppWebView:(WKWebView *)webView messageOfInvokePasswordFreeWithDict:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
