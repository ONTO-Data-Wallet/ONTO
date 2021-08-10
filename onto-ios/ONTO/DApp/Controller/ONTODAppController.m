//
//  ONTODAppController.m
//  ONTO
//
//  Created by onchain on 2019/5/8.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppController.h"
#import "ONTODAppWebView.h"
#import "ONTODAppWebContentController.h"
#import "ONTODAppBrowserController.h"
#import "ONTODAppWalletTipsAlertView.h"//创建钱包导入钱包提示窗体
#import "ONTODAppChangeWalletAlertView.h"

#import "CreateViewController.h"
#import "ImportWalletVC.h"
#import "ONTOWakePayViewController.h"
#import "ONTOWakePaySureViewController.h"
#import "SelectDefaultWallet.h"

@interface ONTODAppController ()<ONTODAppWebViewDelegate,ONTODAppWalletTipsAlertViewDelegate>
{
    NSString          *_nomalUrlStr;
}
@property(nonatomic,strong)ONTODAppWebView        *dAppWebView;
@property(nonatomic,strong)UIButton               *backButton;
@property(nonatomic,strong)BrowserView            *browserView;
@property(nonatomic,strong)MBProgressHUD          *hub;
@property(nonatomic,copy)NSString                 *confirmPwd;
@property(nonatomic,copy)NSString                 *confirmSurePwd;
@property(nonatomic,strong)NSDictionary           *promptDic;
@property(nonatomic,strong)NSDictionary           *defaultWalletDic;
@property(nonatomic,assign)BOOL                   isFirst;
@property(nonatomic,copy)NSString                 *hashString;
@property(nonatomic,strong)id                      responseOriginal;
@property(nonatomic,strong)ONTOWakePayViewController       *loginVC;
@property(nonatomic,strong)ONTOWakePaySureViewController   *payVC;
@property(nonatomic,strong)ONTODAppWalletTipsAlertView     *alertView;
@property(nonatomic,strong)SelectDefaultWallet             *optionsView;
@property(nonatomic,strong)UIWindow                        *window;
@property(nonatomic,strong)NSArray                         *walletArr;
@property(nonatomic,strong)ONTODAppChangeWalletAlertView *changeView;

@end
@implementation ONTODAppController
#pragma mark - Init
- (instancetype)initWithUrlStr:(NSString*)urlStr
{
    if (self = [super init])
    {
        _nomalUrlStr = urlStr;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.browserView];
    [self p_initSetting];
    [self p_initUI];
    [self p_initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:INVOKEPASSWORDFREE];
    [Common deleteEncryptedContent:INVOKEPASSWORDFREE];
    self.isFirst = YES;
    [self getBalance];
    
    self.navigationController.navigationBar.translucent = YES;
}
#pragma mark - Private
-(void)p_initSetting
{
    [self p_settingNavShow];
}

-(void)p_settingNavShow
{
    //Left
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(p_closeButtonSlot:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@"DApp_Close"] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    UIBarButtonItem *lFixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    lFixedSpaceBarButtonItem.width = 22;
    
    self.navigationItem.leftBarButtonItems  = @[backItem,lFixedSpaceBarButtonItem,closeItem];
    
    //Right
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton addTarget:self action:@selector(p_refreshButtonSlot:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setImage:[UIImage imageNamed:@"DApp_Refresh"] forState:UIControlStateNormal];
    [refreshButton sizeToFit];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 22;

    self.navigationItem.rightBarButtonItems  = @[/*searchItem,fixedSpaceBarButtonItem,*/refreshItem];
}

-(void)p_initUI
{
    [self.view addSubview:self.dAppWebView];
}

-(void)p_initData
{
//    _nomalUrlStr = @"http://101.132.193.149:5000/#/"; //demo调试
    
    [self.dAppWebView setNormalUrlstr:_nomalUrlStr];
}

