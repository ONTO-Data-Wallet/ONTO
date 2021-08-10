//
//  DIManageViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/12.
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

#import "DIManageViewController.h"
#import "DIManageCell.h"
#import "UIView+Scale.h"
#import "CCRequest.h"
#import "UITableView+EmptyData.h"
#import "BackupViewController.h"
#import "ImportViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import "ConfirmPwdViewController.h"
#import "ScreenLockController.h"
#import "CreateViewController.h"
#import "KeystoreImportVC.h"
#import "SendConfirmView.h"
#import "ViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import "MBProgressHUD.h"
#import "PasswordSheet.h"
#import "ONTO-Swift.h"
@interface DIManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UIButton *importDIBtn;
@property (nonatomic, strong) NSMutableArray *identArr;
@property (nonatomic, assign) NSInteger slectindex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (weak, nonatomic) IBOutlet UIButton *swithBtn;
@property (nonatomic, assign) NSInteger willSwitchIndex;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (nonatomic, strong) SendConfirmView *sendConfirmV;
@property (nonatomic, copy) NSString *selectOntID;
@property (nonatomic, strong) MBProgressHUD *hub;

@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *salt;
@property (nonatomic,copy) NSString *key;

@property (nonatomic,copy) NSString *confirmPwd;
@property (nonatomic, strong) PasswordSheet * sheetV;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation DIManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _willSwitchIndex = [[[NSUserDefaults standardUserDefaults]valueForKey:SELECTINDEX]integerValue];
    [self setTable];
    [self configNav];
    self.navigationController.navigationBar.translucent = NO;
    
    if (_isOntIdLogin||_isWalletLogin) {
        [self loginHidden];
        if (_isWalletLogin) {
            [self setNavTitle:Localized(@"WalletLogin")];

        }else{
            
            [self setNavTitle:Localized(@"ONTIDLogin")];

        }


    }
}

- (void)handlePrompt:(NSString *)prompt{
    
    [_hub hideAnimated:YES];
//    [_hub removeFromSuperview];
//    _hub = nil;

    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
        [_sendConfirmV dismiss];
        [self verifySuccess];
        
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

- (void)loadJS{
    
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",_key,[Common transferredMeaning:_confirmPwd],self.address,self.salt];
 
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

- (void)GeneralButtonAction{
    //初始化进度框，置于当前的View当中
    self.hub = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication].delegate window]];
    [[[UIApplication sharedApplication].delegate window] addSubview:_hub];
    
    //如果设置此属性则当前的view置于后台
    _hub.dimBackground = YES;
    
    //设置对话框文字
//    _hub.labelText = @"加载中";
    //细节文字
//    _hub.detailsLabelText = @"请耐心等待";
    
    [_hub showAnimated:YES];
    //显示对话框
//    [_hub showAnimated:YES whileExecutingBlock:^{
//        //对话框显示时需要执行的操作
//        sleep(3);
//    }// 在HUD被隐藏后的回调
//       completionBlock:^{
//           //操作执行完后取消对话框
//           [_hub removeFromSuperview];
//           _hub = nil;
//       }];
}


- (void)loginHidden{
    _line1.hidden = YES;
    _line2.hidden = YES;
    _swithBtn.hidden = YES;
    _createBtn.hidden = YES;
    _importDIBtn.hidden = YES;
    
}

- (IBAction)swithClick:(id)sender {
    
    NSDictionary *identityDic = _identArr[_willSwitchIndex];
    
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
    
    [self showMsg:Localized(@"WalletManageSuccess") duration:1.0 imgName:@"hud_success"];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", @(_willSwitchIndex)] forKey:SELECTINDEX];

    
//    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SOCKET_LOGOUT object:nil];
//    //切换后 websoket 需要重连
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    appDelegate.isSocketConnect = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)newClick:(id)sender {
    CreateViewController *VC = [[CreateViewController alloc]init];
    VC.isIdentity = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [_tableHeight setConstant:_identArr.count * 84*([[UIScreen mainScreen] bounds].size.width/375)+10];
    NSString *str =  [Common getEncryptedContent:APP_ACCOUNT];
    if(str == nil){
        return;
    }
    NSDictionary *jsDic= [self parseJSONStringToNSDictionary:str];
    if (_isWalletLogin) {
        _identArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:ALLASSET_ACCOUNT]];
    }else{
        _identArr = [NSMutableArray arrayWithArray:jsDic[@"identities"]];
    }
    
     [_myTable reloadData];
}

