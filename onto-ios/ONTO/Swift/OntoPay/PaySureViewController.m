//
//  PaySureViewController.m
//  ONTO
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "PaySureViewController.h"
#import "SendConfirmView.h"
#import "ONTO-Swift.h"
@interface PaySureViewController ()
@property(nonatomic, strong) SendConfirmView *sendConfirmV;
@property(nonatomic, copy)   NSString *confirmPwd;
@property (nonatomic, strong) BrowserView *browserView;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, strong)NSDictionary * payDetailDic;
@end

@implementation PaySureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    
    [self configUI];
    
    // Do any additional setup after loading the view.
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
            
            NSLog(@"checkTrade=%@",prompt);
            NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
            NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
            self.defaultDic = dict;
            
            if ([Common isBlankString:obj[@"result"]]) {
                [self.hub hideAnimated:YES];
                [Common showToast:Localized(@"Networkerrors")];
                return;
            }
            NSDictionary * resultDic = obj[@"result"];
            if (resultDic[@"Error"]) {
                if ([resultDic[@"Error"] integerValue] >0) {
                    [self.hub hideAnimated:YES];
                    if ([resultDic[@"Error"] integerValue] == 47001) {
                        [Common showToast:Localized(@"payNot")];
                    }else{
                        NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),resultDic[@"Error"]];
                        [Common showToast:errorStr];
                    }
                    
                    return;
                }
            }
            NSDictionary * reDic = resultDic[@"Result"];
            NSArray * Notify = reDic[@"Notify"];
            for (NSDictionary * payDic in Notify) {
                NSString * ContractAddress = payDic[@"ContractAddress"];
                if ([ContractAddress isEqualToString:@"0100000000000000000000000000000000000000"]) {
                    self.isONT = YES;
                    NSArray * arr = payDic[@"States"];
                    if ([arr[1] isEqualToString:dict[@"address"]] && [arr[0] isEqualToString:@"transfer"]) {
                        self.payerAddress = arr[1];
                        self.toAddress  = arr[2];
                        self.payMoney = arr[3];
                    }else{
                    }
                }else if ([ContractAddress isEqualToString:@"0200000000000000000000000000000000000000"]) {
                    self.isONT = NO;
                    NSArray * arr = payDic[@"States"];
                    if ([arr[1] isEqualToString:dict[@"address"]] && [arr[0] isEqualToString:@"transfer"]) {
                        self.payerAddress = arr[1];
                        self.toAddress  = arr[2];
                        self.payMoney = [Common getPayMoney:[NSString stringWithFormat:@"%@",arr[3]]];
                    }else{
                    }
                }
            }
            
//            if ([Common isBlankString:self.payMoney] || [Common isBlankString:self.toAddress]) {
//                
//                NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.sendTransaction('%@','sendTransaction')",self.hashString];
//                LOADJS1;
//                LOADJS2;
//                LOADJS3;
//                __weak typeof(self) weakSelf = self;
//                [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
//                [self.browserView setCallbackPrompt:^(NSString * prompt) {
//                    [weakSelf handlePrompt:prompt];
//                }];
//                return;
//            }
            [self.hub hideAnimated:YES];
            OntoPayDetailViewController *vc = [[OntoPayDetailViewController alloc]init];
            vc.dataArray = self.dataArray;
            vc.toAddress = self.toAddress    ;
            vc.hashString = self.hashString;
            vc.payerAddress = self.payerAddress;
            vc.defaultDic = self.defaultDic;
            vc.payInfo = self.payinfoDic;
            vc.callback = self.callback  ;
            vc.isONT = self.isONT;
            vc.payMoney = self.payMoney;
            vc.payDetailDic = self.payDetailDic;
            vc.gas = [NSString stringWithFormat:@"%@",reDic[@"Gas"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([prompt hasPrefix:@"sendTransaction"]){
        [_hub hideAnimated:YES];
        if (!obj[@"error"]) {
            return;
        }
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            [Common showToast:Localized(@"sendSuccess")];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
- (void)getInvokeMessage:(NSString*)urlString{
    
    NSDictionary * pDic = self.payinfoDic[@"params"];
    self.hub=[ToastUtil showMessage:@"" toView:nil];
    if (pDic[@"callback"]) {
        self.callback = pDic[@"callback"];
    }
    urlString = pDic[@"qrcodeUrl"];
    [[CCRequest shareInstance] requestWithURLStringNoLoading:urlString MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal) {
        [self.hub hideAnimated:YES];
        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[responseOriginal valueForKey:@"error"]]];
            return;
        }
        
        if ([responseOriginal isKindOfClass:[NSDictionary class]] && responseOriginal[@"params"]) {
            NSDictionary * paramsD = responseOriginal[@"params"];
            NSDictionary * invokeConfig = paramsD[@"invokeConfig"];
            if (!invokeConfig[@"payer"]) {
                [Common showToast:Localized(@"noPayerWallet")];
                return;
            }
            if (![self.defaultDic[@"address"] isEqualToString:invokeConfig[@"payer"]]) {
                [Common showToast:Localized(@"noPayerWallet")];
                return;
            }
        }
        
        self.payDetailDic = responseOriginal;
        self.sendConfirmV.paybyStr = @"";
        self.sendConfirmV.amountStr = @"";
        self.sendConfirmV.isWalletBack = YES;
        [self.sendConfirmV show];
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        NSLog(@"222=%@",responseOriginal);
        [self.hub hideAnimated:YES];
    }];
}
-(void)configUI{
    [self.view addSubview:self.browserView];
    UIImageView * imageV =[[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"RegisterONTOLogo"];
    [self.view addSubview:imageV];
    
    UILabel * thirdName = [[UILabel alloc]init];
    thirdName.text = Localized(@"dapppay");
    thirdName.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [thirdName changeSpace:0 wordSpace:1*SCALE_W];
    thirdName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thirdName];
    
    UILabel * requiredLB = [[UILabel alloc]init];
    requiredLB.text = Localized(@"dappneed");
    requiredLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [requiredLB changeSpace:0 wordSpace:1];
    requiredLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:requiredLB];
    
    UIImageView * dotImage1 =[[UIImageView alloc]init];
    dotImage1.layer.cornerRadius = 3.5*SCALE_W;
    dotImage1.backgroundColor = [UIColor colorWithHexString:@"#6E6F70"];
    [self.view addSubview:dotImage1];
    
    UIImageView * dotImage2 =[[UIImageView alloc]init];
    dotImage2.layer.cornerRadius = 3.5*SCALE_W;
    dotImage2.backgroundColor = [UIColor colorWithHexString:@"#6E6F70"];
    [self.view addSubview:dotImage2];
    
    UILabel * requiredLB1 =[[UILabel alloc]init];
    requiredLB1.numberOfLines = 0;
    requiredLB1.text = Localized(@"dapppre");
    requiredLB1.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [requiredLB1 changeSpace:0 wordSpace:1];
    requiredLB1.textAlignment = NSTextAlignmentLeft;
    requiredLB1.numberOfLines = 0;
    [self.view addSubview:requiredLB1];
    
    UILabel * requiredLB2 =[[UILabel alloc]init];
    requiredLB2.numberOfLines = 0;
    requiredLB2.text = Localized(@"dappsure");
    requiredLB2.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [requiredLB2 changeSpace:0 wordSpace:1];
    requiredLB2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:requiredLB2];
    
    UILabel * FromLB =[[UILabel alloc]init];
    FromLB.text = Localized(@"dappWallet");
    FromLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [FromLB changeSpace:0 wordSpace:1];
    FromLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:FromLB];
    
    UIButton * btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:Localized(@"NEWCONFIRM") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [btn.titleLabel changeSpace:0 wordSpace:3*SCALE_W];
    [self.view addSubview:btn];
    
    UILabel * nameLB =[[UILabel alloc]init];
    nameLB.text = self.defaultDic[@"label"];
    nameLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
