//
//  CommonOCAdapter.m
//  ONTO
//
//  Created by PC-269 on 2018/8/27.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "CommonOCAdapter.h"
#import "ImportViewController.h"
#import "DataBase.h"
#import "ClaimModel.h"
#import "UIViewController+HUD.h"
#import "Common.h"
#import "ToastUtil.h"
#import "SendConfirmView.h"
#import "IdentityModel.h"
#import <MJExtension/MJExtension.h>
#import "ONTO-Swift.h"

//#define LOADJS1 [self.browserView.wkWebView evaluateJavaScript:SERVERNODE completionHandler:nil]
//#define LOADJS2 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setSocketPort('20335')" completionHandler:nil]
//#define LOADJS3 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setRestPort('20334')" completionHandler:nil]

#define LOADJS11(x) [x.browserView.wkWebView evaluateJavaScript:SERVERNODE completionHandler:nil]
#define LOADJS22(x) [x.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setSocketPort('20335')" completionHandler:nil]
#define LOADJS33(x) [x.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setRestPort('20334')" completionHandler:nil]

@interface CommonOCAdapter()

@property(nonatomic, strong) MBProgressHUD *hub;
@property(nonatomic, strong) SendConfirmView *sendConfirmV;

@end

@implementation CommonOCAdapter


+ (CommonOCAdapter*)share
{
    static dispatch_once_t pred = 0;
    __strong static id _shared_Object = nil;
    dispatch_once(&pred, ^{
        _shared_Object = [[self alloc] init];
    });
    return _shared_Object;
}

-(id)init {
    self = [super init];
    if (self) {
        
        //test
        [self bKycVerfied];
    }
    
    return self;
}

