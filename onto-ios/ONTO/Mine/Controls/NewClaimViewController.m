//
//  NewClaimViewController.m
//  ONTO
//
//  Created by Apple on 2018/11/22.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "NewClaimViewController.h"

#import "CCRequest.h"
#import <WebKit/WebKit.h>
#import "ConfirmPwdViewController.h"
#import "AnimationView.h"
#import "Config.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "IdentityViewController.h"
#import "BlockChainCertCell.h"
#import "IDViewController.h"
#import "DataBase.h"
#import "ClaimModel.h"
#import "WebIdentityViewController.h"
#import "RealNameViewController.h"
#import "LPActionSheet.h"
#import "AuthInfoViewController.h"
#import "blackView.h"
#import "Common.h"
#import "ONTO-Swift.h"
@interface NewClaimViewController ()<UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate>
@property(weak, nonatomic) IBOutlet UILabel *claimLabel;
@property(weak, nonatomic) IBOutlet UILabel *creatTime;
@property(weak, nonatomic) IBOutlet UILabel *expiredTime;
@property(weak, nonatomic) IBOutlet UITableView *myTable;
@property(nonatomic, strong) NSMutableArray *contentTitleArr;
@property(nonatomic, strong) NSMutableArray *contentValueArr;
@property(nonatomic, copy) NSString *context;
@property(nonatomic, copy) NSString *issuer;
@property(nonatomic, copy) NSString *subject;
@property(nonatomic, copy) NSString *txnHash;