//Button Slots
-(void)p_refreshButtonSlot:(UIButton*)button
{
    [self.dAppWebView reloadWebView];
}

-(void)p_searchButtonSlot:(UIButton*)button
{
    [self.navigationController pushViewController:[[ONTODAppBrowserController alloc] init] animated:YES];
}

-(void)p_backButtonSlot:(UIButton*)button
{
    if ([self.dAppWebView isCanGoBack])
    {
        [self.dAppWebView webViewGoBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)p_closeButtonSlot:(UIButton*)button
{
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Delegate
-(void)ONTODAppWebView:(WKWebView*)webView didFinishNavigation:(WKNavigation *)navigation
{
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
        if (error == nil) {
            self.title = title;
        }
    }];
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

//login
-(void)ONTODAppWebView:(WKWebView *)webView messageOfLoginWithDict:(NSDictionary*)dict
{
    if (![self haveWallet]) {
        // 返回错误信息
        return;
    }
    
    NSDictionary * walletDic = [self getDefaultWallet];
    self.promptDic = dict;
    
    self.loginVC = nil;
    self.loginVC.infoDic = dict;
    [self showActionVc:self.loginVC];
    __weak typeof(self) weakSelf = self;
    [_loginVC setPwdBlock:^(NSString * _Nonnull pwdString) {
        weakSelf.confirmPwd = pwdString;
        [weakSelf loginWithWalletDic:walletDic pwdString:pwdString];
    }];
    
}

//getAccount
-(void)ONTODAppWebView:(WKWebView *)webView messageOfGetAccountWithDict:(NSDictionary*)dict
{
    if (![self haveWallet]) {
        // 返回错误信息
        return;
    }
    [self getDefaultWallet];
    
    NSString * idStr = @"";
    if (dict[@"id"]) {
        idStr = dict[@"id"];
    }
    NSString * versionStr = @"";
    if (dict[@"version"]) {
        versionStr = dict[@"version"];
    }
    NSDictionary *params = @{@"action":@"getAccount",
                             @"error":@0,
                             @"desc":@"SUCCESS",
                             @"result":self.defaultWalletDic[@"address"],
                             @"id":idStr,
                             @"version":versionStr
                             };
    [self.dAppWebView sendMessageToWeb:params];
}

//invoke
-(void)ONTODAppWebView:(WKWebView *)webView messageOfInvokeWithDict:(NSDictionary*)dict
{
    if (![self haveWallet]) {
        // 返回错误信息
        return;
    }
    
    NSDictionary * walletDic = [self getDefaultWallet];
    self.promptDic = dict;
    
    self.loginVC = nil;
    self.loginVC.infoDic = dict;
    [self showActionVc:self.loginVC];
    __weak typeof(self) weakSelf = self;
    [_loginVC setPwdBlock:^(NSString * _Nonnull pwdString) {
        weakSelf.confirmPwd = pwdString;
        [weakSelf loginWithWalletDic:walletDic pwdString:pwdString];
    }];
    
//    [self getBalance];
}

//invokeRead
-(void)ONTODAppWebView:(WKWebView *)webView messageOfInvokeReadWithDict:(NSDictionary*)dict
{
    if (![self haveWallet]) {
        // 返回错误信息
        return;
    }
    
    self.promptDic = dict;
    NSDictionary * tradeDic = [self checkPayer:self.promptDic];
    if (tradeDic == nil) {
        [self emptyInfo:@"no wallet" resultDic:self.promptDic];
        return;
    }
    NSString *str = [self convertToJsonData:tradeDic];
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.makeDappInvokeReadTransaction('%@','makeDappTransaction')",str];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}

//invokePasswordFree
-(void)ONTODAppWebView:(WKWebView *)webView messageOfInvokePasswordFreeWithDict:(NSDictionary*)dict
{
    
    NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:INVOKEPASSWORDFREE];
    NSDictionary * params = self.promptDic[@"params"];
    NSString *jsonString ;
    if (params.count >0) {
        jsonString = [Common dictionaryToJson:params];
    }
    if (allArray) {
        self.isFirst = YES;
        for (NSString * paramsStr in allArray) {
            if ([jsonString isEqualToString:paramsStr]) {
                self.isFirst = NO;
            }
        }
        
    }else{
        self.isFirst = YES;
    }
    
    if (self.isFirst) {
        if (![self haveWallet]) {
            // 返回错误信息
            return;
        }
        
        NSDictionary * walletDic = [self getDefaultWallet];
        self.promptDic = dict;
        
        self.loginVC = nil;
        self.loginVC.infoDic = dict;
        [self showActionVc:self.loginVC];
        __weak typeof(self) weakSelf = self;
        [_loginVC setPwdBlock:^(NSString * _Nonnull pwdString) {
            weakSelf.confirmPwd = pwdString;
            [weakSelf loginWithWalletDic:walletDic pwdString:pwdString];
        }];
    }else {
        if (![self haveWallet]) {
            // 返回错误信息
            return;
        }
        self.promptDic = dict;
        NSDictionary * tradeDic = [self checkPayer:self.promptDic];
        if (tradeDic == nil) {
            [self emptyInfo:@"no wallet" resultDic:self.promptDic];
            return;
        }
        NSString *str = [self convertToJsonData:tradeDic];
        NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.makeDappTransaction('%@','%@','makeDappTransaction')",str,self.confirmSurePwd];
        [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        __weak typeof(self) weakSelf = self;
        [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
            [weakSelf handlePrompt:prompt];
        }];
    }
    
    
    
}

#pragma mark - Properties
-(UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(p_backButtonSlot:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:[UIImage imageNamed:@"DApp_Back"] forState:UIControlStateNormal];
        [_backButton sizeToFit];
    }
    return _backButton;
}

-(ONTODAppWebView*)dAppWebView
{
    if (!_dAppWebView)
    {
        _dAppWebView = [[ONTODAppWebView alloc] initWithFrame:CGRectMake(0, LL_StatusBarAndNavigationBarHeight, self.view.width, self.view.height-LL_StatusBarAndNavigationBarHeight)];
        _dAppWebView.delegate = self;
    }
    return _dAppWebView;
}

-(void)loginWithWalletDic:(NSDictionary*)walletDic pwdString:(NSString*) pwdString {
    if (pwdString.length < 8) {
        [Common showToast:Localized(@"SelectAlertPassWord")];
        return ;
    }
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",walletDic[@"key"],[Common transferredMeaning:pwdString],walletDic[@"address"],walletDic[@"salt"]];
    
    if (pwdString.length==0) {
        return;
    }
    _hub=[ToastUtil showMessage:@"" toView:nil];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
- (BOOL)haveWallet {
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    if (jsonStr){
        NSDictionary *walletDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        if ([walletDict isKindOfClass:[NSDictionary class]] && walletDict[@"label"]){
            
            return YES;
        }else {
            // 检查本地是否有普通钱包
            NSArray * walletArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
            BOOL isHave = NO;
            for (NSDictionary *dic in walletArray) {
                if ([dic isKindOfClass:[NSDictionary class]] && dic[@"label"]){
                    isHave = YES;
                }
            }
            if (!isHave) {
                [self toCreateWallet];
            }else {
                [self toChangeWallet];
            }
            return NO;
        }
    }else {
        [self toCreateWallet];
        return NO;
    }
    return YES;
}

-(void)toCreateWallet
{
    [_alertView removeFromSuperview];
    _alertView = [ONTODAppWalletTipsAlertView CreatWalletTipsAlertView];
    _alertView.isDapp = YES;
    _alertView.delegate = self;
}

-(void)toChangeWallet
{
    if (_changeView != nil) {
        [_changeView removeFromSuperview];
    }
    _changeView = [ONTODAppChangeWalletAlertView CreatWalletTipsAlertView];
    _changeView.isDapp = YES;
    _changeView.delegate = self;
}

/** 创建钱包点击 */
-(void)walletTipsAlertCreateBtnSlot:(ONTODAppWalletTipsAlertView*)alertView
{
    CreateViewController *vc = [[CreateViewController alloc] init];
    vc.isWallet = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 导入钱包点击 */
-(void)walletTipsAlertInputBtnSlot:(ONTODAppWalletTipsAlertView*)alertView
{
    ImportWalletVC *importWVC = [[ImportWalletVC alloc] init];
    [self.navigationController pushViewController:importWVC animated:YES];
}

/** 切换钱包点击 */
-(void)walletTipsAlertChangeBtnSlot:(ONTODAppChangeWalletAlertView*)alertView
{
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *shareArr = [NSMutableArray array];
    _walletArr = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    for (int i = 0; i < _walletArr.count; i++) {
        if ([_walletArr[i] isKindOfClass:[NSDictionary class]] && _walletArr[i][@"label"]) {
            
            [titleArr addObject:_walletArr[i][@"label"]];
        } else {
            [titleArr addObject:_walletArr[i][@"sharedWalletName"]];
            [shareArr addObject:[NSNumber numberWithInteger:i]];
        }
        [self getDefaultWallet];
        if ([self.defaultWalletDic isEqual:_walletArr[i]]) {
            //当前钱包
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", i] forKey:SELECTWALLET];
        }
    }
    __weak typeof(self) weakSelf = self;
    _optionsView =
    [[SelectDefaultWallet alloc] initWithOptionsArr:titleArr shareArray:shareArr cancelTitle:Localized(@"Cancel") actionBlock:^{
        [weakSelf getBalance];
    }];
    
    _window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [_window addSubview:_optionsView];
    [_window makeKeyAndVisible];
}

- (NSDictionary *)getDefaultWallet
{
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *walletDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.defaultWalletDic = walletDict;
    return walletDict;
}

- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
            [weakSelf handlePrompt:prompt];
        }];
        [_browserView setCallbackJSFinish:^{
        }];
    }
    return _browserView;
}

