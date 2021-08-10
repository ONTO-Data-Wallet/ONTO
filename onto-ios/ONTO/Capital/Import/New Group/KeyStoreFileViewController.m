 //
//  KeyStoreFileViewController.m
//  ONTO
//
//  Created by 赵伟 on 24/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "KeyStoreFileViewController.h"
#import "BrowserView.h"
#import "WebIdentityViewController.h"
#import "DataBase.h"
#import "ClaimModel.h"
#import "ViewController.h"
#import "BackupV.h"
#import <ONTO-Swift.h>
@interface KeyStoreFileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mainTitleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UITextView *myTextF;
@property (weak, nonatomic) IBOutlet UIButton *confiremBtn;
@property (nonatomic, strong) BrowserView *browserView;
@property (weak, nonatomic) IBOutlet UIButton *keystoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBox;
@property (nonatomic,copy)  NSString *JsonStr;
@property(nonatomic, strong) MBProgressHUD *hub;
@end

@implementation KeyStoreFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadJS];
    self.confiremBtn.layer.cornerRadius = 1;
    self.confiremBtn.layer.masksToBounds = YES;

//    _confiremBtn.layer.borderWidth = 0.5;
//    _confiremBtn.layer.borderColor  = [UIColor colorWithHexString:@"#E9EDEF"].CGColor;
    [_saveBox.titleLabel changeSpace:0 wordSpace:3];
    [_saveBox setEnlargeEdge:15];
    [_saveBox setTitle:Localized(@"SAVETODROPBOX") forState:UIControlStateNormal];
    [_confiremBtn.titleLabel changeSpace:0 wordSpace:3];
    if (_isWallet) {
        _saveBox.hidden = YES;
    }
    [_confiremBtn setTitle:Localized(@"CopyKeystore") forState:UIControlStateNormal];
//    self.mainTitleL.text = Localized(@"Saveoffline");
    self.subtitleL.attributedText =  [self getAttributedStringWithString:Localized(@"Pleasecopyandpaste") lineSpace:0];;
    [self.subtitleL changeSpace:2 wordSpace:1];
    self.subtitleL.numberOfLines = 0;
    [self.keystoreBtn setTitle:Localized(@"Whatkeystore") forState:UIControlStateNormal];
    self.myTextF.textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16);
    self.myTextF.userInteractionEnabled = YES;
    [self.myTextF setEditable:NO];
    
    [self configNav];
    
    [_saveBox handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        //点击触摸区跳转的问题-bug
        if (!_isWallet)
        {
            BoxLoginViewController *vc =[[BoxLoginViewController alloc]init];
            vc.jsonStr = self.JsonStr;
            vc.type = @"input";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)configNav {
    [self setNavTitle:_isWallet?Localized(@"ExporttKeystore1"): Localized(@"ExporttKeystore")];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#000000"],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:21 weight:UIFontWeightBold],
                                                                      NSKernAttributeName: @2
                                                                      }];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"cotback"] Title:Localized(@"Back")];
    
}

- (void)navLeftAction {
    
    

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@A",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]]==NO&&_isWallet==NO) {
        
        
        BackupV * v = [[BackupV alloc]initWithTitle:Localized(@"BackUpNotice") imageString:@"dropLater" leftButtonString:Localized(@"Later") rightButtonString:Localized(@"OK")];
        v.callleftback = ^(NSString *string) {
            if (_isFirstIdentity==YES) {
                
                [ViewController gotoIdentityVC];
                
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:[NSString stringWithFormat:@"%@A",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]];
            }
        };
        v.callback = ^(NSString *string) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"%@A",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]];
            if (_isFirstIdentity==YES) {
                
                [ViewController gotoIdentityVC];
                
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        };
        [v show];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

}



- (IBAction)keyStoreClick:(id)sender {
    WebIdentityViewController *VC= [[WebIdentityViewController alloc]init];
    VC.introduce = [NSString stringWithFormat:@"https://info.onto.app/#/detail/%@",[ENORCN isEqualToString:@"cn"]?@"3":@"18"];
    [self.navigationController pushViewController:VC animated:YES];
}