//MARK: - QR Scan
//调用扫描
- (void)showQrScan:(UIViewController *)baseController handler:(RequestCommonBlock)handler {
    
    ImportViewController *vc =[[ImportViewController alloc]init];
    vc.isWallet = YES;
    vc.scanType = ScanWithDraw;
    [vc setCallback:^(NSString *stringValue) {
        DebugLog(@"stringValue%@",stringValue);
        //[weakSelf createCOT:stringValue handler:handler];
        NSString *v = [stringValue stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        if(!(v != nil && [v length])){
            handler(false,nil);
            return ;
        }
        
        NSDictionary *d = @{@"value":v};
        if(handler){
            handler(YES,d);
        }
    }];
//    vc.isCOT =YES;
    [baseController.navigationController pushViewController:vc animated:true];
}

-(void)createCOT:(NSString*)string inCv:(UIViewController *)cv handler:(RequestCommonBlock)handler{
    
    MBProgressHUD *hub=[ToastUtil showMessage:@"" toView:nil];
    NSDictionary *params = [Common dictionaryWithJsonString:string].mutableCopy;
    NSLog(@"params=%@",params);
//    [[CCRequest shareInstance] requestWithURLString:[NSString stringWithFormat:@"%@/%@",COTInfo,[ENORCN isEqualToString:@"cn"] ? @"CN" : @"EN"] MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
//        [hub hideAnimated:YES];
//        NSLog(@"responseOriginal--%@",responseOriginal);
//        NSDictionary *dic =responseOriginal[@"Result"];
//        NSDictionary *ReqContexts =dic[@"ReqContexts"];
//        NSArray *OArray = ReqContexts[@"O"];
//        NSDictionary *ODic = OArray[0];
//        NSArray *ReqContextsArray =ODic[@"Contexts"];
//
//
//        NSArray * MArray =ReqContexts[@"M"];
//        if (MArray.count==0) {
//            int num =0;
//            for (NSDictionary *idmType in OArray) {
//                ClaimModel *claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:idmType[@"ClaimContext"] andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
//                if ([Common isBlankString:claimmodel.OwnerOntId]) {
//                    num ++;
//                }
//            }
//            if (num <ReqContextsArray.count) {
//                COTListViewController *vc = [[COTListViewController alloc]init];
//                vc.resultDic = dic;
//                vc.certArray = OArray;
//                [cv.navigationController pushViewController:vc animated:YES];
//            }else{
//                GetCertViewController *vc = [[GetCertViewController alloc]init];
//                vc.certArray = OArray;
//                vc.resultDic = dic;
//                [cv.navigationController pushViewController:vc animated:YES];
//            }
//        }else{
//            COTMListViewController *vc =[[COTMListViewController alloc]init];
//            vc.resultArr = MArray;
//            vc.resultDic = dic;
//            vc.resultOArr = OArray;
//            [cv.navigationController pushViewController:vc animated:YES];
//        }
//    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
//        [hub hideAnimated:YES];
//
//        if ([responseOriginal[@"Error"] integerValue] == 62001 ||[responseOriginal[@"Error"] integerValue] == 61003 ) {
//            [cv showHint:Localized(@"invalidQRCode") yOffset:200];
//        }else if ([responseOriginal[@"Error"] integerValue] == 62003 ){
//            [cv showHint:Localized(@"sceneUnusual") yOffset:200];
//        }else {
//            NSString* msg = responseOriginal[@"message"];
//            if(msg == nil || msg.length == 0){
//                return ;
//            }
//
//            [cv showHint:msg yOffset:200];
//        }
//    }];
    [[CCRequest shareInstance] requestWithURLString:[NSString stringWithFormat:@"%@/%@",COTInfo,[ENORCN isEqualToString:@"cn"] ? @"CN" : @"EN"] MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        [hub hideAnimated:YES];
        NSDictionary *dic =responseOriginal[@"Result"];
        NSDictionary *ReqContexts =dic[@"ReqContexts"];
        NSArray *OArray = ReqContexts[@"O"];
        NSArray *ReqContextsArray = nil;;
        if(OArray.count > 0){
            NSDictionary *ODic = OArray[0];
            ReqContextsArray =ODic[@"Contexts"];
        }
        
        NSArray * MArray =ReqContexts[@"M"];
        if (MArray.count==0) {
            int num =0;
            for (NSDictionary *idmType in OArray) {
                ClaimModel *claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:idmType[@"ClaimContext"] andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
                if ([Common isBlankString:claimmodel.OwnerOntId]) {
                    num ++;
                }
            }
            if (num <ReqContextsArray.count) {
                COTListViewController *vc = [[COTListViewController alloc]init];
                vc.resultDic = dic;
                vc.certArray = OArray;
                vc.oMaxNum = [ReqContexts[@"OMaxNum"] intValue];
                vc.oMinNum = [ReqContexts[@"OMinNum"] intValue];
                [cv.navigationController pushViewController:vc animated:YES];
            }else{
                GetCertViewController *vc = [[GetCertViewController alloc]init];
                vc.certArray = OArray;
                vc.resultDic = dic;
                [cv.navigationController pushViewController:vc animated:YES];
            }
        }else{
            COTMListViewController *vc =[[COTMListViewController alloc]init];
            vc.resultArr = MArray;
            vc.resultDic = dic;
            vc.resultOArr = OArray;
            vc.oMaxNum = [ReqContexts[@"OMaxNum"] intValue];
            vc.oMinNum = [ReqContexts[@"OMinNum"] intValue];
            [cv.navigationController pushViewController:vc animated:YES];
        }
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        [hub hideAnimated:YES];
        
        if ([responseOriginal[@"Error"] integerValue] == 62001 ||[responseOriginal[@"Error"] integerValue] == 61003 ) {
            [Common showToast:Localized(@"invalidQRCode")];
        }else if ([responseOriginal[@"Error"] integerValue] == 62003 ){
            [Common showToast:Localized(@"sceneUnusual")];
        }
    }];
}

//MARK: - ONT ID
//本地是否存在OntId
+ (BOOL)bHasOntID {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@A",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]]==YES) {
        return  YES;
    }
    
    return NO;
}

+ (NSString *)getOntId {
    
    NSString *ontId = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
//     ontId = [ontId substringFromIndex:8];
    return  ontId;
}

//MARK: - common utils
+ (NSString *)getUserLanguage {
    return [[NSUserDefaults standardUserDefaults] valueForKey:HomeLanguage];
}
    
