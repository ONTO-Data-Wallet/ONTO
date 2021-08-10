//
//  CapitalViewController.m
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

#import "CapitalViewController.h"
#import "CreateViewController.h"
#import "AssetCell.h"
#import "CapitalDetailViewController.h"
#import "GetViewController.h"
#import "ImportWalletVC.h"
#import "WalletDetailViewController.h"
#import "WalletBackupVC.h"
#import "CreateShareWalletViewController.h"
#import "ShareWalletDetailViewController.h"
#import "walletManagerView.h"
#import "JoinShareWalletViewController.h"
#import "ShareWalletTransferAccountsViewController.h"
#import "SwapTextViewController.h"
#import "SwapListViewController.h"
#import "NewWalletManagerViewController.h"
#import "CommonOCAdapter.h"
#import "ONTO-Swift.h"
#import "TokenManageViewController.h"
#import "OEP4ViewController.h"
//static const int TimerInterval = 20;

#import "ONTODAppWalletTipsAlertView.h"//创建钱包导入钱包提示窗体
#import "ONTODAppChangeWalletAlertView.h"
#import "ONTOWakePayViewController.h"
#import "ONTOWakePaySureViewController.h"
#import "SelectDefaultWallet.h"

@interface CapitalViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *tokenList;
@property (weak, nonatomic) IBOutlet UIButton *tokenManage;

@property(weak, nonatomic) IBOutlet UILabel *nameL;
@property(weak, nonatomic) IBOutlet UILabel *addressL;
@property(weak, nonatomic) IBOutlet UILabel *myAssetL;
@property(weak, nonatomic) IBOutlet UILabel *typeL;
@property(weak, nonatomic) IBOutlet UILabel *netWorkL;
@property(weak, nonatomic) IBOutlet UITableView *tableV;
@property(weak, nonatomic) IBOutlet UILabel *backLabel;
@property(weak, nonatomic) IBOutlet UIView *backView;
@property(weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property(nonatomic, strong) NSDictionary *walletDict;
@property(nonatomic, strong) NSArray *allWalletArray;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) BrowserView *browserView;
@property(nonatomic, copy) NSString *exchange;
@property(nonatomic, copy) NSString *GoalType;
@property(nonatomic, copy) NSString *changeMoney;
@property(nonatomic, strong) NSMutableArray *tokenArray;
@property(nonatomic, strong) NSMutableArray *tokenShowArray;

// ONT 数量
@property(nonatomic, copy) NSString *amount;

// Claimable ONG 数量，可以redeem
@property(nonatomic, copy) NSString *ongAppove;

// 未解绑ONG，Unbound ONG，服务端返回的名词是错误的，服务端的 Unbound ONG 实际上是 Claimable ONG
@property(nonatomic, copy) NSString *waitboundong;

//@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, copy) NSArray *walletArr;
@property(nonatomic, copy) NSArray *pumArr;
@property(weak, nonatomic) IBOutlet UIButton *qrBtn;
@property(weak, nonatomic) IBOutlet UIButton *addressBtn;
@property(weak, nonatomic) IBOutlet UILabel *gobakL;
@property(weak, nonatomic) IBOutlet UIView *topView;
@property(weak, nonatomic) IBOutlet UIButton *createWallBtn;
@property(weak, nonatomic) IBOutlet UIButton *importWalletBtn;
@property(weak, nonatomic) IBOutlet UIButton *createShareWalletBtn;
@property(weak, nonatomic) IBOutlet UIButton *leadShareWalletBtn;
@property(weak, nonatomic) IBOutlet UILabel *ruleLB;
@property(nonatomic, strong) walletManagerView *optionsView;
@property(nonatomic, strong) UIWindow *window;
@property(weak, nonatomic) IBOutlet UIButton *swapBtn;

@property(weak, nonatomic) IBOutlet UIView *swapView;
@property(nonatomic, copy) NSString *NET5;
@property(nonatomic, copy) NSString *totalpumpkin;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *swapViewBottom;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableVBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IconTop;
//@property (nonatomic,strong)MBProgressHUD * hud;
//ONT_CANDY

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tolenListTop;

@property(nonatomic,assign) BOOL isFirst;
@property(nonatomic,assign) BOOL isChange;

@property(nonatomic,strong)ONTOWakePayViewController       *loginVC;
@property(nonatomic,strong)ONTOWakePaySureViewController   *payVC;
@property(nonatomic,strong)ONTODAppWalletTipsAlertView     *alertView;
@property(nonatomic,strong)ONTODAppChangeWalletAlertView   *changeView;
@property(nonatomic,strong)SelectDefaultWallet             *selectDefaultWallet;
@property(nonatomic,strong)MBProgressHUD          *hub;
@property(nonatomic,strong)NSDictionary           *defaultWalletDic;
@property(nonatomic,strong)NSDictionary           *promptDic;
@property(nonatomic,copy)NSString                 *confirmPwd;
@property(nonatomic,copy)NSString                 *hashString;
@property(nonatomic,copy)NSString *callback;
@property (nonatomic,strong)NSDictionary * payDetailDic;
@property(nonatomic,copy)NSString                 *pwdString;
@property(nonatomic,strong)id                      responseOriginal;
@end

@implementation CapitalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isFirst = YES;
    self.isChange = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //获取通知中心单例对象
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(wakePayInfo:) name:WAKEPAY_NOTIFICATION object:nil];
    [self configUI];
    [self loadJS];
    
    [self p_initNotification];
    [self versionUpdate];
}

-(void)p_initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadJS) name:@"Refresh_Home" object:nil];
}

- (void)versionUpdate
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Version_update,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    [[CCRequest shareInstance] requestWithURLStringNoLoading:urlStr MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal) {
        
        if ([responseObject  isEqual:[NSNull null]]) {
            return;
        }
        
        if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue]>= [responseObject[@"versionCode"] integerValue]) {
            return ;
        }
        if ([responseObject[@"isForceUpdate"] integerValue] ==1) {
            NSString *string = [NSString stringWithFormat:Localized(@"Newversion"),responseObject[@"versionName"]];
            MGPopController *pop = [[MGPopController alloc] initWithTitle:string message:@"" image:[UIImage imageNamed:@"notice_light_gray"]];
            MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                NSString *urlText = [NSString stringWithFormat:@"%@",responseObject[@"downloadUrl"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
                
            }];
            
            action.autoDismiss = NO;
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
        }else{
            
            MGPopController *pop = [[MGPopController alloc] initWithTitle:[NSString stringWithFormat:Localized(@"Newversion1"),responseObject[@"versionName"]] message:@"" image:[UIImage imageNamed:@"notice_light_gray"]];
            MGPopAction *action1 =   [MGPopAction actionWithTitle:Localized(@"Cancel") action:^{
                
            }];
            
            action1.titleColor =[UIColor colorWithHexString:@"#6A797C"];
            [pop addAction:action1];
            
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                NSString *urlText = [NSString stringWithFormat:@"%@",responseObject[@"downloadUrl"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
            }];
            action.titleColor =  [UIColor redColor] ;
            
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            
        }
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
    }];
}

- (IBAction)swapClick:(id)sender
{
    
    [self pushtoSwap];
    
}

