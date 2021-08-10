//
//  SwapExplainViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/7/16.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "SwapExplainViewController.h"
#import "HYKeyboard.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define textViewfont 14

#define KEYBOARD_NIB_PATH @"BangcleSafeKeyBoard.bundle/resources/HYKeyboard"
typedef NS_ENUM(NSInteger, PWDType) {
    PWDTypeDefault,
    PWDTypeNext,
};
@interface SwapExplainViewController ()<HYKeyboardDelegate,UITextFieldDelegate>
{
    HYKeyboard*keyboard;
    NSString*inputText;
    NSInteger i;
}

@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel3;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel4;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel5;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel6;
@property (weak, nonatomic) IBOutlet UILabel *requestAmountL;
@property (weak, nonatomic) IBOutlet UILabel *neoBalanceL;
@property (weak, nonatomic) IBOutlet UILabel *walletPassardL;
@property (weak, nonatomic) IBOutlet UIButton *confirmB;
@property (weak, nonatomic) IBOutlet UITextField *amoutF;
@property (weak, nonatomic) IBOutlet UITextField *passWordF;
@property(nonatomic,strong)BrowserView      *browserView;
@property (nonatomic, strong) MBProgressHUD *hub;

@end

@implementation SwapExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    [self setNavTitle:Localized(@"MainNetONT")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    self.tipLabel1.text =  Localized(@"swap_tip1");
    self.tipLabel2.text =  Localized(@"swap_tip2");
    self.tipLabel3.text =  Localized(@"swap_tip3");
    self.tipLabel4.text =  Localized(@"swap_tip4");
    self.tipLabel5.text =  Localized(@"swap_tip5");
    self.tipLabel6.text =  Localized(@"swap_tip6");
    self.requestAmountL.text = Localized(@"SwapAmount");
    self.neoBalanceL.text = [NSString stringWithFormat:@"%@ %@ ONT", Localized(@"NEOBalance"),[Common divideAndReturnPrecision8Str:self.NET5]];

//    self.neoBalanceL.text = [NSString stringWithFormat:@"%@ %@ ONT", Localized(@"NEOBalance"),[NSString stringWithFormat:@"%ld",[self.NET5 longValue]/100000000]];
    
    self.walletPassardL.text = Localized(@"WalletPassword");
    [self.confirmB setTitle:Localized(@"Confirm") forState:UIControlStateNormal];
    self.amoutF.keyboardType =UIKeyboardTypeNumberPad;
    [self.amoutF addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
    
    self.passWordF.delegate = self;
    self.passWordF.secureTextEntry = YES;
    self.passWordF.placeholder = Localized(@"InputTheWalletPassword");
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
- (void)loadJS {
    
     NSString *jsStr = [Common getEncryptedContent:ASSET_ACCOUNT];
     NSDictionary *dict = [Common dictionaryWithJsonString:jsStr];
      NSString *  jsurl = [NSString stringWithFormat:@"Ont.SDK.neoTransfer('%@','%@','%@','%@','%@','%@','neoTransfer')",dict[@"address"],@"AFmseVrdL9f9oyCzZefL9tG6UbvhPbdYzM",self.amoutF.text,dict[@"key"],[Common transferredMeaning:self.passWordF.text],dict[@"salt"]];
      NSString *str = [jsurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.browserView.wkWebView evaluateJavaScript:str completionHandler:nil];
//    __weak typeof(self) weakSelf = self;
//    [self.browserView setCallbackPrompt:^(NSString *prompt) {
//        [weakSelf handlePrompt:prompt];
//    }];
    
}

- (void)handlePrompt:(NSString *)prompt{
    [_hub hideAnimated:YES];

    if ([prompt hasPrefix:@"neoTransfer"]) {
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        if ([[obj valueForKey:@"error"] integerValue] == 53000) {
            //            [ToastUtil shortToast:APPWINDOW value:Localized(@"PASSWORDERROR")];
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            return;
        }
        
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[obj valueForKey:@"error"]]];
//            [ToastUtil shortToast:APPWINDOW value:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[obj valueForKey:@"error"]]];
            
            return;
        }
        
        NSArray *array = [prompt componentsSeparatedByString:@"params="];
        NSDictionary *dict = [Common dictionaryWithJsonString:array[1]];
        if ([Common dx_isNullOrNilWithObject:dict]) {
            return;
        }
        DebugLog(@"yyyy%@",array);
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSString *jsStr = [Common getEncryptedContent:ASSET_ACCOUNT];
        NSDictionary *walletdict = [Common dictionaryWithJsonString:jsStr];
        NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@%@",walletdict[@"address"],ALLSWAP]];
        NSMutableArray *newArray;
        if (allArray) {
            newArray = [[NSMutableArray alloc] initWithArray:allArray];
        } else {
            newArray = [[NSMutableArray alloc] init];
        }
        
//        {
//            if ([dic[@"assetname"] isEqualToString:@"ont"]) {
//                _moneyNumLB.text =[NSString stringWithFormat:@"%d %@",[dic[@"amount"]intValue],@"ONT" ];
//            }else{
//                _moneyNumLB.text =[NSString stringWithFormat:@"%@ %@",dic[@"amount"],@"ONG" ];
//            }
//
//            _timeLB.text =[Common newGetTimeFromTimestamp:dic[@"confirmtime"]];
//
//
//        }
        

        NSDictionary *swapDic = @{@"assetname":@"ont",@"amount":self.amoutF.text,@"confirmtime":[Common getNowTimeTimestamp],@"neo_txnhash":dict[@"result"]};

        [newArray addObject:swapDic];
      
        
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:[NSString stringWithFormat:@"%@%@",walletdict[@"address"],ALLSWAP]];
}
}