-(UITabBarController *)tabController{
    UITabBarController *tab = (UITabBarController *)APP_DELEGATE.window.rootViewController;
    if(tab == nil) {
        DebugLog(@"error! APP_DELEGATE.window.rootViewController is nil!");
        tab = [UITabBarController new];
    }
    return tab;
}
    
    -(NSInteger)indexByName:(NSString *)className {
        NSArray *arr = self.tabController.viewControllers;
        for(NSInteger i=0;i<arr.count;i++){
            UINavigationController* nav = arr[i];
            if(nav.viewControllers.count == 0){
                continue;
            }
            
            id object = nav.viewControllers[0];
            NSString *cl = NSStringFromClass([object class]);
            if([cl isEqualToString:className]){
                return  i;
            }
        }
        
        DebugLog(@"errror! can't find index in tabViewController by className %@",className);
        return -1;
    }
    
    -(void)setTabIndex:(NSString *)className {
        
        NSInteger index = [self indexByName:className];
        if(index < 0){
            return;
        }
        
        self.tabController.selectedIndex = index;
    }

//MARK: - 获取钱包地址
+ (NSArray *)getWalletList {
    
//    prompt===Ont://getAssetAccountDataStr?params={"error":0,"result":"{\"address\":\"AUqQipKSdyUdGeQjpCDEmEZwAigv88X3s2\",\"label\":\"Zhan\",\"lock\":false,\"algorithm\":\"ECDSA\",\"parameters\":{\"curve\":\"P-256\"},\"key\":\"jZs6+8i1iSgsyui2rOEd7RzqWxwcMRx6LKLS1/FWV3j/rsLmDWrjHZr32/LCxnqZ\",\"enc-alg\":\"aes-256-gcm\",\"salt\":\"HMDbo3JhlGTRhb+FgYABVw==\",\"isDefault\":false,\"publicKey\":\"03ffaac5183b46afc3060105ff7e1fe4bc67476f146082076de8e762ea9adaa1a1\",\"signatureScheme\":\"SHA256withECDSA\"}","mnemonicEnc":"eJxBgTIn7FPMTRn3D7E7ZMRA6l7fsbFBXcTPErfvKEwBlOhhEUUfnBZUzpifSZKwtNtSak10sSdAqq3Qz/pGUeUjTWc8LB9TZEOUvOv1IdcEMs85ZPEH1KWlwTc="}
//
//
//    2018-08-29 16:17:43.035648+0800 ONTO[7769:863277] ggg=Ont://getAssetAccountDataStr?params={"error":0,"result":"{\"address\":\"AUqQipKSdyUdGeQjpCDEmEZwAigv88X3s2\",\"label\":\"Zhan\",\"lock\":false,\"algorithm\":\"ECDSA\",\"parameters\":{\"curve\":\"P-256\"},\"key\":\"jZs6+8i1iSgsyui2rOEd7RzqWxwcMRx6LKLS1/FWV3j/rsLmDWrjHZr32/LCxnqZ\",\"enc-alg\":\"aes-256-gcm\",\"salt\":\"HMDbo3JhlGTRhb+FgYABVw==\",\"isDefault\":false,\"publicKey\":\"03ffaac5183b46afc3060105ff7e1fe4bc67476f146082076de8e762ea9adaa1a1\",\"signatureScheme\":\"SHA256withECDSA\"}","mnemonicEnc":"eJxBgTIn7FPMTRn3D7E7ZMRA6l7fsbFBXcTPErfvKEwBlOhhEUUfnBZUzpifSZKwtNtSak10sSdAqq3Qz/pGUeUjTWc8LB9TZEOUvOv1IdcEMs85ZPEH1KWlwTc="}
//    2018-08-29 16:17:43.036294+0800 ONTO[7769:863277] -[CreateViewController handlePrompt:] 第187行
//    ~~~~~~~~{"address":"AUqQipKSdyUdGeQjpCDEmEZwAigv88X3s2","label":"Zhan","lock":false,"algorithm":"ECDSA","parameters":{"curve":"P-256"},"key":"jZs6+8i1iSgsyui2rOEd7RzqWxwcMRx6LKLS1/FWV3j/rsLmDWrjHZr32/LCxnqZ","enc-alg":"aes-256-gcm","salt":"HMDbo3JhlGTRhb+FgYABVw==","isDefault":false,"publicKey":"03ffaac5183b46afc3060105ff7e1fe4bc67476f146082076de8e762ea9adaa1a1","signatureScheme":"SHA256withECDSA"}
    NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    DebugLog(@"allArray:%@",allArray);
    return  allArray;
}

