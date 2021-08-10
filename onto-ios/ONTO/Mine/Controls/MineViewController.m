//
//  MineViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/9.
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

#import "MineViewController.h"
#import "MineCell.h"
#import "IDCell.h"
//#import "UIView+Scale.h"
#import "WebIdentityViewController.h"
#import "MyVerifiedClaimViewController.h"
#import "NewSettingViewController.h"
#import "DIManageViewController.h"
#import "WalletManageViewController.h"
#import "HelpCentreViewController.h"
#import "SLControlModel.h"
#import "MyVerifiedClaimViewController.h"
#import "AboutUsViewController.h"
#import "PendingViewController.h"
#import "NotificationViewController.h"
#import "ContactsViewController.h"
#import "ScreenLockController.h"
#import "ConfirmPwdViewController.h"
#import "SendConfirmView.h"
#import "BackupViewController.h"
#import "LPActionSheet.h"
#import "IdentitySheet.h"
#import "KeyStoreBackupVC.h"
#import "KeyStoreFileViewController.h"
#import "PasswordView.h"

#import "BrowserView.h"
//ont-candy
#import "ONTO-Swift.h"

#import "PasswordSheet.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,SLDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UILabel *meTitleLabel;
@property (nonatomic, strong) SLControlModel *model;
@property (nonatomic, copy) NSArray *imageArr;
@property (nonatomic, copy) NSArray *titleArr;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ontIdLabel;
@property (nonatomic, strong) PasswordView *passwordView;
@property (weak, nonatomic) IBOutlet UILabel *identityBackL;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic ,assign) NSInteger type;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *backUpView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (nonatomic,assign) BOOL isKeystoreBackupVC;//判断是否跳转到KeyStoreBackupVC页面
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pasterBtnleft;
@property(nonatomic,strong)BrowserView      *browserView;
@property(nonatomic,copy)NSString * pwdString;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (weak, nonatomic) IBOutlet UIImageView *candyCoverImgView;

@property (nonatomic, strong) PasswordSheet * sheetV;

@property(weak, nonatomic) IBOutlet UIButton *backupBtn;

@property(nonatomic,strong)UIView *unLoginView;
@end

@implementation MineViewController


- (IBAction)backUpClick:(id)sender {
  _type = 0;
  [self confirmViewShow];

  self.backupBtn.enabled = NO;
  [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:2.0];//防止用户重复点击
}
- (void)changeButtonStatus { self.backupBtn.enabled = YES; }

