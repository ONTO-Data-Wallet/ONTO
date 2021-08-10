//
//  ImportEnterViewController.m
//  ONTO
//
//  Created by 张超 on 2018/3/11.
/*
 * **************************************************************************************
 *  Copyright © 2014-2018 Ontology Foundation Ltd.
 *  All rights reserved.
 *
 *  This software is supplied only under the terms of a license agreement,
 *  nondisclosure agreement or other written agreement with Ontology Foundation Ltd.
 *  Use, redistribution or other disclosure of any parts of this
 *  software is prohibited except in accordance with the terms of such written
 *  agreement with Ontology Foundation Ltd. This software is confidential
 *  and proprietary information of Ontology Foundation Ltd.
 *
 * **************************************************************************************
 *///

#import "ImportEnterViewController.h"
#import "BackView.h"
#import "ConfirmPwdViewController.h"

@interface ImportEnterViewController ()

@property (weak, nonatomic) IBOutlet UITextView *contentT;
@property (weak, nonatomic) IBOutlet UILabel *alertL;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end

@implementation ImportEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
}

- (void)configUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#4e4e4e"];
    BackView *backV = [[BackView alloc] initWithFrame:CGRectZero];
    [backV setCallbackBack:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:backV];
    
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(StatusBarHeight+3);
        make.height.mas_equalTo(@30);
    }];
    [backV layoutIfNeeded];
    
    self.alertL.text = Localized(@"EnterEncrypted");
    self.contentT.layer.cornerRadius = 5;
    self.contentT.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 1;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.borderColor = [UIColor colorWithHexString:@"#20c0db"].CGColor;
    self.confirmBtn.layer.borderWidth = 1;
    self.changeBtn.layer.cornerRadius = 1;
    self.changeBtn.layer.masksToBounds = YES;
    [self.confirmBtn setTitle:Localized(@"Confirm") forState:UIControlStateNormal];
    [self.changeBtn setTitle:Localized(@"QRCode") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)confirmAction:(id)sender {
    
    if (_isWallet==NO) {
        NSDictionary *jsDic= [self parseJSONStringToNSDictionary:[Common getEncryptedContent:APP_ACCOUNT]];
        NSArray *idenArr = jsDic[@"identities"];
        for (int i=0; i<idenArr.count; i++) {
            NSDictionary *dic = idenArr[i];
            //身份导入重复时
            if ([self.contentT.text  isEqualToString:[[[dic valueForKey:@"controls"] objectAtIndex:0] valueForKey:@"key"]]) {

       
                
                MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Alreadyin") message:nil image:nil];
                MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                    [self.navigationController popViewControllerAnimated:YES];

                }];
                action.titleColor =MainColor;
                [pop addAction:action];
                [pop show];
                pop.showCloseButton = NO;
                
                return;
            }
        }
    }
    else
    {
        //钱包重复导入
        NSArray *idenArr = [[NSUserDefaults standardUserDefaults] objectForKey:ALLASSET_ACCOUNT];
        for (int i=0; i<idenArr.count; i++)
        {
            NSDictionary *dic = idenArr[i];
            if ([self.contentT.text isEqualToString:[dic valueForKey:@"key"]])
            {

//                MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletAlreadyin") message:nil image:nil];
//                MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//                    [self.navigationController popViewControllerAnimated:YES];
//
//                }];
//                action.titleColor =MainColor;
//                [pop addAction:action];
//                [pop show];
//                pop.showCloseButton = NO;
                
                return;
            }
        }
    }
    
        ConfirmPwdViewController *vc = [[ConfirmPwdViewController alloc] init];
        vc.encryptedStr = self.contentT.text;
        vc.isWallet = _isWallet;
        [self.navigationController pushViewController:vc animated:YES];
    
}


-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}


- (IBAction)changeAction:(id)sender {
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