- (void)configNav {
    [self setNavTitle:Localized(@"Digitalidentitymanage")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}

- (void)navLeftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setTable{
    
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    [self setExtraCellLineHidden:self.myTable];
//    self.myTable.backgroundColor = TABLEBACKCOLOR;
    self.importDIBtn.layer.masksToBounds = YES;
    self.importDIBtn.layer.cornerRadius = 1;
    [self.importDIBtn setTitle:Localized(@"ImportdIgitalIdentity") forState:UIControlStateNormal];
    [self.createBtn setTitle:Localized(@"New") forState:UIControlStateNormal];
    [self.swithBtn setTitle:Localized(@"Switch") forState:UIControlStateNormal];

}

-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (IBAction)importDIBtnClick:(id)sender {
   
    NewOntImportViewController * vc = [[NewOntImportViewController alloc]init];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"box"];
    [self.navigationController pushViewController:vc animated:YES];
//    KeystoreImportVC *vc = [[KeystoreImportVC alloc]init];
//    vc.isIdentity = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    // Return the number of sections.
    [tableView tableViewDisplayWitMsg:_isWalletLogin?Localized(@"NoWallet"): Localized(@"NoClaims") ifNecessaryForRowCount:_identArr.count];
    
    
    return _identArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 84*([[UIScreen mainScreen] bounds].size.width/375);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"DIManageCell";
    //通过xib的名称加载自定义的cell
    DIManageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    

    NSDictionary *identityDic = _identArr[indexPath.section];
    
    
    if (_isWalletLogin) {
        cell.nameLabel.text = [identityDic valueForKey:@"label"];
        cell.ontIdLabel.text = [identityDic valueForKey:@"address"];
        
    }else{
        
        
        cell.ontIdLabel.text =  identityDic[@"ontid"];
        NSInteger selectIndex = [[[NSUserDefaults standardUserDefaults]valueForKey:SELECTINDEX]integerValue];
        if ([[NSUserDefaults standardUserDefaults]valueForKey:SELECTINDEX]&&self.isOntIdLogin==NO) {
            if (indexPath.section == selectIndex) {
                cell.defaultBtn.selected = YES;
                cell.defaultLabel.text =Localized(@"Default");
                cell.nameLabel.textColor =  MainColor;
                cell.ontIdLabel.textColor = MainColor;
            }else{
                cell.defaultBtn.selected = NO;
                cell.defaultLabel.text =Localized(@"Setasdefault");
            }
        }
        
        cell.defaultBtn.tag = indexPath.section;
//        [cell.defaultBtn addTarget:self action:@selector(defaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.backUpBtn.tag = indexPath.section;
//        [cell.backUpBtn addTarget:self action:@selector(backUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.nameLabel.text = [_identArr[indexPath.section] valueForKey:@"label"];
        
    }
    
   
    
    return cell;
}

- (void)backUpBtnClick:(UIButton *)sender{
    
    [self pushBackupVCWithIndex:sender.tag];
}

