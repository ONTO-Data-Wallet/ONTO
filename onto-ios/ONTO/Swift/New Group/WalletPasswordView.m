//
//  WalletPasswordView.m
//  ONTO
//
//  Created by Apple on 2018/10/25.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "WalletPasswordView.h"
#import <PromiseKit/AnyPromise.h>
#import "BrowserView.h"
#import "SendConfirmView.h"
#import "Config.h"
@interface WalletPasswordView()
@property (nonatomic, strong) SendConfirmView *sendConfirmV;
@property (nonatomic,copy) NSString *confirmPwd;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, strong) NSDictionary  *dic;
@property(nonatomic, strong) BrowserView *browserView;
@property(strong, nonatomic) AnyPromise *browserPromise;
@end

@implementation WalletPasswordView

-(instancetype)initWithTitle:(NSString *)title selectedDic:(NSDictionary*)selectedDic{
    self = [super init];
    if (self) {
        self.dic = selectedDic;
        [self addSubview:self.sendConfirmV];
        [self addSubview:self.browserView];
        self.browserPromise = [self getBrowserPromise];
        self.sendConfirmV.paybyStr = @"";
        self.sendConfirmV.amountStr = @"";
        self.sendConfirmV.isWalletBack = YES;
        [self.sendConfirmV show];
        [self.sendConfirmV.sureB handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [self loadJS];
        }];
    }
    return self;
}
- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
    }
    return _browserView;
}
- (AnyPromise *)getBrowserPromise {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        //这里应该有个Promise
        __weak typeof(self) weakSelf = self;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
            [weakSelf handlePrompt:prompt];
        }];
        
        [self.browserView setCallbackJSFinish:^{
            // if param is an NSError, rejects, else, resolves
            resolve(@1);
        }];
    }];
}
- (SendConfirmView *)sendConfirmV {
    
    if (!_sendConfirmV) {
        
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.height, kScreenWidth, kScreenHeight)];
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            weakSelf.confirmPwd = password;
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf loadJS];
            
        }];
    }
    return _sendConfirmV;
}
- (void)loadJS{
    
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",self.dic[@"key"],[Common transferredMeaning:_confirmPwd],self.dic[@"address"],self.dic[@"salt"]];
    
    if (_confirmPwd.length==0) {
        return;
    }
    _hub=[ToastUtil showMessage:@"" toView:nil];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}


-(void)compoundTrade:(NSDictionary*)hashDic{
    NSLog(@"hashDic=%@",hashDic);
    NSDictionary *params = @{
                             @"sendAddress": self.dic[@"address"],
                             @"receiveAddress": self.dic[@"address"],
                             @"assetName": @"pumpkin08",
                             @"amount": @"1",
                             @"txBodyHash": [hashDic valueForKey:@"tx"],
                             @"txIdHash": [hashDic valueForKey:@"txHash"]
                             };


    CCSuccess successCallback = ^(id responseObject,
                                  id responseOriginal) {

        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            NSString *err = [responseOriginal objectForKey:@"error"];
            NSString *msg = [NSString stringWithFormat:@"%@:%@", Localized(@"Systemerror"), err];
            [Common showToast:msg];
            return;
        }

        [_sendConfirmV dismiss];
        [_hub hideAnimated:YES];
        if (_callback) {
            _callback(@"");
        }

    };

    CCFailure failureCallback = ^(NSError *error, NSString *errorDesc, id responseOriginal) {

        [Common showToast:Localized(@"Networkerrors")];
        [_hub hideAnimated:YES];

    };

    [[CCRequest shareInstance] requestWithURLStringNoLoading:Assettransfer
                                                  MethodType:MethodTypePOST
                                                      Params:params
                                                     Success:successCallback
                                                     Failure:failureCallback];
}
- (void)handlePrompt:(NSString *)prompt{
    
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"compoundOep8"]) {
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
//            [_sendConfirmV dismiss];
            NSDictionary *dict = [Common dictionaryWithJsonString:promptArray[1]];
            [self compoundTrade:dict];
            
        }else{
            [_hub hideAnimated:YES];
        }
    }else if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]){
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
            //        [_sendConfirmV dismiss];
            [self compound];
        }else{
            [_hub hideAnimated:YES];
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            
        }
    }
    
    
}

-(void)compound{
    NSLog(@"dic===%@",self.dic);
    self.browserPromise.then(^(NSString *bar) {
        
        NSString * contractHash = [[NSUserDefaults standardUserDefaults] valueForKey:PUMPKINHASH];
        NSString * gas_limit = [[NSUserDefaults standardUserDefaults] valueForKey:PUMPKINGASLIMIT];
        NSString * gas_price = [[NSUserDefaults standardUserDefaults] valueForKey:PUMPKINGASPRICE];
        // 创建一个钱包
        NSString *jsStr =
        [NSString stringWithFormat:@"Ont.SDK.compoundOep8('%@','%@',1,'%@','%@','%@','%@','%@','%@','compoundOep8')", contractHash,self.dic[@"address"],self.dic[@"key"],[Common transferredMeaning:_confirmPwd],self.dic[@"salt"],gas_price,gas_limit,self.dic[@"address"]];
        
        return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
            
            //节点方法 每次调用JSSDK前都必须调用
            LOADJS
            
            [self.browserView.wkWebView
             evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError *_Nullable error) {
                 
                 if (error) {
                     resolve(error);
                 } else {
                     resolve(result);
                     NSLog(@"result=%@",result);
                     //          DebugLog(result);
                 }
             }];
            
        }];
        
    }).then(^{
        
    }).catch(^(NSError *error) {
        //    DebugLog(error);
    });
}
@end
