//
//  IDViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/16.
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

#import "IDViewController.h"
#import "IdentityViewController.h"
#import "MyVerifiedClaimViewController.h"
#import "CCRequest.h"
#import "CHButton.h"
#import "SocketRocketUtility.h"
#import "IDCardCell.h"
#import "ImportViewController.h"
#import "IDCardViewController.h"
#import "CreateViewController.h"
#import "WebIdentityViewController.h"
#import "HelpCentreViewController.h"
#import "Config.h"
#import "Api.h"
#import "PendingViewController.h"
#import "RealNameViewController.h"
#import "UIView+Scale.h"
#import "IdentityModel.h"
#import "MJExtension.h"
#import "MakeIDCardVC.h"
#import "IndentityCell.h"
#import "ClaimViewController.h"
#import "IDCardListViewController.h"
#import "ScreenLockController.h"
#import "RemenberWordViewController.h"
#import "DataBase.h"
#import "ClaimModel.h"
#import "ThirdpartyViewController.h"
#import "CapitalViewController.h"
#import "IdAuthCell.h"
#import "SocialAuthCell.h"
#import "Config.h"
#import "AuthInfoViewController.h"
#import "KeystoreImportVC.h"
#import "EnterWordViewController.h"
#import "SecurityViewController.h"
#import "BrowserView.h"
#import "ONTO-Swift.h"
#import "IMNewDetailViewController.h"
#import "ConfirmPwdViewController.h"
#import "SendConfirmView.h"
#import "KeyStoreFileViewController.h"
#import "CheckView.h"
#import "BackupV.h"
#import "PasswordSheet.h"
#import "TitleImageButton.h"
#import "NewClaimViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface IDViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *claimsBtn;
@property (strong, nonatomic) CHButton *badgeButton;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, copy) NSArray *modelArr;
@property (weak, nonatomic) IBOutlet UIButton *idMenueBtn;
@property (weak, nonatomic) IBOutlet UIView *backWhiteView;
@property (weak, nonatomic) IBOutlet UIView *exampleView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *IDTitle;
@property (weak, nonatomic) IBOutlet UILabel *makeIdentityLabel;
@property (weak, nonatomic) IBOutlet UIButton *learnMoreBtn;
@property (weak, nonatomic) IBOutlet UILabel *custmizedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *exsample1;
@property (weak, nonatomic) IBOutlet UILabel *exsample2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic, copy) NSArray *modelArr1;
@property (nonatomic, strong)NSTimer * timer;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (nonatomic,strong) SendConfirmView *sendConfirmV;
@property(nonatomic,strong)UIWindow         *window;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;


@property (nonatomic,strong)UIView *headCollectionV;
@property (nonatomic,strong)UIView *headBackV;
@property (strong, nonatomic)  UILabel *authTitle;
@property (strong, nonatomic)  UICollectionView *AuthCollectionView;
@property (strong, nonatomic)  UIButton *helpButton;
@property (nonatomic,strong)NSArray * IdAuthArr;
@property (nonatomic,strong)NSArray * SocialAuthArr;
@property (nonatomic,strong)NSArray * appNativeArr;

@property (weak, nonatomic) IBOutlet UILabel *netWorkL;
@property (nonatomic, strong) BrowserView *browserView;
@property (nonatomic, strong) PasswordSheet * sheetV;
//@property (nonatomic, strong) MBProgressHUD *hub;
@property(nonatomic, copy) NSString *hashString;

@end

@implementation IDViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.

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

- (void)handlePrompt:(NSString *)prompt{
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"verifyFailed") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }
    NSString * toPubkey;
    if ([prompt hasPrefix:@"decodeTransHash"]) {
        
        NSDictionary * resultDic = obj[@"result"];
        NSArray * sigsArr = resultDic[@"sigs"];
        NSDictionary * dic = sigsArr[0];
        NSArray * pubKeysArr = dic[@"pubKeys"];
        NSDictionary * subDic = pubKeysArr[0];
        toPubkey = subDic[@"key"];
        NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.adderssFromPublicKey('%@','adderssFromPublicKey')",subDic[@"key"]];
        
        LOADJS1;
        LOADJS2;
        LOADJS3;
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    }
    if ([prompt hasPrefix:@"adderssFromPublicKey"]) {
        NSString * toAddress = obj[@"result"];
        NSLog(@"toAddress=%@",toAddress);
        NSString * title = [NSString stringWithFormat:Localized(@"payTest"),toAddress];
        NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
        NSDictionary *walletDict = [Common dictionaryWithJsonString:jsonStr];
        NSLog(@"walletDict=%@",walletDict);
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"verifySuccess") message:title image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"sendSign") action:^{
            
            NSString* jsStr  =  [NSString stringWithFormat:@"addSign('%@','%@')",self.hashString,walletDict[@"key"]];
            LOADJS1;
            LOADJS2;
            LOADJS3;
            [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        }];
        MGPopAction *action1 =   [MGPopAction actionWithTitle:Localized(@"Cancel") action:^{
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop addAction:action1];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }
    if ([prompt hasPrefix:@"addSign"]) {
        NSString * resultString = obj[@"result"];
        NSLog(@"toAddress=%@",resultString);
    }
    
    
}

- (void)loadJS{
//    NSString *str =  [Common getEncryptedContent:APP_ACCOUNT];
//    NSDictionary *jsDic= [Common dictionaryWithJsonString:str];
//    NSString *defaultOntid = [jsDic valueForKey:@"defaultOntid"];
//    NSArray *identArr = jsDic[@"identities"];
//    NSDictionary *identitiesDic = identArr[[[[NSUserDefaults standardUserDefaults]valueForKey:SELECTINDEX]integerValue]];
//    NSDictionary *controlsDic =identitiesDic[@"controls"][0];
//    
//    NSString *jsStr =  [NSString stringWithFormat:@"Ont.SDK.signData('%@','%@','%@','%@','%@','newsignDataStr')",defaultOntid,controlsDic[@"key"],@"111111",controlsDic[@"address"],controlsDic[@"salt"]];
//
//    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
//    __weak typeof(self) weakSelf = self;
//    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
//        [weakSelf handlePrompt:prompt];
//    }];
    
}

- (void)configNetLabel{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (appDelegate.isNetWorkConnect==NO) {
        [self nonNetWork];
    }else{
        [self getNetWork];
    }
    
}

-(NSString * )currentVersion{
    
    NSString *key = @"CFBundleShortVersionString";
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[key];
    return currentVersion;
}

