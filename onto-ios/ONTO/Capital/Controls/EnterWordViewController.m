//
//  EnterWordViewController.m
//  ONTO
//
//  Created by 赵伟 on 22/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "EnterWordViewController.h"
#import "CZTagButtons.h"
#import "CZTagTextButtons.h"
#import "WalletDetailViewController.h"
#import "MGPopController.h"
#import "ViewController.h"

@interface EnterWordViewController ()
@property (nonatomic, strong) CZTagTextButtons *textView;
@property (nonatomic, strong) CZTagButtons *buttonView;

@property (weak, nonatomic) IBOutlet UILabel *mnenomicTitle;
@property (weak, nonatomic) IBOutlet UILabel *mnenomicSubTitle;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *middleL;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLabelTop;

@end

@implementation EnterWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
}

- (IBAction)nextAction:(id)sender {


    NSString *textword = [_textView getContent];
  
    if ([textword isEqualToString:_remenberWord]) {

        [self mninomicSuccess];
        
    }else{

        [self mninomicFailed];
    }
    
}


- (void)mninomicFailed{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"BackupFailed") message:Localized(@"ConFirmFailed") preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
    
}

- (void)mninomicSuccess{

    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"backupWallet") message:Localized(@"recoveryPhrase") image:[UIImage imageNamed:@"Rectangle 17"]];

    MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"iknow") action:^{
        [Common deleteEncryptedContent:_address];
          [ViewController gotoCapitalVC];
    }];
    action.titleColor =MainColor;

    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;

}

- (void)configUI{
    
    _middleL.text = Localized(@"Correctorder");
    _mnenomicTitle.text = Localized(@"Backupmnemonicwords");
    _mnenomicSubTitle.text = Localized(@"Mnemonicwordsinorder");
    _mnenomicSubTitle.textAlignment =NSTextAlignmentCenter;
    [_nextBtn setTitle:Localized(@"Next") forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:Localized(@"BackupMnemonicWords")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    self.nextBtn.layer.cornerRadius = 1;
    self.nextBtn.layer.masksToBounds = YES;

    _textView  =[[CZTagTextButtons alloc]initWithCompletionHandlerBlock:^(CZTypographyButton1 *button, NSInteger index) {
        
        DebugLog(@"%@----%zd ",button.titleLabel.text,index);
        [_buttonView removeCurrenWithTitle:button.titleLabel.text];
        _nextBtn.hidden = YES;
        _clearBtn.hidden = YES;
    } typographyButtonTitles:@[] withSuperViewF:CGRectMake(10, 90, kScreenWidth -20, 125)];
    
    _textView.cz_backgroundColor = [UIColor colorWithHexString:@"#F6F8F9"];
        _textView.cz_buttonTitleColor = [UIColor colorWithHexString:@"#0AA5C9"];
    [self.view addSubview:_textView];
    
    NSMutableArray *nutableArray =[NSMutableArray arrayWithArray:[self.remenberWord componentsSeparatedByString:@" "]];

    NSMutableArray *wordArr = [NSMutableArray array];
    for (NSInteger i =0;i<nutableArray.count;i++) {
        
        NSMutableString *word = nutableArray[i];
        [wordArr addObject:[word stringByAppendingString:[NSString stringWithFormat:@"%ld",i]]];
         
    }
    
    _buttonView  =[[CZTagButtons alloc]initWithCompletionHandlerBlock:^(CZTypographyButton *button, NSInteger index) {
        
        [_textView addButtonWithTitle:button.titleLabel.text];
        DebugLog(@"%@----%zd ",button.titleLabel.text,index);
        
        if (_textView.tagButtons.count ==12) {
            _nextBtn.hidden = NO;
            _clearBtn.hidden = NO;
        }else{
            _nextBtn.hidden = YES;
            _clearBtn.hidden = YES;
        }
        
    } typographyButtonTitles:[Common getRandomArrFrome:wordArr] withSuperViewF:CGRectMake(10, 310, kScreenWidth -20, 10000)];
    
    if (LL_iPhone5S) {
        [_middleLabelTop setConstant:170];
        _buttonView.frame = CGRectMake(10, 275, kScreenWidth -20, 10000);
    }
    
    _buttonView.cz_backgroundColor = [UIColor clearColor];
    _buttonView.cz_buttonTitleColor = MAINAPPCOLOR;
    [self.view addSubview:_buttonView];
    //获取buttons的高度
    DebugLog(@"%f",_buttonView.frame.size.height);
    [_clearBtn setTitle:Localized(@"Clear") forState:UIControlStateNormal];
}

- (IBAction)clearAction:(id)sender {
    
     NSMutableArray *nutableArray = [[NSMutableArray alloc]initWithArray:[Common getRandomArrFrome:[self.remenberWord componentsSeparatedByString:@" "]]];

    for (NSString *title in nutableArray) {
         [_buttonView removeCurrenWithTitle:title];
    }
    
    [_textView removeAllTextTitle];
    _nextBtn.hidden = YES;
    _clearBtn.hidden = YES;
   
    
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

@end
