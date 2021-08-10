//
//  ImportViewController.m
//  ONTO
//
//  Created by Zeus.Zhang on 2018/2/27.
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

#import "ImportViewController.h"
#import "SGQRCode.h"
#import "BackView.h"
#import "ImportEnterViewController.h"
#import "ConfirmPwdViewController.h"
#import "ToastUtil.h"
#import "SendViewController.h"
#import <Photos/Photos.h>
#import "ThirdpartyViewController.h"
#import "ONTO-Swift.h"
#import "SendConfirmView.h"
#import "PaySureViewController.h"
@interface ImportViewController () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>

@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, copy) NSString *thirdOntId;
@property (nonatomic, copy) NSString *session;
@property (nonatomic, strong) BrowserView *browserView;
@property (nonatomic, copy) NSString *hashString;
@property (nonatomic, copy) NSString *payAddress;
@property (nonatomic, copy) NSString *toAddress;
@property (nonatomic, copy) NSString *payMoney;
@property (nonatomic, strong)NSMutableArray * walletArray;
@property (nonatomic, strong)NSDictionary * defaultDic;
@property (nonatomic, strong)NSDictionary * payinfoDic;
@property (nonatomic, strong)NSDictionary * payDetailDic;
@property(nonatomic, strong) SendConfirmView *sendConfirmV;
@property(nonatomic, copy)   NSString *confirmPwd;
@property(nonatomic, copy)   NSString *callbackURL;
@property(nonatomic, assign)   BOOL  isONT;
@end

