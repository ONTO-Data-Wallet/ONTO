//
//  ConfirmJoinView.m
//  ONTO
//
//  Created by Apple on 2018/7/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ConfirmJoinView.h"
#import "Config.h"
#import "HYKeyboard.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SPACE 10
#define KEYBOARD_NIB_PATH @"BangcleSafeKeyBoard.bundle/resources/HYKeyboard"

@interface ConfirmJoinView ()<HYKeyboardDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    HYKeyboard*keyboard;
}
@property (nonatomic, strong) UIView           *bgView;
@property (nonatomic, strong) UIView           *maskView;
@property (strong, nonatomic) UITextField      *passwordF;
@property (strong, nonatomic) UITextField      *addressField;
@property (nonatomic, copy)   NSString         *walletAddress;
@property (nonatomic, strong) PwdEnterView     *pwdEnterV;
@property (nonatomic, strong) NSMutableArray   *dataArray;
@property (nonatomic,strong)  UITableView      *tableView;
@property (nonatomic,strong)  NSDictionary     *selectDic;
@property (nonatomic,assign)  BOOL             isFirst;
@property (nonatomic,copy)    NSString         *password;
@property (nonatomic,assign)  NSInteger        selectRow;
@property (nonatomic, strong) UIButton           *sureBtn;
@end

@implementation ConfirmJoinView