// TS SDK callback processing
- (void)handlePrompt:(NSString *)prompt
{
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    // Password decryption callback processing
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"])
    {
//        [self getBalance];
        [self decryptEncryptedPrivateKey:obj];
        
    }
    else if ([prompt hasPrefix:@"newsignDataStrHex"])
    {
        
        [self newsignDataStrHex:obj];
    }
    else if ([prompt hasPrefix:@"makeDappTransaction"])
    {
        
        [self makeDappTransaction:obj];
    }
    else if ([prompt hasPrefix:@"checkTrade"])
    {
        
        [self checkTrade:obj];
    }
    else if ([prompt hasPrefix:@"sendTransaction"])
    {
        [self toSendTransaction:obj];
    }
    else if ([prompt hasPrefix:@"sendrawtransaction"])
    {

//        [self toSendTransaction:obj];
        
//        [self getBalance];

    }
}

-(void)decryptEncryptedPrivateKey:(NSDictionary *)obj{
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        [_hub hideAnimated:YES];
        self.confirmPwd = @"";
        //密码错误还会开始游戏的问题-bug
//        [self errorSend:obj];
        [Common showErrorMsg:Localized(@"PASSWORDERROR")];
        
    }else{
        if (self.promptDic[@"action"]) {
            if ([self.promptDic[@"action"] isEqualToString:@"login"]) {
                
                [self actionLogin];
                
            }else if ([self.promptDic[@"action"] isEqualToString:@"invoke"]){
                
                [self actionInvoke: obj];
                
            }else if ([self.promptDic[@"action"] isEqualToString:@"invokePasswordFree"]){
                
                [self actionInvokePasswordFree:obj];
            }
        }
    }
}