//    [nameLB changeSpace:0 wordSpace:1];
    nameLB.textColor = [UIColor colorWithHexString:@"#6E6F70"];
    nameLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:nameLB];
    
    UILabel * addressLB =[[UILabel alloc]init];
    addressLB.text = self.defaultDic[@"address"];
    addressLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
//    [nameLB changeSpace:0 wordSpace:1];
    addressLB.textColor = [UIColor colorWithHexString:@"#000000"];
    addressLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:addressLB];
    
    UIView * line =[[ UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self.view addSubview:line];
    

    UIButton * whatBtn = [[UIButton alloc]init];
    [whatBtn setImage:[UIImage imageNamed:@"cotlink"] forState:UIControlStateNormal];
    [whatBtn setTitle:Localized(@"whatPre") forState:UIControlStateNormal];
    [whatBtn setTitleColor:[UIColor colorWithHexString:@"#216ed5"] forState:UIControlStateNormal];
    whatBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [self.view addSubview:whatBtn];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(15*SCALE_W);
        make.width.height.mas_offset(60*SCALE_W);
    }];
    
    [thirdName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(15*SCALE_W);
        make.centerX.equalTo(self.view);
    }];
    
    [requiredLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(thirdName.mas_bottom).offset(30*SCALE_W);
    }];
    
    [dotImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.width.height.mas_offset(7*SCALE_W);
        make.top.equalTo(requiredLB.mas_bottom).offset(19*SCALE_W);
    }];
    
    
    
    [requiredLB1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35*SCALE_W);
        make.right.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(requiredLB.mas_bottom).offset(15*SCALE_W);
    }];
    
    [dotImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.width.height.mas_offset(7*SCALE_W);
        make.top.equalTo(requiredLB1.mas_bottom).offset(10*SCALE_W);
    }];
    [requiredLB2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35*SCALE_W);
        make.right.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(requiredLB1.mas_bottom).offset(5*SCALE_W);
    }];
    
    [FromLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(requiredLB2.mas_bottom).offset(18*SCALE_W);
    }];
    
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(FromLB.mas_bottom).offset(12*SCALE_W);
    }];
    
    [addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FromLB);
        make.top.equalTo(nameLB.mas_bottom).offset(6*SCALE_W);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.height.mas_offset(1);
        make.top.equalTo(addressLB.mas_bottom).offset(18*SCALE_W);
    }];
    
    [whatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_offset(25*SCALE_W);
        make.top.equalTo(line.mas_bottom).offset(15*SCALE_W);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(58*SCALE_W);
        make.right.equalTo(self.view).offset(-58*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-40*SCALE_W - 34);
        }else{
            make.bottom.equalTo(self.view).offset(-40*SCALE_W );
        }
    }];
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self getInvokeMessage:@""];
    }];
    
    [whatBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        WebIdentityViewController *VC= [[WebIdentityViewController alloc]init];
        if ([ENORCN isEqualToString:@"cn"]) {
            VC.introduce = @"https://info.onto.app/#/detail/85";
        }else{
            VC.introduce = @"https://info.onto.app/#/detail/86";
        }
        
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
// 导航栏设置
- (void)configNav {
    [self setNavLeftImageIcon:[UIImage imageNamed:@"cotback"] Title:Localized(@"Back")];
    
}

// 返回
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
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
