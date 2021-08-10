//
//  ONTOWakePayViewController.m
//  ONTO
//
//  Created by Apple on 2019/5/15.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTOWakePayViewController.h"

@interface ONTOWakePayViewController ()
@property(nonatomic, strong)UIView* bottomView;
@end

@implementation ONTOWakePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI ];
}
-(void)createUI{
    NSDictionary* params = _infoDic[@"params"];
    _bottomView = [[UIView alloc]init];
    _bottomView.layer.cornerRadius = 5;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    UIButton* closeBtn = [[UIButton alloc]init];
    [closeBtn setEnlargeEdge:25];
    [closeBtn setImage:[UIImage imageNamed:@"Dapp_Close_gray"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:closeBtn];
    
    UILabel* typeLB = [[UILabel alloc]init];
    typeLB.text = Localized(@"wakePay");// Login wakePay
    typeLB.font = [UIFont systemFontOfSize:21 weight:UIFontWeightSemibold];
    [_bottomView addSubview:typeLB];
    
    UIImageView* thirdImage = [[UIImageView alloc]init];
    thirdImage.layer.cornerRadius = 12.5;
    [thirdImage sd_setImageWithURL:[NSURL URLWithString:params[@"dappIcon"]] placeholderImage:[UIImage imageNamed:@"Dapp_Logo"]];
    [_bottomView addSubview:thirdImage];
    
    UILabel* thirdName = [[UILabel alloc]init];
    
    if ([Common isBlankString:params[@"dappName"]]) {
        thirdName.text =@"Dapp";
    }else {
        thirdName.text =params[@"dappName"];
    }
    thirdName.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:thirdName];
    
    UIView* pwdV = [[UIView alloc]init];
    pwdV.layer.cornerRadius = 3;
    pwdV.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [_bottomView addSubview:pwdV];
    
    UITextField* pwdField = [[UITextField alloc]init];
    pwdField.font = [UIFont systemFontOfSize:14];
    pwdField.placeholder = Localized(@"InputWalletPWD");
    pwdField.secureTextEntry = YES;
    [pwdField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_bottomView addSubview:pwdField];
    
    UIButton* eyeBtn = [[UIButton alloc]init];
    [eyeBtn setEnlargeEdge:25];
    [eyeBtn setImage:[UIImage imageNamed:@"Dapp_Show"] forState:UIControlStateNormal];
    [eyeBtn setImage:[UIImage imageNamed:@"Dapp_Eye"] forState:UIControlStateSelected];
    [_bottomView addSubview:eyeBtn];
    
    UIButton* nextBtn = [[UIButton alloc ]init];
    [nextBtn setTitle:Localized(@"payNext") forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    nextBtn.backgroundColor = [UIColor blackColor];
    [_bottomView addSubview:nextBtn];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-30 - LL_TabbarSafeBottomMargin);
    }];
    
    [typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(self.bottomView).offset(29);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-20);
        make.top.equalTo(self.bottomView).offset(38);
        make.width.height.mas_offset(16);
    }];
    
    [thirdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB);
        make.top.equalTo(typeLB.mas_bottom).offset(15);
        make.width.height.mas_offset(25);
    }];
    
    [thirdName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdImage.mas_right).offset(15);
        make.centerY.equalTo(thirdImage.mas_centerY);
    }];
    
    [pwdV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.right.equalTo(self.bottomView).offset(-20);
        make.top.equalTo(thirdImage.mas_bottom).offset(20);
        make.height.mas_offset(40);
    }];
    
    [pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pwdV).offset(15);
        make.right.equalTo(pwdV).offset(-27);
        make.top.equalTo(thirdImage.mas_bottom).offset(20);
        make.height.mas_offset(40);
    }];
    
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pwdV).offset(-11);
        make.centerY.equalTo(pwdField);
        make.width.mas_offset(16);
        make.height.mas_offset(13);
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdField.mas_bottom).offset(25);
        make.left.right.equalTo(pwdV);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-21);
        make.height.mas_offset(40);
    }];
    
    [nextBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (_pwdBlock) {
            _pwdBlock(pwdField.text);
        }
    }];
    
    [eyeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        eyeBtn.selected = !eyeBtn.selected;
        pwdField.secureTextEntry = eyeBtn.selected ? NO : YES;
    }];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:15];
        
    }
}

-(void)closeView {
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
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