- (void)confirmViewShow{

    NSString* str = [Common getEncryptedContent:APP_ACCOUNT];
    NSDictionary* jsDic = [Common dictionaryWithJsonString:str];
    NSArray* arr  = jsDic[@"identities"];
    NSDictionary* defaultDic;
    for (NSDictionary* subDic in arr) {
        if ([subDic[@"ontid"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]) {
            defaultDic = subDic;
        }
    }
    __weak typeof(self) weakSelf = self;
    _sheetV= [[PasswordSheet alloc]initWithTitle:Localized(@"NewPassword") selectedDic:defaultDic];
    _sheetV.callback = ^(NSString *str ) {
        [weakSelf.sheetV dismiss];
        KeyStoreFileViewController *vc = [[KeyStoreFileViewController alloc] init];
        vc.identityDic =  [NSMutableArray arrayWithArray:jsDic[@"identities"]][[[[NSUserDefaults standardUserDefaults]valueForKey:SELECTINDEX]integerValue]];;
        vc.isWallet = NO;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    _window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
    [_window addSubview:_sheetV];
    [_window makeKeyAndVisible];


}

- (PasswordView *)passwordView {

  if (!_passwordView) {

    _passwordView = [[PasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    __weak typeof(self) weakSelf = self;
    [_passwordView setCallback:^(NSString *password) {


      weakSelf.pwdString = weakSelf.passwordView.pwdEnterV.textField.text;
      [weakSelf loadJS];

    }];
  }
  return _passwordView;
}

- (void)pushBackupVCWithIndex:(NSInteger)index {

  ConfirmPwdViewController *vc = [[ConfirmPwdViewController alloc] init];
  vc.ontID = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
  vc.isDigitalIdentity = YES;

  NSString *str = [Common getEncryptedContent:APP_ACCOUNT];
  NSDictionary *jsDic = [Common dictionaryWithJsonString:str];
  vc.identityDic = [NSMutableArray arrayWithArray:jsDic[@"identities"]][[[[NSUserDefaults standardUserDefaults]
      valueForKey:SELECTINDEX] integerValue]];
  vc.name = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:IDENTITY_NAME]];
  [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)pasteClick:(id)sender {

  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  pasteboard.string = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
//    [self showHint:Localized(@"OntidCopySuccess")];
  [Common showToast:Localized(@"OntidCopySuccess")];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self setTable];
  _pwdString = @"";
  [self.view addSubview:self.browserView];
  [self setNavTitle:Localized(@"MeTitle")];
  [self setNavRightImageIcon:[UIImage imageNamed:@"darkright"] Title:nil];
  self.identityBackL.text = Localized(@"identityBackL");
  self.navigationController.delegate = self;
  _topBackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"me_bg"]];

  [[NSNotificationCenter defaultCenter]
      addObserver:self selector:@selector(getCaliamNotication) name:NOTIFICATION_SOCKET_GETCLAIM object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self selector:@selector(getCaliamNotication) name:CHECKTRANSFERTOMORE object:nil];

  _imageArr = @[@[@"联系人", @"消息"], @[@"设置", @"帮助", @"关于"]];
  _titleArr = @[@[Localized(@"Contacts"), Localized(@"NotificationCentre")],
      @[Localized(@"Systemsettings"), Localized(@"Helpcenter"), Localized(@"Aboutus")]];

  if (LL_iPhone5S) {
    [_pasterBtnleft setConstant:-10];
  }

    if (LL_iPhone5S) {
        [_pasterBtnleft setConstant:-10];
    }
    
    //candy box
    _candyCoverImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(candyCoverClicked:)];
    [_candyCoverImgView addGestureRecognizer:tap];
    

}

- (void)navRightAction {

    if (![Common userLogin]) {
        [self unLoginClick];
    }else{
        IdentitySheet *optionsView = [[IdentitySheet alloc] initWithTitleView:nil optionsArr:@[@"备份身份",
                                                                                               @"切换身份"]
                                                                  cancelTitle:Localized(@"Cancel")
                                                                selectedBlock:^(NSIndexPath *index) {
        if (index.row == 0 && index.section == 0) {
           _type = index.row;
           [self confirmViewShow];
       } else if (index.row == 1) {
           
           MGPopController
           *pop = [[MGPopController alloc] initWithTitle:Localized(@"Switchingidentities") message:@"" image:nil];
           MGPopAction *action1 = [MGPopAction actionWithTitle:Localized(@"Cancel") action:^{
               
           }];
           
           
           action1.titleColor = [UIColor colorWithHexString:@"#6A797C"];
           [pop addAction:action1];
           
           MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"Switch") action:^{
               DIManageViewController *vc = [[DIManageViewController alloc] init];
               [self.navigationController pushViewController:vc animated:YES];
           }];
           action.titleColor = [UIColor redColor];
           
           [pop addAction:action];
           [pop show];
           pop.showCloseButton = NO;
       }
                                                                    
                                                                }
                                                                  cancelBlock:^{}];
        
        _window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [_window addSubview:optionsView];
        [_window makeKeyAndVisible];
    }
  

}