- (void)defaultBtnClick:(UIButton *)sender{
    //这个方法里返回一个索引数组，貌似是屏幕中显示所有cell 的索引
     NSDictionary *identityDic = _identArr[sender.tag];
    
    NSArray *arr = [self.myTable indexPathsForVisibleRows];
    NSIndexPath *index =  [NSIndexPath indexPathForItem:0 inSection:sender.tag];
    DIManageCell *cell = [self.myTable cellForRowAtIndexPath:index];
    if (cell.defaultBtn.selected == YES) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_EXISIT];
    NSString *ontID = [identityDic valueForKey:@"ontid"];
    
    if ([Common judgeisExpireWithOntId:ontID]) {
        
        ScreenLockController *lockVc = [[ScreenLockController alloc]init];
        lockVc.modalPresentationStyle = UIModalPresentationOverFullScreen | UIModalTransitionStyleCrossDissolve;
        lockVc.ontID = ontID;
        lockVc.isManage = YES;
        lockVc.manageName = [identityDic valueForKey:@"label"];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nocationDefaultBtnClick) name:EXPIREMANAGENOTIFICATION object:nil];
        [self presentViewController:lockVc animated:YES completion:nil];
        _slectindex = sender.tag;
        
    }else{
      
        for (NSIndexPath *indexPath in arr) {
            //根据索引，获取cell 然后就可以做你想做的事情啦
            DIManageCell *cell = [self.myTable cellForRowAtIndexPath:indexPath];
            cell.defaultBtn.selected = NO;
            cell.defaultLabel.text = cell.defaultLabel.text =Localized(@"Setasdefault");;
        }
        
        cell.defaultBtn.selected = YES;
        cell.defaultLabel.text = @"Default";

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
        
        [self showMsg:Localized(@"WalletManageSuccess") duration:1.0 imgName:@"hud_success"];
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", @(sender.tag)] forKey:SELECTINDEX];
        
        
//        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SOCKET_LOGOUT object:nil];
//        //切换后 websoket 需要重连
//        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//        appDelegate.isSocketConnect = YES;

    }
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)showMsg:(NSString *)msg duration:(CGFloat)time imgName:(NSString *)imgName{
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // 显示模式,改成customView,即显示自定义图片(mode设置,必须写在customView赋值之前)
    hud.mode = MBProgressHUDModeCustomView;
    
    // 设置要显示 的自定义的图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    // 显示的文字,比如:加载失败...加载中...
    hud.label.text = msg;
    // 标志:必须为YES,才可以隐藏,  隐藏的时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.color = [UIColor whiteColor];
    [hud hideAnimated:YES afterDelay:time];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self pushBackupVCWithIndex:indexPath.section];
    NSDictionary *identityDic = _identArr[indexPath.section];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_EXISIT];
    NSString *ontID = [identityDic valueForKey:@"ontid"];
    self.selectOntID = [identityDic valueForKey:@"ontid"];
    
    if (_isOntIdLogin) {
        [self confirmViewShow];
    }
    
    if (_isWalletLogin) {
        _key = [identityDic valueForKey:@"key"];
        _salt = [identityDic valueForKey:@"salt"];
        _address = [identityDic valueForKey:@"address"];
        
        [self confirmViewShow];
    }
    
        //这个方法里返回一个索引数组，貌似是屏幕中显示所有cell 的索引
    
        NSArray *arr = [self.myTable indexPathsForVisibleRows];
        NSIndexPath *index =  [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
        DIManageCell *cell = [self.myTable cellForRowAtIndexPath:index];
        if (cell.defaultBtn.selected == YES) {
            return;
        }
        
    
    
//        if ([Common judgeisExpireWithOntId:ontID]) {
//            ScreenLockController *lockVc = [[ScreenLockController alloc]init];
//            lockVc.modalPresentationStyle = UIModalPresentationOverFullScreen | UIModalTransitionStyleCrossDissolve;
//            lockVc.ontID = ontID;
//            lockVc.isManage = YES;
//            lockVc.manageName = [identityDic valueForKey:@"label"];
//
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nocationDefaultBtnClick) name:EXPIREMANAGENOTIFICATION object:nil];
//            [self presentViewController:lockVc animated:YES completion:nil];
//            _slectindex = indexPath.section;
//
//        }else{
    
            for (NSIndexPath *indexPath in arr) {
                //根据索引，获取cell 然后就可以做你想做的事情啦
                DIManageCell *cell = [self.myTable cellForRowAtIndexPath:indexPath];
                cell.defaultBtn.selected = NO;
                cell.defaultLabel.text = cell.defaultLabel.text =Localized(@"Setasdefault");
                cell.nameLabel.textColor =  [UIColor colorWithHexString:@"#2B4045"];
                cell.ontIdLabel.textColor = [UIColor colorWithHexString:@"#AAB3B4"];
            }
            
            cell.defaultBtn.selected = YES;
            cell.defaultLabel.text = @"Default";
            cell.nameLabel.textColor =  MainColor;
            cell.ontIdLabel.textColor = MainColor;
            
            _willSwitchIndex = indexPath.section;
            
        
            
//        }
}

- (void)confirmViewShow{
    
    self.sendConfirmV.paybyStr = @"";
    self.sendConfirmV.amountStr = @"";
    self.sendConfirmV.isWalletBack = YES;

    self.sendConfirmV.isIdentity = self.isOntIdLogin;
    if (_isWalletLogin) {
        self.sendConfirmV.inputL.text = Localized(@"InputTheWalletPassword");
        [self.sendConfirmV show];
    }else{
        NSString* str = [Common getEncryptedContent:APP_ACCOUNT];
        NSDictionary* jsDic = [Common dictionaryWithJsonString:str];
        NSArray* arr  = jsDic[@"identities"];
        NSDictionary* defaultDic;
        for (NSDictionary* subDic in arr) {
            if ([subDic[@"ontid"] isEqualToString:self.selectOntID]) {
                defaultDic = subDic;
            }
        }
        __weak typeof(self) weakSelf = self;
        _sheetV= [[PasswordSheet alloc]initWithTitle:Localized(@"NewPassword") selectedDic:defaultDic];
        _sheetV.callback = ^(NSString *str ) {
            [weakSelf.sheetV dismiss];
            [weakSelf verifySuccess];
        };
        
        _window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
        [_window addSubview:_sheetV];
        [_window makeKeyAndVisible];
    }

    
    
    
    
}

- (SendConfirmView *)sendConfirmV {
    
    if (!_sendConfirmV) {
        
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
        self.sendConfirmV.isIdentity = YES;
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            
            if (weakSelf.isWalletLogin) {
                
                weakSelf.confirmPwd = password;
                [weakSelf loadJS];
                
            }else{
                //身份备份验证
                if ([Common judgePasswordisMatchWithPassWord:   weakSelf.sendConfirmV.pwdEnterV.textField.text
                                                   WithOntId:weakSelf.selectOntID]) {
                    
                    [weakSelf.sendConfirmV dismiss];
                    
                    [weakSelf verifySuccess];
                    
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
    
            
        }];
    }
    return _sendConfirmV;
}
- (void)verifySuccess{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.isNeedPrensentLogin = YES;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IDENTITY_EXISIT]) {
        [ViewController gotoIdentityVC];
    }
    
    else {
        [ViewController gotoHomeVC];
    }
    
}