- (void)pushtoSwap
{
    NSArray *allArray = [[NSUserDefaults standardUserDefaults]
                         valueForKey:[NSString stringWithFormat:@"%@%@", [NSString stringWithFormat:@"%@", self
                                                                          .walletDict[@"address"]], ALLSWAP]];
    
    if (allArray.count == 0)
    {
        SwapTextViewController *vc = [[SwapTextViewController alloc] init];
        vc.NET5 = self.NET5;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
        
        SwapListViewController *vc = [[SwapListViewController alloc] init];
        vc.NET5 = self.NET5;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)copyClick:(id)sender {
    [Common showToast:Localized(@"WalletCopySuccess")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.addressL.text;
}

- (void)navRightAction {
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *shareArr = [NSMutableArray array];
    for (int i = 0; i < _walletArr.count; i++) {
        if ([_walletArr[i] isKindOfClass:[NSDictionary class]] && _walletArr[i][@"label"]) {
            
            [titleArr addObject:_walletArr[i][@"label"]];
        } else {
            [titleArr addObject:_walletArr[i][@"sharedWalletName"]];
            [shareArr addObject:[NSNumber numberWithInteger:i]];
        }
        if ([self.walletDict isEqual:_walletArr[i]]) {
            //当前钱包
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", i] forKey:SELECTWALLET];
        }
    }
    __weak typeof(self) weakSelf = self;
    _optionsView =
    [[walletManagerView alloc] initWithOptionsArr:titleArr shareArray:shareArr cancelTitle:Localized(@"Cancel")
                               defaultWalletBlock:^(NSIndexPath *indexPath) {
                                   [weakSelf changeWallet:indexPath];
                               } selectedBlock:^(NSIndexPath *index) {
                                   [weakSelf selectAction:index];
                               }];
    
    _window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [_window addSubview:_optionsView];
    [_window makeKeyAndVisible];
}

- (void)changeWallet:(NSIndexPath *)indexPath {
    self.isChange = YES;
    NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.walletDict = array[indexPath.row];
    NSString *jsonStr = [Common dictionaryToJson:self.walletDict];
    [Common setEncryptedContent:jsonStr WithKey:ASSET_ACCOUNT];
    
    if ([self.walletDict isKindOfClass:[NSDictionary class]] && self.walletDict[@"label"])
    {
        self.addressL.text = [NSString stringWithFormat:@"%@", self.walletDict[@"address"]];
        self.addressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.nameL.text = self.walletDict[@"label"];
        self.ruleLB.hidden = YES;
        self.swapBtn.hidden = NO;
        self.tokenManage.hidden = NO;
        
    } else {
        self.swapBtn.hidden = YES;
        self.addressL.text = [NSString stringWithFormat:@"%@", self.walletDict[@"sharedWalletAddress"]];
        self.addressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.nameL.text = self.walletDict[@"sharedWalletName"];
        self.ruleLB.hidden = NO;
        self.tokenManage.hidden = YES;
        self.ruleLB.text =
        [NSString stringWithFormat:Localized(@"shareRule"), [self.walletDict[@"requiredNumber"] integerValue], [self
                                                                                                                .walletDict[@"totalNumber"] integerValue]];
        
    }
    [self nonBackupHidden];
    [self loadJS];
}
- (void)selectAction:(NSIndexPath *)indexPath {
    
    self.isChange = YES;
    if (indexPath.row == 0) {
        CreateViewController *vc1 = [[CreateViewController alloc] init];
        vc1.isWallet = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    } else if (indexPath.row == 1) {
        ImportWalletVC *importWVC = [[ImportWalletVC alloc] init];
        [self.navigationController pushViewController:importWVC animated:YES];
    } else if (indexPath.row == 2) {
        
        NewWalletManagerViewController *managerVC1 = [[NewWalletManagerViewController alloc] init];
        [self.navigationController pushViewController:managerVC1 animated:YES];
        
    } else if (indexPath.row == 3) {
        CreateShareWalletViewController *createVC1 = [[CreateShareWalletViewController alloc] init];
        [self.navigationController pushViewController:createVC1 animated:YES];
    } else if (indexPath.row == 4) {
        JoinShareWalletViewController *joinVC1 = [[JoinShareWalletViewController alloc] init];
        [self.navigationController pushViewController:joinVC1 animated:YES];
    }
}

- (void)noCreateNotice {
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT] count] == 6) {
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Upwallets") message:nil image:nil];
        MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor = MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        
        return;
    }
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)configUI
{
    self.netWorkL.hidden = YES;
    _netWorkL.text = Localized(@"Netdisconnected");
    
    [self.view addSubview:self.browserView];
    [self setNavTitle:Localized(@"WalletTitle")];
    
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadJS];
    }];
    self.backLabel.text = Localized(@"ActivateitA");
    self.gobakL.text = Localized(@"Gotobackupwallet");
    [_createWallBtn setTitle:Localized(@"CreateWallet") forState:UIControlStateNormal];
    [_importWalletBtn setTitle:Localized(@"ImportWallet") forState:UIControlStateNormal];
    [_createShareWalletBtn setTitle:Localized(@"createShareWallet") forState:UIControlStateNormal];
    [_leadShareWalletBtn setTitle:Localized(@"leadShareWallet") forState:UIControlStateNormal];
    [_swapBtn setTitle:Localized(@"MainNetONT") forState:UIControlStateNormal];
    _NET5 = @"";
    
    if (LL_iPhone5S) {
        [_swapViewBottom setConstant:-10];
        [_IconTop setConstant:50];
        _addressL.font = [UIFont systemFontOfSize:11];
    }
    
}

- (void)getNetWork {
    
    _netWorkL.hidden = YES;
    
}

- (void)nonNetWork {
    
    _netWorkL.hidden = NO;
    
}

- (void)navLeftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)thirdClick:(id)sender {
    
    MGPopController *pop = [[MGPopController alloc]
                            initWithTitle:@"" message:Localized(@"Referenceonly") image:[UIImage imageNamed:@"notice_light_gray"]];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{
        
    }];
    action.titleColor = MainColor;
    
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
}