#pragma mark baseAction
- (void)navLeftAction {
  
        [self.navigationController popViewControllerAnimated:YES];
    
}
    
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.passWordF resignFirstResponder];
    //具体调用显示安全键盘位置根据项目的实际情况调整，此处只是作为demo演示
    [self showSecureKeyboardAction];
    return NO;
}
/**初始化安全键盘*/
- (void)showSecureKeyboardAction{
    
    if (keyboard) {
        [keyboard.view removeFromSuperview];
        keyboard.view =nil;
        keyboard=nil;
    }
    keyboard = [[HYKeyboard alloc] initWithNibName:KEYBOARD_NIB_PATH bundle:nil];
    /**弹出安全键盘的宿主控制器，不能传nil*/
    keyboard.hostViewController = self;
    /**是否设置按钮无按压和动画效果*/
    //    keyboard.btnPressAnimation=YES;
    /**是否设置按钮随机变化*/
    keyboard.btnrRandomChange=YES;
    /**是否显示密码明文动画*/
    keyboard.shouldTextAnimation=YES;
    /**安全键盘事件回调，必须实现HYKeyboardDelegate内的其中一个*/
    keyboard.keyboardDelegate=self;
    /**弹出安全键盘的宿主输入框，可以传nil*/
    keyboard.hostTextField = self.passWordF;
    /**是否输入内容加密*/
    keyboard.secure = YES;
    //设置加密类型，分为AES和SM42种类型，默认为SM4
    //    [keyboard setSecureType:HYSecureTypeAES];
    //    keyboard.arrayText = [NSMutableArray arrayWithArray:contents];//把已输入的内容以array传入;
    /**输入框已有的内容*/
    keyboard.contentText=inputText;
    keyboard.synthesize = YES;//hostTextField输入框同步更新，用*填充
    /**是否清空输入框内容*/
    keyboard.shouldClear = YES;
    /**背景提示*/
    keyboard.stringPlaceholder = self.passWordF.placeholder;
    keyboard.intMaxLength = 15;//最大输入长度
    keyboard.keyboardType = HYKeyboardTypeNone;//输入框类型
    /**更新安全键盘输入类型*/
    [keyboard shouldRefresh:HYKeyboardTypeNone];
    //    [keyboard setTextAnimationSecond:0.8];//默认不设置，动画时长为1秒
    //--------添加安全键盘到ViewController---------
    
    [self.view addSubview:keyboard.view];
    [self.view bringSubviewToFront:keyboard.view];
    //安全键盘显示动画
    CGRect rect=keyboard.view.frame;
    rect.size.width=self.view.frame.size.width;
    rect.origin.y=self.view.frame.size.height+10;
    keyboard.view.frame=rect;
    //显示输入框动画
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.2f];
    rect.origin.y=self.view.frame.size.height-keyboard.view.frame.size.height;
    keyboard.view.frame=rect;
    [UIView commitAnimations];
}
- (void)textFieldDidChange1:(UITextField *)textField{
    
        if (textField.text.length > 10) {
            
            textField.text = [textField.text substringToIndex:10];
            
        }

}
#pragma mark--关闭键盘回调

-(void)inputOverWithTextField:(UITextField *)textField inputText:(NSString *)text
{
    inputText=text;

        self.passWordF.text = text;
    
    
    [self hiddenKeyboardView];
    
}

-(void)inputOverWithChange:(UITextField *)textField changeText:(NSString *)text
{
    //    DebugLog(@"变化内容:%@",text);
    inputText=text;
  
        self.passWordF.text = text;
        [self textFieldDidChange:self.passWordF];
        
    
    if (textField.text.length == 15) {
        DebugLog(@"输入完毕");
        [textField resignFirstResponder];
        //        _callbackPwd(textField.text);
        [self hiddenKeyboardView];
    }
}

- (void)textFieldDidChange:(UITextField *)textField{

            if (textField.text.length > 15) {
                
                textField.text = [textField.text substringToIndex:15];
                
            }
    
    
}

-(void)hiddenKeyboardView
{
    //隐藏输入框动画
    [ UIView animateWithDuration:0.3 animations:^
     {
         CGRect rect=keyboard.view.frame;
         rect.origin.y=self.view.frame.size.height+10;
         keyboard.view.frame=rect;
         
     }completion:^(BOOL finished){
         
         [keyboard.view removeFromSuperview];
         keyboard.keyboardDelegate=nil;
         keyboard.view =nil;
         keyboard=nil;
     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    [self hiddenKeyboardView];
}

- (IBAction)confirmClick:(id)sender {
    
    
    
    if ([self.amoutF.text integerValue] <= 0) {
        [Common showToast:Localized(@"SwapZeroNotice")];
//        [ToastUtil shortToast:self.view value:Localized(@"SwapZeroNotice")];

        return;
    }

    if ([self.amoutF.text integerValue]>[self.NET5 longValue]/100000000) {
        [Common showToast:Localized(@"SwapgreaterT")];
//        [ToastUtil shortToast:self.view value:Localized(@"SwapgreaterT")];

        return;
    }
    
    if (self.passWordF.text.length > 15||self.passWordF.text.length <8) {
        [Common showToast:Localized(@"SelectAlertPassWord")];
//        [ToastUtil shortToast:self.view value:Localized(@"SelectAlertPassWord")];
        return;
    }
    
    
    [self.view addSubview:self.browserView];
    LOADJS1;
    LOADJS2;
    LOADJS3;
    _hub=[ToastUtil showMessage:@"" toView:nil];

    [self loadJS];
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