@property(nonatomic, strong) AnimationView *animationV;
@property(weak, nonatomic) IBOutlet UILabel *expiredLabel;
@property(weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property(weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property(weak, nonatomic) IBOutlet UIView *bgFooterView;
@property(weak, nonatomic) IBOutlet UIImageView *companyIcon;
@property(weak, nonatomic) IBOutlet UILabel *headerL1;
@property(weak, nonatomic) IBOutlet UILabel *headerLabel2;
@property(weak, nonatomic) IBOutlet UILabel *creatTimeLabel;

@property(nonatomic, copy) NSString *password;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) NSTimer *timer;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewBottom;

@property(weak, nonatomic) IBOutlet UILabel *claimStatus;

@property(nonatomic, strong) NSDictionary *claimDic;

@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIView *animateV;
@property(nonatomic,strong)NSDictionary * ChargeInfo;
@end

@implementation NewClaimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
    
    //实名认证本地化
    NSString *ontID = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
    ClaimModel *model = [[DataBase sharedDataBase] getCalimWithClaimContext:self.claimContext andOwnerOntId:ontID];
    
    if ([Common isBlankString:model.OwnerOntId]) {
        [self getData];
    } else if (self.isFace) {
        [self getData];
    } else {
        [self handleData:[Common dictionaryWithJsonString:model.Content]];
    }
    
    [self setTable];
    [self configNav];
    
    if (!_isPending) {
        [_tableviewBottom setConstant:10];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (_isFace) {
        // 禁用返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

- (void)showMsg:(NSString *)msg {
    _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // 显示模式,改成customView,即显示自定义图片(mode设置,必须写在customView赋值之前)
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.label.text = msg;
}

- (void)configNav {
    [self setNavTitle:Localized(@"newClaimDetails")];
    
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    
    //    if (![_claimContext isEqualToString:@"claim:employment_authentication"]){
    ////        [self setNavRightImageIcon:nil Title:Localized(@"Update")];
    //        [self setNavRightImageIcon:[UIImage imageNamed:@"IdDot"] Title:nil];
    //    }
    if ([self.claimContext isEqualToString:@"claim:cfca_authentication"]|| [self.claimContext isEqualToString:@"claim:sensetime_authentication"]) {
    }else{
        [self setNavRightImageIcon:[UIImage imageNamed:@"IdDot"] Title:nil];
        
    }
    
}

- (void)navRightAction {
    
    AppDelegate *appdelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.bottomView removeFromSuperview];
    self.bottomView = [blackView initWithForView:appdelegate.window];
    self.bottomView.alpha = 0;
    
    self.animateV = [[UIView alloc] initWithFrame:CGRectMake(0, SYSHeight, SYSWidth, 168 * SCALE_W)];
    [self.bottomView addSubview:self.animateV];
    
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(16 * SCALE_W, 0, SYSWidth - 32 * SCALE_W, 101 * SCALE_W)];
    bgV.backgroundColor = [UIColor whiteColor];
    bgV.layer.cornerRadius = 2.f;
    [self.animateV addSubview:bgV];
    
    UIButton *renewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SYSWidth - 32 * SCALE_W, 50 * SCALE_W)];
    [renewBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    [renewBtn setTitle:Localized(@"Renew") forState:UIControlStateNormal];
    renewBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [bgV addSubview:renewBtn];
    
    UIButton *deleteBtn =
    [[UIButton alloc] initWithFrame:CGRectMake(0, 51 * SCALE_W, SYSWidth - 32 * SCALE_W, 50 * SCALE_W)];
    [deleteBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    [deleteBtn setTitle:Localized(@"Delete") forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [bgV addSubview:deleteBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50 * SCALE_W, SYSWidth - 32 * SCALE_W, 1 * SCALE_W)];
    line.backgroundColor = LIGHTGRAYBG;
    [bgV addSubview:line];
    
    UIButton *cancleBtn =
    [[UIButton alloc] initWithFrame:CGRectMake(16 * SCALE_W, 110 * SCALE_W, SYSWidth - 32 * SCALE_W, 50 * SCALE_W)];
    cancleBtn.layer.cornerRadius = 2.f;
    cancleBtn.backgroundColor = [UIColor whiteColor];
    [cancleBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    [cancleBtn setTitle:Localized(@"Cancel") forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.animateV addSubview:cancleBtn];
    
    UITapGestureRecognizer
    *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissScreenBgView)];
    tapGesture.cancelsTouchesInView = YES;
    [self.bottomView addGestureRecognizer:tapGesture];
    
    [renewBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [UIView animateWithDuration:.2 animations:^{
            self.animateV.frame = CGRectMake(0, SYSHeight, SYSWidth, SYSHeight);
            self.bottomView.alpha = 0;
        }                completion:^(BOOL finished) {
            
            if ([self.claimContext isEqualToString:@"claim:cfca_authentication"]) {
                RealNameViewController *vc = [[RealNameViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            NSInteger claimType = 0;
            
            NSString *context = self.claimContext;
            
            if ([context isEqualToString:@"claim:linkedin_authentication"]) {
                claimType = 1;
            } else if ([context isEqualToString:@"claim:github_authentication"]) {
                claimType = 2;
            } else if ([context isEqualToString:@"claim:facebook_authentication"]) {
                claimType = 3;
            } else if ([context isEqualToString:@"claim:twitter_authentication"]) {
                claimType = 0;
            }
            
            WebIdentityViewController *webVC = [[WebIdentityViewController alloc] init];
            webVC.identityType = (IdentityType) claimType;
            webVC.claimurl = self.H5ReqParam;
            [self.navigationController pushViewController:webVC animated:YES];
        }];
    }];
    
    [deleteBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        DebugLog(@"222");
        [self dismissScreenBgView];
        //        [[DataBase sharedDataBase] deleteCalim:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
        [[DataBase sharedDataBase]
         deleteCalim:[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID] andClaimContext:_claimContext];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [cancleBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissScreenBgView];
    }];
    
    [UIView animateWithDuration:.2 animations:^{
        self.animateV.frame = CGRectMake(0, SYSHeight - 168 * SCALE_W, SYSWidth, SYSHeight);
        self.bottomView.alpha = 1;
    }];
    //    NSInteger type = 0;
    //
    //    //cfca认证
    //    if ([_claimContext isEqualToString:@"claim:cfca_authentication"]) {
    //
    //        RealNameViewController *vc = [[RealNameViewController alloc] init];
    //        [self.navigationController pushViewController:vc animated:YES];
    //        return;
    //    }
    //
    //    //社交媒体认证
    //    if ([_claimContext isEqualToString:@"claim:twitter_authentication"]){
    //        type = 0;
    //    }else if ([_claimContext isEqualToString:@"claim:linkedin_authentication"]){
    //        type = 1;
    //    }else if ([_claimContext isEqualToString:@"claim:github_authentication"]){
    //        type = 2;
    //    }else if ([_claimContext isEqualToString:@"claim:facebook_authentication"]){
    //        type = 3;
    //    }
    //      WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
    //      webVC.identityType = (IdentityType)type;
    //      [self.navigationController pushViewController:webVC animated:YES];
    
}
- (void)navLeftAction {
    
    if (_isFace) {
        // 返回到指定界面
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[IDViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
            if ([temp isKindOfClass:[BoxListDetailController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
            
        }
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)configUI {
    
    _confirmBtn.hidden = !_isPending;
    _cancleBtn.hidden = !_isPending;
    _creatTimeLabel.text = Localized(@"CreatTime");
    
}

- (void)setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)creatAnimation {
    
    self.animationV = [[AnimationView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    __weak typeof(self) weakSelf = self;
    [self.animationV setCallback:^{
        [weakSelf showSuccessView:NO];
    }];
    [self.view addSubview:self.animationV];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NAVBACKCOLOR] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //销毁定时器
    [_timer invalidate];
    _timer = nil;
}

- (void)handlePrompt:(NSString *)prompt {
    [_hud hideAnimated:YES];
    if ([prompt hasPrefix:@"getClaim"]) { //创建身份账户
        //        [self.animationV A_stopAnimation];
        [self showSuccessView:YES];
        //        self.backupBtn.userInteractionEnabled = YES;
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        
        id obj =
        [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hud hideAnimated:YES];
            //            [self showHint:Localized(@"FailBeingtoWritten")];
            [Common showToast:Localized(@"FailBeingtoWritten")];
            return;
        }
        NSDictionary *params = @{@"OwnerOntId": [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID],
                                 @"DeviceCode": [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_CODE],
                                 @"ClaimId": self.claimId ? self.claimId : @"",
                                 @"TxnStr": [obj valueForKey:@"tx"]
                                 //                                 @"ConfirmFlag":@(true)
                                 
                                 };
        DebugLog(@"!!!%@", params);
        [[CCRequest shareInstance]
         requestWithURLString:DDOUpdate MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                          id responseOriginal) {
             [[DataBase sharedDataBase]
              changtoStatus:@"1" ClaimContext:_claimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]
                                                                           valueForKey:ONT_ID]];
             
             [self popVC];
             
         }                Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
             
         }];
        
    }
}

