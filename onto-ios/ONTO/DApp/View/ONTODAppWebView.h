//
//  ONTODAppWebView.h
//  ONTO
//
//  Created by onchain on 2019/5/8.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONTODAppWebViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ONTODAppWebView : UIView

//设置H5地址
-(void)setNormalUrlstr:(NSString*)urlStr;

//H5界面返回
-(void)webViewGoBack;

-(void)sendMessageToWeb:(NSDictionary *)dic;

-(void)reloadWebView;

-(BOOL)isCanGoBack;

-(void)webViewGoBack;

@property(nonatomic,weak)id<ONTODAppWebViewDelegate>     delegate;

@end

NS_ASSUME_NONNULL_END
