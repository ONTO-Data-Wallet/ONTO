//
//  KeyStoreQRViewController.m
//  ONTO
//
//  Created by 赵伟 on 24/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "KeyStoreQRViewController.h"

@interface KeyStoreQRViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mainTL1;
@property (weak, nonatomic) IBOutlet UILabel *subL1;
@property (weak, nonatomic) IBOutlet UILabel *mainL2;
@property (weak, nonatomic) IBOutlet UILabel *subL2;
@property (weak, nonatomic) IBOutlet UILabel *noticeL;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIImageView *QRImage;
@property (weak, nonatomic) IBOutlet UIView *noticeView;

@end

@implementation KeyStoreQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 1;
    [self loadJS];
    self.mainTL1.text = Localized(@"Onlyforscanning");
//    self.subL1.text = Localized(@"Dontscreeshot");
    self.mainL2.text = Localized(@"Safeenvironment");
    self.subL2.text = Localized(@"Nopeoples");
    self.noticeL.text =Localized(@"ShowQRcode");
//    [self.confirmBtn setTitle:Localized(@"ShowQRcode") forState:UIControlStateNormal];
    self.noticeView.layer.cornerRadius = 3;
    self.noticeView.layer.masksToBounds = YES;
    self.subL1.attributedText = [self getAttributedStringWithString:Localized(@"Dontscreeshot") lineSpace:5];

}


-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
    
}
- (IBAction)confirmClick:(id)sender {
    self.noticeView.hidden = YES;
}


- (void)loadJS{
 
    NSString *JSURL;
    
    if (_isWallet) {
        NSString * exportAccountToQrcode = [NSString stringWithFormat:@"Ont.SDK.exportAccountToQrcode('%@','exportAccountToQrcode')",[Common dictionaryToJson:_identityDic]];
        JSURL = [exportAccountToQrcode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
    }else{
        
        NSString * exportAccountToQrcode1 = [NSString stringWithFormat:@"Ont.SDK.exportIdentityToQrcode('%@','exportAccountToQrcode')",[Common dictionaryToJson:_identityDic]];
        JSURL = [exportAccountToQrcode1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:JSURL completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    __weak typeof(self) weakSelf = self;
    
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}

- (void)handlePrompt:(NSString *)prompt {
    if ([prompt hasPrefix:@"exportAccountToQrcode"]) {
        NSArray *array = [prompt componentsSeparatedByString:@"params="];
        NSDictionary *dict = [Common dictionaryWithJsonString:array[1]];
        
        if ([[dict valueForKey:@"error"] integerValue] > 0) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[dict valueForKey:@"error"]]];
            return;
        }
        
        self.QRImage.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:array[1] logoImageName:nil logoScaleToSuperView:0.25 withWallet:NO];
        
    }
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