//系统通知
- (void)getNotifcation{
 
    NSDictionary *paramsdic = @{@"AfterTime":[self getNowTimeTimestamp3]
                                ,@"languages":@[ENORCN]};
    
    [[CCRequest shareInstance] requestWithURLStringNoLoading:GetAfterTimeWithLanguages MethodType:MethodTypePOST Params:paramsdic Success:^(id responseObject, id responseOriginal) {
        NSMutableArray *notifiyArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:SYSTEMNOTIFICATIONLIST]];
        [self StoreFistNotificeTime];
        if ([(NSArray*)responseObject count]>0) {
            
            for (NSInteger i=[(NSArray*)responseObject count]-1;i>=0;i--) {
                
                [notifiyArr insertObject:responseObject[i] atIndex:0];
                
            }
            //            [notifiyArr addObjectsFromArray:responseObject];
            [[NSUserDefaults standardUserDefaults] setValue:notifiyArr forKey:SYSTEMNOTIFICATIONLIST];
            
            [[NSUserDefaults standardUserDefaults]setValue:[responseObject[0] valueForKey:@"createTime"] forKey:LAQUSYSTEMNOTIFICATIONLIST];
            
            for (NSDictionary *dic in responseObject) {
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:                [[dic valueForKey:@"createTime"] stringValue]];
            }
            
            //tab小红点
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISNOTIFICATION];
            
            [BaseViewController setTabbarItemWithItemTitle:TABTHREETITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTHREECOLORSELECTED ItemTitleFont:K12FONT ItemImage:TABTHREEIMAGENOTIFICAION ItemImageSelected:TABTHREEIMAGESELECTED AtIndex:2 SourceTabbar:self.tabBarController];
        }
        
        //存下当前时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        //设置时区,这个对于时间的处理有时很重要
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
        [[NSUserDefaults standardUserDefaults] setValue:timeSp forKey:NOTICETIONTIME];
        
    }Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        DebugLog(@"error%@",responseOriginal);
    }];
    
}



- (void)StoreFistNotificeTime{
    
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:LAQUSYSTEMNOTIFICATIONLIST]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        //设置时区,这个对于时间的处理有时很重要
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
        [[NSUserDefaults standardUserDefaults] setValue:timeSp forKey:LAQUSYSTEMNOTIFICATIONLIST];
    }
}

-(NSString *)getNowTimeTimestamp3{
    
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:LAQUSYSTEMNOTIFICATIONLIST]) {
        
        return [[NSUserDefaults standardUserDefaults] valueForKey:LAQUSYSTEMNOTIFICATIONLIST];
        
    }else{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        //设置时区,这个对于时间的处理有时很重要
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
        return timeSp;
        
    }
}




- (IBAction)copyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
//     [self showHint:Localized(@"OntidCopySuccess")];
    [Common showToast:Localized(@"OntidCopySuccess")];
}

- (void)configUI{
  
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 10.3) {
        [self.tableBottom setConstant:-49];
    }else{
        [self.tableBottom setConstant:0];
    }
    
    if (LL_iPhone5S) {
        [self.tableBottom setConstant:-10];
    }