@implementation ImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"CameraRights") message:@"" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
        return;
    }
    self.callbackURL = @"";
    // Do any additional setup after loading the view.
    [self setupQRCodeScanning];
    [self.view addSubview:self.scanningView];
    [self configScanningView];
    //JS初始化
    [self.view addSubview:self.browserView];
}
- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
            [weakSelf handlePrompt:prompt];
        }];
        [_browserView setCallbackJSFinish:^{
//            [weakSelf loadJS];
        }];
    }
    return _browserView;
}
-(void)makeTradeByKey:(NSString*)keyString{
    NSString *str = [self convertToJsonData:self.payDetailDic];
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.makeDappTransaction('%@','%@','makeDappTransaction')",str,keyString];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
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
- (void)handlePrompt:(NSString *)prompt{
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            self.confirmPwd = @"";
            self.payDetailDic = [NSDictionary dictionary];
            MGPopController
            *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
            MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor = MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
        }else{
            [self.sendConfirmV dismiss];
            [self makeTradeByKey:obj[@"result"]];
        }
    }else if ([prompt hasPrefix:@"makeDappTransaction"]){
        self.hashString = obj[@"result"];
        NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.checkTransaction('%@','checkTrade')",obj[@"result"]];
        
        LOADJSPRE;
        LOADJS2;
        LOADJS3;
        __weak typeof(self) weakSelf = self;
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        [self.browserView setCallbackPrompt:^(NSString * prompt) {
            [weakSelf handlePrompt:prompt];
        }];
    }else if ([prompt hasPrefix:@"checkTrade"]){
        NSLog(@"checkTrade=%@",obj);
        
        if ([prompt hasPrefix:@"checkTrade"]) {
            [self.hub hideAnimated:YES];
            NSLog(@"checkTrade=%@",prompt);
            NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
            NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
            self.defaultDic = dict;
            
            NSDictionary * resultDic = obj[@"result"];
            NSDictionary * reDic = resultDic[@"Result"];
            NSArray * Notify = reDic[@"Notify"];
            for (NSDictionary * payDic in Notify) {
                NSString * ContractAddress = payDic[@"ContractAddress"];
                if ([[ContractAddress substringToIndex:2] isEqualToString:@"01"]) {
                    self.isONT = YES;
                    NSArray * arr = payDic[@"States"];
                    if ([arr[1] isEqualToString:dict[@"address"]]) {
                        self.payAddress = arr[1];
                        self.toAddress  = arr[2];
                        self.payMoney = arr[3];
                    }else{
                    }
                }else if ([[ContractAddress substringToIndex:2] isEqualToString:@"02"]) {
                    self.isONT = NO;
                    NSArray * arr = payDic[@"States"];
                    if ([arr[1] isEqualToString:dict[@"address"]]) {
                        self.payAddress = arr[1];
                        self.toAddress  = arr[2];
                        self.payMoney = [Common getPayMoney:[NSString stringWithFormat:@"%@",arr[3]]];
                    }else{
                    }
                }
            }
            OntoPayDetailViewController *vc = [[OntoPayDetailViewController alloc]init];
            vc.dataArray = self.walletArray;
            vc.toAddress = self.toAddress    ;
            vc.hashString = self.hashString;
            vc.payerAddress = self.payAddress;
            vc.defaultDic = self.defaultDic;
            vc.payInfo = self.payinfoDic;
            vc.callback = self.callbackURL ;
            vc.isONT = self.isONT;
            vc.payMoney = self.payMoney;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
   
}
- (void)configScanningView {
    BackView *backV = [[BackView alloc] initWithFrame:CGRectZero];
    if (self.isCOT) {
        backV.isCOT =self.isCOT;
    }
    [backV setCallbackBack:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.scanningView addSubview:backV];
    
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scanningView).offset(20);
        make.top.equalTo(self.scanningView).offset(StatusBarHeight+3);
        make.height.mas_equalTo(@30);
    }];
    [backV layoutIfNeeded];
    
    UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [albumBtn setTitle:Localized(@"Album") forState:UIControlStateNormal];
    albumBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [albumBtn setTitleColor:[UIColor colorWithHexString:@"#33c4dc"] forState:UIControlStateNormal];
    albumBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [albumBtn addTarget:self action:@selector(albumAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scanningView addSubview:albumBtn];
    
    [albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scanningView).offset(-24);
        make.centerY.mas_equalTo(backV);
    }];
    
    UILabel *alertL = [[UILabel alloc] init];
    alertL.font = K12FONT;
    alertL.textColor = [UIColor whiteColor];
    alertL.textAlignment = NSTextAlignmentCenter;
    alertL.text = Localized(@"EncryptedNote");
    [self.scanningView addSubview:alertL];
  
    [alertL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scanningView);
        make.bottom.equalTo(self.scanningView).offset(-50);
    }];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:Localized(@"EncryptedPrivateKey") forState:UIControlStateNormal];
    changeBtn.titleLabel.font = K14BFONT;
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.layer.cornerRadius = 1;
    changeBtn.layer.masksToBounds = YES;
    [changeBtn setBackgroundColor:[UIColor colorWithHexString:@"#88d5ff"]];
    [changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scanningView addSubview:changeBtn];
   
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(289, 50));
        make.bottom.equalTo(alertL.mas_top).offset(-28);
        make.centerX.mas_equalTo(self.scanningView);
        make.height.mas_equalTo(@50);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    
    UIImageView *pwdIV = [[UIImageView alloc] init];
    pwdIV.image = [UIImage imageNamed:@"pwd"];
    [self.scanningView addSubview:pwdIV];
    
    [pwdIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 19));
        make.centerX.mas_equalTo(self.scanningView);
        make.bottom.equalTo(changeBtn.mas_top).offset(-18);
    }];
    
    UIView * whiteBG =[[UIView alloc]init];
    whiteBG.backgroundColor = [UIColor whiteColor];
    [self.scanningView addSubview:whiteBG];
    [whiteBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scanningView);
        make.top.equalTo(self.scanningView).offset(72*SCALE_W+SafeAreaTopHeight);
        make.height.mas_offset(50*SCALE_W);
        make.width.mas_offset(260*SCALE_W);
    }];
    
    UIView *dot =[[UIView alloc]init];
    dot.backgroundColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [whiteBG addSubview:dot];
    [dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(whiteBG.mas_centerY);
        make.right.equalTo(whiteBG.mas_right).offset(-19.5*SCALE_W);
        make.width.height.mas_offset(10*SCALE_W);
    }];
