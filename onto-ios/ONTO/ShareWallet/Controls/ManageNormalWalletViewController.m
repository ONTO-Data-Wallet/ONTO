//
//  ManageNormalWalletViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/30.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ManageNormalWalletViewController.h"
#import "SendConfirmView.h"
#import "KeyStoreBackupVC.h"
@interface ManageNormalWalletViewController ()
@property (nonatomic, strong) SendConfirmView *sendConfirmV;
@property (nonatomic,copy) NSString *confirmPwd;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic,assign) NSInteger btnTpye;
@end

@implementation ManageNormalWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNav];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    UILabel *nameLB =[[UILabel alloc]initWithFrame:CGRectMake(0, 40*SCALE_W, SYSWidth, 24*SCALE_W)];
    nameLB.font =[UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
    nameLB.textAlignment =NSTextAlignmentCenter;
    nameLB.textColor =BLACKLB;
    nameLB.text =_dic[@"label"];
    [self.view addSubview:nameLB];
    
    UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(SYSWidth/2-50*SCALE_W, 104*SCALE_W, 100*SCALE_W, 100*SCALE_W)];
    image.image =[UIImage imageNamed:@"shareTu"];
    [self.view addSubview:image];
    
    NSString * addressString =self.dic[@"address"];
    
    UIButton * copyBtn =[[UIButton alloc]initWithFrame:CGRectMake(SYSWidth -33*SCALE_W, 274*SCALE_W, 16*SCALE_W, 16*SCALE_W)];
    [copyBtn setEnlargeEdge:25];
    [copyBtn setImage:[UIImage imageNamed:@"gray9"] forState:UIControlStateNormal];
    [self.view addSubview:copyBtn];
    [copyBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//        [self showHint:Localized(@"WalletCopySuccess")];
        [Common showToast:Localized(@"WalletCopySuccess")];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = addressString;
    }];
    
    UILabel *addressLB =[[UILabel alloc]initWithFrame:CGRectMake(17*SCALE_W, 254*SCALE_W, SYSWidth-60*SCALE_W, 16*SCALE_W)];
    addressLB.text =Localized(@"shareAddress");
    addressLB.font =[UIFont systemFontOfSize:14];
    addressLB.textColor =LIGHTGRAYLB;
    addressLB.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:addressLB];
    
    UILabel *addressLB1 =[[UILabel alloc]initWithFrame:CGRectMake(17*SCALE_W, 274*SCALE_W, SYSWidth-60*SCALE_W, 16*SCALE_W)];
    addressLB1.text =addressString;
    addressLB1.font =[UIFont systemFontOfSize:14];
    addressLB1.textColor =BLACKLB;
    addressLB1.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:addressLB1];
    
    
    NSString * addressString2 =self.dic[@"publicKey"];
    CGSize strSize = [addressString2 boundingRectWithSize:CGSizeMake(SYSWidth-60*SCALE_W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    UIButton * copyBtn2 =[[UIButton alloc]initWithFrame:CGRectMake(SYSWidth -33*SCALE_W, 274*SCALE_W+60*SCALE_W, 16*SCALE_W, 16*SCALE_W)];
    [copyBtn2 setEnlargeEdge:25];
    [copyBtn2 setImage:[UIImage imageNamed:@"gray9"] forState:UIControlStateNormal];
    [self.view addSubview:copyBtn2];
    [copyBtn2 handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//        [self showHint:Localized(@"WalletKeySuccess")];
        [Common showToast:Localized(@"WalletKeySuccess")];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = addressString2;
    }];
    
    UILabel *addressLB2 =[[UILabel alloc]initWithFrame:CGRectMake(17*SCALE_W, 254*SCALE_W+50*SCALE_W, SYSWidth-60*SCALE_W, 16*SCALE_W)];
    addressLB2.text =Localized(@"normalPublicKey");
    addressLB2.font =[UIFont systemFontOfSize:14];
    addressLB2.textColor =LIGHTGRAYLB;
    addressLB2.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:addressLB2];
    
    UILabel *addressLB3 =[[UILabel alloc]initWithFrame:CGRectMake(17*SCALE_W, 274*SCALE_W+50*SCALE_W, SYSWidth-60*SCALE_W, strSize.height+5)];
    addressLB3.text =addressString2;
    addressLB3.numberOfLines =0;
    addressLB3.font =[UIFont systemFontOfSize:14];
    addressLB3.textColor =BLACKLB;
    addressLB3.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:addressLB3];
    
    UIButton * exportBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, SYSHeight-64-49, SYSWidth/2, 49)];
    if (KIsiPhoneX) {
        exportBtn.frame =CGRectMake(0, SYSHeight-64-49-34-24, SYSWidth/2, 49);
    }
    [exportBtn setImage:[UIImage imageNamed:@"dark_blue"] forState:UIControlStateNormal];
    [exportBtn setTitle:[NSString stringWithFormat:@" %@",Localized(@"Export")] forState:UIControlStateNormal];
    [exportBtn setTitleColor:[UIColor colorWithHexString:@"#35BFDF"] forState:UIControlStateNormal];
    exportBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [exportBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
    [self.view addSubview:exportBtn];
    
    UIButton * deleteBtn =[[UIButton alloc]initWithFrame:CGRectMake(SYSWidth/2, SYSHeight-64-49, SYSWidth/2, 49)];
    if (KIsiPhoneX) {
        deleteBtn.frame =CGRectMake(SYSWidth/2, SYSHeight-64-49-34-24, SYSWidth/2, 49);
    }
    [deleteBtn setImage:[UIImage imageNamed:@"newDelete"] forState:UIControlStateNormal];
    [deleteBtn setTitle:[NSString stringWithFormat:@" %@",Localized(@"Delete")] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:BLACKLB forState:UIControlStateNormal];
    deleteBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [deleteBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
    [self.view addSubview:deleteBtn];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(SYSWidth/2-1, SYSHeight -64-49+7.5, 2, 34)];
    if (KIsiPhoneX) {
        line.frame =CGRectMake(SYSWidth/2-1, SYSHeight-64-49-34-24+7.5, 2, 34);
    }
    line.backgroundColor =LINEBG;
    [self.view addSubview:line];
    
    [exportBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.view addSubview:self.sendConfirmV];
        self.btnTpye =1;
        self.sendConfirmV.paybyStr = @"";
        self.sendConfirmV.amountStr = @"";
        self.sendConfirmV.isWalletBack = YES;
        [self.sendConfirmV show];
    }];
    
    [deleteBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.view addSubview:self.sendConfirmV];
        self.btnTpye =10;
        self.sendConfirmV.paybyStr = @"";
        self.sendConfirmV.amountStr = @"";
        self.sendConfirmV.isWalletBack = YES;
        [self.sendConfirmV show];
    }];
}
- (SendConfirmView *)sendConfirmV {
    
    if (!_sendConfirmV) {
        
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            
            weakSelf.confirmPwd = password;
            
            
            [weakSelf loadJS];
            
        }];
    }
    return _sendConfirmV;
}
- (void)loadJS{
    
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",self.dic[@"key"],[Common transferredMeaning:_confirmPwd],self.dic[@"address"],self.dic[@"salt"]];
    
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
    
    [_hub hideAnimated:YES];
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
            [_sendConfirmV dismiss];
            if (_btnTpye==1) {
                KeyStoreBackupVC *vc = [[KeyStoreBackupVC alloc]init];
                vc.isWallet = YES;
                vc.passwordString = _confirmPwd;
                vc.identityDic = _dic;
                vc.name = _dic[@"name"];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                
                if ([[[Common dictionaryWithJsonString:[Common getEncryptedContent:ASSET_ACCOUNT]
                       ]valueForKey:@"address"] isEqualToString:[self.dic valueForKey:@"address"]]) {

                    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletCanNotDeleted") message:nil image:nil];
                    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{

                    }];
                    action.titleColor =MainColor;
                    [pop addAction:action];
                    [pop show];
                    pop.showCloseButton = NO;
                    return;
                }
                NSMutableArray * arr =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:ALLASSET_ACCOUNT]] ;;
                //删除数据，和删除动画
                [arr removeObject:self.dic];
                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:ALLASSET_ACCOUNT];
                [self.navigationController  popViewControllerAnimated:YES];
                
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
}
-(void)createNav{
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
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