// action login
- (void)actionLogin{
    // Sign the message
    NSDictionary *params = self.promptDic[@"params"];
    NSString *signStr =[Common hexStringFromString:params[@"message"]];
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.signDataHex('%@','%@','%@','%@','%@','newsignDataStrHex')",signStr,self.defaultWalletDic[@"key"],[Common base64EncodeString:_confirmPwd],self.defaultWalletDic[@"address"],self.defaultWalletDic[@"salt"]];
    
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
// newsignDataStrHex
- (void)newsignDataStrHex:(NSDictionary*)obj{
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        [_hub hideAnimated:YES];
        [self errorSend:obj];
        NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),obj[@"error"]];
        [Common showErrorMsg:errorStr];
    }else{
        
        [_hub hideAnimated:YES];
        if (obj[@"result"]) {
            if ([obj[@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * result = obj[@"result"];
                if (result[@"Error"]) {
                    
                    if ([[result valueForKey:@"Error"] integerValue] > 0) {
                        if ([result[@"Error"] integerValue] == 47001) {
                            [Common showErrorMsg:Localized(@"payNot")];
                        }else{
                            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),result[@"Error"]];
                            [Common showErrorMsg:errorStr];
                        }
                        return;
                    }
                }
            }
        }
        [_loginVC dismissViewControllerAnimated:YES completion:nil];
        NSDictionary *params = self.promptDic[@"params"];
        NSString * idStr = @"";
        if (self.promptDic[@"id"]) {
            idStr = self.promptDic[@"id"];
        }
        NSString * versionStr = @"";
        if (self.promptDic[@"version"]) {
            versionStr = self.promptDic[@"version"];
        }
        NSDictionary *result =@{@"type": @"account",
                                @"publickey":self.defaultWalletDic[@"publicKey"],
                                @"user": self.defaultWalletDic[@"address"],
                                @"message":params[@"message"] ,
                                @"signature":obj[@"result"],
                                };
        NSDictionary *nParams = @{@"action":@"login",
                                  @"version": @"v1.0.0",
                                  @"error": @0,
                                  @"desc": @"SUCCESS",
                                  @"result":result,
                                  @"id":idStr,
                                  @"version":versionStr
                                  };
        [self.dAppWebView sendMessageToWeb:nParams];
    }
}