//
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = _isWallet||_isVerb||_isReceiverAddress?Localized(@"Scanwallent"):Localized(@"ScanIdentity");

    
//    if (_isReceiverAddress) {
//
//    }
    [whiteBG addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor blackColor]; //[UIColor colorWithHexString:@"35BFDF"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.scanningView);
        make.top.equalTo(whiteBG);
        make.left.equalTo(whiteBG.mas_left).offset(19);
        make.size.mas_equalTo(CGSizeMake(241*SCALE_W, 50*SCALE_W));
    }];
    
    
    
    
    if (_isThired) {
        albumBtn.hidden = YES;
        alertL.hidden = YES;
        changeBtn.hidden = YES;
         titleLabel.text = Localized(@"ScanLogin");
    }
    if (_isKeyStore) {
        titleLabel.text = Localized(@"Scankeystore");
    }
    if (_isShareWalletAddress) {
        titleLabel.text = Localized(@"ScanShareCode");
    }
    if (_isCOT) {
        titleLabel.text = Localized(@"IMScanAuthorize");
//        [self setNavLeftImageIcon:[UIImage imageNamed:@"cotback"] Title:@""];
    }
    if (_isPay) {
        titleLabel.text = Localized(@"ONTOPay");
    }
    if (_isReceiverAddress) {
         albumBtn.hidden = YES;
        changeBtn.hidden = YES;
    }
    
    if (_isWallet==NO&&_isVerb==NO&&_isKeyStore==YES&&_isImportWallet==NO) {
        titleLabel.text = Localized(@"ScanIdentity");
    }
    
    albumBtn.hidden = YES;
    alertL.hidden = YES;
    changeBtn.hidden = YES;
    pwdIV.hidden = YES;
}
- (SendConfirmView *)sendConfirmV {
    
    if (!_sendConfirmV) {
        
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            weakSelf.confirmPwd = password;
            [weakSelf loadPswJS];
        }];
    }
    return _sendConfirmV;
}
- (void)loadPswJS{
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    if (dict.count == 0) {
        return;
    }
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",dict[@"key"],[Common transferredMeaning:_confirmPwd],dict[@"address"],dict[@"salt"]];
    
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
- (void)albumAction {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"AlbumRights") message:@"" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
        return;
    }
    
    SGQRCodeAlbumManager *albumManager = [SGQRCodeAlbumManager sharedManager];
    [albumManager readQRCodeFromAlbumWithCurrentController:self];
    albumManager.delegate = self;

}
- (void)changeAction {
    ImportEnterViewController *vc = [[ImportEnterViewController alloc] initWithNibName:@"ImportEnterViewController" bundle:nil];
    vc.isWallet = _isWallet;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    _manager.delegate = self;
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height)];
    }
    return _scanningView;
}

- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.payDetailDic = [NSDictionary dictionary];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"CameraRights") message:@"" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
        return;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager startRunning];
    [_manager resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.scanningView removeTimer];
    [_manager stopRunning];
    [_manager cancelSampleBufferDelegate];
}

