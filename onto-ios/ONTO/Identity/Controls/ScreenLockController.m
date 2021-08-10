//
//  ScreenLockController.m
//  ONTO
//
//  Created by 赵伟 on 17/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "ScreenLockController.h"
#import "UIView+XYMenu.h"
#import "Config.h"
#import "ToastUtil.h"
#import "HYKeyboard.h"
#define KEYBOARD_NIB_PATH @"BangcleSafeKeyBoard.bundle/resources/HYKeyboard"

@interface ScreenLockController () <UIGestureRecognizerDelegate,HYKeyboardDelegate,UITextFieldDelegate>
{
    HYKeyboard*keyboard;
    NSString*inputText;
}
@property (nonatomic, strong) NSMutableArray *identArr;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordF;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UILabel *exceedLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;

@end

@implementation ScreenLockController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
}

- (void)configUI{
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:IDENTITY_NAME]];
    if (_manageName) {
        _nameLabel.text = _manageName;
    }
    
    _doneBtn.layer.cornerRadius = 1;
    _doneBtn.layer.masksToBounds = YES;
    [_doneBtn setTitle:Localized(@"Done") forState:UIControlStateNormal];
    _passwordF.placeholder = Localized(@"SelectAlertPassWord");
    _exceedLabel.text = Localized(@"PasswordExpired");
    _changeLabel.text = Localized(@"SwitchIdentity");
 [self.passwordF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.passwordF.delegate = self;
    self.passwordF.secureTextEntry = YES;

}

- (IBAction)doneClick:(id)sender {
    
    if (self.passwordF.text.length==0) {
        [Common showToast:Localized(@"SelectAlertPassWord")];
//        [ToastUtil shortToast:self.view value: Localized(@"SelectAlertPassWord")];
        return;
    }
    
    if ([Common judgePasswordisMatchWithPassWord:self.passwordF.text WithOntId:_ontID]) {
   
        [Common setTimestampwithPassword:self.passwordF.text WithOntId:_ontID];
       
        if (_isManage) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EXPIREMANAGENOTIFICATION object:nil];

        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:EXPIRENOTIFICATION object:nil];
        }
         [self dismissViewControllerAnimated:YES completion:nil];
       
    }else{
        [Common showToast:Localized(@"Incorrectpassword")];
//        [ToastUtil shortToast:self.view value:Localized(@"Incorrectpassword")];
        [self.passwordF resignFirstResponder];
    }
    
}

- (IBAction)IDListAction:(id)sender {
    
    [self showMenu:(UIView *)sender menuType:XYMenuMidNormal];

}

- (void)showMenu:(UIView *)sender menuType:(XYMenuType)type{

    
    NSDictionary *jsDic= [Common dictionaryWithJsonString:[Common getEncryptedContent:APP_ACCOUNT]];
    _identArr = [NSMutableArray arrayWithArray:jsDic[@"identities"]];
    
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *imageArr = [NSMutableArray array];

    for (int i=0;i<_identArr.count;i++) {
        
        
        [nameArr addObject:[_identArr[i] valueForKey:@"label"]];
        [imageArr addObject:[NSString stringWithFormat:@"随机icon%ld",(long)(i+1)%4+1]];
    }


    [sender xy_showMenuWithImages:imageArr titles:nameArr menuType:type withItemClickIndex:^(NSInteger index) {
        
        [self chagneIdentityWithIndex:index];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            
        }];
    }];
    
}

- (void)chagneIdentityWithIndex:(NSInteger)index{
    
    index = index-1;
    NSDictionary *identityDic = _identArr[index];
    NSString * key = [[identityDic valueForKey:@"controls"][0] valueForKey:@"key"];
    NSString * identityName = [identityDic valueForKey:@"label"];
    [[NSUserDefaults standardUserDefaults] setValue:[identityDic valueForKey:@"ontid"] forKey:ONT_ID];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@DeviceCode",[identityDic valueForKey:@"ontid"] ] ];
    [[NSUserDefaults standardUserDefaults] setValue:identityName forKey:IDENTITY_NAME];
    [[NSUserDefaults standardUserDefaults] setValue:key forKey:ENCRYPTED_PRIVATEKEY];
    
    NSString *deviececode = [[NSUserDefaults standardUserDefaults] valueForKey:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
    DebugLog(@"devicecode=%@",deviececode);
    [[NSUserDefaults standardUserDefaults] setValue:deviececode forKey:DEVICE_CODE];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", @(index)] forKey:SELECTINDEX];
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SOCKET_LOGOUT object:nil];
//    //切换后 websoket 需要重连
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    appDelegate.isSocketConnect = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    inputText = @"";
    [textField resignFirstResponder];
    
    
    

    
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
    keyboard.hostTextField = self.passwordF;
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
    keyboard.stringPlaceholder = self.passwordF.placeholder;
    keyboard.intMaxLength = 15;//最大输入长度
    keyboard.keyboardType = HYKeyboardTypeNumber;//输入框类型
    /**更新安全键盘输入类型*/
    [keyboard shouldRefresh:HYKeyboardTypeNumber];
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

#pragma mark--关闭键盘回调

-(void)inputOverWithTextField:(UITextField *)textField inputText:(NSString *)text
{
    inputText=text;
   
        self.passwordF.text = text;
    
    
    [self hiddenKeyboardView];
    
}

-(void)inputOverWithChange:(UITextField *)textField changeText:(NSString *)text
{
    //    NSLog(@"变化内容:%@",text);
    inputText=text;
 
    self.passwordF.text = text;

    [self textFieldDidChange:self.passwordF];
    
    if (textField.text.length == 6) {
        [textField resignFirstResponder];
        //        _callbackPwd(textField.text);
        [self hiddenKeyboardView];
    }
}
- (void)textFieldDidChange:(UITextField *)textField{

        
        if (textField.text.length > 6) {
            
            textField.text = [textField.text substringToIndex:6];
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
