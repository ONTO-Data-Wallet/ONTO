//
//  WebIdentityViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/8.
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

#import "WebIdentityViewController.h"
#import <WebKit/WebKit.h>
#import "Common.h"
#import "WaitingViewController.h"
@interface WebIdentityViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler> {
  WKWebView *webView;
}
@property(nonatomic, strong) UIProgressView *progressView;

@end

@implementation WebIdentityViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self configNav];
  [self configUI];

  AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
  if (appDelegate.isNetWorkConnect == NO) {
    [Common showToast:Localized(@"NetworkAnomaly")];
//        [ToastUtil shortToast:self.view value:Localized(@"NetworkAnomaly")];
  } else {
    [self loadWeb];
  }

  self.progressView =
      [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
  self.progressView.backgroundColor = MainColor;
  self.progressView.tintColor = [UIColor colorWithHexString:@"#35BFDF"];

  //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
  self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
  [self.view addSubview:self.progressView];

  [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
  if ([keyPath isEqualToString:@"estimatedProgress"]) {
    self.progressView.progress = webView.estimatedProgress;
    if (self.progressView.progress == 1) {
      /*
       *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
       *动画时长0.25s，延时0.3s后开始动画
       *动画结束后将progressView隐藏
       */
      __weak typeof(self) weakSelf = self;
      [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
      }                completion:^(BOOL finished) {
//                weakSelf.progressView.hidden = YES;

      }];
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)configUI {

  webView = [[WKWebView alloc] init];
  [self.view addSubview:webView];
  [webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(self.view);
    make.bottom.equalTo(self.view);
  }];
  webView.UIDelegate = self;
  webView.navigationDelegate = self;

}

- (void)configNav {

  [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];

}

- (void)navLeftAction {

  if (webView.canGoBack == YES) {

    if (_helpCentre) {
      [webView goBack];
    } else {

      [self.navigationController popViewControllerAnimated:YES];

    }

  } else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (void)loadWeb {

  NSString *typeStr = @"";
    if (_address) {
//        NSURL*url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
//        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        NSString *webPath = [[NSBundle mainBundle] pathForResource:@"js" ofType:nil];
        [webView loadFileURL:[NSURL fileURLWithPath:[webPath stringByAppendingPathComponent:@"test.html"]] allowingReadAccessToURL:[NSURL fileURLWithPath:webPath]];
        
        return;
    }
  if (_transaction) {

    [self setNavTitle:Localized(@"InfoOnblack")];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:NETNAME] isEqualToString:@"MainNet"]) {

      typeStr = [NSString stringWithFormat:@"https://explorer.ont.io/transaction/%@", _transaction];

    } else {

      typeStr =
          [NSString stringWithFormat:@"https://explorer.ont.io/transaction/%@/%@", _transaction, [NSString stringWithFormat:@"%@", @"testnet"]];

    }
    if ([self screenURLString:typeStr]) {

      [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:typeStr]]];
    }
    return;
  }

  if (_knowMoreUrl) {
    [self setNavTitle:Localized(@"KownMore")];

    typeStr = _knowMoreUrl;
    if ([self screenURLString:typeStr]) {

      [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:typeStr]]];
    }
    return;
  }

  if (_identitycard) {

    [self setNavTitle:Localized(@"")];
    typeStr = _identitycard;
    if ([self screenURLString:typeStr]) {

      [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:typeStr]]];
    }
    return;
  }
  if (_proction) {

    [self setNavTitle:Localized(@"")];
    typeStr = _proction;
    if ([self screenURLString:typeStr]) {

      [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:typeStr]]];
    }
    return;
  }
  if (_usersprivacy) {

    [self setNavTitle:Localized(@"")];
    typeStr = _usersprivacy;
    if ([self screenURLString:typeStr]) {

      [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:typeStr]]];
    }
    return;
  }
  if (_verifyUrl) {

    [self setNavTitle:Localized(@"")];
    typeStr = _verifyUrl;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:typeStr]]];
    return;
  }
  if (_introduce) {

    [self setNavTitle:Localized(@"")];
    typeStr = _introduce;
    if ([self screenURLString:typeStr]) {

      [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:typeStr]]];
    }
    return;
  }

  if (_helpCentre) {
    //http://13.67.90.237/#/detail/7
    typeStr = _helpCentre;
    if ([self screenURLString:typeStr]) {

      [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:typeStr]]];
    }
    [self setNavTitle:Localized(@"HelpCentre")];

    return;
  }

  switch (_identityType) {
    case 0:typeStr = @"twitter_authentication";
      [self setNavTitle:Localized(@"TwitterClaim")];
      break;
    case 1:typeStr = @"linkedin_authentication";
      [self setNavTitle:Localized(@"LinkedinClaim")];
      break;
    case 2:typeStr = @"github_authentication";
      [self setNavTitle:Localized(@"GithubClaim")];
      break;
    case 3:typeStr = @"facebook_authentication";
      [self setNavTitle:Localized(@"FacebookClaim")];
      break;
    default:break;
  }

  NSString *userLanguage;
  if ([[Common getUserLanguage] isEqualToString:@"en"]) {
    userLanguage = @"en";
  } else {
    userLanguage = @"zh_hans";
  }

  NSString *urlStr = [NSString stringWithFormat:@"%@?%@", H5URL, _claimurl];
  DebugLog(@"urlStr !!%@", urlStr);