- (void)popVC {
    
    __weak typeof(self) weakSelf = self;
    
    if (_isFace) {
        // 返回到指定界面
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[IDViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    } else {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
}

- (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary
    *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

- (void)showSuccessView:(BOOL)isSuccess {
    //    self.animationV.hidden = YES;
    //    promptL.hidden = YES;
    //    self.successV = [[SuccessView alloc] initWithFrame:CGRectZero Success:isSuccess];
    //    [self.view addSubview:self.successV];
    //    [self.backupBtn setBackgroundColor:[UIColor colorWithHexString:@"#2295d4"]];
    //    [self.backupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    if (!isSuccess) {
    //        [self.backupBtn setTitle:Localized(@"CreateAgain") forState:UIControlStateNormal];
    //    }
    //
    //    [self.successV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.mas_equalTo(self.view);
    //        make.top.equalTo(self.view).offset(65);
    //        make.bottom.equalTo(bgIV.mas_bottom).offset(-30);
    //    }];
    //    [self.successV layoutIfNeeded];
    //}
}

- (IBAction)getClaimClick:(id)sender {
    
    //    ConfirmPwdViewController *vc = [[ConfirmPwdViewController alloc]init];
    //    vc.isClaims = YES;
    //    vc.delegate = self;
    //    [self.navigationController pushViewController:vc animated:YES];
    [self getCalim];
    
}
//第二次

//代理方法
- (void)getCalim {
    
    //    _password = password;
    
    NSString *password = [Common getEncryptedContent:[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]];
    
    NSString *jsStr =
    [NSString stringWithFormat:@"Ont.SDK.getClaim('%@','%@','%@','%@','%@','%@','%@','%@','%@','getClaim')", self
     .claimId, self.context, self.issuer, self.subject, [[NSUserDefaults standardUserDefaults]
                                                         valueForKey:ENCRYPTED_PRIVATEKEY], password, [[NSUserDefaults standardUserDefaults]
                                                                                                       valueForKey:ONTPASSADDRSS], [[NSUserDefaults standardUserDefaults]
                                                                                                                                    valueForKey:ONTIDGASPRICE], [[NSUserDefaults standardUserDefaults]
                                                                                                                                                                 valueForKey:ONTIDGASLIMIT]];
    
    [self showMsg:Localized(@"Beingwritten")];
    
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];;
    DebugLog(@"jsStr = %@", jsStr);
    _timer =
    [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
}

//第一次
- (void)loadJS {
    
    NSString *jsStr =
    [NSString stringWithFormat:@"Ont.SDK.getClaim('%@','%@','%@','%@','%@','%@','%@','getClaim')", self
     .claimId, self.context, self.issuer, self.subject, [[NSUserDefaults standardUserDefaults]
                                                         valueForKey:ENCRYPTED_PRIVATEKEY], _password, self.txnHash];
    
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}

- (IBAction)rejectClick:(id)sender {
    
    if ([_claimContext isEqualToString:@"claim:cfca_authentication"]) {
        // 返回到指定界面
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[IDViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        return;
    }
    
    //初始化提示框；
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"确定是否取消" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }]];
    
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        
        //点击按钮的响应事件；
        NSDictionary *params = @{@"OwnerOntId": [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID],
                                 @"DeviceCode": [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_CODE],
                                 @"ClaimId": self.claimId ? self.claimId : @"",
                                 @"TxnHash": @"",
                                 @"ConfirmFlag": @(false)};
        DebugLog(@"!!!%@", params);
        [[CCRequest shareInstance]
         requestWithURLString:Claim_confirm MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                              id responseOriginal) {
             [[DataBase sharedDataBase]
              changtoStatus:@"2" ClaimContext:_claimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]
                                                                           valueForKey:ONT_ID]];
             
             [weakSelf.navigationController popViewControllerAnimated:YES];
             
         }                Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
             
         }];
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)delayMethod {
    [_hud hideAnimated:YES];
    //    [self showHint:Localized(@"FailBeingtoWritten")];
    [Common showToast:Localized(@"FailBeingtoWritten")];
    [self performSelector:@selector(delayMethod2) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    //    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)delayMethod2 {
    
    [_hud hideAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData {
    
    NSDictionary *params = @{@"OwnerOntId": [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID],
                             @"DeviceCode": [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_CODE],
                             @"ClaimId": self.claimId ? self.claimId : @"",
                             @"ClaimContext": self.claimContext ? self.claimContext : @"",
                             //                             @"ClaimContext":@"claim:idm_passport_authentication",
                             @"Status": @""
                             };
    DebugLog(@"!!!%@", params);
    
    [[CCRequest shareInstance]
     requestWithURLString:Claim_query MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                        id responseOriginal) {
         
         DebugLog(@"ceshi=%@", responseObject);
         if ([responseObject[@"EncryptedOrigData"] isEqualToString:@""]) {
             return;
         }
         //实名认证本地化
         
         //  if ([_claimContext isEqualToString:@"claim:cfca_authentication"]) {
         
         ClaimModel *model = [[ClaimModel alloc] init];
         model.OwnerOntId = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
         model.ClaimContext = self.claimContext;
         model.Content = [Common dictionaryToJson:responseObject];
         model.status = @"1";
         [[DataBase sharedDataBase] addClaim:model isSoket:NO];
         
         NSDictionary *dic = [Common claimdencode:responseObject[@"EncryptedOrigData"]];
         NSDictionary *dic1 = dic[@"claim"];
         DebugLog(@"dic->%@", dic);
         //删除后台数据库操作
         NSDictionary *params = @{@"OwnerOntId": [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID],
                                  @"DeviceCode": [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_CODE],
                                  @"ClaimId": dic1[@"jti"]
                                  };
         DebugLog(@"!!!%@", params);
         [[CCRequest shareInstance]
          requestWithURLString:LocalizationConfirm MethodType:MethodTypePOST Params:params Success:^(id responseObject,
                                                                                                     id responseOriginal) {
              
          }                Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
              
          }];
         
         //            ClaimModel *model2 = [[DataBase sharedDataBase]getCalimWithClaimContext:self.claimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
         
         //        }
         
         [self handleData:responseObject];
         
     }                Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
         
     }];
}