- (void)pushBackupVCWithIndex:(NSInteger)index{

//    BackupViewController *backupVC = [[BackupViewController alloc] init];
//    backupVC.isDigitalIdentity = YES;
//    backupVC.identityDic = _identArr[index];
//    backupVC.name = [_identArr[index] valueForKey:@"label"];
//    [self.navigationController pushViewController:backupVC animated:YES];
    
    ConfirmPwdViewController *vc = [[ConfirmPwdViewController alloc]init];
    vc.ontID = [_identArr[index] valueForKey:@"ontid"];
    vc.isDigitalIdentity = YES;
    vc.identityDic = _identArr[index];
    vc.name = [_identArr[index] valueForKey:@"label"];
    [self.navigationController pushViewController:vc animated:YES];

}

//让tableView分割线居左的代理方法

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

////自定义section的头部
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 58)];//创建一个视图
//        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 14, 230, 20)];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.font = [UIFont fontWithName:@"Heiti SC" size:13];
//        //    headerLabel.text = section==0?Localized(@"Realname"):Localized(@"Social");
//        headerLabel.text = Localized(@"Digitalidentitylist");
//        [headerView addSubview:headerLabel];
//         return headerView;
//    }else{
//
//        return nil;
//
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    if (section==0) {
//        return 46;
//    }
//    return 2;
     return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Localized(@"Delete");
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selectIndex = [[[NSUserDefaults standardUserDefaults]valueForKey:SELECTINDEX]integerValue];
    if (selectIndex==indexPath.section) {
        
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"IdentityCanNotDeleted") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
                return;
    }
    
    NSMutableDictionary *jsDic= [NSMutableDictionary dictionaryWithDictionary:[self parseJSONStringToNSDictionary:[Common getEncryptedContent:APP_ACCOUNT]]];
    NSMutableArray *arrIdentity =[NSMutableArray arrayWithArray:jsDic[@"identities"]];
    
    [arrIdentity removeObjectAtIndex:indexPath.section];
    //NSString *arrString = [arrIdentity componentsJoinedByString:@""];
    [jsDic setValue:arrIdentity forKey:@"identities"];
    NSString *appStr =[self DataTOjsonString:jsDic];
    NSMutableString *appStr1 = [NSMutableString stringWithString:appStr];
    
//    [[NSUserDefaults standardUserDefaults]setValue:[appStr1 stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:APP_ACCOUNT];
    [Common setEncryptedContent:[appStr1 stringByReplacingOccurrencesOfString:@"\n" withString:@""] WithKey:APP_ACCOUNT];

    //处理打钩消失的问题
    if (selectIndex>indexPath.section) {
        selectIndex =  selectIndex-1;
    }
//    [str stringValue]
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",selectIndex]  forKey:SELECTINDEX];
    //删除数据，和删除动画
    [_identArr removeObjectAtIndex:indexPath.section];
    [self.myTable reloadData];
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        DebugLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)nocationDefaultBtnClick{
    //这个方法里返回一个索引数组，貌似是屏幕中显示所有cell 的索引
    NSDictionary *identityDic = _identArr[_slectindex];
    
    NSArray *arr = [self.myTable indexPathsForVisibleRows];
    NSIndexPath *index =  [NSIndexPath indexPathForItem:0 inSection:_slectindex];
    DIManageCell *cell = [self.myTable cellForRowAtIndexPath:index];
    if (cell.defaultBtn.selected == YES) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_EXISIT];
  
        for (NSIndexPath *indexPath in arr) {
            //根据索引，获取cell 然后就可以做你想做的事情啦
            DIManageCell *cell = [self.myTable cellForRowAtIndexPath:indexPath];
            cell.defaultBtn.selected = NO;
            cell.defaultLabel.text = cell.defaultLabel.text =Localized(@"Setasdefault");;
        }
        
        cell.defaultBtn.selected = YES;
        cell.defaultLabel.text = @"Default";
    
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
        
        [self showMsg:Localized(@"WalletManageSuccess") duration:1.0 imgName:@"hud_success"];
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", @(_slectindex)] forKey:SELECTINDEX];
        
//        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SOCKET_LOGOUT object:nil];
//        //切换后 websoket 需要重连
//        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//        appDelegate.isSocketConnect = YES;
    
     [[NSNotificationCenter defaultCenter] postNotificationName:EXPIRENOTIFICATION object:nil];
    
}

@end