// avtion invoke
- (void)actionInvoke:(NSDictionary*)obj{
    NSDictionary * tradeDic = [self checkPayer:self.promptDic];
    if (tradeDic == nil) {
        [self emptyInfo:@"no wallet" resultDic:self.promptDic];
        return;
    }
    NSString *str = [self convertToJsonData:tradeDic];
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.makeDappTransaction('%@','%@','makeDappTransaction')",str,obj[@"result"]];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}

// makeDappTransaction
- (void)makeDappTransaction:(NSDictionary*)obj{
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        [_hub hideAnimated:YES];
        [self errorSend:obj];
        NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),obj[@"error"]];
        [Common showErrorMsg:errorStr];
        
    }else{
        if (obj[@"result"]) {
            if ([obj[@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * result = obj[@"result"];
                if (result[@"Error"]) {
                    
                    if ([[result valueForKey:@"Error"] integerValue] > 0) {
                        [_hub hideAnimated:YES];
                        if ([result[@"Error"] integerValue] == 47001) {
                            [Common showErrorMsg:Localized(@"payNot")];
                        }else{
                            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),result[@"Error"]];
                            [Common showErrorMsg:errorStr];
                        }
                        return;
                    }
                }
            }
        }
        self.hashString = obj[@"result"];
        NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.checkTransaction('%@','checkTrade')",obj[@"result"]];
        
        LOADJS1;
        LOADJS2;
        LOADJS3;
        __weak typeof(self) weakSelf = self;
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        [self.browserView setCallbackPrompt:^(NSString * prompt) {
            [weakSelf handlePrompt:prompt];
        }];
    }
}
// checkTrade
- (void)checkTrade:(NSDictionary*)obj{
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        [_hub hideAnimated:YES];
        [self errorSend:obj];
        if ([obj[@"error"] integerValue] == 47001) {
            [Common showErrorMsg:Localized(@"payNot")];
        }else{
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),obj[@"error"]];
            [Common showErrorMsg:errorStr];
        }
        
    }else{
        [_hub hideAnimated:YES];
        if (obj[@"result"]) {
            if ([obj[@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * result = obj[@"result"];
                if (result[@"Error"]) {
                    
                    if ([[result valueForKey:@"Error"] integerValue] > 0) {
                        if ([result[@"Error"] integerValue] == 47001) {
                            [Common showErrorMsg:Localized(@"payNot")];
                        }else{
                            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),result[@"Error"]];
                            [Common showErrorMsg:errorStr];
                        }
                        return;
                    }
                }
            }
        }
        if ([obj isKindOfClass:[NSDictionary class]] && obj[@"result"]) {
            if ([Common isBlankString:obj[@"result"]]) {
                [Common showErrorMsg:Localized(@"Systemerror")];
                [self errorSend:obj];
            }else{
                if ([self.promptDic[@"action"] isEqualToString:@"invokeRead"]){
                    [self invokeReadToWeb:obj];
                    [self.loginVC dismissViewControllerAnimated:YES completion:nil];
                }else{
                    
                    [self.loginVC dismissViewControllerAnimated:NO completion:^{
                        
                        if (self.isFirst)
                        {
                            // TODO 支付确认
//                            self.payVC = nil;
//                            self.payVC.infoDic = obj;
//                            self.payVC.responseOriginal = self.responseOriginal;
//                            [self showActionVc:self.payVC];
//
//                            __weak typeof(self) weakSelf = self;
//                            [self.payVC setSureBlock:^{
//                                // TODO 上链
//                                [weakSelf sendTransaction];
//                            }];
                            
                            [self p_getCurrentBalanceWithDict:obj];
                            
                        }
                        else
                        {
                            [self sendTransaction];
                        }
                    }];
                }
            }
        }
    }
}