//    [self setNavTitle:Localized(@"OntID")];
    
    
//    [self setNavRightImageIcon:[UIImage imageNamed:@"coticon-none"] Title:@""];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"coticon-none"] Title:@""];
    self.view.backgroundColor = [UIColor whiteColor];

    self.exampleView.layer.masksToBounds = YES;
    self.exampleView.layer.cornerRadius = 7;
    self.startBtn.layer.masksToBounds = YES;
    self.startBtn.layer.cornerRadius = 1;
    [self.startBtn setTitle:Localized(@"Start") forState:UIControlStateNormal];
    [self.learnMoreBtn setTitle:Localized(@"LearnMore") forState:UIControlStateNormal];
    self.makeIdentityLabel.text = Localized(@"MakeIdentityCards");
    self.custmizedLabel.text = Localized(@"Custmizedidentity");

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:START]==YES) {
        _exampleView.hidden = YES;
        _startBtn.hidden = YES;
        _custmizedLabel.hidden = NO;
        
    }else{
        
        _exampleView.hidden = NO;
        _startBtn.hidden = NO;
        _custmizedLabel.hidden = YES;
    }

    _expireLabel.text = Localized(@"Identitylogin");
    _doneBtn.layer.cornerRadius = 1;
    _doneBtn.layer.masksToBounds = YES;
    [_doneBtn setTitle:Localized(@"Login") forState:UIControlStateNormal];
    _netWorkL.text = Localized(@"Netdisconnected");

}
- (void)navLeftAction {
    __weak typeof(self) weakSelf = self;
    ImportViewController *vc =[[ImportViewController alloc]init];
    [vc setCallback:^(NSString *stringValue) {
        [weakSelf createCOT:stringValue];
    }];
    vc.isCOT =YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)navRightAction{
    __weak typeof(self) weakSelf = self;
    ImportViewController *vc =[[ImportViewController alloc]init];
    [vc setCallback:^(NSString *stringValue) {
        
        [weakSelf createPay:stringValue];
    }];
    vc.isPay =YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)createPay:(NSString*)stringValue{
    NSDictionary * dic = [Common dictionaryWithJsonString:stringValue];
    NSLog(@"paydic=%@",dic);
    if ([dic[@"type"] isEqualToString:@"login"]) {
        NSString *login = [NSString stringWithFormat:Localized(@"loginInfo"),dic[@"message"]];
        MGPopController *pop = [[MGPopController alloc] initWithTitle:login message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"toSign") action:^{
        }];
        MGPopAction *action1 =   [MGPopAction actionWithTitle:Localized(@"Cancel") action:^{
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop addAction:action1];
        [pop show];
        pop.showCloseButton = NO;
    }else if ([dic[@"type"] isEqualToString:@"invoke"]) {
        
        self.hashString = dic[@"signedTx"];
        NSString* jsStr  =  [NSString stringWithFormat:@"decodeTransHash('%@')",self.hashString];
        
        LOADJS1;
        LOADJS2;
        LOADJS3;
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    }
}
-(void)createCOT:(NSString*)string{
    MBProgressHUD *hub=[ToastUtil showMessage:@"" toView:nil];
    NSDictionary * pDic = [Common dictionaryWithJsonString:string];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:pDic];
    [[CCRequest shareInstance] requestWithURLString:[NSString stringWithFormat:@"%@/%@",COTInfo,[ENORCN isEqualToString:@"cn"] ? @"CN" : @"EN"] MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        [hub hideAnimated:YES];
        NSDictionary *dic =responseOriginal[@"Result"];
        if (dic.count == 0) {
            return ;
        }
        NSDictionary *ReqContexts =dic[@"ReqContexts"];
        NSArray *OArray = ReqContexts[@"O"];
        NSDictionary *ODic ;
        NSArray *ReqContextsArray ;
        if (OArray.count>0) {
            ODic = OArray[0];
            ReqContextsArray =ODic[@"Contexts"];
        }else{
            ReqContextsArray = [NSArray array];
        }
        
        NSArray * MArray =ReqContexts[@"M"];
        if (MArray.count==0) {
            int num =0;
            for (NSDictionary *idmType in OArray) {
                ClaimModel *claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:idmType[@"ClaimContext"] andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
                if ([Common isBlankString:claimmodel.OwnerOntId]) {
                    num ++;
                }
            }
            if (num <ReqContextsArray.count) {
                COTListViewController *vc = [[COTListViewController alloc]init];
                vc.resultDic = dic;
                vc.certArray = OArray;
                vc.oMaxNum = [ReqContexts[@"OMaxNum"] intValue];
                vc.oMinNum = [ReqContexts[@"OMinNum"] intValue];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                GetCertViewController *vc = [[GetCertViewController alloc]init];
                vc.certArray = OArray;
                vc.resultDic = dic;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            COTMListViewController *vc =[[COTMListViewController alloc]init];
            vc.resultArr = MArray;
            vc.resultDic = dic;
            vc.resultOArr = OArray;
            vc.oMaxNum = [ReqContexts[@"OMaxNum"] intValue];
            vc.oMinNum = [ReqContexts[@"OMinNum"]intValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        [hub hideAnimated:YES];
        
        if ([responseOriginal[@"Error"] integerValue] == 62001 ||[responseOriginal[@"Error"] integerValue] == 61003 ) {
            [Common showToast:Localized(@"invalidQRCode")];
        }else if ([responseOriginal[@"Error"] integerValue] == 62003 ){
            [Common showToast:Localized(@"sceneUnusual")];
        }
    }];
}
- (IBAction)helpBtnClick:(id)sender {
    WebIdentityViewController *VC= [[WebIdentityViewController alloc]init];
    VC.introduce = [NSString stringWithFormat:@"https://info.onto.app/#/detail/%@",[ENORCN isEqualToString:@"cn"]?@"32":@"33"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)startAction:(id)sender {
        _exampleView.hidden = YES;
        _startBtn.hidden = YES;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:START];
}

//- (void)navLeftAction {
//    HelpCentreViewController *vc = [[HelpCentreViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    
//}

//- (void)navRightAction {
//    KeystoreImportVC *vc = [[KeystoreImportVC alloc]init];
//    vc.isIdentity = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//
//}

- (void)touchIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0&&indexPath.row==0) {
        
        if (_myTable.hidden) {
            ScreenLockController *lockVc = [[ScreenLockController alloc]init];
            lockVc.modalPresentationStyle = UIModalPresentationOverFullScreen | UIModalTransitionStyleCrossDissolve;
            lockVc.ontID = [[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID];
            [self presentViewController:lockVc animated:YES completion:nil];
            
        }else{
            
            IDCardListViewController *vc = [[IDCardListViewController alloc]init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else if (indexPath.section==0&&indexPath.row==1){
        
        
        if (_myTable.hidden) {
            ScreenLockController *lockVc = [[ScreenLockController alloc]init];
            lockVc.modalPresentationStyle = UIModalPresentationOverFullScreen | UIModalTransitionStyleCrossDissolve;
            lockVc.ontID = [[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID];
            [self presentViewController:lockVc animated:YES completion:nil];
            
        }else{
            PendingViewController *vc = [[PendingViewController alloc]init];
            vc.verfiedClaimType = 2;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        
    }else if (indexPath.section==0&&indexPath.row==2){
        MakeIDCardVC *mcVC = [[MakeIDCardVC alloc]init];
        [self.navigationController pushViewController:mcVC animated:YES];
    }else if (indexPath.section==1&&indexPath.row==0){
        CreateViewController *control = [[CreateViewController alloc] init];
        control.isIdentity = YES;
        [self.navigationController pushViewController:control animated:YES];
    }else if (indexPath.section==1&&indexPath.row==1){
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"CameraRights") message:@"" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];

            return;
        }
        ImportViewController *control = [[ImportViewController alloc] init];
        [self.navigationController pushViewController:control animated:YES];
        
    }
}

- (IBAction)menuClick:(id)sender {
    [self.idMenueBtn setImage:[UIImage imageNamed:@"asset_menu"] forState:UIControlStateNormal];
}


- (IBAction)kownMoreAction:(id)sender {
    WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    if ([Common userLogin]) {
        
//        [self.view removeAllSubviews];
        self.myTable.hidden = NO;
        [self.view bringSubviewToFront:self.myTable];
        NSLog(@"%d", self.myTable.hidden);
        [self createIdentityView];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        //底部隐藏遮盖一部分
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        NSString *ontID = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
        ontID = [ontID substringFromIndex:8];
        self.idLabel.text =[NSString stringWithFormat:@"ONT ID: %@",ontID] ;
        //    [self getCardList];
        _IDTitle.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:IDENTITY_NAME]];
        _iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"随机icon%ld",(long)([[[NSUserDefaults standardUserDefaults]valueForKey:SELECTINDEX]integerValue]+1)%5+1]];
        
        TitleImageButton * titleBtn =[[TitleImageButton alloc]initWithFrame:CGRectMake(0, 0, 200*SCALE_W, 44)];
        [titleBtn setTitle:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:IDENTITY_NAME]] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:@"titleimage"] forState:UIControlStateNormal];
        [titleBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            COTListIntroViewController *vc =[[COTListIntroViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        self.navigationItem.titleView = titleBtn;
        
        [self getDataFromcache];
        [self getData:NO];
        self.navigationController.navigationBar.translucent = NO;
        [self configNetLabel];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"%@A",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]]==YES) {
            self.headBackV.hidden =YES;
            _headCollectionV.frame = CGRectMake(0, 0, SYSWidth, 149*SCALE_W+110);
        }else{
            [self.headCollectionV addSubview:self.headBackV];
            self.headBackV.hidden =NO;
            _headCollectionV.frame = CGRectMake(0, 0, SYSWidth, 149*SCALE_W+180);
        }
        return;
    }
    else
    {
        [self createEmptyIdentityView];
    }

}

- (void)getDataFromcache{

    if ([[NSUserDefaults standardUserDefaults] valueForKey:IDAUTHARR]&&[[NSUserDefaults standardUserDefaults] valueForKey:SOCIALAUCHARR]) {
        NSArray *dataArr = [[NSUserDefaults standardUserDefaults] valueForKey:IDAUTHARR];
        NSArray *socialArr = [[NSUserDefaults standardUserDefaults] valueForKey:SOCIALAUCHARR];
        self.IdAuthArr =[IdentityModel mj_objectArrayWithKeyValuesArray:dataArr];
        self.SocialAuthArr =[IdentityModel mj_objectArrayWithKeyValuesArray:socialArr];

        IdentityModel *modelCFCA = [[IdentityModel alloc]init];
        ClaimModel *claimmodel = [[ClaimModel alloc] init];
        claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:@"claim:cfca_authentication" andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
        
        modelCFCA.ClaimContext = @"claim:cfca_authentication";
        modelCFCA.Name = Localized(@"Identity");
        modelCFCA.IssuedFlag = @([claimmodel.status integerValue]);
        [self.myTable reloadData];
        [self.AuthCollectionView reloadData];
    }
}