- (IBAction)addressClick:(id)sender {
    if ([Common getEncryptedContent:self.walletDict[@"address"]]) {
        
        [self presentNonBackUpAlart];
        
    } else {
        if ([self.walletDict isKindOfClass:[NSDictionary class]] && self.walletDict[@"label"]) {
            //普通钱包
            GetViewController *vc = [[GetViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            // 共享钱包
            ShareWalletDetailViewController *vc = [[ShareWalletDetailViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)presentNonBackUpAlart {
    
    MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"Backupmnemonic") message:nil image:nil];
    MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{
        WalletDetailViewController *vc = [[WalletDetailViewController alloc] init];
        vc.address = self.walletDict[@"address"];
        vc.identityDic = self.walletDict;
        vc.name = self.walletDict[@"label"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    action.titleColor = MainColor;
    [pop addAction:action];
    [pop show];
    pop.showCloseButton = NO;
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

-(void)loadDragon:(NSString*)address
{
    //    let str = "OntCryptoAddress('\(walletAddress!)')"
    NSString * jsStr = [NSString stringWithFormat:@"OntCryptoAddress('%@')",address];
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
}

- (void)loadJS
{
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    if (dict.count == 0) {
        return;
    }
    BOOL isShare = NO;
    NSString *urlStr;
    if ([dict isKindOfClass:[NSDictionary class]] && dict[@"label"]) {
        isShare = NO;
        urlStr = [NSString stringWithFormat:@"%@/%@", Get_Blance, dict[@"address"]];
    } else {
        isShare = YES;
        urlStr = [NSString stringWithFormat:@"%@/%@", Get_Blance, dict[@"sharedWalletAddress"]];
    }
    MBProgressHUD * hud;
    hud =[ToastUtil showMessage:@"" toView:nil];
    [hud hideAnimated:YES afterDelay:5];
    CCSuccess successCallback = ^(id responseObject, id responseOriginal) {
        [hud hideAnimated:YES];
        [self.tableV.mj_header endRefreshing];
        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            return;
        }
        
        //重构后
        //        ONTOWalletRootModel *model = [ONTOWalletRootModel organizeData:responseObject WithAddress:dict[@"address"]];
        //        NSLog(@"%@", model);
        //        self.tokenArray = model.tokenArray;
        //        self.tokenShowArray = model.tokenShowArray;
        //        defaultTokenArray = model.defaultTokenArray;
        //        self.waitboundong = model.waitboundong.stringValue;
        //amount如果没有就是0
        //        self.dataArray = [model createDataMarr];
        //        NSLog(@"%@", self.dataArray);
        
        NSLog(@"responseOriginal=%@",responseOriginal);
        self.responseOriginal = responseOriginal;
        [[NSUserDefaults standardUserDefaults] setObject:responseOriginal forKey:@"responseOriginal"];
        self.dataArray = [[NSMutableArray alloc] init];
        self.tokenArray =[NSMutableArray array ];
        [self.tokenArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:TOKENLIST]];
        NSArray * ceshiA = @[@{@"ShortName":@"totalpumpkin",@"Logo":@"pumkinRectangle 7",@"Type":@"OEP-8",@"ShortName_1":@"PUMPKIN"},
                             @{@"ShortName":@"HyperDragons",@"Logo":@"dragonRectangle_1",@"Type":@"OEP-5",@"ShortName_1":@"HyperDragons"}];
        [self.tokenArray addObjectsFromArray:ceshiA];
        self.tokenShowArray = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@%@",dict[@"address"],TOKENLISTSHOW]];
        NSArray * defaultTokenArray = [[NSUserDefaults standardUserDefaults]valueForKey:DEFAULTTOKENLIST];
        NSLog(@"---%@",defaultTokenArray);
        self.pumArr = [NSArray arrayWithArray:responseObject];
        for (NSDictionary *dic in (NSArray *) responseObject) {
            if ([dic[@"AssetName"] isEqualToString:@"ont"]) {
                [self.dataArray insertObject:@{@"type": @"ONT", @"amount": dic[@"Balance"]} atIndex:0];
                _amount = dic[@"Balance"];
                [[CommonOCAdapter share]saveOntCount:dic];
            }
            if ([dic[@"AssetName"] isEqualToString:@"ong"]) {
                [self.dataArray addObject:@{@"type": @"ONG", @"amount": dic[@"Balance"]}];
            }
            
            if ([dic[@"AssetName"] isEqualToString:@"waitboundong"]) {
                self.waitboundong = dic[@"Balance"];
            }
            
            if ([dic[@"AssetName"] isEqualToString:@"unboundong"]) {
                _ongAppove = dic[@"Balance"];
            }
            if ([dic[@"AssetName"] isEqualToString:@"totalpumpkin"]) {
                _totalpumpkin = dic[@"Balance"];
            }

        }
        if (isShare == NO) {
            if (defaultTokenArray.count > 0) {
                for (NSDictionary * defaultDic in defaultTokenArray) {
                    BOOL haveDefault = NO;
                    for (NSDictionary *dic in (NSArray *) responseObject) {
                        if ([dic[@"AssetName"] isEqualToString:defaultDic[@"ShortName"]]) {
                            haveDefault = YES;
                            [self.dataArray addObject:@{@"type": defaultDic[@"ShortName"], @"amount": dic[@"Balance"],@"picUrl":defaultDic[@"Logo"]}];
                        }
                    }
                    if (!haveDefault) {
                        [self.dataArray addObject:@{@"type": defaultDic[@"ShortName"], @"amount": @"0",@"picUrl":defaultDic[@"Logo"]}];
                    }
                }
            }
        }
        if (isShare == NO) {
            if (self.tokenArray.count > 0) {
                for (NSDictionary * tokenDic in self.tokenArray) {
                    for (NSDictionary * tokenShowDic in self.tokenShowArray) {
                        if ([tokenShowDic[@"AssetName"] isEqualToString:tokenDic[@"ShortName"]]) {
                            if ([tokenShowDic[@"isShow"] isEqualToString:@"0"]) {
                                BOOL isHave = NO;
                                for (NSDictionary *dic in (NSArray *) responseObject) {
                                    
                                    if (tokenDic[@"ShortName_1"]) {
                                        if ([dic[@"AssetName"] isEqualToString:tokenDic[@"ShortName"]]) {
                                            isHave = YES;
                                            if ([dic[@"AssetName"] isEqualToString:@"totalpumpkin"]) {
                                                [self.dataArray insertObject:@{@"type": tokenDic[@"ShortName"], @"amount": dic[@"Balance"],@"picUrl":tokenDic[@"Logo"]} atIndex:2+defaultTokenArray.count];
                                            }else if ([dic[@"AssetName"] isEqualToString:@"HyperDragons"]){
                                                BOOL ishavePumkin = NO;
                                                for (NSDictionary*typeDic in self.dataArray) {
                                                    if ([typeDic[@"type"] isEqualToString:@"totalpumpkin"]) {
                                                        ishavePumkin = YES;
                                                    }
                                                }
                                                if (ishavePumkin) {
                                                    [self.dataArray insertObject:@{@"type": tokenDic[@"ShortName"], @"amount": dic[@"Balance"],@"picUrl":tokenDic[@"Logo"]} atIndex:3+defaultTokenArray.count];
                                                }else{
                                                    [self.dataArray insertObject:@{@"type": tokenDic[@"ShortName"], @"amount": dic[@"Balance"],@"picUrl":tokenDic[@"Logo"]} atIndex:2+defaultTokenArray.count];
                                                }
                                                
                                            }else{
                                                
                                                [self.dataArray addObject:@{@"type": tokenDic[@"ShortName"], @"amount": dic[@"Balance"],@"picUrl":tokenDic[@"Logo"]}];
                                            }
                                            
                                            
                                        }
                                    }else{
                                        if ([dic[@"AssetName"] isEqualToString:tokenDic[@"ShortName"]]) {
                                            isHave = YES;
                                            if ([dic[@"AssetName"] isEqualToString:@"totalpumpkin"]) {
                                                [self.dataArray insertObject:@{@"type": tokenDic[@"ShortName"], @"amount": dic[@"Balance"],@"picUrl":tokenDic[@"Logo"]} atIndex:2+defaultTokenArray.count];
                                            }else if ([dic[@"AssetName"] isEqualToString:@"HyperDragons"]){
                                                BOOL ishavePumkin = NO;
                                                for (NSDictionary*typeDic in self.dataArray) {
                                                    if ([typeDic[@"type"] isEqualToString:@"totalpumpkin"]) {
                                                        ishavePumkin = YES;
                                                    }
                                                }
                                                if (ishavePumkin) {
                                                    [self.dataArray insertObject:@{@"type": tokenDic[@"ShortName"], @"amount": dic[@"Balance"],@"picUrl":tokenDic[@"Logo"]} atIndex:3+defaultTokenArray.count];
                                                }else{
                                                    [self.dataArray insertObject:@{@"type": tokenDic[@"ShortName"], @"amount": dic[@"Balance"],@"picUrl":tokenDic[@"Logo"]} atIndex:2+defaultTokenArray.count];
                                                }
                                            }else{
                                                
                                                [self.dataArray addObject:@{@"type": tokenDic[@"ShortName"], @"amount": dic[@"Balance"],@"picUrl":tokenDic[@"Logo"]}];
                                            }
                                            
                                            
                                        }
                                    }
                                }
                                if (!isHave) {
                                    if ([tokenDic[@"ShortName"] isEqualToString:@"totalpumpkin"]) {
                                        [self.dataArray insertObject:@{@"type": tokenDic[@"ShortName"], @"amount": @"0",@"picUrl":tokenDic[@"Logo"]} atIndex:2+defaultTokenArray.count];
                                    }else if ([tokenDic[@"ShortName"] isEqualToString:@"HyperDragons"]){
                                        BOOL ishavePumkin = NO;
                                        for (NSDictionary*typeDic in self.dataArray) {
                                            if ([typeDic[@"type"] isEqualToString:@"totalpumpkin"]) {
                                                ishavePumkin = YES;
                                            }
                                        }
                                        if (ishavePumkin) {
                                            [self.dataArray insertObject:@{@"type": tokenDic[@"ShortName"], @"amount": @"0",@"picUrl":tokenDic[@"Logo"]} atIndex:3+defaultTokenArray.count];
                                        }else{
                                            [self.dataArray insertObject:@{@"type": tokenDic[@"ShortName"], @"amount": @"0",@"picUrl":tokenDic[@"Logo"]} atIndex:2+defaultTokenArray.count];
                                        }
                                        
                                    }else{
                                        
                                        [self.dataArray addObject:@{@"type": tokenDic[@"ShortName"], @"amount": @"0",@"picUrl":tokenDic[@"Logo"]}];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if ([self.walletDict isKindOfClass:[NSDictionary class]] && self.walletDict[@"label"])
        {
            self.addressL.text = [NSString stringWithFormat:@"%@", self.walletDict[@"address"]];
            self.addressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
            self.nameL.text = self.walletDict[@"label"];
            self.ruleLB.hidden = YES;
        }
        else
        {
            self.tokenManage.hidden = YES;
            self.addressL.text = [NSString stringWithFormat:@"%@", self.walletDict[@"sharedWalletAddress"]];
            self.addressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
            self.nameL.text = self.walletDict[@"sharedWalletName"];
            self.ruleLB.hidden = NO;
            self.ruleLB.text = [NSString stringWithFormat:Localized(@"shareRule"),
                                [self.walletDict[@"requiredNumber"] integerValue],
                                [self.walletDict[@"totalNumber"] integerValue]];
            if (self.dataArray.count == 4)
            {
                [self.dataArray removeObjectAtIndex:3];
            }
        }
        
        [self.tableV reloadData];
        [self getUnit];
    };

    CCFailure failureCallback = ^(NSError *error, NSString *errorDesc, id responseOriginal) {
        [hud hideAnimated:YES];
        [self.tableV.mj_header endRefreshing];
        [Common showToast:Localized(@"NetworkAnomaly")];
        if (self.isChange) {
            self.isChange = NO;
            [self.dataArray removeAllObjects];
        }
        self.responseOriginal = responseOriginal;
        [self.tableV reloadData];
    };
    
    //TODO: requestWithURLString1 这个命名搞清楚有啥不同后要改
    [[CCRequest shareInstance] requestWithURLString1:urlStr
                                          MethodType:MethodTypeGET
                                              Params:nil
                                             Success:successCallback
                                             Failure:failureCallback];
    
    NSString *getNeoBalancejsStr =
    [NSString stringWithFormat:@"Ont.SDK.getNeoBalance('%@', 'getNeoBalance')", dict[@"address"]];
    
    //节点方法 每次调用JSSDK前都必须调用
    LOADJS1;
    LOADJS2;
    LOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:getNeoBalancejsStr completionHandler:nil];
}

- (IBAction)tokenManageAction:(id)sender {
    // manage
    self.isFirst = YES;
    TokenManageViewController * vc = [[TokenManageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_window makeKeyAndVisible];
    self.tokenList.text = Localized(@"TOKENLIST");
    [self.tokenManage setTitle:Localized(@"tokenMANAGE") forState:UIControlStateNormal];
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    if (jsonStr)
    {
        self.walletDict =
        [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        if ([self.walletDict isKindOfClass:[NSDictionary class]] && self.walletDict[@"label"])
        {
            self.addressL.text = [NSString stringWithFormat:@"%@", self.walletDict[@"address"]];
            self.addressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
            self.nameL.text = self.walletDict[@"label"];
            self.ruleLB.hidden = YES;
            self.swapBtn.hidden = YES;
            self.tokenManage.hidden = NO;
        }
        else
        {
            self.swapBtn.hidden = YES;
            self.addressL.text = [NSString stringWithFormat:@"%@", self.walletDict[@"sharedWalletAddress"]];
            self.addressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
            self.nameL.text = self.walletDict[@"sharedWalletName"];
            self.ruleLB.hidden = NO;
            self.tokenManage.hidden = YES;
            self.ruleLB.text =
            [NSString stringWithFormat:Localized(@"shareRule"), [self.walletDict[@"requiredNumber"] integerValue], [self
                                                                                                                    .walletDict[@"totalNumber"] integerValue]];
        }
        
        _topView.hidden = YES;
        //      _topView.hidden = NO;
        [self setNavRightImageIcon:[UIImage imageNamed:@"darkright"] Title:nil];
        
    }
    else
    {
        _topView.hidden = NO;
        
    }
    
    //    if (self.isFirst) {
    //        self.isFirst = NO;
//    [self loadJS];
    //    }
    
    
    //  _timer = [NSTimer scheduledTimerWithTimeInterval:TimerInterval
    //                                            target:self
    //                                          selector:@selector(queryDataInTimer)
    //                                          userInfo:nil
    //                                           repeats:YES];
    [self configNetLabel];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //  self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#000000"],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:21 weight:UIFontWeightBold],
                                                                      NSKernAttributeName: @2
                                                                      }];
    
    _walletArr = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    
    [self nonBackupHidden];
    
    //底部隐藏遮盖一部分
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)nonBackupHidden {
    
    //没有备份过记词
    if ([Common getEncryptedContent:self.walletDict[@"address"]]) {
        
        self.tableV.hidden = YES;
        self.qrBtn.hidden = YES;
        self.addressL.hidden = YES;
        self.addressBtn.hidden = YES;
        self.thirdBtn.hidden = YES;
        self.backView.hidden = NO;
        self.backLabel.hidden = NO;
        self.swapView.hidden = YES;
        self.typeL.hidden = YES;
        self.tokenList.hidden = YES;
//        self.tokenManage.hidden = YES;
        [_tolenListTop setConstant:  0];
    } else {
        
        self.tableV.hidden = NO;
        self.qrBtn.hidden = NO;
        self.addressL.hidden = NO;
        self.addressBtn.hidden = NO;
        self.thirdBtn.hidden = NO;
        self.backView.hidden = YES;
        self.backLabel.hidden = YES;
        self.swapView.hidden = NO;
        self.typeL.hidden = NO;
        self.tokenList.hidden = NO;
//        self.tokenManage.hidden = NO;
        [_tolenListTop setConstant:30];
    }
}

- (IBAction)backClick:(id)sender {
    
    WalletBackupVC *vc = [[WalletBackupVC alloc] init];
    vc.remenberWord = [Common getEncryptedContent:self.walletDict[@"address"]];
    vc.address = self.walletDict[@"address"];
    vc.passwordHash = self.walletDict[@"passwordHash"];
    vc.key = self.walletDict[@"key"];
    vc.salt = self.walletDict[@"salt"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //销毁定时器
    //  [_timer invalidate];
    //  _timer = nil;
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)configNetLabel {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (appDelegate.isNetWorkConnect == NO) {
        [self nonNetWork];
    } else {
        [self getNetWork];
    }
}

- (void)queryDataInTimer {
    [self loadJS];
}

- (void)getUnit {
    
    NSString *unit;
    if (![Common getUNIT]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"USD" forKey:UNIT];
    } else {
        unit = [Common getUNIT];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseURL, Get_UNIT];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    typedef void(^TaskCompletionHandler)(NSData *_Nullable, NSURLResponse *_Nullable, NSError *_Nullable);
    TaskCompletionHandler taskCompletionHandler = ^(NSData *_Nullable data, NSURLResponse *_Nullable response,
                                                    NSError *_Nullable error) {
        if (error == nil) {
            
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict =
            [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if ([[dict objectForKey:@"Error"] integerValue] > 0) {
                return;
            }
            
            NSString
            *money = [[dict objectForKey:@"Result"] valueForKey:@"Money"];
            NSString *goalType =
            [[dict objectForKey:@"Result"] valueForKey:@"GoalType"];
            
            _exchange = money;
            _GoalType = goalType;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSString *numStr = [Common getMoney:self.amount Exchange:money];
                NSString *prefix = [goalType isEqualToString:@"CNY"] ? @"¥" : @"$";
                NSString *formatStr = [Common countNumAndChangeformat:numStr];
                self.changeMoney =
                [NSString stringWithFormat:@"%@ %@", prefix, formatStr];
                self.typeL.text = Localized(@"newAddress");
                [self.tableV reloadData];
                
            }];
        }
    };
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:taskCompletionHandler];
    //5.执行任务
    [dataTask resume];
}

- (IBAction)createWallet:(id)sender {
    CreateViewController *vc = [[CreateViewController alloc] init];
    vc.isWallet = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)importAction:(id)sender {
    ImportWalletVC *vc = [[ImportWalletVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)createShareWalletAction:(id)sender {
    CreateShareWalletViewController *vc = [[CreateShareWalletViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)leadShareWalletAction:(id)sender {
    JoinShareWalletViewController *vc = [[JoinShareWalletViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"cellid";
    AssetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = (AssetCell *) [[[NSBundle mainBundle] loadNibNamed:@"AssetCell" owner:self options:nil] lastObject];
    }
    
    [cell fillData:[self.dataArray[indexPath.section] valueForKey:@"type"]
            amount:[self.dataArray[indexPath.section] valueForKey:@"amount"]
              type:self.myAssetL.text
        tokenArray:self.tokenArray];
    
    NSDictionary * dic = self.dataArray[indexPath.section];
    if (indexPath.section == 0){
        cell.imageV.image = [UIImage imageNamed:@"newOnt"];
        cell.typeL.text = self.changeMoney;
    }else if (indexPath.section == 1) {
        cell.imageV.image = [UIImage imageNamed:@"newOng"];
        cell.typeL.hidden = YES;
    }else{
        //
        //        "ShortName_1":@"PUMPKIN"},
        //    @{@"ShortName":@"dragon",@"Logo":@"dragonRectangle_1",@"Type":@"OEP-5",@"ShortName_1":@"HyperDragons"}];
        if ([dic[@"type"] isEqualToString:@"totalpumpkin"])
        {
            cell.imageV.image = [UIImage imageNamed:@"pumkinRectangle 7"];
        }
        else if ([dic[@"type"] isEqualToString:@"HyperDragons"])
        {
            cell.imageV.image = [UIImage imageNamed:@"dragonRectangle_1"];
        }
        else if ([dic[@"type"] isEqualToString:@"PAX"])
        {
            cell.imageV.image = [UIImage imageNamed:@"DApp_Pax"];
        }
        else
        {
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"picUrl"]]];
        }
    }
    
    cell.layer.cornerRadius = 4;
    cell.layer.masksToBounds = YES;
    cell.contentBorderColor = [UIColor lightGrayColor];
    //  cell.contentBackgroundColor = [UIColor colorWithHexString:@"#F6F8F9"];
    cell.contentBorderWidth = 0;
    cell.contentMargin = 8;
    cell.contentCornerRadius = CGSizeMake(10, 10);
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    return view;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SYSWidth-40, 1)];
    view.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.isFirst = YES;
    if ([Common getEncryptedContent:self.walletDict[@"address"]]) {
        
        [self presentNonBackUpAlart];
        
    } else {
        
        NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
        NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
        
        if ([dict isKindOfClass:[NSDictionary class]] && dict[@"label"]) {
            
            // 普通钱包
            if (indexPath.section == 0) {
                
                //点击跳转7004资产详情
                CapitalDetailViewController *vc = [[CapitalDetailViewController alloc] init];
                vc.type = @"ONT";
                vc.amount = [self.dataArray[indexPath.section] valueForKey:@"amount"];
                vc.exchange = _exchange;
                vc.GoalType = _GoalType;
                vc.walletDict = self.walletDict;
                vc.ongAppove = self.ongAppove;
                if (self.dataArray.count > 0) {
                    vc.ongAmount = [Common getPrecision9Str:[self.dataArray[1] valueForKey:@"amount"]];
                }
                [self.navigationController pushViewController:vc animated:YES];
                
            } else if (indexPath.section == 1) {
                
                CapitalDetailViewController *vc = [[CapitalDetailViewController alloc] init];
                vc.type = @"ONG";
                vc.amount = [Common getPrecision9Str:[self.dataArray[indexPath.section] valueForKey:@"amount"]];
                vc.exchange = _exchange;
                vc.GoalType = _GoalType;
                vc.walletDict = self.walletDict;
                vc.waitboundong = self.waitboundong;
                vc.ongAppove = self.ongAppove;
                
                vc.ontAmount = [self.dataArray[0] valueForKey:@"amount"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                NSDictionary * dic = self.dataArray[indexPath.section];
                if ([dic[@"type"] isEqualToString:@"HyperDragons"]) {
                    DragonListViewController *vc = [[DragonListViewController alloc]init];
                    vc.walletAddress = self.walletDict[@"address"];
                    vc.walletDic = self.walletDict;
                    if (self.dataArray.count > 0) {
                        vc.ongAmount = [Common getPrecision9Str:[self.dataArray[1] valueForKey:@"amount"]];
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([dic[@"type"] isEqualToString:@"totalpumpkin"]) {
                    PumpkinNumViewController * vc = [[PumpkinNumViewController alloc]init];
                    vc.pumArr = self.pumArr;
                    vc.walletAddress =  self.walletDict[@"address"];
                    vc.walletDic = self.walletDict;
                    if (self.dataArray.count > 0) {
                        vc.ongAmount = [Common getPrecision9Str:[self.dataArray[1] valueForKey:@"amount"]];
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    
                    OEP4ViewController *vc = [[OEP4ViewController alloc] init];
                    vc.amount = [self.dataArray[indexPath.section] valueForKey:@"amount"];
                    vc.exchange = _exchange;
                    vc.GoalType = _GoalType;
                    vc.walletDict = self.walletDict;
                    vc.waitboundong = self.waitboundong;
                    vc.ongAppove = self.ongAppove;
                    if (self.dataArray.count > 0) {
                        vc.ongAmount = [Common getPrecision9Str:[self.dataArray[1] valueForKey:@"amount"]];
                    }
                    vc.ontAmount = [self.dataArray[0] valueForKey:@"amount"];
                    NSArray * defaultTokenArray = [[NSUserDefaults standardUserDefaults]valueForKey:DEFAULTTOKENLIST];
                    BOOL isDefault = NO;
                    if (defaultTokenArray.count > 0) {
                        for (NSDictionary *defaultDic in defaultTokenArray) {
                            if ([dic[@"type"] isEqualToString:defaultDic[@"ShortName"]]) {
                                isDefault = YES;
                                vc.tokenDict = defaultDic;
                            }
                        }
                    }
                    if (!isDefault) {
                        if (self.tokenArray.count > 0) {
                            for (NSDictionary * subdic in self.tokenArray) {
                                if ([dic[@"type"] isEqualToString:subdic[@"ShortName"]]) {
                                    vc.tokenDict = subdic;
                                }
                            }
                        }
                        
                    }
                    
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            
        } else {
            
            if (indexPath.section == 2) {
                [self pushtoSwap];
                return;
            }
            
            // 共享钱包
            ShareWalletTransferAccountsViewController *vc = [[ShareWalletTransferAccountsViewController alloc] init];
            USERMODEL.isShareWallet = YES;
            if (indexPath.section == 0) {
                vc.isONT = YES;
                vc.amount = [self.dataArray[indexPath.section] valueForKey:@"amount"];
            } else {
                vc.isONT = NO;
                vc.waitboundong = self.waitboundong;
                vc.amount = [Common getPrecision9Str:[self.dataArray[indexPath.section] valueForKey:@"amount"]];
                vc.ongAppove = self.ongAppove;
            }
            vc.GoalType = _GoalType;
            vc.exchange = _exchange;
            vc.ongAmount = [Common getPrecision9Str:[self.dataArray[1] valueForKey:@"amount"]];
            vc.address = dict[@"sharedWalletAddress"];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)wakePayInfo:(NSNotification*)info{
    NSDictionary *payInfo = info.userInfo;
    NSLog(@"dic=%@",payInfo);
    if (![self haveWallet]) {
        // 返回错误信息
        return;
    }
    NSDictionary * walletDic= [self getDefaultWallet];
    
    self.promptDic = payInfo;
    
    self.loginVC = nil;
    self.loginVC.infoDic = payInfo;
    [self showActionVc:self.loginVC];
    __weak typeof(self) weakSelf = self;
    [_loginVC setPwdBlock:^(NSString * _Nonnull pwdString) {
        weakSelf.confirmPwd = pwdString;
        [weakSelf loginWithWalletDic:walletDic pwdString:pwdString];
    }];
    
}
-(void)loginWithWalletDic:(NSDictionary*)walletDic pwdString:(NSString*) pwdString {
    if (pwdString.length < 8) {
        [Common showToast:Localized(@"SelectAlertPassWord")];
        return ;
    }
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",walletDic[@"key"],[Common transferredMeaning:pwdString],walletDic[@"address"],walletDic[@"salt"]];
    
    if (pwdString.length==0) {
        return;
    }
    _hub=[ToastUtil showMessage:@"" toView:nil];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)haveWallet {
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    if (jsonStr){
        NSDictionary *walletDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        if ([walletDict isKindOfClass:[NSDictionary class]] && walletDict[@"label"]){
            
            return YES;
        }else {
            // 检查本地是否有普通钱包
            NSArray * walletArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
            BOOL isHave = NO;
            for (NSDictionary *dic in walletArray) {
                if ([dic isKindOfClass:[NSDictionary class]] && dic[@"label"]){
                    isHave = YES;
                }
            }
            if (!isHave) {
                [self toCreateWallet];
            }else {
                [self toChangeWallet];
            }
            return NO;
        }
    }else {
        [self toCreateWallet];
        return NO;
    }
    return YES;
}
-(void)toCreateWallet {
    [_alertView removeFromSuperview];
    _alertView = [ONTODAppWalletTipsAlertView CreatWalletTipsAlertView];
    _alertView.isDapp = NO;
    _alertView.delegate = self;
}

-(void)toChangeWallet {
    
    _changeView = [ONTODAppChangeWalletAlertView CreatWalletTipsAlertView];
    _changeView.isDapp = NO;
    _changeView.delegate = self;
}
/** 创建钱包点击 */
-(void)walletTipsAlertCreateBtnSlot:(ONTODAppWalletTipsAlertView*)alertView{
    CreateViewController *vc = [[CreateViewController alloc] init];
    vc.isWallet = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/** 导入钱包点击 */
-(void)walletTipsAlertInputBtnSlot:(ONTODAppWalletTipsAlertView*)alertView{
    ImportWalletVC *importWVC = [[ImportWalletVC alloc] init];
    [self.navigationController pushViewController:importWVC animated:YES];
}
/** 切换钱包点击 */
-(void)walletTipsAlertChangeBtnSlot:(ONTODAppChangeWalletAlertView*)alertView{
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *shareArr = [NSMutableArray array];
    _walletArr = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    for (int i = 0; i < _walletArr.count; i++) {
        if ([_walletArr[i] isKindOfClass:[NSDictionary class]] && _walletArr[i][@"label"]) {
            
            [titleArr addObject:_walletArr[i][@"label"]];
        } else {
            [titleArr addObject:_walletArr[i][@"sharedWalletName"]];
            [shareArr addObject:[NSNumber numberWithInteger:i]];
        }
        [self getDefaultWallet];
        if ([self.defaultWalletDic isEqual:_walletArr[i]]) {
            //当前钱包
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", i] forKey:SELECTWALLET];
        }
    }
    __weak typeof(self) weakSelf = self;
    _selectDefaultWallet =
    [[SelectDefaultWallet alloc] initWithOptionsArr:titleArr shareArray:shareArr cancelTitle:Localized(@"Cancel") actionBlock:^{
        [weakSelf loadJS];
        weakSelf.walletDict = [weakSelf getDefaultWallet];
        if ([weakSelf.walletDict isKindOfClass:[NSDictionary class]] && weakSelf.walletDict[@"label"])
        {
            weakSelf.addressL.text = [NSString stringWithFormat:@"%@", weakSelf.walletDict[@"address"]];
            weakSelf.addressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
            weakSelf.nameL.text = weakSelf.walletDict[@"label"];
            weakSelf.ruleLB.hidden = YES;
            weakSelf.swapBtn.hidden = NO;
            weakSelf.tokenManage.hidden = NO;
            
        } else {
            weakSelf.swapBtn.hidden = YES;
            weakSelf.addressL.text = [NSString stringWithFormat:@"%@", weakSelf.walletDict[@"sharedWalletAddress"]];
            weakSelf.addressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
            weakSelf.nameL.text = weakSelf.walletDict[@"sharedWalletName"];
            weakSelf.ruleLB.hidden = NO;
            weakSelf.tokenManage.hidden = YES;
            weakSelf.ruleLB.text =
            [NSString stringWithFormat:Localized(@"shareRule"), [weakSelf.walletDict[@"requiredNumber"] integerValue], [weakSelf
                                                                                                                    .walletDict[@"totalNumber"] integerValue]];
            
        }
        [weakSelf nonBackupHidden];
    }];
    
    _window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [_window addSubview:_selectDefaultWallet];
    [_window makeKeyAndVisible];
}
- (NSDictionary *)getDefaultWallet {
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *walletDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.defaultWalletDic = walletDict;
    return walletDict;
}
-(void)showActionVc:(id)actionVc {
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdelegate.window.rootViewController.definesPresentationContext = YES;
    [appdelegate.window.rootViewController presentViewController:actionVc animated:YES completion:^{
    }];
}
- (ONTOWakePayViewController*)loginVC {
    if (!_loginVC) {
        _loginVC = [[ONTOWakePayViewController alloc]init];
        _loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return _loginVC;
}
- (ONTOWakePaySureViewController*)payVC {
    if (!_payVC) {
        _payVC = [[ONTOWakePaySureViewController alloc]init];
        _payVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return _payVC;
}


- (void)handlePrompt:(NSString *)prompt {
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = [promptArray[1] dataUsingEncoding:NSUTF8StringEncoding];
    
    id obj = [NSJSONSerialization JSONObjectWithData:resultStr options:0 error:nil];
    
    
    if ([prompt hasPrefix:@"getNeoBalance"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            return;
        }
        NSArray *array = [prompt componentsSeparatedByString:@"params="];
        NSDictionary *dict = [Common dictionaryWithJsonString:array[1]];
        
        if ([Common dx_isNullOrNilWithObject:dict]) {
            return;
        }
        
        if ([self.walletDict isKindOfClass:[NSDictionary class]] && self.walletDict[@"label"]) {
            _NET5 = [dict[@"result"] stringValue];
            //TODO: 当数据为三条时，这里假定了服务端返回的格式
            if (self.dataArray.count == 3) {
                //        [self.dataArray replaceObjectAtIndex:2 withObject:@{@"type": ONTNEP5,
                //            @"amount": [dict[@"result"] stringValue]}];
            }
        }
        [self.tableV reloadData];
    }else if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]){
        [self decryptEncryptedPrivateKey:obj];
    }else if ([prompt hasPrefix:@"newsignDataStrHex"]){
        [self newsignDataStrHex:obj];
    }else if ([prompt hasPrefix:@"makeDappTransaction"]){
        
        [self makeDappTransaction:obj];
    }else if ([prompt hasPrefix:@"checkTrade"]){
        
        [self checkTrade:obj];
    }else if ([prompt hasPrefix:@"sendTransaction"]){
        
        [self toSendTransaction:obj];
        
    }
    
}

-(void)toSendTransaction:(NSDictionary *)obj{
    
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        [_hub hideAnimated:YES];
        if ([obj[@"error"] integerValue] == 47001) {
            [Common showErrorMsg:Localized(@"payNot")];
        }else{
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),obj[@"error"]];
            [Common showErrorMsg:errorStr];
        }
        return;
        
    }
    
    if (obj[@"result"]) {
        if ([obj[@"result"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary * result = obj[@"result"];
            if (result[@"Error"]) {
                
                if ([[result valueForKey:@"Error"] integerValue] > 0) {
                    [_hub hideAnimated:YES];
                    if ([result[@"Error"] integerValue] == 47001) {
                        [Common showErrorMsg:Localized(@"payNot")];
                    }else{
                        NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),result[@"Error"]];
                        [Common showErrorMsg:errorStr];
                    }
                    return;
                }
            }
        }
    }
    [self.payVC dismissViewControllerAnimated:YES completion:nil];
    [_hub hideAnimated:YES];
    NSDictionary * result = obj[@"result"];
    
    NSString * idStr = @"";
    if (self.promptDic[@"id"]) {
        idStr = self.promptDic[@"id"];
    }
    NSString * versionStr = @"";
    if (self.promptDic[@"version"]) {
        versionStr = self.promptDic[@"version"];
    }
    
    NSDictionary *nParams ;
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
        nParams = @{@"action":@"invoke",
                    @"version": @"v1.0.0",
                    @"error": @0,
                    @"desc": @"SUCCESS",
                    @"result":result[@"Result"],
                    @"id":idStr,
                    @"version":versionStr
                    };
    }else{
        NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),obj[@"error"]];
        [Common showErrorMsg:errorStr];
        nParams = @{@"action":@"invoke",
                    @"version": @"v1.0.0",
                    @"error": @8001,
                    @"desc": @"SUCCESS",
                    @"result":result[@"Result"],
                    @"id":idStr,
                    @"version":versionStr
                    };
    }
    NSDictionary *params = self.promptDic[@"params"];
    [[CCRequest shareInstance] requestWithURLString:params[@"callback"] MethodType:MethodTypePOST Params:nParams Success:^(id responseObject, id responseOriginal) {
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        
    }];
    
}
-(void)decryptEncryptedPrivateKey:(NSDictionary *)obj{
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        [_hub hideAnimated:YES];
        self.confirmPwd = @"";
        [Common showErrorMsg:Localized(@"PASSWORDERROR")];
        
    }else{
        if (obj[@"result"]) {
            if ([obj[@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * result = obj[@"result"];
                if (result[@"Error"]) {
                    
                    if ([[result valueForKey:@"Error"] integerValue] > 0) {
                        [_hub hideAnimated:YES];
                        if ([result[@"Error"] integerValue] == 47001) {
                            [Common showErrorMsg:Localized(@"payNot")];
                        }else{
                            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),result[@"Error"]];
                            [Common showErrorMsg:errorStr];
                        }
                        return;
                    }
                }
            }
        }
        if (self.promptDic[@"action"]) {
            if ([self.promptDic[@"action"] isEqualToString:@"login"]) {
                
                [self actionLogin];
                
            }else if ([self.promptDic[@"action"] isEqualToString:@"invoke"]){
                NSDictionary *params = self.promptDic[@"params"];
                if (params[@"qrcodeUrl"]) {
                    self.pwdString = obj[@"result"];
                    [self getInvokeMessage:params[@"qrcodeUrl"]];
                }else{
                    
                    [self actionInvoke: obj];
                }
                
            }
        }
    }
}
// checkTrade
- (void)checkTrade:(NSDictionary*)obj{
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        [_hub hideAnimated:YES];
        if ([obj[@"error"] integerValue] == 47001) {
            [Common showErrorMsg:Localized(@"payNot")];
        }else{
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),obj[@"error"]];
            [Common showErrorMsg:errorStr];
        }
        
    }else{
        [_hub hideAnimated:YES];
        if ([obj isKindOfClass:[NSDictionary class]] && obj[@"result"]) {
            if ([Common isBlankString:obj[@"result"]]) {
                [Common showErrorMsg:Localized(@"Systemerror")];
            }else{
                if (obj[@"result"]) {
                    if ([obj[@"result"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary * result = obj[@"result"];
                        if (result[@"Error"]) {
                            
                            if ([[result valueForKey:@"Error"] integerValue] > 0) {
                                [_hub hideAnimated:YES];
                                if ([result[@"Error"] integerValue] == 47001) {
                                    [Common showErrorMsg:Localized(@"payNot")];
                                }else{
                                    NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),result[@"Error"]];
                                    [Common showErrorMsg:errorStr];
                                }
                                return;
                            }
                        }
                    }
                }
                [self.loginVC dismissViewControllerAnimated:NO completion:^{
                    
                        // TODO 支付确认
                        self.payVC = nil;
                        self.payVC.infoDic = obj;
                        self.payVC.responseOriginal = self.responseOriginal;
                        [self showActionVc:self.payVC];
                    
                        __weak typeof(self) weakSelf = self;
                        [self.payVC setSureBlock:^{
                            // TODO 上链
                            [weakSelf sendTransaction];
                        }];
                    
                    
                }];
            
                
            }
        }
        
        
    }
}
// newsignDataStrHex
- (void)newsignDataStrHex:(NSDictionary*)obj{
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        [_hub hideAnimated:YES];
//        [self errorSend:obj];
        NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),obj[@"error"]];
        [Common showErrorMsg:errorStr];
    }else{
        
        [_hub hideAnimated:YES];
        if (obj[@"result"]) {
            if ([obj[@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * result = obj[@"result"];
                if (result[@"Error"]) {
                    
                    if ([[result valueForKey:@"Error"] integerValue] > 0) {
                        [_hub hideAnimated:YES];
                        if ([result[@"Error"] integerValue] == 47001) {
                            [Common showErrorMsg:Localized(@"payNot")];
                        }else{
                            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),result[@"Error"]];
                            [Common showErrorMsg:errorStr];
                        }
                        return;
                    }
                }
            }
        }
        [_loginVC dismissViewControllerAnimated:YES completion:nil];
        NSDictionary *params = self.promptDic[@"params"];
        NSString * idStr = @"";
        if (self.promptDic[@"id"]) {
            idStr = self.promptDic[@"id"];
        }
        NSString * versionStr = @"";
        if (self.promptDic[@"version"]) {
            versionStr = self.promptDic[@"version"];
        }
        NSDictionary *result =@{@"type": @"account",
                                @"publickey":self.defaultWalletDic[@"publicKey"],
                                @"user": self.defaultWalletDic[@"address"],
                                @"message":params[@"message"] ,
                                @"signature":obj[@"result"],
                                };
        NSDictionary *nParams = @{@"action":@"login",
                                  @"version": @"v1.0.0",
                                  @"error": @0,
                                  @"desc": @"SUCCESS",
                                  @"result":result,
                                  @"id":idStr,
                                  @"version":versionStr
                                  };
        
        [[CCRequest shareInstance] requestWithURLString:params[@"callback"] MethodType:MethodTypePOST Params:nParams Success:^(id responseObject, id responseOriginal) {
            
        } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
            
        }];
    }
}

// sendTransaction
- (void)sendTransaction{
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.sendTransaction('%@','sendTransaction')",self.hashString];
    LOADJS1;
    LOADJS2;
    LOADJS3;
    __weak typeof(self) weakSelf = self;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    [self.browserView setCallbackPrompt:^(NSString * prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}

// action login
- (void)actionLogin{
    // Sign the message
    NSDictionary *params = self.promptDic[@"params"];
    NSString *signStr =[Common hexStringFromString:params[@"message"]];
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.signDataHex('%@','%@','%@','%@','%@','newsignDataStrHex')",signStr,self.defaultWalletDic[@"key"],[Common base64EncodeString:_confirmPwd],self.defaultWalletDic[@"address"],self.defaultWalletDic[@"salt"]];
    
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}

// avtion invoke
- (void)actionInvoke:(NSDictionary*)obj{
    NSDictionary * tradeDic = [self checkPayer:self.payDetailDic];
    if (tradeDic == nil) {
//        [self emptyInfo:@"no wallet" resultDic:self.promptDic];
        return;
    }
    NSString *str = [self convertToJsonData:tradeDic];
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.makeDappTransaction('%@','%@','makeDappTransaction')",str,self.pwdString];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}

// makeDappTransaction
- (void)makeDappTransaction:(NSDictionary*)obj{
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        [_hub hideAnimated:YES];
//        [self errorSend:obj];
        NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),obj[@"error"]];
        [Common showErrorMsg:errorStr];
        
    }else{
        if (obj[@"result"]) {
            if ([obj[@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * result = obj[@"result"];
                if (result[@"Error"]) {
                    
                    if ([[result valueForKey:@"Error"] integerValue] > 0) {
                        [_hub hideAnimated:YES];
                        if ([result[@"Error"] integerValue] == 47001) {
                            [Common showErrorMsg:Localized(@"payNot")];
                        }else{
                            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),result[@"Error"]];
                            [Common showErrorMsg:errorStr];
                        }
                        return;
                    }
                }
            }
        }
        self.hashString = obj[@"result"];
        NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.checkTransaction('%@','checkTrade')",obj[@"result"]];
        
        LOADJS1;
        LOADJS2;
        LOADJS3;
        __weak typeof(self) weakSelf = self;
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        [self.browserView setCallbackPrompt:^(NSString * prompt) {
            [weakSelf handlePrompt:prompt];
        }];
    }
}

// Check transaction payer
-(NSDictionary*)checkPayer:(NSDictionary*)dic{
    NSMutableDictionary * resultParamsChange = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSMutableDictionary * paramsD = [NSMutableDictionary dictionaryWithDictionary:resultParamsChange[@"params"]] ;
    NSMutableDictionary * invokeConfig = [NSMutableDictionary dictionaryWithDictionary:paramsD[@"invokeConfig"]] ;
    if (!invokeConfig[@"payer"]) {
        [invokeConfig setValue:self.defaultWalletDic[@"address"] forKey:@"payer"];
        paramsD[@"invokeConfig"] = invokeConfig;
        resultParamsChange[@"params"] = paramsD;
        return resultParamsChange;
    }
    if ([Common isBlankString:invokeConfig[@"payer"]]) {
        [invokeConfig setValue:self.defaultWalletDic[@"address"] forKey:@"payer"];
        paramsD[@"invokeConfig"] = invokeConfig;
        resultParamsChange[@"params"] = paramsD;
        return resultParamsChange;
    }
    if (![self.defaultWalletDic[@"address"] isEqualToString:invokeConfig[@"payer"]]) {
        [Common showToast:@"There is no corresponding payment wallet, please add the wallet first."];
        return nil;
    }
    return dic;
    
}
// Convert a dictionary to a Json string
-(NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

- (void)getInvokeMessage:(NSString*)urlString{
    
    NSDictionary * pDic = self.promptDic[@"params"];
    if (pDic[@"callback"]) {
        self.callback = pDic[@"callback"];
    }
    urlString = pDic[@"qrcodeUrl"];
    [[CCRequest shareInstance] requestWithURLStringNoLoading:urlString MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal) {
        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[responseOriginal valueForKey:@"error"]]];
            return;
        }
        
        if ([responseOriginal isKindOfClass:[NSDictionary class]] && responseOriginal[@"params"]) {
            NSDictionary * paramsD = responseOriginal[@"params"];
            NSDictionary * invokeConfig = paramsD[@"invokeConfig"];
            if (!invokeConfig[@"payer"]) {
                [Common showToast:Localized(@"noPayerWallet")];
                return;
            }
            if (![self.defaultWalletDic[@"address"] isEqualToString:invokeConfig[@"payer"]]) {
                [Common showToast:Localized(@"noPayerWallet")];
                return;
            }
        }
        
        self.payDetailDic = responseOriginal;
        [self actionInvoke:responseOriginal];
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        NSLog(@"222=%@",responseOriginal);
    }];
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