//    if ([self screenURLString:typeStr]) {

  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
//    }
}
- (BOOL)screenURLString:(NSString *)urlString {
  NSArray *urlArray = @[@"onto.app", @"app.ont.io", @"polarisexplorer.ont.io", @"explorer.ont.io", @"service.onto.app",
      @"info.onto.app", @"swap.ont.io", @"medium.com", @"discordapp.com",
      @"oauth.io", @"api.twitter.com", @"www.facebook.com", @"facebook.com", @"twitter.com", @"assets-cdn.github.com",
      @"cdn.bootcss.com", @"www.google-analytics.com", @"api.github.com", @"github.com", @"www.linkedin.com",
      @"static.licdn.com", @"media.licdn.com", @"static.xx.fbcdn.net", @"abs-0.twimg.com", @"pbs.twimg.com",
      @"abs.twimg.com", @"scontent–lht6–1.xx.fbcdn.net", @"m.facebook.com", @"staticxx.facebook.com",
      @"pixel.facebook.com", @"googleads.g.doubleclick.net", @"https://m.tuoniaox.com",@"https://shuftipro.com"];
  for (NSString *url in urlArray) {
    if ([urlString containsString:url]) {
      return YES;
    }
  }

  return NO;
}
//将NSString转换成十六进制的字符串则可使用如下方式:
- (NSString *)convertStringToHexStr:(NSString *)str {
  if (!str || [str length] == 0) {
    return @"";
  }
  NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];

  NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];

  [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
    unsigned char *dataBytes = (unsigned char *) bytes;
    for (NSInteger i = 0; i < byteRange.length; i++) {
      NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
      if ([hexStr length] == 2) {
        [string appendString:hexStr];
      } else {
        [string appendFormat:@"0%@", hexStr];
      }
    }
  }];

  return string;
}

#pragma mark WKWebViewDelegate
/**
 webview加载完成
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
  DebugLog(@"js finish！！！");
//    _callbackJSFinish();
  [MBProgressHUD hideHUDForView:self.view animated:YES];
  [MBProgressHUD hideHUDForView:self.view animated:YES];

  self.progressView.hidden = YES;

}

/**
 webview开始加载
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
  DebugLog(@"js start！！！");
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];

  //开始加载网页时展示出progressView
  self.progressView.hidden = NO;
  //开始加载网页的时候将progressView的Height恢复为1.5倍
  self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
  //防止progressView被网页挡住
  [self.view bringSubviewToFront:self.progressView];

}
- (void)dealloc {
  [webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
/**
 webview加载失败
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
  DebugLog(@"js error！！！");
  [MBProgressHUD hideHUDForView:self.view animated:YES];
  [MBProgressHUD hideHUDForView:self.view animated:YES];
  self.progressView.hidden = YES;
}

/**
 webview拦截alert
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(
    void))completionHandler {
  DebugLog(@"alert%@", message);
  completionHandler();
}

/**
 webview拦截Confirm
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(
    BOOL))completionHandler {
  DebugLog(@"confirm%@", message);
  completionHandler(YES);
}

/**
 webview拦截Prompt
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(
    NSString *_Nullable))completionHandler {

//    [self.navigationController popViewControllerAnimated:YES];
  DebugLog(@"prompt===%@", prompt);
  [self savePrompt:prompt];
  completionHandler(@"123");
}

/**
 webview拦截js方法
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
  DebugLog(@"message:%@", message);
}

#pragma mark handlePrompt
- (void)savePrompt:(NSString *)prompt {
  NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
  NSString *resultStr = promptArray[1];

  NSDictionary *promtDic =
      [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
  DebugLog(@"%@", promtDic);
  if ([[promtDic valueForKey:@"Error"] integerValue] != 0) {

    [self.navigationController popViewControllerAnimated:YES];
    return;
  }
  WaitingViewController *vc = [[WaitingViewController alloc] init];
  NSMutableDictionary *dic =
      [NSMutableDictionary dictionaryWithDictionary:[Common dictionaryWithJsonString:[promtDic valueForKey:@"data"]]];
  [dic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_CODE] forKey:@"DeviceCode"];
  vc.promtDic = dic;
  vc.claimImage = self.claimImage;
  [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {

  [super viewWillDisappear:animated];

}

- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
  NSString
      *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
  NSError *errors;
  [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