- (void)handleData:(NSDictionary *)responseObject {
    self.claimDic = [[Common claimdencode:[responseObject valueForKey:@"EncryptedOrigData"]] valueForKey:@"claim"];
    _claimId = [self.claimDic valueForKey:@"jti"];
    _creatTime.text = [Common getTimeFromTimestamp:[[self.claimDic valueForKey:@"iat"] stringValue]];
    _expiredTime.text = [Common getTimeFromTimestamp:[[self.claimDic valueForKey:@"exp"] stringValue]];
    _headerLabel2.text = Localized(@"IssuerONTID");
    
    NSString *claimType = [self.claimDic valueForKey:@"context"];
    _ChargeInfo = responseObject[@"ChargeInfo"];
    
    if ([claimType isEqualToString:@"claim:employment_authentication"]) {
        _claimLabel.text = Localized(@"Info");
    } else if ([claimType isEqualToString:@"claim:linkedin_authentication"]) {
        _claimLabel.text = @"Linkedin Info";
    } else if ([claimType isEqualToString:@"claim:github_authentication"]) {
        _claimLabel.text = @"Github Info";
    } else if ([claimType isEqualToString:@"claim:facebook_authentication"]) {
        _claimLabel.text = @"Facebook Info";
    } else if ([claimType isEqualToString:@"claim:twitter_authentication"]) {
        _claimLabel.text = @"Twitter Info";
    } else if ([claimType isEqualToString:@"claim:cfca_authentication"]) {
        _claimLabel.text = @"Twitter Info";
    }
    
    [_companyIcon sd_setImageWithURL:[NSURL URLWithString:_claimImage]];
    if ([_expiredTime.text length] == 0) {
        _expiredLabel.hidden = YES;
        _expiredTime.hidden = YES;
    }
    
    NSDictionary *contentDic = [self.claimDic valueForKey:@"clm"];
    
    _contentTitleArr = [NSMutableArray array];
    _contentValueArr = [NSMutableArray array];
    [_contentTitleArr addObject:[contentDic allKeys]];
    [_contentValueArr addObject:[contentDic allValues]];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_contentTitleArr[0]];
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:_contentValueArr[0]];
    for (int i = 0; i < [arr count]; i++) {
        if ([arr[i] isEqualToString:@"IdNumber"] || [arr[i] isEqualToString:@"IssuerName"]) {
            [(NSMutableArray *) arr removeObjectAtIndex:i];
            [(NSMutableArray *) arr1 removeObjectAtIndex:i];
        }
    }
    
    [_contentTitleArr replaceObjectAtIndex:0 withObject:arr];
    [_contentValueArr replaceObjectAtIndex:0 withObject:arr1];
    
    _context = [self.claimDic valueForKey:@"context"];
    _issuer = [self.claimDic valueForKey:@"iss"];
    _subject = [self.claimDic valueForKey:@"sub"];
    
    //第二组数据
    //    可信声明状态 4:待确认 1:已确认接收 2:已拒绝接收
    NSString *statusStr;
    //        Pending = "Pending";
    //        Canceled = "Canceled";
    //        Received = "Received";
    if (_stauts == 1) {
        statusStr = Localized(@"Received");
        _claimStatus.textColor = [UIColor colorWithHexString:@"#60A614"];
    }
    
    if (_stauts == 4) {
        statusStr = Localized(@"Received");
        _claimStatus.textColor = [UIColor colorWithHexString:@"#FF9A49"];
    }
    
    if (_stauts == 9) {
        statusStr = Localized(@"Received");
        _claimStatus.textColor = [UIColor colorWithHexString:@"#FF9A49"];
    }
    
    if (_stauts == 2) {
        statusStr = Localized(@"Canceled");
        _claimStatus.textColor = [UIColor colorWithHexString:@"#fe1717"];
    }
    
    ClaimModel *claimmodel = [[DataBase sharedDataBase]
                              getCalimWithClaimContext:self.claimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]
                                                                                        valueForKey:ONT_ID]];
    
    if (_stauts == 0 && [claimmodel.status integerValue] == 1) {
        NSDictionary *dic = [Common dictionaryWithJsonString:claimmodel.Content];
        NSString *expTime;
        if (dic.count != 0) {
            NSDictionary *dic1 = [Common claimdencode:dic[@"EncryptedOrigData"]];
            NSDictionary *dic2 = dic1[@"claim"];
            expTime = dic2[@"exp"];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
        NSTimeInterval time = [date timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
        
        if ([timeString integerValue] >= [expTime integerValue]) {
            statusStr = Localized(@"IdExpired");
            _claimStatus.textColor = [UIColor colorWithHexString:@"#B41F3C"];
        } else {
            statusStr = Localized(@"Received");
            _claimStatus.textColor = [UIColor colorWithHexString:@"#60A614"];
        }
        
    }
    NSString * feeStr ;
    if (_ChargeInfo.count>0) {
        feeStr  = [NSString stringWithFormat:@"%@ ONG",[Common getshuftiStr:_ChargeInfo[@"Amount"]]];
    }else{
        feeStr  = @"0 ONG";
    }
    
    _claimStatus.text = statusStr;
    if ([Common isBlankString:[responseObject valueForKey:@"TxnHash"]]) {
        
        NSArray *arrKey = @[Localized(@"authStatus"),Localized(@"SFee"), Localized(@"Created"), Localized(@"ExpiresAt")];
        NSArray *arrValue = @[statusStr,feeStr,
                              [NSString stringWithFormat:@"%@", [Common getTimeFromTimestamp:[[self.claimDic valueForKey:@"iat"]
                                                                                              stringValue]]], [Common getTimeFromTimestamp:[[self.claimDic valueForKey:@"exp"] stringValue]]];
        [_contentTitleArr addObject:arrKey];
        [_contentValueArr addObject:arrValue];
        
    } else {
        
        NSString *TxnHash = [Common isBlankString:[responseObject valueForKey:@"TxnHash"]] ? @"" :
        [responseObject valueForKey:@"TxnHash"];
        NSArray *arrKey = @[Localized(@"authStatus"), Localized(@"SFee"),Localized(@"Created"), Localized(@"ExpiresAt"),
                            Localized(@"BlockchainTransaction")];
        
        NSString *created =
        [NSString stringWithFormat:@"%@", [Common getTimeFromTimestamp:[[self.claimDic valueForKey:@"iat"]
                                                                        stringValue]]];
        NSString *exp = [Common getTimeFromTimestamp:[[self.claimDic valueForKey:@"exp"] stringValue]];
        if (statusStr != nil && TxnHash != nil && created != nil && exp != nil) {
            NSArray *arrValue = @[statusStr,feeStr, created, exp, TxnHash];
            [_contentTitleArr addObject:arrKey];
            [_contentValueArr addObject:arrValue];
        }
    }
    
    [_myTable reloadData];
    
}

- (void)setTable {
    //描边
    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.layer.cornerRadius = 1;
    _confirmBtn.layer.borderWidth = 1;
    _confirmBtn.layer.borderColor = MainColor.CGColor;
    [_confirmBtn setTitle:Localized(@"Confirm") forState:UIControlStateNormal];
    _cancleBtn.layer.masksToBounds = YES;
    _cancleBtn.layer.cornerRadius = 1;
    _cancleBtn.layer.borderWidth = 1;
    _cancleBtn.layer.borderColor = MainColor.CGColor;
    [_cancleBtn setTitle:Localized(@"Cancel") forState:UIControlStateNormal];
    
    self.bgFooterView.backgroundColor = LIGHTGRAYBG;
    self.bgFooterView.frame = CGRectMake(8 * SCALE_W, 0, SYSWidth - 16 * SCALE_W, 60 * SCALE_W);
    UIBezierPath *maskPath =
    [UIBezierPath bezierPathWithRoundedRect:self.bgFooterView.bounds byRoundingCorners:UIRectCornerTopLeft
     | UIRectCornerTopRight  cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgFooterView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgFooterView.layer.mask = maskLayer;
    
    CGSize strSize = [[NSString stringWithFormat:@"%@", Localized(@"IssuerONTID")]
                      sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    self.headerLabel2.frame = CGRectMake(32 * SCALE_W, 0, strSize.width, 60 * SCALE_W);
    self.companyIcon.frame = CGRectMake(42 * SCALE_W + strSize.width, 18 * SCALE_W, 108 * SCALE_W, 24 * SCALE_W);
    self.headerLabel2.textColor = LIGHTGRAYLB;
    
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    self.myTable.frame =
    CGRectMake(8 * SCALE_W, 60 * SCALE_W + 1, SYSWidth - 16 * SCALE_W, SYSHeight - 60 * SCALE_W - 64);
    
    if (KIsiPhoneX) {
        self.myTable.frame =
        CGRectMake(8 * SCALE_W, 60 * SCALE_W + 1, SYSWidth - 16 * SCALE_W, SYSHeight - 185 * SCALE_W);
        
    }
    
    [self setExtraCellLineHidden:self.myTable];
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.myTable.showsVerticalScrollIndicator = NO;
    
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYSWidth - 16 * SCALE_W, 67 * SCALE_W)];
    UIImageView *image = [[UIImageView alloc]
                          initWithFrame:CGRectMake(62 * SCALE_W, 31 * SCALE_W, SYSWidth - 140 * SCALE_W, 36 * SCALE_W)];
    [bgV addSubview:image];
    image.image = [UIImage imageNamed:@"Ontoloogy Attested"];
    if (_stauts == 1) {
        self.myTable.tableFooterView = bgV;
    } else if (_stauts == 0) {
        ClaimModel *model = [[DataBase sharedDataBase]
                             getCalimWithClaimContext:self.claimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]
                                                                                       valueForKey:ONT_ID]];
        if ([model.status integerValue] == 1) {
            self.myTable.tableFooterView = bgV;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BlockChainCertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlockChainCertCell"];
    
    if (!cell) {
        cell = [[BlockChainCertCell alloc]
                initWithCornerRadius:3 Style:UITableViewCellStyleSubtitle reuseIdentifier:@"BlockChainCertCell"];
    }
    cell.titleLB.text = _contentTitleArr[indexPath.section][indexPath.row];
    
    if ([_contentValueArr[indexPath.section][indexPath.row] isKindOfClass:[NSNumber class]]) {
        cell.contentLB.text = [_contentValueArr[indexPath.section][indexPath.row] description];
    } else {
        if (([self.claimContext isEqualToString:@"claim:cfca_authentication"] && indexPath.section == 0)||([self.claimContext isEqualToString:@"claim:sensetime_authentication"] && indexPath.section == 0)) {
            NSString *oldStr = _contentValueArr[indexPath.section][indexPath.row];
            NSMutableString *num = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", oldStr]];
            
            if (indexPath.row == 0) {
                
                cell.contentLB.text = [self changeToNewNameString:_contentValueArr[indexPath.section][indexPath.row]];
            } else if (indexPath.row == 1) {
                [num replaceCharactersInRange:NSMakeRange(14, 4) withString:@"****"];
                cell.contentLB.text = [NSString stringWithFormat:@"%@", num];
            } else {
                cell.contentLB.text = _contentValueArr[indexPath.section][indexPath.row];
            }
        } else {
            cell.contentLB.text = _contentValueArr[indexPath.section][indexPath.row];
        }
        
    }
    cell.userInteractionEnabled = NO;
    cell.titleLB.font = [UIFont boldSystemFontOfSize:14.f];
    cell.contentLB.font = [UIFont systemFontOfSize:17];
    cell.titleLB.textColor =
    indexPath.section == 0 ? [UIColor colorWithHexString:@"#AAB3B4"] : [UIColor colorWithHexString:@"#AAB3B4"];
    cell.contentLB.textColor =
    indexPath.section == 0 ? [UIColor colorWithHexString:@"#AAB3B4"] : [UIColor colorWithHexString:@"#AAB3B4"];
    cell.backgroundColor = indexPath.section == 0 ? [UIColor colorWithHexString:@"#F6F8F9"] : [UIColor whiteColor];
    
    if (indexPath.section == 0 && indexPath.row == [_contentValueArr[0] count] - 1) {
        cell.roundCornerType = KKRoundCornerCellTypeBottom;
    } else {
        cell.roundCornerType = KKRoundCornerCellTypeDefault;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (_stauts == 1) {
            cell.contentLB.textColor = [UIColor colorWithHexString:@"#60A614"];
            
        }
        if (_stauts == 4) {
            cell.contentLB.textColor = [UIColor colorWithHexString:@"#ff9600"];
            
        }
        if (_stauts == 9) {
            cell.contentLB.textColor = [UIColor colorWithHexString:@"#ff9600"];
            
        }
        if (_stauts == 2) {
            cell.contentLB.textColor = [UIColor colorWithHexString:@"#fe1717"];
            
        }
        ClaimModel *claimmodel = [[DataBase sharedDataBase]
                                  getCalimWithClaimContext:self.claimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]
                                                                                            valueForKey:ONT_ID]];
        if (_stauts == 0 && [claimmodel.status integerValue] == 1) {
            NSDictionary *dic = [Common dictionaryWithJsonString:claimmodel.Content];
            NSString *expTime;
            if (dic.count != 0) {
                NSDictionary *dic1 = [Common claimdencode:dic[@"EncryptedOrigData"]];
                DebugLog(@"hhhh=%@", dic1);
                NSDictionary *dic2 = dic1[@"claim"];
                expTime = dic2[@"exp"];
            }
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
            NSTimeInterval time = [date timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
            
            if ([timeString integerValue] >= [expTime integerValue]) {
                cell.contentLB.textColor = [UIColor colorWithHexString:@"#B41F3C"];
                cell.rightImage.hidden = NO;
                cell.renewLB.hidden = NO;
                cell.userInteractionEnabled = YES;
                
            } else {
                cell.contentLB.textColor = [UIColor colorWithHexString:@"#60A614"];
                
            }
            
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 4) {
        cell.rightImage.hidden = NO;
        cell.userInteractionEnabled = YES;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.rightImage.hidden = NO;
        cell.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYSWidth - 16 * SCALE_W, 40 * SCALE_W)];
        UIButton
        *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 24 * SCALE_W, SYSWidth - 16 * SCALE_W, 16 * SCALE_W)];
        [btn setImage:[UIImage imageNamed:@"IdHelp"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.hidden = ![self.claimContext isEqualToString:@"claim:cfca_authentication"];
        NSString *issuerName = [[self.claimDic objectForKey:@"clm"] objectForKey:@"IssuerName"];
        NSString *btnTitle = [NSString stringWithFormat:Localized(@"WhatCertification"), issuerName];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(authInfo) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor colorWithHexString:@"#35BFDF"] forState:UIControlStateNormal];
        [bgV addSubview:btn];
        return bgV;
    }
    return nil;
}
- (void)authInfo {
    
    WebIdentityViewController *VC = [[WebIdentityViewController alloc] init];
    
    if ([self.claimContext isEqualToString:@"claim:cfca_authentication"]) {
        VC.introduce = [NSString stringWithFormat:@"https://info.onto.app/#/detail/%@",
                        [ENORCN isEqualToString:@"cn"] ? @"34" : @"35"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40 * SCALE_W;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80 * SCALE_W;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.contentTitleArr[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.contentTitleArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 4) {
        WebIdentityViewController *vc = [[WebIdentityViewController alloc] init];
        vc.transaction = self.contentValueArr[1][4];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
        if (_ChargeInfo.count==0) {
            return;
        }
        vc.transaction = _ChargeInfo[@"TxnHash"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 消失视图
- (void)dismissScreenBgView {
    [UIView animateWithDuration:.2 animations:^{
        self.animateV.frame = CGRectMake(0, SYSHeight, SYSWidth, SYSHeight);
        self.bottomView.alpha = 0;
    }                completion:^(BOOL finished) {
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 80;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - 姓名隐藏
- (NSString *)changeToNewNameString:(NSString *)oldName {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@", [oldName substringToIndex:1]];
    for (int i = 0; i < oldName.length - 1; i++) {
        [str insertString:@"*" atIndex:1];
    }
    return str;
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
