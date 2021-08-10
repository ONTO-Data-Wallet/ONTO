//
//  WalletDetailViewController.m
//  ONTO
//
//  Created by 赵伟 on 23/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "WalletDetailViewController.h"
#import "RemenberWordViewController.h"
#import "BackupViewController.h"
#import "ConfirmPwdViewController.h"
#import "KeyStoreBackupVC.h"
#import "ToastUtil.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "WalletBackupVC.h"

@interface WalletDetailViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *mnenomicBtm;
@property (weak, nonatomic) IBOutlet UIButton *keyStoreBtn;
@property (nonatomic,copy)  NSString *confirmPwd;
@property (nonatomic,copy) NSString *clickType;  //1 mennomic 2 keystore 3 delete
@property (nonatomic, strong) MBProgressHUD *hub;
@end

@implementation WalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _addressLabel.text = [NSString stringWithFormat:@"Address:%@",_address];
    self.view.backgroundColor = TABLEBACKCOLOR;
    _nameLabel.text = _name;
    _mnenomicBtm.layer.cornerRadius = 1;
    _mnenomicBtm.layer.masksToBounds = YES;
    if (![Common getEncryptedContent:_address]){
        _mnenomicBtm.hidden = YES;
    }

    [self configNav];
    [self.mnenomicBtm setTitle:Localized(@"Backupmnemonicwords") forState:UIControlStateNormal];
    [self.keyStoreBtn setTitle:[NSString stringWithFormat:@"    %@",Localized(@"ExportKeystore")] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liabilityexemptionNotice) name:RESPONSIBLENOTIFICATION object:nil];

}

-(void)dealloc{
   
      [[NSNotificationCenter defaultCenter] removeObserver:self name:RESPONSIBLENOTIFICATION object:nil];
    //第二种方法.这里可以移除该控制器下名称为tongzhi的通知
    //移除名称为tongzhi的那个通知
}

- (void)viewWillAppear:(BOOL)animated{
  
}

- (void)viewWillDisappear:(BOOL)animated{
   
}


- (void)configNav {
    [self setNavTitle:Localized(@"AssetTitle")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}

- (void)navLeftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)deleteAction:(id)sender {
//    _isMnenomic = NO;
    self.clickType = @"3";
     [self  presentAlart];
   
    
}

- (IBAction)mnenomicClick:(id)sender {
    

    WalletBackupVC *vc = [[WalletBackupVC alloc]init];
    vc.remenberWord = [Common getEncryptedContent:_address];
    vc.address =_address;
    vc.passwordHash = [self.identityDic valueForKey:@"passwordHash"];
    vc.key = [self.identityDic valueForKey:@"key"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)importKeyStoreClick:(id)sender {
    
    _clickType = @"2";
    [self  presentAlart];
}


- (void)presentAlart{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
    
    //增加取消按钮；
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //获取第1个输入框；
        UITextField *userNameTextField = alertController.textFields.firstObject;
        DebugLog(@"支付密码 = %@",userNameTextField.text);
        _confirmPwd = userNameTextField.text;
        [ToastUtil showMessage:@"" toView:self.view];
        [self loadJS];
        
    }]];
    //定义第一个输入框；
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入密码";
        textField.secureTextEntry = YES;
//        textField.keyboardType = UIKeyboardTypeNumberPad;
       [textField addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)textFieldDidChange1:(UITextField *)textField{
    
    
        
        if (textField.text.length > 15) {
            
            textField.text = [textField.text substringToIndex:15];
            
        }
        
}
    
- (void)liabilityexemptionNotice{
    
    if ([Common getEncryptedContent:_address]) {
      
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Responsible") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        DebugLog(@"移除了名称为tongzhi的通知");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:RESPONSIBLENOTIFICATION object:nil];
    }
}

- (void)loadJS{

    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",[self.identityDic valueForKey:@"key"] ,[Common transferredMeaning:_confirmPwd],self.address,[self.identityDic valueForKey:@"salt"]];


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
- (void)handlePrompt:(NSString *)prompt{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_hub hideAnimated:YES];

    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
        
        if ([_clickType isEqualToString:@"1"]) {
                RemenberWordViewController *vc = [[RemenberWordViewController alloc]init];
                vc.address = _address;
                vc.remenberWord = [Common getEncryptedContent:_address];
                vc.salt = [self.identityDic valueForKey:@"salt"];

               vc.confirmPwd = _confirmPwd;
            

                [self.navigationController pushViewController:vc animated:YES];
        }else  if ([_clickType isEqualToString:@"2"]){
            
            KeyStoreBackupVC *vc = [[KeyStoreBackupVC alloc]init];
            vc.isWallet = YES;
            vc.identityDic = _identityDic;
            vc.name = _name;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            //在这里实现删除操作
            
            if ([[[Common dictionaryWithJsonString:[Common getEncryptedContent:ASSET_ACCOUNT]
                   ]valueForKey:@"address"] isEqualToString:_address]) {
               
                
                MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletCanNotDeleted") message:nil image:nil];
                MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                    
                }];
                action.titleColor =MainColor;
                [pop addAction:action];
                [pop show];
                pop.showCloseButton = NO;
                return;
            }

            
            NSMutableArray *assetArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:ALLASSET_ACCOUNT]] ;
            //删除数据，和删除动画
            [assetArr removeObject:self.identityDic];
            [[NSUserDefaults standardUserDefaults] setObject:assetArr forKey:ALLASSET_ACCOUNT];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