//{
//    address = AUqQipKSdyUdGeQjpCDEmEZwAigv88X3s2;
//    algorithm = ECDSA;
//    "enc-alg" = "aes-256-gcm";
//    isDefault = 0;
//    key = "jZs6+8i1iSgsyui2rOEd7RzqWxwcMRx6LKLS1/FWV3j/rsLmDWrjHZr32/LCxnqZ";
//    label = Zhan;
//    lock = 0;
//    parameters =     {
//        curve = "P-256";
//    };
//    publicKey = 03ffaac5183b46afc3060105ff7e1fe4bc67476f146082076de8e762ea9adaa1a1;
//    salt = "HMDbo3JhlGTRhb+FgYABVw==";
//    signatureScheme = SHA256withECDSA;
//}
+ (NSString *)getPublicKey {
    
    if([[CommonOCAdapter getWalletList] count] == 0){
        DebugLog(@"error! no wallet!");
        return nil;
    }
   
    
    
//    NSDictionary *walletDict = [[CommonOCAdapter getWalletList] lastObject];
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *walletDict = [Common dictionaryWithJsonString:jsonStr];
    NSString* v = walletDict[@"publicKey"];
    return  v;
}

+ (NSDictionary *)getWalletDict {
    
    if([[CommonOCAdapter getWalletList] count] == 0){
        DebugLog(@"error! no wallet!");
        return nil;
    }
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *walletDict = [Common dictionaryWithJsonString:jsonStr];
    
    return walletDict;
}

+ (NSString *)getWalletAddress {
    
    NSDictionary *d = [self getWalletDict];
    return d[@"address"];
}

-(void)confirmPwd:(NSString *)pwd handler:(RequestCommonBlock)handler {
    
    NSString *ontId = [ZYUtilsSW getOntId];
    NSDictionary *d = [self ontAccountById:ontId];
    if(d == nil){
        return;
    }
    
    NSArray *controls = d[@"controls"];
    if(controls == nil || controls.count == 0){
        DebugLog(@"error! controls is nil!");
        if(handler){
            NSDictionary* d = @{@"msg":@"error!"};
            handler(false,d);
        }
        return;
    }
    NSDictionary *dControl = controls[0];
    NSString *address = dControl[@"address"];
    NSString *key = dControl[@"key"];
    NSString *salt = dControl[@"salt"];
    
    [self decryptPrivateKey:key pwd:pwd address:address salt:salt handler:^(BOOL bSucces, id callBacks) {
         handler(bSucces,callBacks);
    }];
}

//通过js获取验证密码是否正确
- (void)decryptPrivateKey:(NSString *)_key pwd:(NSString *)_confirmPwd address:(NSString *)address salt:(NSString *)salt handler:(RequestCommonBlock)handler{
    
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",_key,[Common transferredMeaning:_confirmPwd],address,salt];
    
    if (_confirmPwd.length==0) {
        return;
    }
    _hub = [ToastUtil showMessage:@"" toView:nil];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [_hub hideAnimated:YES];
        NSDictionary *result = [weakSelf convertDecryptResult:prompt];
        if(result[@"error"] && [result[@"error"] integerValue] == 0 ){
            handler(YES,result);
            return;
        }
        
        NSDictionary *d = @{@"msg":Localized(@"PASSWORDERROR")};
        handler(NO,d);
        return;
    }];
}

-(NSDictionary *)convertDecryptResult:(NSString *)prompt {
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    if(promptArray == nil || promptArray.count < 2){
        DebugLog(@"error!返回的prompt 不对! prompt:%@",prompt);
        return nil;
    }
    
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    return obj;
}

- (void)handlePrompt:(NSString *)prompt {
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
    
        return;
    }

}


//zhan5