-(instancetype)initWithAddress:(NSString *)address  isFirst:(BOOL)isFirst{
    self = [super init];
    if (self) {
        self.walletAddress =address;
        self.isFirst =isFirst;
        self.selectRow =-1;
        [self getData];
        [self configUI];
    }
    return self;
}
-(void)getData{
    _dataArray = [NSMutableArray array];
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary * walletDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSMutableArray *allArray= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:ALLASSET_ACCOUNT]] ;
    if (self.isFirst==YES) {
        for (NSDictionary* dic in walletDic[@"coPayers"]) {
            for (NSDictionary * allDic in allArray) {
                if ([allDic isKindOfClass:[NSDictionary class]] &&allDic[@"label"]) {
                    if ([dic[@"address"] isEqualToString:allDic[@"address"]]) {
                        [_dataArray addObject:allDic];
                    }
                }
            }
        }
    }else{
        for (NSDictionary* dic in walletDic[@"coPayers"]) {
            if ([self.walletAddress isEqualToString:dic[@"address"]]) {
                [_dataArray addObject:dic];
            }
        }
    }
    
}
- (void)configUI {
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    [self createDetailV];
}
-(void)createDetailV{
    UIButton * leftImage =[[UIButton alloc]initWithFrame:CGRectMake(16*SCALE_W, 12*SCALE_W, 22*SCALE_W, 22*SCALE_W)];
    [leftImage setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftImage handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismiss];
    }];
    [self.bgView addSubview:leftImage];
    
    UILabel* titleLB =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 47*SCALE_W)];
    titleLB.textAlignment =NSTextAlignmentCenter;
    titleLB.font =[UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLB.textColor =[UIColor colorWithHexString:@"#6A797C"];
    titleLB.text =Localized(@"EnterPassword");
    [self.bgView addSubview:titleLB];
    
    
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 47*SCALE_W-1, SYSWidth, 1)];
    line.backgroundColor =LINEBG;
    [self.bgView addSubview:line];
    
    NSMutableAttributedString *addressString = [[NSMutableAttributedString alloc] initWithString:Localized(@"YourWalletAddress")];
    if (![[Common getUserLanguage]isEqualToString:@"en"]) {
        [addressString addAttribute:NSForegroundColorAttributeName value:MAINAPPCOLOR range:NSMakeRange(0, 4)];
        [addressString addAttribute:NSForegroundColorAttributeName value:BLACKLB range:NSMakeRange(4, addressString.length-4)];
    }else{
        [addressString addAttribute:NSForegroundColorAttributeName value:MAINAPPCOLOR range:NSMakeRange(0, 11)];
        [addressString addAttribute:NSForegroundColorAttributeName value:BLACKLB range:NSMakeRange(11, addressString.length-11)];
    }
    UILabel *addressLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 80*SCALE_W, SYSWidth-75*SCALE_W, 17*SCALE_W )];
    addressLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    addressLB.textAlignment =NSTextAlignmentLeft;
    addressLB.attributedText =addressString;
    [self.bgView addSubview:addressLB];
    
    
    NSMutableAttributedString *pwdString = [[NSMutableAttributedString alloc] initWithString:Localized(@"YourWalletPSW")];
    if (![[Common getUserLanguage]isEqualToString:@"en"]) {
        [pwdString addAttribute:NSForegroundColorAttributeName value:MAINAPPCOLOR range:NSMakeRange(0, 4)];
        [pwdString addAttribute:NSForegroundColorAttributeName value:BLACKLB range:NSMakeRange(4, pwdString.length-4)];
    }else{
        [pwdString addAttribute:NSForegroundColorAttributeName value:MAINAPPCOLOR range:NSMakeRange(0, 11)];
        [pwdString addAttribute:NSForegroundColorAttributeName value:BLACKLB range:NSMakeRange(11, pwdString.length-11)];
    }
    UILabel *pawLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 168*SCALE_W, SYSWidth-48*SCALE_W, 17*SCALE_W )];
    pawLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    pawLB.textAlignment =NSTextAlignmentLeft;
    pawLB.attributedText =pwdString;
    [self.bgView addSubview:pawLB];
    
    for (int i=0; i<1; i++) {
        UIView * line1 =[[UIView alloc]initWithFrame:CGRectMake(24*SCALE_W, 146*SCALE_W +86*i, SYSWidth-56, 1)];
        line1.backgroundColor =LINEBG;
        [self.bgView addSubview:line1];
    }
    self.addressField =[[UITextField alloc]initWithFrame:CGRectMake(24*SCALE_W, 102*SCALE_W, SYSWidth-70*SCALE_W, 30*SCALE_W)];
    self.addressField.textColor =BLACKLB;
    self.addressField.placeholder =Localized(@"FillAddress");
    
    self.addressField.font =[UIFont systemFontOfSize:12];
    [self.bgView addSubview:self.addressField];
    
    UIButton *selectAddressBtn =[[UIButton alloc]initWithFrame:CGRectMake(SYSWidth- 42*SCALE_W, 108*SCALE_W, 16*SCALE_W, 16*SCALE_W)];
    [selectAddressBtn setEnlargeEdge:10];
    [selectAddressBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    selectAddressBtn.selected =YES;
    [selectAddressBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.addressField resignFirstResponder];
        [self.passwordF resignFirstResponder];
        if (selectAddressBtn.selected==YES) {
            [selectAddressBtn setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
            [self.bgView addSubview:self.tableView];
            self.tableView.hidden =NO;
            [self.tableView reloadData];
        }else{
            [selectAddressBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
            self.tableView.hidden =YES;
        }
        selectAddressBtn.selected =!selectAddressBtn.selected;
    }];
    [self.bgView addSubview:selectAddressBtn];
    
    if (_dataArray.count ==1) {
        self.addressField.text =_dataArray[0][@"address"];
        self.selectDic =_dataArray[0];
        selectAddressBtn.hidden =YES;
    }else{
        self.addressField.text =_dataArray[0][@"address"];
        self.selectDic =_dataArray[0];
        self.selectRow =0;
    }
    
    //密码
    [self.bgView addSubview:self.pwdEnterV];
    self.pwdEnterV.frame =CGRectMake(24*SCALE_W, 189*SCALE_W, SYSWidth-48*SCALE_W, 30*SCALE_W);
//    self.passwordF =[[UITextField alloc]initWithFrame:CGRectMake(24*SCALE_W, 189*SCALE_W, SYSWidth-48*SCALE_W, 30*SCALE_W)];
//    self.passwordF.borderStyle = UITextBorderStyleNone;
//    self.passwordF.font = K14FONT;
//    self.passwordF.placeholder = Localized(@"SelectAlertPassWord");
//    self.passwordF.secureTextEntry = YES;
//    self.passwordF.keyboardType = UIKeyboardTypeNumberPad;
//    self.passwordF.delegate = self;
//    [self.passwordF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self.bgView addSubview:self.passwordF];
    
    self.sureBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 476*SCALE_W, SYSWidth, 48*SCALE_W)];
    if (LL_iPhoneX) {
        self.sureBtn.frame = CGRectMake(0, 476*SCALE_W-LL_TabbarSafeBottomMargin, SYSWidth,48*SCALE_W);

    }
    [self.sureBtn setTitle:Localized(@"Confirm") forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    self.sureBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [self.sureBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
    [self.sureBtn addTarget:self action:@selector(confirmInput) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.sureBtn];
    
}
-(void)confirmInput{

    if (self.password.length < 8 ) {
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"SelectAlertPassWord") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{}];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }

    DebugLog(@"----------------------------confirmInput");
    self.sureBtn.enabled = NO;

    if (_callback) {
        _callback(self.addressField.text,self.password,self.selectDic);
    }
    [self.pwdEnterV hiddenKeyboardView];

    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:3.0f];//防止用户重复点击

}