- (void)getNetWork{
    
    _netWorkL.hidden = YES;
    
}

- (void)nonNetWork{
    
    _netWorkL.hidden = NO;
    
}

- (void)changeExpireUI
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IDENTITY_EXISIT];
    NSString *ontID = [[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
  
    if ([Common judgeisExpireWithOntId:ontID]) {
        _myTable.hidden = YES;
        _doneBtn.hidden = NO;
        _expireLabel.hidden = NO;
          appDelegate.isEpire = YES;
    }else{
        _myTable.hidden = NO;
        _doneBtn.hidden = YES;
        _expireLabel.hidden = YES;
        appDelegate.isEpire = NO;

    }
    
}

- (IBAction)doneClick:(id)sender {
    
    ScreenLockController *lockVc = [[ScreenLockController alloc]init];
    lockVc.modalPresentationStyle = UIModalPresentationOverFullScreen | UIModalTransitionStyleCrossDissolve;
    lockVc.ontID = [[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID];
    [self presentViewController:lockVc animated:YES completion:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //销毁定时器
    [_timer invalidate];
    _timer = nil;
//    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

//- (void)function:(NSTimer*)timer{
//
//    [self getData:YES];
//    DebugLog(@"调用");
//}

- (void)getData:(BOOL)isRepeats{
    
    NSString *deviceCode = [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_CODE];
    if (!deviceCode) return;
    
    NSDictionary *params = @{@"ontId":[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID],@"deviceCode":deviceCode,@"pageNumber":@(1),@"pageSize":@(20),@"language":ENORCNDAXIE};
    [[CCRequest shareInstance] requestWithURLString:Trustanchor_query MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        NSArray *OrganizationListArr = [responseObject valueForKey:@"OrganizationList"];
        NSArray *socialArr = [responseObject valueForKey:@"SocialList"];
        NSArray *AppNativeListArr = [responseObject valueForKey:@"AppNativeList"];
        
        NSMutableArray *dataArr =[NSMutableArray array];
//        if (AppNativeListArr.count >0) {
//
//            [dataArr addObject:AppNativeListArr[0]];
//        }
//
        for (NSDictionary * nativeDic in AppNativeListArr) {
            if ([nativeDic[@"ClaimContext"]isEqualToString:@"claim:sfp_passport_authentication"]) {
                [dataArr addObject:nativeDic];
            }
        }
        for (NSDictionary * nativeDic in AppNativeListArr) {
            if ([nativeDic[@"ClaimContext"]isEqualToString:@"claim:sensetime_authentication"]) {
                [dataArr addObject:nativeDic];
            }
        }
        for (NSDictionary * nativeDic in AppNativeListArr) {
            if ([nativeDic[@"ClaimContext"]isEqualToString:@"claim:idm_passport_authentication"]) {
                [dataArr addObject:nativeDic];
            }
        }
        [dataArr addObjectsFromArray:OrganizationListArr];
        NSMutableArray * socialArr1 = [NSMutableArray array];
        for (NSDictionary * dic in AppNativeListArr) {
            if ([dic[@"ClaimContext"] isEqualToString:@"claim:email_authentication"] ) {
                [socialArr1 addObject:dic];
            }
            if ([dic[@"ClaimContext"] isEqualToString:@"claim:mobile_authentication"]) {
                [socialArr1 insertObject:dic atIndex:0];
            }
        }
        [socialArr1 addObjectsFromArray:socialArr];
        
        self.IdAuthArr =[IdentityModel mj_objectArrayWithKeyValuesArray:dataArr];
        self.SocialAuthArr =[IdentityModel mj_objectArrayWithKeyValuesArray:socialArr1];
        self.appNativeArr =[IdentityModel mj_objectArrayWithKeyValuesArray:AppNativeListArr];

        NSArray *arr= [IdentityModel mj_objectArrayWithKeyValuesArray:dataArr];
        [[NSUserDefaults standardUserDefaults]setObject:dataArr forKey:IDAUTHARR];
        [[NSUserDefaults standardUserDefaults]setObject:socialArr1 forKey:SOCIALAUCHARR];
        [[NSUserDefaults standardUserDefaults]setObject:AppNativeListArr forKey:APPAUCHARR];
        if (isRepeats==YES) {
            for (IdentityModel *model in arr) {
                if ([[model IssuedFlag] integerValue]!=2) {
                    [_timer invalidate];
                    _timer = nil;
                }
            }
        }
        
        IdentityModel *modelCFCA = [[IdentityModel alloc]init];
        ClaimModel *claimmodel = [[ClaimModel alloc] init];
        claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:@"claim:cfca_authentication" andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
        
        modelCFCA.ClaimContext = @"claim:cfca_authentication";
        modelCFCA.Name = Localized(@"Identity");
        modelCFCA.IssuedFlag = @([claimmodel.status integerValue]);
        [self.myTable reloadData];
        [self.AuthCollectionView reloadData];
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        if ([responseOriginal isKindOfClass:[NSDictionary class]] && responseOriginal[@"Error"]) {
            if ([responseOriginal[@"Error"]integerValue] == 63003) {
                    BOOL isAward= YES;
                    NSArray *viewControllers = self.navigationController.viewControllers;
                    for (UIViewController *vc in viewControllers) {
                        if ([vc isMemberOfClass:[NewLoginViewController class]]) {
                            isAward = NO;
                        }
                    }
                    if (isAward == YES) {
                        [_timer invalidate];
                        _timer = nil;
                    
                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"%@DeviceCode",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]];
                        NewLoginViewController *vc =[[NewLoginViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:NO];
                        return;

                    }
            }
        }
//        if ([[responseOriginal valueForKey:@"Error"] integerValue]==62001) {
//            [self loadJS];
//        }
        
//        [self getData:NO];
    }];
}

- (void)setTable{
    
//    if (!self.myTable)
//    {
//        self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 320, 548)];
//        self.myTable.clipsToBounds = YES;
//    }
    
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    [self setExtraCellLineHidden:self.myTable];
    self.myTable.backgroundColor = NAVBACKCOLOR;
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.myTable.tableHeaderView = self.headCollectionV;
    
    [self.headCollectionV addSubview:self.authTitle];
    [self.headCollectionV addSubview:self.AuthCollectionView];
    [self.headCollectionV addSubview:self.helpButton];
    

}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.SocialAuthArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 104*([[UIScreen mainScreen] bounds].size.width/375);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId =@"cellId";
    SocialAuthCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[SocialAuthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    IdentityModel *model =self.SocialAuthArr[indexPath.row];
    [cell reloadIdAuth:model];
    return cell;
    

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClaimModel *claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:[(IdentityModel*)self.SocialAuthArr[indexPath.row] ClaimContext] andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
    NSDictionary *contentDic;
    NSDictionary *EncryptedDic;
    NSDictionary *claimDic;
    NSDictionary *clmDic;
    if (claimmodel.Content.length>0) {
       contentDic = [Common dictionaryWithJsonString:claimmodel.Content];
        if ([contentDic isKindOfClass:[NSDictionary class]] && contentDic[@"EncryptedOrigData"]) {
            EncryptedDic = [Common claimdencode:contentDic[@"EncryptedOrigData"]];
            if ([EncryptedDic isKindOfClass:[NSDictionary class]] && EncryptedDic[@"claim"]) {
                claimDic = EncryptedDic[@"claim"];
                if ([claimDic isKindOfClass:[NSDictionary class]] && claimDic[@"clm"]) {
                    clmDic = claimDic[@"clm"];
                    
                }
            }
        }
    }
    
    
    
        //    if ([[(IdentityModel*)_modelArr1[indexPath.section][indexPath.row] IssuedFlag] integerValue] ==1) {
    
        
        if ([claimmodel.status integerValue] != 0) {

            if ([claimmodel.ClaimContext isEqualToString:@"claim:email_authentication"]) {
                NewClaimDetailViewController * vc = [[NewClaimDetailViewController alloc]init];
                vc.claimContext = claimmodel.ClaimContext;
                vc.contentStr = clmDic[@"Email"];
                vc.statusType = @"email";
                [self.navigationController   pushViewController:vc animated:YES];
                return;
            }
            if ([claimmodel.ClaimContext isEqualToString:@"claim:mobile_authentication"]) {
                NewClaimDetailViewController * vc = [[NewClaimDetailViewController alloc]init];
                vc.claimContext = claimmodel.ClaimContext;
                
                NSArray * mobileArr = [clmDic[@"PhoneNumber"] componentsSeparatedByString:@"*"];
                vc.contentStrLeft = mobileArr[0];
                vc.contentStr = mobileArr[1];
                vc.statusType = @"mobile";
                [self.navigationController   pushViewController:vc animated:YES];
                return;
            }
            ClaimViewController *claimVC = [[ClaimViewController alloc]init];
            claimVC.claimContext =  [(IdentityModel*)self.SocialAuthArr[indexPath.row] ClaimContext];
             claimVC.stauts = [claimmodel.status integerValue];
            claimVC.claimImage =[(IdentityModel*)self.SocialAuthArr[indexPath.row] HeadLogo];
            claimVC.H5ReqParam  =[(IdentityModel*)self.SocialAuthArr[indexPath.row] H5ReqParam];
            
            
            if (claimVC.stauts==9) {
                claimVC.stauts = 4;
            }
            claimVC.isPending =  claimVC.stauts==4?YES:NO;
            [self.navigationController pushViewController:claimVC animated:YES];
            
        }else{

            
            NSInteger claimType=0;
            
            NSString *context = [(IdentityModel*)self.SocialAuthArr[indexPath.row] ClaimContext];
            IdentityModel *model =self.SocialAuthArr[indexPath.row];
            if ([context isEqualToString:@"claim:email_authentication"]) {
                if ([claimmodel.status integerValue] == 1) {
                    NewClaimDetailViewController * vc = [[NewClaimDetailViewController alloc]init];
                    vc.claimContext = context;
                    vc.contentStr = clmDic[@"Email"];
                    vc.statusType = @"email";
                    [self.navigationController   pushViewController:vc animated:YES];
                    return;
                }else if ([model.IssuedFlag intValue] == 9){
                    NewClaimDetailViewController * vc = [[NewClaimDetailViewController alloc]init];
                    vc.claimContext = context;
                    vc.contentStr = @"";
                    vc.statusType = @"email";
                    [self.navigationController   pushViewController:vc animated:YES];
                    return;
                }
                else{
                    
                    NewEmailViewController * vc = [[NewEmailViewController alloc]init];
                    vc.claimContext = context;
                    [self.navigationController   pushViewController:vc animated:YES];
                    return;
                }
                
            }
            
            if ([context isEqualToString:@"claim:mobile_authentication"]) {
                if ([claimmodel.status integerValue] == 1) {
                    NewClaimDetailViewController * vc = [[NewClaimDetailViewController alloc]init];
                    vc.claimContext = context;
                    NSArray * mobileArr = [clmDic[@"PhoneNumber"] componentsSeparatedByString:@"*"];
                    vc.contentStrLeft = mobileArr[0];
                    vc.contentStr = mobileArr[1];
                    vc.statusType = @"mobile";
                    [self.navigationController   pushViewController:vc animated:YES];
                    return;
                }else if ([model.IssuedFlag intValue] == 9){
                    NewClaimDetailViewController * vc = [[NewClaimDetailViewController alloc]init];
                    vc.claimContext = context;
                    vc.contentStrLeft = @"";
                    vc.contentStr = @"";
                    vc.statusType = @"mobile";
                    [self.navigationController   pushViewController:vc animated:YES];
                    return;
                }else{
                    NewMobileViewController *vc = [[NewMobileViewController alloc]init];
                    vc.claimContext = context;
                    [self.navigationController   pushViewController:vc animated:YES];
                    
                    return;
                }
            }
           if ([context isEqualToString:@"claim:linkedin_authentication"]) {
               claimType = 1;
            }
           else  if ([context isEqualToString:@"claim:github_authentication"]) {
             claimType = 2;
            }
            else  if ([context isEqualToString:@"claim:facebook_authentication"]) {
                claimType = 3;
            }
            else   if ([context isEqualToString:@"claim:twitter_authentication"]) {
               claimType = 0;
            }
            
            WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
            webVC.identityType = (IdentityType)claimType;
            webVC.claimImage =[(IdentityModel*)self.SocialAuthArr[indexPath.row] HeadLogo];
            webVC.claimurl = [(IdentityModel*)self.SocialAuthArr[indexPath.row] H5ReqParam];
            [self.navigationController pushViewController:webVC animated:YES];
            
        }
//    }

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

//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];//创建一个视图
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 230, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]; //[UIFont fontWithName:@"SFProText-Semibold" size:14];
    headerLabel.textColor =[UIColor colorWithHexString:@"#6A797C"];
//    headerLabel.text = section==0?Localized(@"Realname"):Localized(@"Social");
    headerLabel.text = Localized(@"Social");
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 20;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


- (void)setWebSokect{
    
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    appDelegate.isSocketConnect = NO;
//    NSString *urlString =[NSString stringWithFormat:@"%@/api/v1/ontpass/pending/message",SokectURL];
//    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:urlString];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logOutAction) name:NOTIFICATION_SOCKET_LOGOUT object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setWebSokect) name:NOTIFICATION_SOCKET_APPACTIVE object:nil];
    
}

- (void)logOutAction{

//    [[SocketRocketUtility instance]reSendData];
//    //切换账号时 小红点消失
//      [self.idMenueBtn setImage:[UIImage imageNamed:@"asset_menu"] forState:UIControlStateNormal];
//    [self setNavRightImageIcon:[UIImage imageNamed:@"spread"] Title:nil];
}



- (void)SRWebSocketDidOpen {
    DebugLog(@"开启成功");
    //在成功后需要做的操作。。。
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    
    //收到服务端发送过来的消息
/*
    NSString * message = note.object;
    NSDictionary *messageDic = [Common dictionaryWithJsonString:message];
    
    if ([[messageDic allKeys]  containsObject: @"ClaimList"]) {
        
        [_idMenueBtn setImage:[UIImage imageNamed:@"Identities _reddot"] forState:UIControlStateNormal];
//        [self setNavRightImageIcon:[UIImage imageNamed:@"Identities _reddot"] Title:nil];
       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SOCKET_GETCLAIM object:nil];
        if ([[messageDic valueForKey:@"ClaimList"] count]!=0) {
            NSString *claimid =[[messageDic valueForKey:@"ClaimList"][0]valueForKey:@"ClaimId"];
            [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:claimid];
        }
        
          [BaseViewController setTabbarItemWithItemTitle:TABTHREETITLE ItemTitleColor:TABTHREECOLOR ItemTitleColorSelected:TABTHREECOLORSELECTED ItemTitleFont:K12FONT ItemImage:TABTHREEIMAGENOTIFICAION ItemImageSelected:TABTHREEIMAGESELECTED AtIndex:2 SourceTabbar:self.tabBarController];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISNOTIFICATION];
    }
*/
}



- (IBAction)helpCentreClick:(id)sender {
    HelpCentreViewController *vc = [[HelpCentreViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)SocialIDClick:(id)sender {
    
    IdentityViewController *vc = [[IdentityViewController alloc]init];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)claimsClick:(id)sender {
    
    MyVerifiedClaimViewController *vc = [[MyVerifiedClaimViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)thirdPartyClick:(id)sender {
            NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"CameraRights") message:@"" preferredStyle: UIAlertControllerStyleAlert];
    
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
    
                return;
            }
            ImportViewController *vc = [[ImportViewController alloc] init];
            vc.isThired = YES;
            [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)zicanClick:(id)sender {
    
    CapitalViewController *vc = [[CapitalViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)shenfenClick:(id)sender {
    
}


#pragma mark -- dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.IdAuthArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IdAuthCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"auth" forIndexPath:indexPath];
    IdentityModel *model =self.IdAuthArr[indexPath.row];
    [cell reloadIdAuth:model];
    return cell;
}
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(149*SCALE_W, 149*SCALE_W);
}
//调节item边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0*SCALE_W, 0, 0*SCALE_W);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

   
    IdentityModel *model =self.IdAuthArr[indexPath.row];
    if ([model.IsComing integerValue]==1) {
        
    }else{
        if ([model.ClaimContext isEqualToString:@"claim:cfca_authentication"]) {
            ClaimModel *claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:model.ClaimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
            ClaimViewController *claimVC = [[ClaimViewController alloc]init];
            claimVC.claimImage = model.HeadLogo;
            claimVC.H5ReqParam =model.H5ReqParam;
            claimVC.claimContext = @"claim:cfca_authentication";
            if ([model.IssuedFlag integerValue]==0 && [claimmodel.status integerValue]!=1) {
                AuthInfoViewController *vc =[[AuthInfoViewController alloc]init];
                vc.typeImage =@"logo-cfca";
                vc.claimImage =model.HeadLogo;
                vc.chargeModel = model;
                vc.typeString = Localized(@"authInfoDetail");
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            if ([model.ChargeInfo.Charge isEqualToString:@"1"]) {
                PayStatusViewController * vc = [[PayStatusViewController alloc]init];
        
                if ([model.IssuedFlag integerValue]==9 || [model.IssuedFlag integerValue]==4) {
                    vc.statusType = @"2";
                }else if ([model.IssuedFlag integerValue]==8){
                    vc.statusType = @"3";
                    
                }else if ([model.IssuedFlag integerValue]==3){
                    vc.statusType = @"1";
                    
                }else if ([model.IssuedFlag integerValue]==0 || [claimmodel.status integerValue]==1){
                    NewClaimViewController * newCliamVc = [[NewClaimViewController alloc]init];
                    newCliamVc.claimImage = model.HeadLogo;
                    newCliamVc.H5ReqParam =model.H5ReqParam;
                    newCliamVc.claimContext = @"claim:cfca_authentication";
                    [self.navigationController pushViewController:newCliamVc animated:YES];
                    return;
                }else{
                    return;
                }
                vc.shuftiModel = model;
                vc.calimFrom = @"CFCA";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if ([model.IssuedFlag integerValue]==9 || [model.IssuedFlag integerValue]==4) {
                    claimVC.stauts = 4;
                    claimVC.isPending = YES;
                }else if ([model.IssuedFlag integerValue]==1){
                    claimVC.stauts = 1;
                    claimVC.isPending = NO;
                }else if ([model.IssuedFlag integerValue]==3){
                    claimVC.stauts = 3;
                    claimVC.isPending = NO;
                }else{
                    claimVC.stauts = [model.IssuedFlag integerValue];
                    claimVC.isPending = NO;
                }
                [self.navigationController pushViewController:claimVC animated:YES];
            }
            
            
        }else if ([model.ClaimContext isEqualToString:@"claim:sensetime_authentication"]) {
            ClaimModel *claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:model.ClaimContext andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
            ClaimViewController *claimVC = [[ClaimViewController alloc]init];
            claimVC.claimImage = model.HeadLogo;
            claimVC.H5ReqParam =model.H5ReqParam;
            claimVC.claimContext = @"claim:sensetime_authentication";
            if ([model.IssuedFlag integerValue]==0 && [claimmodel.status integerValue]!=1) {
                AuthInfoViewController *vc =[[AuthInfoViewController alloc]init];
                vc.typeImage =@"shangtang";
                vc.claimImage =model.HeadLogo;
                vc.chargeModel = model;
                vc.typeString = Localized(@"shangtangInfo");
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            if ([model.ChargeInfo.Charge isEqualToString:@"1"]) {
                PayStatusViewController * vc = [[PayStatusViewController alloc]init];
                
                if ([model.IssuedFlag integerValue]==9 || [model.IssuedFlag integerValue]==4) {
                    vc.statusType = @"2";
                }else if ([model.IssuedFlag integerValue]==8){
                    vc.statusType = @"3";
                    
                }else if ([model.IssuedFlag integerValue]==3){
                    vc.statusType = @"1";
                    
                }else if ([model.IssuedFlag integerValue]==0 || [claimmodel.status integerValue]==1){
                    NewClaimViewController * newCliamVc = [[NewClaimViewController alloc]init];
                    newCliamVc.claimImage = model.HeadLogo;
                    newCliamVc.H5ReqParam =model.H5ReqParam;
                    newCliamVc.claimContext = @"claim:sensetime_authentication";
                    [self.navigationController pushViewController:newCliamVc animated:YES];
                    return;
                }else{
                    return;
                }
                vc.shuftiModel = model;
                vc.calimFrom = @"sensetime";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if ([model.IssuedFlag integerValue]==9 || [model.IssuedFlag integerValue]==4) {
                    claimVC.stauts = 4;
                    claimVC.isPending = YES;
                }else if ([model.IssuedFlag integerValue]==1){
                    claimVC.stauts = 1;
                    claimVC.isPending = NO;
                }else if ([model.IssuedFlag integerValue]==3){
                    claimVC.stauts = 3;
                    claimVC.isPending = NO;
                }else{
                    claimVC.stauts = [model.IssuedFlag integerValue];
                    claimVC.isPending = NO;
                }
                [self.navigationController pushViewController:claimVC animated:YES];
            }
            
        }else if ([model.ClaimContext hasPrefix:@"claim:sfp"]){
            if ([[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@c",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]]) {
                
                if (self.appNativeArr.count == 0) {
                    NSArray * arr =[[NSUserDefaults standardUserDefaults] valueForKey:APPAUCHARR];
                    if (arr.count ==0) {
                        return;
                    }else{
                        self.appNativeArr = [IdentityModel mj_objectArrayWithKeyValuesArray:arr];
                    }
                }
                
                ShuftiDocViewController *vc = [[ShuftiDocViewController alloc]init];
                vc.modelArr = self.appNativeArr;
                vc.myStatus = @"1";
                
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                appDelegate.selectCountry = [[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@c",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else{
                if (self.appNativeArr.count == 0) {
                    NSArray * arr =[[NSUserDefaults standardUserDefaults] valueForKey:APPAUCHARR];
                    if (arr.count ==0) {
                        return;
                    }else{
                        
                        self.appNativeArr = [IdentityModel mj_objectArrayWithKeyValuesArray:arr];
                    }
                }
                
                AuthInfoViewController *vc =[[AuthInfoViewController alloc]init];
                vc.typeImage = @"SHUFTIPRO";
                vc.modelArr = self.appNativeArr;
                vc.typeString = Localized(@"Shufti_Introduce");
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
        }else if ([model.ClaimContext hasPrefix:@"claim:idm"]){
            
            //    是否认证过
            if ([[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@c",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]]) {
                
                if (self.appNativeArr.count == 0) {
                    NSArray * arr =[[NSUserDefaults standardUserDefaults] valueForKey:APPAUCHARR];
                    if (arr.count ==0) {
                        return;
                    }else{
                        self.appNativeArr = [IdentityModel mj_objectArrayWithKeyValuesArray:arr];
                    }
                }
                
                DocTypeViewController *vc = [[DocTypeViewController alloc]init];
                vc.modelArr = self.appNativeArr;
                vc.myStatus = @"1";
                
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                appDelegate.selectCountry = [[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@c",[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]]];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else{
                if (self.appNativeArr.count == 0) {
                    NSArray * arr =[[NSUserDefaults standardUserDefaults] valueForKey:APPAUCHARR];
                    if (arr.count ==0) {
                        return;
                    }else{
                        
                        self.appNativeArr = [IdentityModel mj_objectArrayWithKeyValuesArray:arr];
                    }
                }
                
                AuthInfoViewController *vc =[[AuthInfoViewController alloc]init];
                vc.typeImage = @"cotinnerlogo";
                vc.modelArr = self.appNativeArr;
                vc.typeString =  Localized(@"IM_Introduce");
//                vc.typeString = Localized(@"Shufti_Introduce");
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
        }
        else{
            ClaimModel *claimmodel = [[DataBase sharedDataBase]getCalimWithClaimContext:[(IdentityModel*)self.IdAuthArr[indexPath.row] ClaimContext] andOwnerOntId:[[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID]];
            if ([claimmodel.status integerValue] != 0) {
                
                ClaimViewController *claimVC = [[ClaimViewController alloc]init];
                claimVC.claimContext =  [(IdentityModel*)self.IdAuthArr[indexPath.row] ClaimContext];
                claimVC.H5ReqParam =[(IdentityModel*)self.IdAuthArr[indexPath.row] H5ReqParam];
                claimVC.stauts = [claimmodel.status integerValue];
                if (claimVC.stauts==9) {
                    claimVC.stauts = 4;
                }
                claimVC.isPending =  claimVC.stauts==4?YES:NO;
                [self.navigationController pushViewController:claimVC animated:YES];
                
            }else{
                
                NSInteger claimType=0;
                WebIdentityViewController *webVC = [[WebIdentityViewController alloc]init];
                webVC.identityType = (IdentityType)claimType;
                webVC.claimurl = [(IdentityModel*)self.IdAuthArr[indexPath.row] H5ReqParam];
                [self.navigationController pushViewController:webVC animated:YES];
                
            }
        }
    }
    
}
-(UIView*)headCollectionV{
    if (!_headCollectionV) {
        _headCollectionV =[[UIView alloc]init];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"%@A",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]]==YES) {
            _headCollectionV.frame = CGRectMake(0, 0, SYSWidth, 149*SCALE_W+110);
        }else{
            _headCollectionV.frame = CGRectMake(0, 0, SYSWidth, 149*SCALE_W+180);
        }
    }
    return _headCollectionV;
}
-(UILabel*)authTitle{
    if (!_authTitle) {
        _authTitle =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 0, SYSWidth-24*SCALE_W, 36)];
        _authTitle.textAlignment =NSTextAlignmentLeft;
        _authTitle.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];//[UIFont fontWithName:@"SFProText-Semibold" size:14];
        _authTitle.textColor =[UIColor colorWithHexString:@"#6A797C"];
        _authTitle.text =Localized(@"Identity");
    }
    return _authTitle;
}
-(UICollectionView*)AuthCollectionView{
    if (!_AuthCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing =15.5*SCALE_W;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _AuthCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(16*SCALE_W, 46, SYSWidth-16*SCALE_W, 149*SCALE_W) collectionViewLayout:flowLayout];
        _AuthCollectionView.dataSource = self;
        _AuthCollectionView.delegate = self;
        _AuthCollectionView.backgroundColor =[UIColor whiteColor];
        _AuthCollectionView.showsHorizontalScrollIndicator =NO;
        [_AuthCollectionView registerClass:[IdAuthCell class] forCellWithReuseIdentifier:@"auth"];
    }
    return _AuthCollectionView;
}
-(UIButton*)helpButton{
    if (!_helpButton) {
        _helpButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 46+149*SCALE_W, SYSWidth, 64)];
        [_helpButton setTitle:Localized(@"IdHelp") forState:UIControlStateNormal];
        [_helpButton setImage:[UIImage imageNamed:@"IdHelp"] forState:UIControlStateNormal];
        [_helpButton setTitleColor:BLUELB forState:UIControlStateNormal];
        [_helpButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            WebIdentityViewController *VC= [[WebIdentityViewController alloc]init];
            VC.introduce = [NSString stringWithFormat:@"https://info.onto.app/#/detail/%@",[ENORCN isEqualToString:@"cn"]?@"32":@"33"];
            [self.navigationController pushViewController:VC animated:YES];
            
        }];
        _helpButton.titleLabel.font =[UIFont systemFontOfSize:14];
        
    }
    return _helpButton;
}
#pragma mark - 备份
-(UIView*)headBackV{
    if (!_headBackV) {
        _headBackV =[[UIView alloc]initWithFrame:CGRectMake(-1, 46+149*SCALE_W +64, SYSWidth + 2, 50)];
        _headBackV.layer.borderWidth =1;
        _headBackV.layer.borderColor = [[UIColor colorWithHexString:@"#FF9A49"] CGColor];
        CGSize strSize = [Localized(@"identityBackL") sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
        
        UIImageView * leftImage =[[UIImageView alloc]initWithFrame:CGRectMake(SYSWidth/2 - strSize.width/2 -25, 15, 20, 20)];
        leftImage.image =[UIImage imageNamed:@"Rectangle"];
        [_headBackV addSubview:leftImage];
        
        
        UILabel* LB =[[UILabel alloc]initWithFrame:CGRectMake(SYSWidth/2 - strSize.width/2, 0, strSize.width, 50)];
        LB.textColor = [UIColor colorWithHexString:@"#FF9A49"];
        LB.textAlignment =NSTextAlignmentCenter;
        LB.font =[UIFont systemFontOfSize:14];
        LB.text = Localized(@"identityBackL");
        [_headBackV addSubview:LB];
        
        UIImageView * rightImage =[[UIImageView alloc]initWithFrame:CGRectMake(SYSWidth/2 + strSize.width/2 +5, 14.5, 21, 21)];
        rightImage.image =[UIImage imageNamed:@"Rectangle Copy"];
        [_headBackV addSubview:rightImage];
        
        UIButton* btn =[[UIButton alloc]initWithFrame:_headBackV.bounds];
        [_headBackV addSubview:btn];
        [btn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headBackV;
}
-(void)toBack{
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
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)createIdentityView {
    self.hashString = @"";
    [self setWebSokect];
    [self setTable];
    [self configUI];
    [self getNotifcation];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeExpireUI) name:EXPIRENOTIFICATION object:nil];
    [self changeExpireUI];
    //JS初始化
    _browserView = self.browserView;
}

-(void)p_clearSubViews
{
    if (self.view.subviews.count>0)
    {
        for (UIView *objc in self.view.subviews)
        {
            if (![objc isKindOfClass:[UITableView class]])
            {
                [objc removeFromSuperview];
            }
        }
    }
}

- (void)createEmptyIdentityView {
//    [self.view removeAllSubviews];
    
    [self p_clearSubViews];
    
     [self setNavTitle:@"ONT ID"];
    self.myTable.hidden = YES;
//    self.netWorkL.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = YES;
    
    
    YYImage *image = [YYImage imageNamed:@"ONT ID.gif"];
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"ONT ID" withExtension:@"gif"];
    // 将GIF图片转换成对应的图片源
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);
    // 获取图片源个数，即由多少帧图片组成
    size_t frameCout = CGImageSourceGetCount(gifSource);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, frameCout-1, NULL);
    UIImage *imageName = [UIImage imageWithCGImage:imageRef];
    
    [RACObserve(imageView, currentAnimatedImageIndex) subscribeNext:^(id _Nullable x) {
        if ([x integerValue] == imageView.animationImages.count) {
            [imageView stopAnimating];
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        imageView.image = imageName;
    });
    
    UILabel * idInfoLB = [[UILabel alloc]init];
    idInfoLB.text = Localized(@"NewONTIDDec");
    idInfoLB.textColor = [UIColor blackColor];
    idInfoLB.numberOfLines = 0;
    idInfoLB.font = [UIFont systemFontOfSize:16];
    [idInfoLB changeSpace:3 wordSpace:0];
    idInfoLB.textAlignment = NSTextAlignmentCenter;
    idInfoLB.alpha = 0.3;
    [self.view addSubview:idInfoLB];
    
    UIButton * createBtn = [[UIButton alloc]init];
    [createBtn setTitle:Localized(@"newCreateOntId") forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    createBtn.backgroundColor = [UIColor colorWithHexString:@"#0069E0"];
    createBtn.layer.cornerRadius = 5;
    [self.view addSubview:createBtn];
    
    UIButton * importBtn = [[UIButton alloc]init];
    [importBtn setTitle:Localized(@"ImportAIdentity") forState:UIControlStateNormal];
    [importBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    importBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    importBtn.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    importBtn.layer.cornerRadius = 5;
    [self.view addSubview:importBtn];

    [idInfoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35*SCALE_W);
        make.right.equalTo(self.view).offset(-35*SCALE_W);
        make.top.equalTo(self.view).offset(275*SCALE_W);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(157*SCALE_W);
        make.width.mas_offset(258*SCALE_W);
        make.height.mas_offset(90*SCALE_W);
    }];

    
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35*SCALE_W);
        make.right.equalTo(self.view).offset(-35*SCALE_W);
        make.height.mas_offset(45*SCALE_W);
        make.top.equalTo(self.view.mas_bottom).offset(-145*SCALE_W - LL_TabbarHeight + 300*SCALE_W);
    }];
    
    [importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35*SCALE_W);
        make.right.equalTo(self.view).offset(-35*SCALE_W);
        make.height.mas_offset(45);
        make.top.equalTo(createBtn.mas_bottom).offset(20*SCALE_W);
    }];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:1 animations:^{
        [createBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-145*SCALE_W - LL_TabbarHeight );
        }];
        
        [importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(createBtn.mas_bottom).offset(20*SCALE_W);
        }];
        
        [self.view layoutIfNeeded];
    }];
    [createBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        CreateViewController *VC = [[CreateViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
    [importBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        NewOntImportViewController * vc = [[NewOntImportViewController alloc]init];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"box"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