//zhan6
//{
//    accounts =     (
//    );
//    createTime = "2018-09-05T13:18:08.993Z";
//    defaultAccountAddress = "";
//    defaultOntid = "did:ont:ANYvue84h7i53NbYzpqCXCmT7YejYSW3jd";
//    extra = "<null>";
//    identities =     (
//                      {
//                          controls =             (
//                                                  {
//                                                      address = ANYvue84h7i53NbYzpqCXCmT7YejYSW3jd;
//                                                      algorithm = ECDSA;
//                                                      "enc-alg" = "aes-256-gcm";
//                                                      id = 1;
//                                                      key = "BrGQdB8dh8jDj/IDfvrOBda8jbCC/gQghrOzfKJUFAqMuKsxOaLpQcC45FTb9rzf";
//                                                      parameters =                     {
//                                                          curve = "P-256";
//                                                      };
//                                                      salt = "8GnkJ8rNSKQTFAn9Ckxp8w==";
//                                                  }
//                                                  );
//                          label = Zhan5;
//                          lock = 0;
//                          ontid = "did:ont:ANYvue84h7i53NbYzpqCXCmT7YejYSW3jd";
//                      },
//                      {
//                          controls =             (
//                                                  {
//                                                      address = AKjc78oq47DzL92yX696RLwvum8yEJyUhX;
//                                                      algorithm = ECDSA;
//                                                      "enc-alg" = "aes-256-gcm";
//                                                      id = 1;
//                                                      key = HaaANHhhUZufUA3OZL8xwX7aPfi5jSLv8IcoJ8BNKEE9oHoYpaX01P3NnglFShzu;
//                                                      parameters =                     {
//                                                          curve = "P-256";
//                                                      };
//                                                      salt = "qUxMOAE3R3ky5KcgGvCOZQ==";
//                                                  }
//                                                  );
//                          label = Zhan6;
//                          lock = 0;
//                          ontid = "did:ont:AKjc78oq47DzL92yX696RLwvum8yEJyUhX";
//                      }
//                      );
//    name = Zhan5;
//    scrypt =     {
//        dkLen = 64;
//        n = 4096;
//        p = 8;
//        r = 8;
//    };
//    version = "1.0";
//}

-(NSDictionary *)ontAccountById:(NSString *)ontId {
    
    NSDictionary *dict = CommonOCAdapter.share.getOntAccount;
    NSArray *arr = dict[@"identities"];
    if(arr == nil || arr.count == 0) {
        DebugLog(@"error! arr is not exit!");
        return nil;
    }
    
    for(NSDictionary *d in arr){
        if([d[@"ontid"] isEqualToString:ontId]){
            return d;
        }
    }
    DebugLog(@"erorr! 没有找到 ontId:%@ 对应的 acount dictionary!",ontId);
    return nil;
}

-(void)loadSignJS:(NSString *)content pwd:(NSString *)confirmPwd handler:(RequestCommonBlock)handler{
    
    NSString *ontId = [ZYUtilsSW getOntId];
    NSDictionary *d = [self ontAccountById:ontId];
    if(d == nil){
        DebugLog(@"erorr! d is nil!");
        return;
    }
    
    NSArray *controls = d[@"controls"];
    if(controls == nil || controls.count == 0){
        DebugLog(@"error! controls is nil!");
        if(handler){
            NSDictionary* d = @{@"msg":@"error!"};
            handler(false,d);
        }
        return;
    }
    NSDictionary *dControl = controls[0];
    NSString *address = dControl[@"address"];
    NSString *key = dControl[@"key"];
    NSString *salt = dControl[@"salt"];
    
    NSString *jsStr =  [NSString stringWithFormat:@"Ont.SDK.signData('%@','%@','%@','%@','%@','signDataStr')",content,key,confirmPwd,address,salt];
    LOADJS11(APP_DELEGATE);
    LOADJS22(APP_DELEGATE);
    LOADJS33(APP_DELEGATE);
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
}

