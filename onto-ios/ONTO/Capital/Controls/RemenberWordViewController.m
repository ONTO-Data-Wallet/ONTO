//
//  RemenberWordViewController.m
//  ONTO
//
//  Created by 赵伟 on 22/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "RemenberWordViewController.h"
#import "EnterWordViewController.h"
#import "WalletDetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface RemenberWordViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *remTitleL;
@property (weak, nonatomic) IBOutlet UILabel *remSubTitleL;
@property (weak, nonatomic) IBOutlet UILabel *remTextL;
@property (nonatomic, copy)NSString *decryptionWord;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remTitleLTop;

@end

@implementation RemenberWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];

    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Anyonewith") message:nil image:nil];
    
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"iknow") action:^{
        
    }];
    
    action.titleColor =MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadJS];
}

- (void)loadJS{

      NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptMnemonicEnc('%@','%@','%@','%@','decryptEncryptedPrivateKey')",_remenberWord,self.address,_salt,[Common transferredMeaning:_confirmPwd]];
    
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
    
}

- (void)handlePrompt:(NSString *)prompt{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        return;
    }
    
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
        
        self.remTextL.text =  [obj valueForKey:@"result"];
        _decryptionWord = [obj valueForKey:@"result"];
        
    }
}

- (void)configUI{
    
    self.view.backgroundColor = TABLEBACKCOLOR;
    [self setNavTitle:Localized(@"Backupmnemonicwords")];
       _remSubTitleL.text = Localized(@"Thesephrases");

    [_nextBtn setTitle:Localized(@"Writtenitdown") forState:UIControlStateNormal];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    self.nextBtn.layer.cornerRadius = 1;
    self.nextBtn.layer.masksToBounds = YES;
    self.subTitle.text = Localized(@"Nextscreen");
    if (LL_iPhone5S) {
        [_remTitleLTop setConstant:-25];
    }
}

- (void)navLeftAction {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:RESPONSIBLENOTIFICATION object:nil];
    WalletDetailViewController *homeVC = [[WalletDetailViewController alloc] init];
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[homeVC class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)nextAction:(id)sender {
    EnterWordViewController *vc = [[EnterWordViewController alloc]init];
    
    vc.remenberWord = _decryptionWord;
    vc.address = _address;
    [self.navigationController pushViewController:vc animated:YES];
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