-(void)changeButtonStatus{
    DebugLog(@"----------------------------confirmInput  changeButtonStatus");
    self.sureBtn.enabled = YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*SCALE_W;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID =@"defaultCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(15*SCALE_W, 0, SYSWidth-78*SCALE_W, 44*SCALE_W)];
        lb.tag =1000;
        lb.textAlignment =NSTextAlignmentLeft;
        lb.font =[UIFont systemFontOfSize:12];
        lb.textColor =LIGHTBLACK;
        [cell.contentView addSubview:lb];
        
        UIView *lineV =[[UIView alloc]initWithFrame:CGRectMake(0, 44*SCALE_W-1, SYSWidth-48*SCALE_W, 1)];
        lineV.backgroundColor =LINEBG;
        [cell.contentView addSubview:lineV];
    }
    NSDictionary* dic =_dataArray[indexPath.row];
    UILabel *addressLB =(UILabel*)[cell.contentView viewWithTag:1000];
    addressLB.text =dic[@"address"];
    if (self.selectRow  == indexPath.row) {
        cell.backgroundColor =[UIColor colorWithHexString:@"#F1F7FB"];
    }else{
        cell.backgroundColor =[UIColor whiteColor];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.addressField.text =_dataArray[indexPath.row][@"address"];
    self.selectDic =_dataArray[indexPath.row];
    if (self.selectRow!=-1 && self.selectRow !=indexPath.row) {
        
        [self.pwdEnterV clearPassword];
    }
    self.selectRow =indexPath.row;
    tableView.hidden =YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField == self.passwordF) {
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
            
        }
        
    }
    
}
- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}
-(UIView*)bgView{
    if (!_bgView) {
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(0, SYSHeight-524*SCALE_W , Screen_Width, 524*SCALE_W)];
        _bgView.clipsToBounds =YES;
        _bgView.backgroundColor =[UIColor whiteColor];
    }
    return _bgView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
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
//    keyboard.hostTextField = _isreType==NO?self.passwordF:self.reEnterPasswordF;
    /**是否输入内容加密*/
    keyboard.secure = YES;
    //设置加密类型，分为AES和SM42种类型，默认为SM4
    //    [keyboard setSecureType:HYSecureTypeAES];
    //    keyboard.arrayText = [NSMutableArray arrayWithArray:contents];//把已输入的内容以array传入;
    /**输入框已有的内容*/
//    keyboard.contentText=inputText;
    keyboard.synthesize = YES;//hostTextField输入框同步更新，用*填充
    /**是否清空输入框内容*/
    keyboard.shouldClear = YES;
    /**背景提示*/