-(void)signContent:(NSString *)content pwd:(NSString *)confirmPwd handler:(RequestCommonBlock)handler {
    
//    NSDictionary *walletDict = [[CommonOCAdapter getWalletList] lastObject];
//    NSString* address = walletDict[@"address"];
//    NSString* key = walletDict[@"key"];
//    NSString* salt = walletDict[@"salt"];

    [self loadSignJS:content pwd:confirmPwd handler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackJSFinish:^{
        [weakSelf loadSignJS:content pwd:confirmPwd handler:nil];
    }];
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {

        NSArray *arr = [prompt componentsSeparatedByString:@"params="];
        if(arr.count < 2){
            DebugLog(@"签名失败！");
            if(handler){
                handler(false,nil);
            }
            return ;
        }
        NSString *results = arr[1];
        NSDictionary *d = [results jsonValueDecoded];
//        DebugLog(@"d = %@",d);
        //        {
        //            Algorithm = SHA256withECDSA;
        //            Format = pgp;
        //            Value = "AdksgZYwKsUEE6HqWV+cCi10YHq/W4aeYjkgvIDp70eBZyKehdtphUFBuOB0MZk3A1DCgumaSEr4q6I+iaGY7DU=";
        //        }
        if(handler){
            handler(YES,d);
        }
    }];
}

//MARK: - show confirm password
- (SendConfirmView *)showConfirmV:(UIViewController *)cv content:(NSString *)content handler:(RequestCommonBlock)handler {
    
    if (!_sendConfirmV) {
    
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, cv.view.height, kScreenWidth, kScreenHeight)];
        _sendConfirmV.isWalletBack = YES;
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            //对content进行签名
            [weakSelf signContent:content pwd:password handler:handler];
        }];
    }
    
    return _sendConfirmV;
}


//MARK: - Acount 相关
//获取账户名称余额等
- (void)getOntAccountFromSever {
    
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    NSString *jsStr;
    NSString *urlStr ;
    if ([dict isKindOfClass:[NSDictionary class]] && dict[@"label"]) {
        jsStr= [NSString stringWithFormat:@"Ont.SDK.getBalance('%@', 'getWalletBalance')", dict[@"address"]];
        urlStr= [NSString stringWithFormat:@"%@/%@",Get_Blance,dict[@"address"]];
    }else{
        jsStr= [NSString stringWithFormat:@"Ont.SDK.getBalance('%@', 'getWalletBalance')", dict[@"sharedWalletAddress"]];
        urlStr= [NSString stringWithFormat:@"%@/%@",Get_Blance,dict[@"sharedWalletAddress"]];
    }

    [[CCRequest shareInstance] requestWithURLString1:urlStr MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal) {
        
        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            
            return;
        }
        
        NSDictionary *walletDict = [NSDictionary new];
        NSString *_amount = @"";
        NSString *waitboundong = @"";
        NSString *_ongAppove = @"";
        NSString *_NET5 = @"";
        NSMutableArray* dataArray = [NSMutableArray new];
        NSLog(@"---***---%@",responseObject);
        for (NSDictionary *dic in (NSArray*)responseObject) {
            
            if ([dic[@"AssetName"] isEqualToString:@"ont"]) {
                [dataArray insertObject:@{@"type":@"ONT",@"amount":dic[@"Balance"]} atIndex:0];
                _amount = dic[@"Balance"];
                //ONT_CANDY
                [[CommonOCAdapter share] saveOntCount:dic];
            }
            if ([dic[@"AssetName"] isEqualToString:@"ong"]) {
                [dataArray addObject:@{@"type":@"ONG",@"amount":dic[@"Balance"]}];
            }
            if ([dic[@"AssetName"] isEqualToString:@"waitboundong"]) {
                 waitboundong = dic[@"Balance"];
            }
            if ([dic[@"AssetName"] isEqualToString:@"unboundong"]) {
                _ongAppove = dic[@"Balance"];
            }
        }
        
        
        if ([walletDict isKindOfClass:[NSDictionary class]] && walletDict[@"label"] ) {
            [dataArray addObject:@{@"type":@"ONT (NEP-5)",@"amount":_NET5}];
        }
        
        
        if ([walletDict isKindOfClass:[NSDictionary class]] && walletDict[@"label"]) {
//            self.addressL.text = [NSString stringWithFormat:@"%@",walletDict[@"address"]];
//            self.nameL.text = self.walletDict[@"label"];
//            self.ruleLB.hidden =YES;
        }else{
//            self.addressL.text = [NSString stringWithFormat:@"%@",walletDict[@"sharedWalletAddress"]];
//            self.nameL.text = walletDict[@"sharedWalletName"];
//            self.ruleLB.hidden =NO;
//            self.ruleLB.text =[NSString stringWithFormat:Localized(@"shareRule"),[self.walletDict[@"requiredNumber"] integerValue],[self.walletDict[@"totalNumber"]integerValue]];
        }
        
        [self getUnit];
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        DebugLog(@"error%@",responseOriginal);
        [ToastUtil shortToast:APP_DELEGATE.window.rootViewController.view value:Localized(@"NetworkAnomaly")];
        
    }];
    
    NSString *getNeoBalancejsStr;
    if ([dict isKindOfClass:[NSDictionary class]] && dict[@"label"]) {
        getNeoBalancejsStr= [NSString stringWithFormat:@"Ont.SDK.getNeoBalance('%@', 'getNeoBalance')", dict[@"address"]];
        
    }else{
        getNeoBalancejsStr= [NSString stringWithFormat:@"Ont.SDK.getNeoBalance('%@', 'getNeoBalance')", dict[@"address"]];
    }
    
    
    NSLog(@"%@",getNeoBalancejsStr);
    //节点方法 每次调用JSSDK前都必须调用