- (void)getCaliamNotication {
  _imageArr = @[@[@"联系人", @"消息1"], @[@"设置", @"帮助", @"关于"]];
  [self.myTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.ontIdLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:IDENTITY_NAME]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"#6A797C"] forKey:NSForegroundColorAttributeName];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"%@A",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]]==YES)
    {
        _backUpView.hidden = YES;
        //        [_tableTop setConstant:0];
        [_tableTop setConstant:20];
    }else
    {
        _backUpView.hidden = NO;
        //        [_tableTop setConstant:50];
        [_tableTop setConstant:70];


    }
    if (![Common userLogin])
    {
        [self.view addSubview:self.unLoginView];
        [self unLoginViewMasonry];
    }
    else
    {
        //修改登录后状态显示未登录的问题-bug
        [self.unLoginView removeFromSuperview];
    }
    _isKeystoreBackupVC = NO;

}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  if ([[NSUserDefaults standardUserDefaults] boolForKey:ISNOTIFICATION] == YES) {
    _imageArr = @[@[@"联系人", @"消息1"], @[@"设置", @"帮助", @"关于"]];
  } else {
    _imageArr = @[@[@"联系人", @"消息"], @[@"设置", @"帮助", @"关于"]];
  }
  [self.myTable reloadData];

}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
//  [BaseViewController setTabbarItemWithItemTitle:TABTHREETITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTHREECOLORSELECTED ItemTitleFont:K12FONT ItemImage:TABTHREEIMAGE ItemImageSelected:TABTHREEIMAGESELECTED AtIndex:2 SourceTabbar:self
//      .tabBarController];

  [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

  [self.navigationController.navigationBar setShadowImage:nil];
  if (_isKeystoreBackupVC == NO) {
    self.navigationController.navigationBar.translucent = NO;
  }
}

- (void)setTable {
  self.myTable.dataSource = self;
  self.myTable.delegate = self;
  [self setExtraCellLineHidden:self.myTable];
  self.myTable.backgroundColor = [UIColor whiteColor];
  self.myTable.separatorStyle = NO;
//    self.myTable.scrollEnabled = NO;
}

