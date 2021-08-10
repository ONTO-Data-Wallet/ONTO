//
//  WebJsView.m
//  ONTO
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "WebJsView.h"
#import "BrowserView.h"
#import "MBProgressHUD.h"
#import "Config.h"
#import "ClaimModel.h"
#import "DataBase.h"
@interface WebJsView()
@property (nonatomic, strong) BrowserView  *browserView;
@property (nonatomic, assign) BOOL         isIdentity;
@property (nonatomic, copy) NSString       *textViewText;
@property (nonatomic, copy) NSString       *pwd;
@property (nonatomic, copy) NSString       *mynewOntid;//新增identity的idd
@property (nonatomic, copy) NSString       *myAppStr;//新增后的所有identity的string
@property (nonatomic, copy) NSDictionary   *mynewDic;//新增identity的string
@property (nonatomic, strong) MBProgressHUD *hub;
@end
@implementation WebJsView
-(instancetype)initWithIdetity:(BOOL)isIdetity textViewText:(NSString*)textViewText pwd:(NSString*)pwd{
    self = [super init];
    if (self) {
        self.isIdentity = isIdetity;
        self.textViewText = textViewText;
        self.pwd = pwd;
        
        [self loadJS];
    }
    return self;
}
- (void)loadJS{
    
    [self addSubview:self.browserView];
    [_hub hideAnimated:YES];
    _hub=[ToastUtil showMessage:@"" toView:nil];
    NSDictionary *strDict = [Common dictionaryWithJsonString:self.textViewText];
    
    
    NSString *urlstr;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:IDENTITY_CREATED]) {
        //第二次导入身份
        urlstr =  [NSString stringWithFormat:@"Ont.SDK.importIdentityWithWallet('%@','%@','%@','%@','%@','importIdentityWithWallet')",strDict[@"label"],strDict[@"key"],self.pwd,strDict[@"address"],strDict[@"salt"]];
        } else {
            //第一次导入身份
            urlstr   =  [NSString stringWithFormat:@"Ont.SDK.importIdentityAndCreateWallet('%@','%@','%@','%@','%@','importIdentityAndCreateWallet')",strDict[@"label"],strDict[@"key"],self.pwd,strDict[@"address"],strDict[@"salt"]];
        }
        
        //节点方法 每次调用JSSDK前都必须调用
        LOADJS1;
        LOADJS2;
        LOADJS3;
        NSString *url = [urlstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [self.browserView.wkWebView evaluateJavaScript:url completionHandler:nil];
}
- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
            [weakSelf handlePrompt:prompt];
        }];
        [_browserView setCallbackJSFinish:^{
                        [weakSelf loadJS];
        }];
    }
    return _browserView;
}
- (void)handlePrompt:(NSString *)prompt{
    
    //创建AssetAccount
    [_hub hideAnimated:YES];
    if ([prompt hasPrefix:@"importIdentityAndCreateWallet"]) { //第一次导入身份
//        [self hideHud];
        DebugLog(@"improtIdentity=%@",prompt);
        //
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        
        
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        DebugLog(@"%@",obj);
        if ([[obj valueForKey:@"error"] integerValue] > 0)
        {
//            NSString * titleString;
//            if ([[obj valueForKey:@"error"] integerValue] == 53000)
//            {
//                //导入keyStone提示错误-bug
//                titleString = Localized(@"ImportFail");
//
//            }
//            else
//            {
//                titleString = [NSString stringWithFormat:@"%@ %@: %@",Localized(@"ImportFail"),Localized(@"Systemerror"),[obj valueForKey:@"error"]];
//            }
//            MGPopController *pop = [[MGPopController alloc] initWithTitle:titleString message:nil image:nil];
//            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//
//            }];
//            action.titleColor =MainColor;
//            [pop addAction:action];
//            [pop show];
//            pop.showCloseButton = NO;
            
            
            return;
        }
        else {
            id result = [NSJSONSerialization JSONObjectWithData:[[obj valueForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            DebugLog(@"!!!!!%@",result);
            NSMutableString *str=[obj valueForKey:@"result"];
            
            NSString *str1 =  [str stringByReplacingOccurrencesOfString:@"\"isDefault\":false" withString:@"\"isDefault\":\"false\""];
            
            NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\"isDefault\":ture" withString:@"\"isDefault\":\"ture\""];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_CREATED];
            //    [[NSUserDefaults standardUserDefaults] setValue:str2 forKey:APP_ACCOUNT];
            [Common setEncryptedContent:str2 WithKey:APP_ACCOUNT];
            
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSDictionary *jsDic= [Common dictionaryWithJsonString:str2];
            
            NSString *defaultOntid = [jsDic valueForKey:@"defaultOntid"];
            [[NSUserDefaults standardUserDefaults] setValue:defaultOntid forKey:ONT_ID];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@DeviceCode",defaultOntid] ];
            //           NSArray *identities = [jsDic valueForKey:@"identities"];
            
            NSDictionary *strDict = [Common dictionaryWithJsonString:self.textViewText];
            NSString *identityName =strDict[@"label"];
            [[NSUserDefaults standardUserDefaults] setValue:identityName forKey:IDENTITY_NAME];
            
            NSString *jsStr =  [NSString stringWithFormat:@"Ont.SDK.signData('%@','%@','%@','%@','%@','signDataStr')",defaultOntid,strDict[@"key"],self.pwd,strDict[@"address"],strDict[@"salt"]];
            
            
            LOADJS1;
            LOADJS2;
            LOADJS3;
            
            
            [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
            
        }
        
    }else if ([prompt hasPrefix:@"importIdentityWithWallet"]){
        //第二次 添加identity
        
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        if ([[obj valueForKey:@"error"] integerValue] > 0)
        {
            
//            NSString * titleString;
//            if ([[obj valueForKey:@"error"] integerValue] == 53000){
//                titleString = [NSString stringWithFormat:@"%@ %@",Localized(@"ImportFail"),Localized(@"PASSWORDERROR")];
//            }else{
//                titleString = [NSString stringWithFormat:@"%@ %@: %@",Localized(@"ImportFail"),Localized(@"Systemerror"),[obj valueForKey:@"error"]];
//            }
//            MGPopController *pop = [[MGPopController alloc] initWithTitle:titleString message:nil image:nil];
//            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//
//            }];
//            action.titleColor =MainColor;
//            [pop addAction:action];
//            [pop show];
//            pop.showCloseButton = NO;
            
            
            return;
        }
        
        id result = [NSJSONSerialization JSONObjectWithData:[[obj valueForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        DebugLog(@"!!!!!%@",result);
        NSMutableString *str=[obj valueForKey:@"result"];
        //        [Common setEncryptedContent:str WithKey:APP_ACCOUNT];
        
        NSMutableDictionary *jsDic= [NSMutableDictionary dictionaryWithDictionary:[Common dictionaryWithJsonString:[Common getEncryptedContent:APP_ACCOUNT]]];
        
        NSMutableArray *arrIdentity =[NSMutableArray arrayWithArray:jsDic[@"identities"]];
        //导入钱包数据
        NSDictionary *newDic =[Common dictionaryWithJsonString:str];
        [arrIdentity addObject:newDic];
        [jsDic setValue:arrIdentity forKey:@"identities"];
        
        NSArray *idenArr = jsDic[@"identities"];
        for (int i=0; i<idenArr.count-1; i++) {
            NSDictionary *dic = idenArr[i];
            //身份导入重复时
            if ([[newDic valueForKey:@"ontid"] isEqualToString:[dic valueForKey:@"ontid"]]) {
                
                MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Alreadyin") message:nil image:nil];
                MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                    
                }];
                action.titleColor =MainColor;
                [pop addAction:action];
                [pop show];
                pop.showCloseButton = NO;
                
                return;
            }
        }
        
        
        _mynewOntid= [newDic valueForKey:@"ontid"];
        NSDictionary *strDict = [Common dictionaryWithJsonString:self.textViewText];
        //存下时间戳和密码
        [Common setTimestampwithPassword:self.pwd WithOntId:_mynewOntid];
        
        self.myAppStr = [NSMutableString stringWithString:[Common dictionaryToJson:jsDic]];
        self.mynewDic = [NSDictionary dictionaryWithDictionary:newDic];
        
        NSString *jsStr =  [NSString stringWithFormat:@"Ont.SDK.signData('%@','%@','%@','%@','%@','newsignDataStr')",_mynewOntid,strDict[@"key"],self.pwd,strDict[@"address"],strDict[@"salt"]];
        //节点方法 每次调用JSSDK前都必须调用
        LOADJS1;
        LOADJS2;
        LOADJS3;
        
        [self addSubview:self.browserView];
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        
    }else if ([prompt hasPrefix:@"newsignDataStr"]) {
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
 
        
        NSDictionary *signature = [Common dictionaryWithJsonString:resultStr];
        NSDictionary *params = @{@"OwnerOntId":_mynewOntid,@"Signature":signature};
        
        
        
        
        [[CCRequest shareInstance] requestWithURLStringNoLoading:Devicecode_gain MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
            
            
            //导入identity后储存devicCode
            NSString *identityName = [_mynewDic valueForKey:@"label"];
            [Common setEncryptedContent:[self.myAppStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] WithKey:APP_ACCOUNT];
            [[NSUserDefaults standardUserDefaults] setValue:identityName forKey:IDENTITY_NAME];
            
            NSString *deviceCode = [responseObject valueForKey:@"DeviceCode"];
            [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:_mynewOntid];
            
//            ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
//            vc.isWallect = NO;
//            [self.navigationController pushViewController:vc animated:YES];
            //存下时间戳和密码
            [Common setTimestampwithPassword:self.pwd WithOntId:_mynewOntid];
            
            
            
            //设为默认身份
            {
                
                
                
                NSString * key = [_mynewDic valueForKey:@"key"];
                NSString * identityName = [_mynewDic valueForKey:@"label"];
                [[NSUserDefaults standardUserDefaults] setValue:[_mynewDic valueForKey:@"ontid"] forKey:ONT_ID];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@DeviceCode",[_mynewDic valueForKey:@"ontid"] ] ];
                [[NSUserDefaults standardUserDefaults] setValue:identityName forKey:IDENTITY_NAME];
                [[NSUserDefaults standardUserDefaults] setValue:key forKey:ENCRYPTED_PRIVATEKEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSInteger selet = [[[Common dictionaryWithJsonString:_myAppStr] valueForKey:@"identities"] count]-1;
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", @(selet)] forKey:SELECTINDEX];
                NSString *deviececode = [responseObject valueForKey:@"DeviceCode"];
                [[NSUserDefaults standardUserDefaults] setValue:deviececode forKey:DEVICE_CODE];
                
                
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SOCKET_LOGOUT object:nil];
                //切换后 websoket 需要重连
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                appDelegate.isSocketConnect = YES;
                
                
            }
            
            NSDictionary *strDict = [Common dictionaryWithJsonString:self.textViewText];
            NSArray * array = strDict[@"claimArray"];
            for (NSDictionary *claimStr in array) {
                
                ClaimModel *model = [[ClaimModel alloc] init];
                model.OwnerOntId = [[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID];
                model.ClaimContext = claimStr[@"claimName"];
                model.Content =  [Common dictionaryToJson:claimStr[@"claimContent"]] ;
                model.status =@"1";
                [[DataBase sharedDataBase] addClaim:model isSoket:NO];
                
            }
            if ([[NSString stringWithFormat:@"%@",strDict[@"country"]] isEqualToString:@""]) {
                
            }else{
                 [[NSUserDefaults standardUserDefaults]setValue:strDict[@"country"] forKey:[NSString stringWithFormat:@"%@c",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]];
            }
           
//            [[NSUserDefaults standardUserDefaults]setValue:strDict[@"country1"] forKey:[NSString stringWithFormat:@"%@shufti",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]];
            if (_callback) {
                _callback(@"");
            }
            
        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
            
            
        }];
        
    }else if ([prompt hasPrefix:@"signDataStr"]) {
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        NSDictionary *signature = [Common dictionaryWithJsonString:resultStr];
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        
        
        NSDictionary *params = @{@"OwnerOntId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],@"Signature":signature};
        [[CCRequest shareInstance] requestWithURLStringNoLoading:Devicecode_gain MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
            
            
            NSString *deviceCode = [responseObject valueForKey:@"DeviceCode"];
            [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:DEVICE_CODE];
            [[NSUserDefaults standardUserDefaults] setValue:deviceCode forKey:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
            
            //存下时间戳和密码
            [Common setTimestampwithPassword:self.pwd WithOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
            
//            ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
//            vc.isWallect = NO;
//            [self.navigationController pushViewController:vc animated:YES];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_EXISIT];
            
            
            NSDictionary *strDict = [Common dictionaryWithJsonString:self.textViewText];
            NSArray * array = strDict[@"claimArray"];
            for (NSDictionary *claimStr in array) {
                
                ClaimModel *model = [[ClaimModel alloc] init];
                model.OwnerOntId = [[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID];
                model.ClaimContext = claimStr[@"claimName"];
                model.Content =  [Common dictionaryToJson:claimStr[@"claimContent"]] ;
                model.status =@"1";
                [[DataBase sharedDataBase] addClaim:model isSoket:NO];
                
            }
            if ([[NSString stringWithFormat:@"%@",strDict[@"country"]] isEqualToString:@""]) {
                
            }else{
                [[NSUserDefaults standardUserDefaults]setValue:strDict[@"country"] forKey:[NSString stringWithFormat:@"%@c",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]];
            }
            if (_callback) {
                _callback(@"");
            }
            
        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
            
            
        }];
    }else{
        
//        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
//        NSString *resultStr = promptArray[1];
//        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//        if ([[obj valueForKey:@"error"] integerValue] > 0) {
//            
//            NSString * titleString;
//            if ([[obj valueForKey:@"error"] integerValue] == 53000){
//                titleString = [NSString stringWithFormat:@"%@ %@",Localized(@"ImportFail"),Localized(@"PASSWORDERROR")];
//            }else{
//                titleString = [NSString stringWithFormat:@"%@ %@: %@",Localized(@"ImportFail"),Localized(@"Systemerror"),[obj valueForKey:@"error"]];
//            }
//            MGPopController *pop = [[MGPopController alloc] initWithTitle:titleString message:nil image:nil];
//            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//                
//            }];
//            action.titleColor =MainColor;
//            [pop addAction:action];
//            [pop show];
//            pop.showCloseButton = NO;
//            
//            
//            return;
//        }
//        
//        DebugLog(@"~~~~~~~~%@",[obj valueForKey:@"result"]);
//        NSMutableString *str=[obj valueForKey:@"result"];
//        NSDictionary *jsDic= [Common dictionaryWithJsonString:str];
//        NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
//        NSMutableArray *newArray;
//        if (allArray) {
//            newArray = [[NSMutableArray alloc] initWithArray:allArray];
//        } else {
//            newArray = [[NSMutableArray alloc] init];
//        }
//        //防止重复添加
//        for (int i=0; i<allArray.count; i++) {
//            if ([[allArray[i] valueForKey:@"address"]isEqualToString:[jsDic valueForKey:@"address"]]) {
//                
//                MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletAlreadyin") message:nil image:nil];
//                MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//                    
//                }];
//                action.titleColor =MainColor;
//                [pop addAction:action];
//                [pop show];
//                pop.showCloseButton = NO;
//                
//                
//                //            OTAlertView *alertV = [[OTAlertView alloc] initWithTitle:Localized(@"WalletAlreadyin")];
//                //            alertV.closeBlock = ^(void){
//                //
//                //            };
//                //            [alertV showAlert];
//                return;
//            }
//        }
//        
//        [newArray addObject:jsDic];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:ALLASSET_ACCOUNT];
//        [Common setEncryptedContent:[Common dictionaryToJson:newArray[newArray.count-1]] WithKey:ASSET_ACCOUNT];
////        ImportSuccessViewController *vc = [[ImportSuccessViewController alloc] initWithNibName:@"ImportSuccessViewController" bundle:nil];
////        vc.isWallect = YES;
////        [self.navigationController pushViewController:vc animated:YES];
//        if (_callback) {
//            _callback(@"");
//        }
    }
}
@end