-(void)p_getCurrentBalanceWithDict:(NSDictionary*)obj
{
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", Get_Blance, dict[@"address"]];
    _hub = [ToastUtil showMessage:@"" toView:nil];
    [[CCRequest shareInstance] requestWithURLString1:urlStr MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal) {
        [_hub hideAnimated:YES];
        self.responseOriginal = responseOriginal;
        self.payVC = nil;
        self.payVC.infoDic = obj;
        self.payVC.responseOriginal = self.responseOriginal;
        [self showActionVc:self.payVC];
        
        __weak typeof(self) weakSelf = self;
        [self.payVC setSureBlock:^{
            // TODO 上链
            [weakSelf sendTransaction];
        }];
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        
        [_hub hideAnimated:YES];
        
    }];
}

// action invokePasswordFree
- (void)actionInvokePasswordFree:(NSDictionary*)obj{
    NSDictionary * tradeDic = [self checkPayer:self.promptDic];
    if (tradeDic == nil) {
        [self emptyInfo:@"no wallet" resultDic:self.promptDic];
        return;
    }
    self.confirmSurePwd = obj[@"result"];
    NSString *str = [self convertToJsonData:tradeDic];
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.makeDappTransaction('%@','%@','makeDappTransaction')",str,obj[@"result"]];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
- (void)toSendTransaction:(NSDictionary*)obj{
    [_hub hideAnimated:YES];
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
        [self.payVC dismissViewControllerAnimated:YES completion:nil];
        
        if (obj[@"result"]) {
            if ([obj[@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * result = obj[@"result"];
                if (result[@"Error"]) {
                    
                    if ([[result valueForKey:@"Error"] integerValue] > 0)
                    {
                        if ([result[@"Error"] integerValue] == 47001) {
                            [Common showErrorMsg:Localized(@"payNot")];
                        }else{
                            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),result[@"Error"]];
                            [Common showErrorMsg:errorStr];
                        }
                        return;
                    }
                    else
                    {
                        NSString *errorResStr = result[@"Result"];
                        if ([errorResStr containsString:@"balance insufficient"])
                        {
                            [Common showErrorMsg:@"余额不足"];
                        }
                    }
                }
            }
        }
        
        NSDictionary * result = obj[@"result"];
        NSDictionary *nParams ;
        NSString * idStr = @"";
        if (self.promptDic[@"id"]) {
            idStr = self.promptDic[@"id"];
        }
        NSString * versionStr = @"";
        if (self.promptDic[@"version"]) {
            versionStr = self.promptDic[@"version"];
        }
        if ([self.promptDic[@"action"] isEqualToString:@"invokePasswordFree"]){
            nParams = @{@"action":@"invokePasswordFree",
                        @"version": @"v1.0.0",
                        @"error": @0,
                        @"desc": @"SUCCESS",
                        @"result":result[@"Result"],
                        @"id":idStr,
                        @"version":versionStr
                        };
            [self toSaveInvokePasswordFreeInfo];
        }else{
            nParams = @{@"action":@"invoke",
                        @"version": @"v1.0.0",
                        @"error": @0,
                        @"desc": @"SUCCESS",
                        @"result":result[@"Result"],
                        @"id":idStr,
                        @"version":versionStr
                        };
        }
        [self.dAppWebView sendMessageToWeb:nParams];
        
    } else {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            [self errorSend:obj];
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),obj[@"error"]];
            [Common showErrorMsg:errorStr];
            
        }
        
    }
}

