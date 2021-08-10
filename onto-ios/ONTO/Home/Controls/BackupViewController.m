//
//  BackupViewController.m
//  ONTO
//
//  Created by 张超 on 2018/3/11.
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

#import "BackupViewController.h"
#import "BackupSuccessViewController.h"
#import "DIManageViewController.h"
#import "ViewController.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@interface BackupViewController ()<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *qrL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *qrIV;
@property (weak, nonatomic) IBOutlet UILabel *ontL;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, copy)NSDictionary *dic;
@property (nonatomic,copy) NSString *qrStr;
@end

@implementation BackupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
    
    if (self.isWallet) {
        [self handleDataWithAsset];
    }else {
        if (_isDigitalIdentity) {
            [self handleDataWithIdentity];
        }else{
            [self handleData];
        }
    }
}

- (void)configUI {
    self.view.backgroundColor = RGBA(244, 244, 244,1);
    [self setNavTitle:self.isWallet?Localized(@"WalletBackup"):Localized(@"DigitalBackup")];
    
    if (_isHideLeft) {
        
    } else {
        [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    }
    self.nextBtn.layer.cornerRadius = 1;
    self.nextBtn.layer.masksToBounds = YES;
    [self.nextBtn setTitle:Localized(@"One-stepBack") forState:UIControlStateNormal];

    self.qrL.text = self.isWallet?Localized(@"WalletQrcode"):Localized(@"DigitalQrcode");
    self.nameL.text = Localized(@"EncrytedType");
    self.nameLabel.text =_name;
}

- (void)loadJS{

    NSString *jsStr;
 
    if (_isWallet) {
        NSString * exportAccountToQrcode = [NSString stringWithFormat:@"Ont.SDK.exportAccountToQrcode('%@','exportAccountToQrcode')",_qrStr];
     jsStr = [exportAccountToQrcode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }else{
           NSString * exportAccountToQrcode = [NSString stringWithFormat:@"Ont.SDK.exportIdentityToQrcode('%@','exportIdentityToQrcode')",_qrStr];
        jsStr = [exportAccountToQrcode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
   
    
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];

}

- (void)handlePrompt:(NSString *)prompt {
    DebugLog(@"%@",prompt);
    if ([prompt hasPrefix:@"exportIdentityToQrcode"]||[prompt hasPrefix:@"exportAccountToQrcode"]) {
        NSArray *array = [prompt componentsSeparatedByString:@"params="];
        NSDictionary *dict = [Common dictionaryWithJsonString:array[1]];

        if ([[dict valueForKey:@"error"] integerValue] > 0) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[dict valueForKey:@"error"]]];
//            [ToastUtil shortToast:self.view value:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[dict valueForKey:@"error"]]];
            return;
        }
        
        self.qrIV.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:array[1] logoImageName:@"" logoScaleToSuperView:0.25 withWallet:_isWallet];
        
    }
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleDataWithAsset {
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    DebugLog(@"jsonDict=%@",jsonDict);
      NSMutableDictionary *qrDict ;
    if (_identityDic){
         qrDict =  [[NSMutableDictionary alloc] initWithDictionary:_identityDic];
    }else{
       qrDict =  [[NSMutableDictionary alloc] initWithDictionary:jsonDict];

    }
    
    _qrStr = [Common dictionaryToJson:qrDict];
    [self loadJS];
    self.ontL.text = [qrDict valueForKey:@"key"];
    _dic = [NSDictionary dictionaryWithDictionary:qrDict];
    self.nameLabel.text =[_dic valueForKey:@"label"];
}