//    LOADJS1;
//    LOADJS2;
//    LOADJS3;
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:getNeoBalancejsStr completionHandler:nil];
}

- (void)getUnit{
    
    NSString *unit;
    if (![Common getUNIT]) {
        
        [[NSUserDefaults standardUserDefaults]setValue:@"USD" forKey:UNIT];
        //        }
    }else{
        unit = [Common getUNIT];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BaseURL,Get_UNIT];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            DebugLog(@"~~%@",dict);
            if ([[dict valueForKey:@"Error"] integerValue] > 0) {
                return ;
            }
            
            NSString *amount = @"";
            NSString *_exchange = @"";
            NSString *_GoalType = @"";
            NSString *money = [NSString stringWithFormat:@"%f",[[[dict valueForKey:@"Result"]valueForKey:@"Money"] floatValue]];
            NSString *goalType = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"Result"]valueForKey:@"GoalType"]];
            _exchange =money;
            _GoalType = goalType;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{//只留下主线程返回的进度数据
                double c = [amount doubleValue] * [money doubleValue];
                NSString *numStr = [NSString stringWithFormat:@"%.2f",c];
//                self.myAssetL.text =  [NSString stringWithFormat:@"%@ %@",[goalType isEqualToString:@"CNY"]?@"¥":@"$",[Common countNumAndChangeformat:numStr]];
//                self.typeL.text = [NSString stringWithFormat:@"%@", Localized(@"TotalAssets")];
            }];
        }
    }];
    //5.执行任务
    [dataTask resume];
}

//获取Ont账号信息
//{
//    accounts =     (
//    );
//    createTime = "2018-08-23T07:45:54.882Z";
//    defaultAccountAddress = "";
//    defaultOntid = "did:ont:AZ6xXZvb24xB9WwMggJAFKust5EiTAXXUs";
//    extra = "<null>";
//    identities =     (
//                      {
//                          controls =             (
//                                                  {
//                                                      address = AZ6xXZvb24xB9WwMggJAFKust5EiTAXXUs;
//                                                      algorithm = ECDSA;
//                                                      "enc-alg" = "aes-256-gcm";
//                                                      id = 1;
//                                                      key = 7gTFCRmsIlUo8T8YZ6DGn4GHEPdBl4ufMClQyCkpHDzXAYkr3TnVfIgclrBpOCOD;
//                                                      parameters =                     {
//                                                          curve = "P-256";
//                                                      };
//                                                      salt = "I5OKikgHvG8yc+6ExGcd/w==";
//                                                  }
//                                                  );
//                          label = zhanzy2;
//                          lock = 0;
//                          ontid = "did:ont:AZ6xXZvb24xB9WwMggJAFKust5EiTAXXUs";
//                      }
//                      );
//    name = zhanzy2;
//    scrypt =     {
//        dkLen = 64;
//        n = 4096;
//        p = 8;
//        r = 8;
//    };
//    version = "1.0";
//}
-(NSDictionary *)getOntAccount {
    
    NSString *str =  [Common getEncryptedContent:APP_ACCOUNT];
    NSDictionary *jsDic= [Common dictionaryWithJsonString:str];
    return jsDic;
}