// invokeRead 反馈
-(void)invokeReadToWeb:(id)obj{
    NSDictionary *result = obj[@"result"];
    NSDictionary *nparams =result[@"Result"];
    NSString * idStr = @"";
    if (self.promptDic[@"id"]) {
        idStr = self.promptDic[@"id"];
    }
    NSString * versionStr = @"";
    if (self.promptDic[@"version"]) {
        versionStr = self.promptDic[@"version"];
    }
    NSDictionary *params = @{@"action":@"invokeRead",
                             @"error":@0,
                             @"desc":@"SUCCESS",
                             @"result":nparams,
                             @"id":idStr,
                             @"version":versionStr
                             };
    [self.dAppWebView sendMessageToWeb:params];
}

// sendTransaction
- (void)sendTransaction{
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.sendTransaction('%@','sendTransaction')",self.hashString];
    LOADJS1;
    LOADJS2;
    LOADJS3;
    __weak typeof(self) weakSelf = self;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    [self.browserView setCallbackPrompt:^(NSString * prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}

// Error message upload
-(void)errorSend:(NSDictionary*)dic{
    NSString * idStr = @"";
    if (self.promptDic[@"id"]) {
        idStr = self.promptDic[@"id"];
    }
    NSString * versionStr = @"";
    if (self.promptDic[@"version"]) {
        versionStr = self.promptDic[@"version"];
    }
    NSDictionary *nParams = @{@"action":self.promptDic[@"action"],
                              @"error": @0,
                              @"desc": @"ERROR",
                              @"result":dic[@"result"],
                              @"id":idStr,
                              @"version":versionStr
                              };
    
    
    [self.dAppWebView sendMessageToWeb:nParams];
}
// Convert a dictionary to a Json string
-(NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
- (ONTOWakePayViewController*)loginVC {
    if (!_loginVC) {
        _loginVC = [[ONTOWakePayViewController alloc]init];
        _loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return _loginVC;
}
- (ONTOWakePaySureViewController*)payVC {
    if (!_payVC) {
        _payVC = [[ONTOWakePaySureViewController alloc]init];
        _payVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return _payVC;
}
// send emptuInfo to web
-(void)emptyInfo:(NSString*)emptyString resultDic:(NSDictionary*)dic{
    NSString * idStr = @"";
    if (dic[@"id"]) {
        idStr = dic[@"id"];
    }
    NSString * versionStr = @"";
    if (dic[@"version"]) {
        versionStr = dic[@"version"];
    }
    NSDictionary *nParams = @{@"action":dic[@"action"],
                              @"error": emptyString,
                              @"desc": @"ERROR",
                              @"result":@"",
                              @"id":idStr,
                              @"version":versionStr
                              };
    [self.dAppWebView sendMessageToWeb:nParams];
}

-(void)showActionVc:(id)actionVc {
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdelegate.window.rootViewController.definesPresentationContext = YES;
    [appdelegate.window.rootViewController presentViewController:actionVc animated:YES completion:^{
    }];
}
// Check transaction payer
-(NSDictionary*)checkPayer:(NSDictionary*)dic{
    NSMutableDictionary * resultParamsChange = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSMutableDictionary * paramsD = [NSMutableDictionary dictionaryWithDictionary:resultParamsChange[@"params"]] ;
    NSMutableDictionary * invokeConfig = [NSMutableDictionary dictionaryWithDictionary:paramsD[@"invokeConfig"]] ;
    if (!invokeConfig[@"payer"]) {
        [invokeConfig setValue:self.defaultWalletDic[@"address"] forKey:@"payer"];
        paramsD[@"invokeConfig"] = invokeConfig;
        resultParamsChange[@"params"] = paramsD;
        return resultParamsChange;
    }
    if ([Common isBlankString:invokeConfig[@"payer"]]) {
        [invokeConfig setValue:self.defaultWalletDic[@"address"] forKey:@"payer"];
        paramsD[@"invokeConfig"] = invokeConfig;
        resultParamsChange[@"params"] = paramsD;
        return resultParamsChange;
    }
    if (![self.defaultWalletDic[@"address"] isEqualToString:invokeConfig[@"payer"]]) {
        [Common showToast:@"There is no corresponding payment wallet, please add the wallet first."];
        return nil;
    }
    return dic;
    
}

// SaveInvokePasswordFreeInfo
-(void)toSaveInvokePasswordFreeInfo{
    NSDictionary * params = self.promptDic[@"params"];
    NSString *jsonString = [Common dictionaryToJson:params];
    NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:INVOKEPASSWORDFREE];
    NSMutableArray *newArray;
    if (allArray) {
        newArray = [[NSMutableArray alloc] initWithArray:allArray];
        BOOL isHave = NO;
        for (NSString * str  in newArray) {
            if ([str isEqualToString:jsonString]) {
                isHave = YES;
            }
        }
        if (isHave == NO) {
            [newArray addObject:jsonString];
        }
    } else {
        newArray = [[NSMutableArray alloc] init];
        [newArray addObject:jsonString];
    }
    [Common setEncryptedContent:self.confirmSurePwd WithKey:INVOKEPASSWORDFREE];
    [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:INVOKEPASSWORDFREE];
}
-(void)getBalance
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 异步执行任务创建方法
    dispatch_async(queue, ^{
        // 这里放异步执行任务代码
        NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
        NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@", Get_Blance, dict[@"address"]];
        
        CCSuccess successCallback = ^(id responseObject, id responseOriginal) {
            self.responseOriginal = responseOriginal;
//            [self.dAppWebView reloadWebView];
        };
        CCFailure failureCallback = ^(NSError *error, NSString *errorDesc, id responseOriginal) {
            self.responseOriginal = nil;
            [self.dAppWebView reloadWebView];
        };
        
        //TODO: requestWithURLString1 这个命名搞清楚有啥不同后要改
        [[CCRequest shareInstance] requestWithURLString1:urlStr
                                              MethodType:MethodTypeGET
                                                  Params:nil
                                                 Success:successCallback
                                                 Failure:failureCallback];
    });
}
@end