- (void)dealloc {
    DebugLog(@"WCQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

#pragma mark SGQRCodeScanManagerDelegate
//扫描回调
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    
    
//    DebugLog(@"metadataObjects=%@",[metadataObjects[0] valueForKey:@"stringValue"]);
//    if (metadataObjects.count ==0) {
//        [ToastUtil shortToast:self.view value:@"error"];
//        return;
//    }
//    
//    if (![Common dictionaryWithJsonString:[metadataObjects[0] valueForKey:@"stringValue"]]) {
//        if (!_isVerb) {
//            [ToastUtil shortToast:self.view value:@"error"];
//
//        }
//        return;
//    }
//    <__NSArrayM 0x1c04531a0>(
//                             <AVMetadataMachineReadableCodeObject: 0x1c023de40, type="org.iso.QRCode", bounds={ 0.5,0.4 0.1x0.2 }>corners { 0.5,0.6 0.6,0.6 0.6,0.4 0.5,0.4 }, time 211451718196916, stringValue "ATfjyFnafWU1GZ1U6wDHU2cTaBaXzJYpBW"
//                             )
    if (self.scanType == ScanWithDraw) {
        if(_callback){
            _callback([metadataObjects[0] valueForKey:@"stringValue"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        if (_callback) {
            [_manager stopRunning];
            NSString * callbackString = [metadataObjects[0] valueForKey:@"stringValue"];
            if (_isCOT) {
                NSDictionary * dic = [Common dictionaryWithJsonString:callbackString];
                NSLog(@"paydic=%@",dic);
                self.payinfoDic = dic;
                self.walletArray = [NSMutableArray array];
                if ([dic isKindOfClass:[NSDictionary class]] && dic[@"action"]) {
                    NSArray * arr = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
                    if (arr.count == 0 || arr == nil) {
                        [Common showToast:Localized(@"NoWallet")];
                        return;
                    }else{
                        for (NSDictionary *  subDic in arr) {
                            if (subDic[@"label"] != nil) {
                                [self.walletArray addObject:subDic];
                            }
                        }
                        if (self.walletArray.count == 0) {
                            [Common showToast:Localized(@"NoWallet")];
                            return;
                        }
                    }
                    if ([dic[@"action"] isEqualToString:@"login"]) {
                        OntoPayViewController * vc =[[OntoPayViewController alloc]init];
                        vc.walletArr = self.walletArray;
                        vc.payInfo = dic;
                        [self.navigationController pushViewController:vc animated:YES];
                        [_manager stopRunning];
                        return;
                    }else if ([dic[@"action"] isEqualToString:@"invoke"]) {
                        NSDictionary * pDic = dic[@"params"];
                        [_manager stopRunning];
                        
                        if (pDic[@"callback"]) {
                            self.callbackURL = pDic[@"callback"];
                        }
                        
//                        self.payinfoDic = dic;
//
//                        self.hub=[ToastUtil showMessage:@"" toView:nil];
//                        [self getInvokeMessage:pDic[@"qrcodeUrl"]];
                        
                        NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
                        NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
                        
                        PaySureViewController * payVc = [[PaySureViewController alloc]init];
                        payVc.payinfoDic = dic;
                        payVc.defaultDic = dict;
                        payVc.dataArray = self.walletArray;
                        [self.navigationController pushViewController:payVc animated:YES];
                        return;
                    }
                }
                
            }
            _callback(callbackString);
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            if (_isThired==YES) {
                
                [_manager stopRunning];
                NSString *str = [metadataObjects[0] valueForKey:@"stringValue"];
                
                // 1.创建一个网络路径
                NSURL *url = [NSURL URLWithString:str];
                // 2.创建一个网络请求
                NSURLRequest *request =[NSURLRequest requestWithURL:url];
                // 3.获得会话对象
                NSURLSession *session = [NSURLSession sharedSession];
                // 4.根据会话对象，创建一个Task任务：
                NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    DebugLog(@"从服务器获取到数据");
                    /*
                     对从服务器获取到的数据data进行相应的处理：
                     */        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                    
                    DebugLog(@"!!!%@",dict);
                    [self getThirdinfoWithUrlStr:[dict valueForKey:@"UrlCN"]];
                    _thirdOntId = [dict valueForKey:@"OntId"];
                    _session = [dict valueForKey:@"SessionId"];
                    
                }];
                // 5.最后一步，执行任务（resume也是继续执行）:
                [sessionDataTask resume];
                
                //            [self getThirdinfoWithUrlStr:];
                return;
            }
            
            NSDictionary *strDict = [Common dictionaryWithJsonString:[metadataObjects[0] valueForKey:@"stringValue"]];
            
            //导入钱包或身份
            if (_isVerb==NO) {
                if (strDict && ([[strDict valueForKey:@"type"] isEqualToString:@"I"] || [[strDict valueForKey:@"type"] isEqualToString:@"A"] )) {
                    ConfirmPwdViewController *vc = [[ConfirmPwdViewController alloc] init];
                    if ([[strDict valueForKey:@"type"] isEqualToString:@"A"]) {
                        vc.isWallet = YES;
                    }
                    vc.encryptedStr = [strDict valueForKey:@"key"];
                    vc.identityName = [strDict valueForKey:@"label"];
                    vc.prefix = [strDict valueForKey:@"prefix"];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    
                    
                    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"ScanQrFail") message:nil image:nil];
                    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                    action.titleColor =MainColor;
                    [pop addAction:action];
                    [pop show];
                    pop.showCloseButton = NO;
                    
                    
                }
            }else{
                
                SendViewController *vc = [[SendViewController alloc]init];
                vc.walletAddr =(NSString*)[metadataObjects[0] valueForKey:@"stringValue"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    }
        [_manager stopRunning];
}

//根据光线强弱打开手电筒
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    
}

#pragma mark SGQRCodeAlbumManagerDelegate
/// 图片选择控制器取消按钮的点击回调方法
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    
}

/// 图片选择控制器读取图片二维码信息成功的回调方法
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    
    if (_callback) {
        _callback(result);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
    DebugLog(@"result=%@",result);
        ;
    NSDictionary *strDict = [self parseJSONStringToNSDictionary:[result stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        
     
        
        
    if (result && [[strDict valueForKey:@"type"] isEqualToString:@"I"]) {
        ConfirmPwdViewController *vc = [[ConfirmPwdViewController alloc] init];
        vc.encryptedStr = [strDict valueForKey:@"key"];
        vc.identityName = [strDict valueForKey:@"label"];
        vc.prefix = [strDict valueForKey:@"prefix"];

        //第一次导入
//        if (![[NSUserDefaults standardUserDefaults] objectForKey:APP_ACCOUNT]) {
              if (![Common getEncryptedContent:APP_ACCOUNT]) {

                  [self.navigationController pushViewController:vc animated:YES];
        }else{
            //以后导入
            
            NSDictionary *jsDic= [self parseJSONStringToNSDictionary:[Common getEncryptedContent:APP_ACCOUNT]];
            NSArray *idenArr = jsDic[@"identities"];
            for (int i=0; i<idenArr.count; i++) {
                NSDictionary *dic = idenArr[i];
                //身份导入重复时
                if ([[strDict valueForKey:@"key"] isEqualToString:[[[dic valueForKey:@"controls"] objectAtIndex:0] valueForKey:@"key"]]) {
            
                    
                    
                    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Alreadyin") message:nil image:nil];
                    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                        [self.navigationController popViewControllerAnimated:YES];

                    }];
                    action.titleColor =MainColor;
                    [pop addAction:action];
                    [pop show];
                    pop.showCloseButton = NO;
                    
                    return;
                }
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
      
    } else if(result && [[strDict valueForKey:@"type"] isEqualToString:@"A"]){
       
        //钱包重复导入是
        NSArray *idenArr = [[NSUserDefaults standardUserDefaults] objectForKey:ALLASSET_ACCOUNT];
        for (int i=0; i<idenArr.count; i++) {
            NSDictionary *dic = idenArr[i];
            if ([[strDict valueForKey:@"key"] isEqualToString:[dic valueForKey:@"key"]]) {
                
//                MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletAlreadyin") message:nil image:nil];
//                MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//                    [self.navigationController popViewControllerAnimated:YES];
//
//                }];
//                action.titleColor =MainColor;
//                [pop addAction:action];
//                [pop show];
//                pop.showCloseButton = NO;

                return;
            }
        }
        ConfirmPwdViewController *vc = [[ConfirmPwdViewController alloc] init];
        vc.encryptedStr = [strDict valueForKey:@"key"];
        vc.identityName = [strDict valueForKey:@"label"];
        vc.isWallet = YES;
        vc.prefix = [strDict valueForKey:@"prefix"];

        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [Common showToast:Localized(@"Photoimportfailed")];
//         [ToastUtil shortToast:self.view value:Localized(@"Photoimportfailed")];
        
    }
    }
}

- (void)getInvokeMessage:(NSString*)urlString{
    
    
    [[CCRequest shareInstance] requestWithURLStringNoLoading:urlString MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal) {
       [self.hub hideAnimated:YES];
        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[responseOriginal valueForKey:@"error"]]];
            return;
        }
        if (self.payDetailDic.count > 0) {
            return;
        }
        MGPopController
        *pop = [[MGPopController alloc] initWithTitle:Localized(@"preInput") message:nil image:nil];
        MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            self.payDetailDic = responseOriginal;
            self.sendConfirmV.paybyStr = @"";
            self.sendConfirmV.amountStr = @"";
            self.sendConfirmV.isWalletBack = YES;
            [self.sendConfirmV show];
        }];
        action.titleColor = MainColor;
        MGPopAction *action1 =   [MGPopAction actionWithTitle:Localized(@"Cancel") action:^{
            self.payDetailDic = [NSDictionary dictionary];
            [_manager startRunning];
        }];
        [pop addAction:action];
        [pop addAction:action1];
        [pop show];
        pop.showCloseButton = NO;
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        NSLog(@"222=%@",responseOriginal);
        [self.hub hideAnimated:YES];
    }];
}
- (void)getThirdinfoWithUrlStr:(NSString*)Str{
    
    [[CCRequest shareInstance] requestWithURLStringNoLoading:Str MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal) {
        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[responseOriginal valueForKey:@"error"]]];
//            [ToastUtil shortToast:self.view value:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[responseOriginal valueForKey:@"error"]]];
            return;
        }
        
        ThirdpartyViewController *vc = [[ThirdpartyViewController alloc]init];
        vc.dic = responseObject;
        vc.thirdOntId = _thirdOntId;
        vc.seesion = _session;
        [self.navigationController pushViewController:vc animated:YES];
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        
    }];
}

-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

/// 图片选择控制器读取图片二维码信息失败的回调函数
- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    [Common showToast:Localized(@"Photoimportfailed")];
//    [ToastUtil shortToast:self.view value:Localized(@"Photoimportfailed")];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