- (void)setExtraCellLineHidden:(UITableView *)tableView {

  UIView *view = [[UIView alloc] init];
  view.backgroundColor = [UIColor clearColor];
  [tableView setTableFooterView:view];
  [tableView setTableHeaderView:view];
}



    
-(void)candyCoverClicked:(id)sender {
    
    if([[LoginCenter shared] bNeedLogin] == true){
        [[LoginCenter shared] showLoginWithBaseController:self handler:^(BOOL bSucces, id callBacks) {
           
            [self dismissViewControllerAnimated:false completion:nil];
            if(bSucces == false) {
                return ;
            }
            
            BoxListController *cv = [BoxListController new];
            //    AccountController *cv = [AccountController new];
            cv.bShowBack = YES;
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
        }];
        return;
    }
    
    
    BoxListController *cv = [BoxListController new];
    //    AccountController *cv = [AccountController new];
    cv.bShowBack = YES;
    cv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cv animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return [_titleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
//        if (section==0) {
//            return 1;
//        }
  return [_titleArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section==0) {
//        if (KIsiPhoneX) {
//            return 144;
//        }
//        return 124*SCALE_W;
//
//    }
  return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//

  static NSString *CellIdentifier = @"MineCell";
  //通过xib的名称加载自定义的cell
  MineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (!cell) {
    //通过xib的名称加载自定义的cell
    cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
  }
  cell.imageArr = _imageArr;
  cell.titleArr = @[@[Localized(@"Contacts"), Localized(@"NotificationCentre")],
      @[Localized(@"Systemsettings"), Localized(@"Helpcenter"), Localized(@"Aboutus")]];
  [cell setwithIndex:indexPath];

  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ContactsViewController *vc = [[ContactsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 1) {
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            if (appDelegate.isEpire) {
                ScreenLockController *lockVc = [[ScreenLockController alloc] init];
                lockVc.modalPresentationStyle = UIModalPresentationOverFullScreen | UIModalTransitionStyleCrossDissolve;
                lockVc.ontID = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
                [self presentViewController:lockVc animated:YES completion:nil];
                
            } else {

                NotificationViewController *vc = [[NotificationViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                _imageArr = @[@[@"联系人", @"消息"], @[@"设置", @"帮助", @"关于"]];

                [self.myTable reloadData];
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NewSettingViewController *vc = [[NewSettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 1) {
            WebIdentityViewController *vc = [[WebIdentityViewController alloc] init];
            vc.helpCentre = [NSString stringWithFormat:@"https://info.onto.app/#/%@", ENORCN];

            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 2) {
            AboutUsViewController *vc = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
}



//让tableView分割线居左的代理方法

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerV = [[UIView alloc] init];
  headerV.backgroundColor = [UIColor whiteColor];
  return headerV;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }
  if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    [cell setPreservesSuperviewLayoutMargins:NO];
  }
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:
    (NSInteger)section {
  if (section == 1) {
    return 0.1;
  }
  return 0.1;
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForFooterInSection:
    (NSInteger)section {
  if (section == 1) {
    return 0;
  }
  return 0.1;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat sectionHeaderHeight = 50;
  if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
    scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
  } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
    scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
  }
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
  if ([_pwdString isEqualToString:@""]) {
    return;
  }
  NSString *str = [Common getEncryptedContent:APP_ACCOUNT];
  NSDictionary *jsDic = [Common dictionaryWithJsonString:str];
  NSArray *arr = jsDic[@"identities"];
  NSDictionary *defaultDic;
  for (NSDictionary *subDic in arr) {
    if ([subDic[@"ontid"] isEqualToString:self.ontIdLabel.text]) {
      defaultDic = subDic;
    }
  }
  NSArray *controlsArr = defaultDic[@"controls"];
  NSDictionary *detailDic = controlsArr[0];
  _hub = [ToastUtil showMessage:@"" toView:nil];

  NSString *jsStr =
      [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')", detailDic[@"key"], _pwdString, detailDic[@"address"], detailDic[@"salt"]];

  LOADJS1;
  LOADJS2;
  LOADJS3;
  [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];

}
- (void)handlePrompt:(NSString *)prompt {
  [_hub hideAnimated:YES];
  [MBProgressHUD hideHUDForView:self.view animated:YES];
  NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
  NSString *resultStr = promptArray[1];
  id obj =
      [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
  if ([[obj valueForKey:@"error"] integerValue] > 0) {
    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"PASSWORDERROR") message:nil image:nil];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{

    }];
    action.titleColor = MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
  } else {
    [self.passwordView dismiss];

    NSString *str = [Common getEncryptedContent:APP_ACCOUNT];
    NSDictionary *jsDic = [Common dictionaryWithJsonString:str];
    KeyStoreFileViewController *vc = [[KeyStoreFileViewController alloc] init];
    vc.identityDic = [NSMutableArray arrayWithArray:jsDic[@"identities"]][[[[NSUserDefaults standardUserDefaults]
        valueForKey:SELECTINDEX] integerValue]];;
    vc.isWallet = NO;
    [self.navigationController pushViewController:vc animated:YES];
  }

}

- (UIView*)unLoginView {
    if (!_unLoginView) {
        _unLoginView = [[UIView alloc] init];
        _unLoginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"me_bg"]];
        _unLoginView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(unLoginClick)];
        
        UILabel * unLoginLB = [[UILabel alloc] init];
        unLoginLB.textColor = [UIColor colorWithHexString:@"#6A797C"];
        unLoginLB.font = [UIFont systemFontOfSize:32 weight:UIFontWeightHeavy];
        unLoginLB.text = Localized(@"UnLoginLB");
        unLoginLB.textAlignment = NSTextAlignmentLeft;
        [_unLoginView addSubview:unLoginLB];
        
        [unLoginLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_unLoginView).offset(20);
            make.top.equalTo(_unLoginView).offset(88 - LL_StatusBarHeight);
        }];
        [_unLoginView addGestureRecognizer:tap];
    }
    return _unLoginView;
}
- (void)unLoginViewMasonry {
    [_unLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(LL_StatusBarAndNavigationBarHeight);
        make.bottom.equalTo(self.backUpView.mas_bottom);
    }];
}
- (void)unLoginClick {
    UnLoginAlertView * unLoginV = [[UnLoginAlertView alloc] initWithFrame:CGRectZero];
    [unLoginV show];
    
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