//MARK: - CFCA & Identity Mind
- (BOOL)bIdentityVerified{
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:IDAUTHARR]&&[[NSUserDefaults standardUserDefaults] valueForKey:SOCIALAUCHARR]) {
        NSArray *dataArr = [[NSUserDefaults standardUserDefaults] valueForKey:IDAUTHARR];
        NSArray *socialArr = [[NSUserDefaults standardUserDefaults] valueForKey:SOCIALAUCHARR];
        NSArray* IdAuthArr =[IdentityModel mj_objectArrayWithKeyValuesArray:dataArr];
        
        ClaimModel *claimmodel = [[ClaimModel alloc] init];
        claimmodel = [[DataBase sharedDataBase] getCalimWithClaimContext:@"claim:cfca_authentication" andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
    
        IdentityModel* model = IdAuthArr[1];
        if ([model.IssuedFlag integerValue]==0 && [claimmodel.status integerValue]!=1) {
            return NO;
        }
        
        if ([model.IssuedFlag integerValue]==9 || [model.IssuedFlag integerValue]==4) {
//            claimVC.stauts = 4;
//            claimVC.isPending = YES;
            return NO;
        }else if ([model.IssuedFlag integerValue]==1){
//            claimVC.stauts = 1;
//            claimVC.isPending = NO;
            return NO;
        }else if ([model.IssuedFlag integerValue]==3){
//            claimVC.stauts = 3;
//            claimVC.isPending = NO;
            return NO;
        }
        
        return YES;
    }
    
    return  NO;
}


//是否identity 认证或 cfca 认证
-(BOOL)bKycVerfied {

    BOOL bIdentityVerified =  [[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@c",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]];
    if(bIdentityVerified){
        return YES;
    }
    
    BOOL bCfcaVerified =  [self bIdentityVerified];
    if(bCfcaVerified){
        return YES;
    }
    
    return NO;
    
}

//MARK: - common Ont candy
-(void)saveDic:(NSDictionary *)dict byKey:(NSString *)key {
    
    NSString *results = [dict jsonStringEncoded];
    [self saveInKeyChain:results key:key];
    DebugLog(@"get store sestion:%@ ",results);
}

-(id)objectValueForKey:(NSString *)key {
    
    NSString *last = [Common getEncryptedContent:key];
    NSDictionary *d = [last jsonValueDecoded];
    return  d;
}

-(NSString *)getOntAmout {
    NSDictionary *d = [self objectValueForKey:ONTID_CANDY_AMOUNT];
    NSString *amount = d[@"Balance"];
    if(amount != nil){
        return amount;
    }
    
    return @"";
}

-(void)saveOntCount:(NSDictionary *)dict {
    
    [self saveDic:dict byKey:ONTID_CANDY_AMOUNT];
}

-(NSDictionary *)getOntDictionary {
    NSDictionary *dict = [self objectValueForKey:ONTID_CANDY_AMOUNT];
    return  dict;
}

-(void)saveOntSession:(NSString *)results {
    
    [self saveInKeyChain:results key:ONTID_CANDY_SESSION];
    NSString *last = [self valueInKeyChain:ONTID_CANDY_SESSION];
    DebugLog(@"get store sestion:%@ ",last);
}

-(NSString *)getOntSession {
    NSString *last = [self valueInKeyChain:ONTID_CANDY_SESSION];
    DebugLog(@"get store sestion:%@ ",last);
    return  last;
}

-(void)saveInKeyChain:(NSString *)value key:(NSString *)key {
     [Common setEncryptedContent:value WithKey:key];
}

-(NSString *)valueInKeyChain:(NSString *)key {
    NSString *last = [Common getEncryptedContent:key];
    DebugLog(@"get store sestion:%@ ",last);
    return  last;
}

-(BOOL)deleteOntSession {
    return  [self deleteItemInKeyChain:ONTID_CANDY_SESSION];
}

-(BOOL)deleteItemInKeyChain:(NSString *)key {
        
    [Common deleteEncryptedContent:key];
    DebugLog(@"delete store sestion:%@ ",key);
    return  true;
}

@end