//    keyboard.stringPlaceholder = _isreType==NO?self.passwordF.placeholder:self.reEnterPasswordF.placeholder;
    keyboard.intMaxLength = 15;//最大输入长度
    //    keyboard.keyboardType = HYKeyboardTypeNumber;//输入框类型
    /**更新安全键盘输入类型*/
    //    [keyboard shouldRefresh:HYKeyboardTypeNumber];
    //    [keyboard setTextAnimationSecond:0.8];//默认不设置，动画时长为1秒
    //--------添加安全键盘到ViewController---------
    
    [self addSubview:keyboard.view];
    [self bringSubviewToFront:keyboard.view];
    //安全键盘显示动画
    CGRect rect=keyboard.view.frame;
    rect.size.width=self.frame.size.width;
    rect.origin.y=self.frame.size.height+10;
    
    keyboard.view.frame=rect;
    //显示输入框动画
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.2f];
    rect.origin.y=self.frame.size.height-keyboard.view.frame.size.height;
    keyboard.view.frame=rect;
    [UIView commitAnimations];
    
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(24*SCALE_W, 146*SCALE_W, SYSWidth-48*SCALE_W, 132*SCALE_W) style:UITableViewStylePlain];
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.layer.cornerRadius =3;
        _tableView.layer.borderWidth=1;
        _tableView.layer.borderColor =[LINEBG CGColor];
    }
    return _tableView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}

- (void)show {
    NSInteger y =  Screen_Width==375 ?Screen_height+43:Screen_height ;
     [self.pwdEnterV clearPassword];
    _bgView.frame = CGRectMake(0, y , Screen_Width - (SCALE_W * 0), 524*SCALE_W);
    self.password =@"";
    [UIView animateWithDuration:.2 animations:^{
        _bgView.frame = CGRectMake(0, SYSHeight-524*SCALE_W , Screen_Width - (SCALE_W * 0), 524*SCALE_W);
        _maskView.alpha = .5;
        
    }];
}

- (void)dismiss {
    [self.pwdEnterV hiddenKeyboardView];
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y += _bgView.bounds.size.height;
        _bgView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.superview.hidden = YES;
    }];
}
#pragma mark--关闭键盘回调

-(void)inputOverWithTextField:(UITextField *)textField inputText:(NSString *)text{
    
    self.passwordF.text =text;
    
    [self hiddenKeyboardView];
}

-(void)inputOverWithChange:(UITextField *)textField changeText:(NSString *)text
{
    self.passwordF.text = text;
    [self textFieldDidChange:self.passwordF];
    if (textField.text.length == 15) {
        DebugLog(@"输入完毕");
        [textField resignFirstResponder];
        //        _callbackPwd(textField.text);
        [self hiddenKeyboardView];
    }
}

-(void)hiddenKeyboardView
{
//    隐藏输入框动画
    [ UIView animateWithDuration:0.3 animations:^
     {
         CGRect rect=keyboard.view.frame;
         rect.origin.y=self.bgView.frame.size.height+10;
         keyboard.view.frame=rect;

     }completion:^(BOOL finished){
    
         [keyboard.view removeFromSuperview];
         keyboard.keyboardDelegate=nil;
         keyboard.view =nil;
         keyboard=nil;
     }];
}
- (PwdEnterView *)pwdEnterV {
    if (!_pwdEnterV) {
        __weak typeof(self) weakself = self;
        _pwdEnterV = [[PwdEnterView alloc] initWithFrame:CGRectMake(24*SCALE_W, 189*SCALE_W, SYSWidth-48*SCALE_W, 30*SCALE_W)];
        _pwdEnterV.textField.placeholder =Localized(@"SelectAlertPassWord");
        _pwdEnterV.textField.font =K14FONT;
        _pwdEnterV.textField.tintColor =[UIColor blackColor];
        [_pwdEnterV setCallbackPwd:^(NSString *pwd_text) {
            weakself.password = pwd_text;
        }];
    }
    return _pwdEnterV;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.pwdEnterV hiddenKeyboardView];
    [self hiddenKeyboardView];
}
@end
