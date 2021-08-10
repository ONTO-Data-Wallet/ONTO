//
//  WalletBackupVC.m
//  ONTO
//
//  Created by 赵伟 on 08/06/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "WalletBackupVC.h"
#import "SendConfirmView.h"
#import "RemenberWordViewController.h"
#import "ToastUtil.h"
#import "MGPopController.h"
#import "Config.h"

@interface WalletBackupVC ()

@property (weak, nonatomic) IBOutlet UILabel *backL1;
@property (weak, nonatomic) IBOutlet UILabel *backL2;
@property (weak, nonatomic) IBOutlet UILabel *backL3;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, strong) SendConfirmView *sendConfirmV;
@property (nonatomic,copy) NSString *confirmPwd;
@property (nonatomic, strong) MBProgressHUD *hub;

@end

@implementation WalletBackupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:Localized(@"WalletBackup")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];

    _backL1.text = Localized(@"Beingwatched");
    _backL2.text = Localized(@"Toassess");
    _backL3.text = Localized(@"Anyonewith");
    [self.confirmBtn setTitle:Localized(@"Gotit") forState:UIControlStateNormal];
}

- (void)handlePrompt:(NSString *)prompt{
        [_hub hideAnimated:YES];
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
            [_sendConfirmV dismiss];
            RemenberWordViewController *vc = [[RemenberWordViewController alloc]init];
            vc.address = _address;
            vc.remenberWord = [Common getEncryptedContent:_address];
            vc.confirmPwd = _confirmPwd;
            vc.salt = _salt;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else{
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

- (void)loadJS{
    
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",_key,[Common transferredMeaning:_confirmPwd],self.address,self.salt];

    
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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (IBAction)confirmAction:(id)sender {
   MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Screenshotsarenotsecure") message:Localized(@"Physicalpaper") image:[UIImage imageNamed:@"backnotice"]];
    
    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"IUnderstand") action:^{

        
        self.sendConfirmV.paybyStr = @"";
        self.sendConfirmV.amountStr = @"";
        self.sendConfirmV.isWalletBack = YES;
        [self.sendConfirmV show];
    }];
    action.titleColor =MainColor;
    
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
  
}

- (SendConfirmView *)sendConfirmV {
    
    if (!_sendConfirmV) {
        
        
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
        _sendConfirmV.isWalletBack =YES;
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            
            weakSelf.confirmPwd = password;

            [weakSelf loadJS];
            
        }];
    }
    return _sendConfirmV;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}


- (void)navLeftAction {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