- (void)handleData {
    
    NSString *jsonStr = [Common getEncryptedContent:APP_ACCOUNT];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    DebugLog(@"jsonDict=%@",jsonDict);
    NSMutableDictionary *qrDict = [[NSMutableDictionary alloc] init];
    [qrDict setValue:@"I" forKey:@"type"];
    [qrDict setValue:[jsonDict valueForKey:@"name"] forKey:@"label"];
    NSArray *identitisArr = [jsonDict valueForKey:@"identities"];
    NSDictionary *controlDict = [[[[jsonDict valueForKey:@"identities"] objectAtIndex:identitisArr.count-1] valueForKey:@"controls"] objectAtIndex:0];
    [qrDict setValue:[controlDict valueForKey:@"algorithm"]  forKey:@"algorithm"];
    [qrDict setValue:[controlDict valueForKey:@"key"] forKey:@"key"];
    [qrDict setValue:[controlDict valueForKey:@"parameters"] forKey:@"parameters"];
    self.ontL.text = [controlDict valueForKey:@"key"];

    //保存私钥匙到本地
    _qrStr = [Common dictionaryToJson:[[jsonDict valueForKey:@"identities"] objectAtIndex:identitisArr.count-1]];
    [self loadJS];

    [[NSUserDefaults standardUserDefaults] setValue:[controlDict valueForKey:@"key"] forKey:ENCRYPTED_PRIVATEKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)handleDataWithIdentity {
    
    NSMutableDictionary *qrDict = [[NSMutableDictionary alloc] init];
    
    _qrStr = [Common dictionaryToJson:_identityDic];
    
    [self loadJS];
    
    [qrDict setValue:@"I" forKey:@"type"];
    [qrDict setValue:[_identityDic valueForKey:@"label"]  forKey:@"label"];
    NSDictionary *controlDict = [[_identityDic valueForKey:@"controls"] objectAtIndex:0];
    [qrDict setValue:[controlDict valueForKey:@"algorithm"]  forKey:@"algorithm"];
    [qrDict setValue:[controlDict valueForKey:@"key"] forKey:@"key"];
    [qrDict setValue:[controlDict valueForKey:@"parameters"] forKey:@"parameters"];
    NSString *qrStr = [Common dictionaryToJson:qrDict];
    self.ontL.text = [controlDict valueForKey:@"key"];
    self.nameLabel.text = [_identityDic valueForKey:@"ontid"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextAction:(id)sender {
    if ([self.nextBtn.titleLabel.text isEqualToString:Localized(@"One-stepBack")]) {
        
        [self.nextBtn setTitle:Localized(@"Next") forState:UIControlStateNormal];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 370)];
       
        UIImageView *scImage = [[UIImageView alloc]init];
        scImage.image = self.qrIV.image;
        scImage.frame = CGRectMake(20, 10, 190, 190);
        scImage.center = backView.center;
        [backView addSubview:scImage];
        
        UILabel *qrLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 300, 20)];
        qrLabel.textAlignment = NSTextAlignmentCenter;
        qrLabel.text = self.isWallet?Localized(@"WalletQrcode"):Localized(@"DigitalQrcode");
        qrLabel.font = [UIFont systemFontOfSize:17];
        [backView addSubview:qrLabel];

        
        UILabel *ontLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 300, 260, 40)];
        ontLabel.textAlignment = NSTextAlignmentCenter;
        DebugLog(@"!!!%@",[_identityDic valueForKey:@"address"]);
       NSString*str=[NSString stringWithFormat:@"%@%@",self.isWallet?Localized(@"WalletAddress"):@"ONT ID:",self.isWallet?[_dic valueForKey:@"address"]:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
        ontLabel.text = str;
        ontLabel.numberOfLines = 2;
        ontLabel.lineBreakMode = NSLineBreakByCharWrapping;

        ontLabel.font = [UIFont systemFontOfSize:12];
        [backView addSubview:ontLabel];
        ontLabel.textColor = [UIColor grayColor];
        UILabel *keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 330, 260, 40)];
        keyLabel.textAlignment = NSTextAlignmentCenter;
        NSString*str1=  [NSString stringWithFormat:@"%@ %@",Localized(@"KeyString"),self.ontL.text];
        NSString *str2= str1;
        keyLabel.text = str2;
        keyLabel.lineBreakMode = NSLineBreakByCharWrapping;

        keyLabel.font = [UIFont systemFontOfSize:12];
        [backView addSubview:keyLabel];
        keyLabel.textColor = MainColor;
        keyLabel.numberOfLines = 2;
        
        [self screenShotView:backView];
        UIImageWriteToSavedPhotosAlbum( [self screenShotView:backView],self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:ISFIRST_BACKUP]==NO) {
            BackupSuccessViewController *VC = [[BackupSuccessViewController alloc] initWithNibName:@"BackupSuccessViewController" bundle:nil];
            VC.isWallet = self.isWallet;
            VC.isIdentity = _isIdentity;
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            if (self.isWallet||_isIdentity) {
                //资产账户导入成功跳转到资产根页
                [self.navigationController popToRootViewControllerAnimated:YES];

            } else {
                if ([[NSUserDefaults standardUserDefaults] valueForKey:ISFIRST_BACKUP]) {
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[DIManageViewController class]]) {
                            DIManageViewController *vc =(DIManageViewController *)controller;
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                } else {
                    //第一次备份成功后跳转
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISFIRST_BACKUP];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [ViewController gotoIdentityVC];
                }
            }
        }
        
    }
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
//        DebugLog(@"save success");

        MGPopController *pop = [[MGPopController alloc] initWithTitle:self.isWallet?Localized(@"WalletSaveToAlbum"):Localized(@"SaveToAlbum") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
    }else{
        DebugLog(@"save failed");
             
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Settingauthority") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
    }
}

- (UIImage *)image:(UIImage *)image withColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, rect);
    
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//传入需要截取的view
-(UIImage *)screenShotView:(UIView *)view{
    
    UIImage *imageRet = [[UIImage alloc]init];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

- (IBAction)copyAction:(id)sender {
//    [self showHint:Localized(@"CopySuccess")];
    [Common showToast:Localized(@"CopySuccess")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.ontL.text;
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