-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSKernAttributeName value:@1 range:range];
    return attributedString;
    
}

- (IBAction)confIrmClick:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.myTextF.text;
//    [self showHint:Localized(@"OntidCopySuccess")];
//     [Common showToast:Localized(@"OntidCopySuccess")];
    COTAlertV *failV = [[COTAlertV alloc]initWithTitle:Localized(@"boxcopy") imageString:@"dropCopy" buttonString:Localized(@"OK")];
    failV.callback = ^(NSString *string) {
    };
    [failV show];
    
}

- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
            DebugLog(@"prompt=%@",prompt);
            [weakSelf handlePrompt:prompt];
        }];
        [_browserView setCallbackJSFinish:^{
            [weakSelf loadJS];
        }];
    }
    return _browserView;
}
    
- (void)loadJS{
    [_hub hideAnimated:YES];
    _hub = [ToastUtil showMessage:@"" toView:nil];
    //节点方法 每次调用JSSDK前都必须调用
    LOADJS1;
    LOADJS2;
    LOADJS3;

    if (_isWallet) {
        NSString * exportAccountToQrcode = [NSString stringWithFormat:@"Ont.SDK.exportAccountToQrcode('%@','exportAccountToQrcode')",[Common dictionaryToJson:_identityDic]];
        [self.browserView.wkWebView evaluateJavaScript:[exportAccountToQrcode stringByReplacingOccurrencesOfString:@"\n" withString:@""] completionHandler:nil];
    }else{
        
        NSString * exportAccountToQrcode1 = [NSString stringWithFormat:@"Ont.SDK.exportIdentityToQrcode('%@','exportAccountToQrcode')",[Common dictionaryToJson:_identityDic]];
        [self.browserView.wkWebView evaluateJavaScript:[exportAccountToQrcode1 stringByReplacingOccurrencesOfString:@"\n" withString:@""] completionHandler:nil];
    }
}

- (void)handlePrompt:(NSString *)prompt {
    DebugLog(@"%@",prompt);
    [_hub hideAnimated:YES];
    if ([prompt hasPrefix:@"exportAccountToQrcode"]) {
        
        NSArray *array = [prompt componentsSeparatedByString:@"params="];
        NSDictionary *dict = [Common dictionaryWithJsonString:array[1]];
        NSArray *claimedArr = [[DataBase sharedDataBase] getAllClaim];

        NSMutableArray *claimArr = [NSMutableArray array];
        
        if(_isWallet==NO){
            
            for (ClaimModel *model in claimedArr) {
    
                NSMutableDictionary *claimdic = [[NSMutableDictionary alloc]init];
                [claimdic setValue:model.ClaimContext forKey:@"claimName"];
                [claimdic setValue:[Common dictionaryWithJsonString:model.Content] forKey:@"claimContent"];
                [claimArr addObject:claimdic];
            }
    
            [dict setValue:claimArr forKey:@"claimArray"];
            
            NSString *country = [[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@c",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]];
//            NSString *country1 = [[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@shufti",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]];
            [dict setValue:country forKey:@"country"];
//            [dict setValue:country1 forKey:@"country11"];
        }

        if ([[dict valueForKey:@"error"] integerValue] > 0) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[dict valueForKey:@"error"]]];
//            [ToastUtil shortToast:self.view value:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[dict valueForKey:@"error"]]];
            return;
        }
        
        
        if(_isWallet==NO){
            self.JsonStr = [Common dictionaryToJson:dict];
            self.myTextF.attributedText =[self getAttributedStringWithString:[Common dictionaryToJson:dict] lineSpace:5];

        }else{
            
            self.myTextF.attributedText =[self getAttributedStringWithString: array[1] lineSpace:5];

        }}
}
-(NSString *)arrayToJSONString:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonResult;
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
