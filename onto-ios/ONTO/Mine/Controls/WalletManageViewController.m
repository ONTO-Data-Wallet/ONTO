//
//  WalletManageViewController.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/28.
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

#import "WalletManageViewController.h"
#import "UIView+Scale.h"
#import "CCRequest.h"
#import "UITableView+EmptyData.h"
#import "BackupViewController.h"
#import "ImportViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import "WallManageCell.h"
#import "ConfirmPwdViewController.h"
#import "WalletDetailViewController.h"
#import "ImportWalletVC.h"
#import "SendConfirmView.h"
#import "KeyStoreBackupVC.h"

@interface WalletManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UIButton *importDIBtn;
@property (nonatomic, strong) NSMutableArray *identArr;

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) NSIndexPath *preSelectedIndexPath;
@property (nonatomic,strong) NSMutableArray *expandArr;
@property (nonatomic, strong) SendConfirmView *sendConfirmV;
@property (nonatomic,copy) NSString *confirmPwd;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *salt;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,assign) NSInteger btnTpye;
@property (nonatomic,copy) NSDictionary *dic;
@property (nonatomic,assign) NSInteger btnTag;
@property (nonatomic, strong) MBProgressHUD *hub;
@end

@implementation WalletManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTable];
    [self configNav];

}

- (void)handlePrompt:(NSString *)prompt{
    
    [_hub hideAnimated:YES];
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
        [_sendConfirmV dismiss];
        if (_btnTpye==0) {
            KeyStoreBackupVC *vc = [[KeyStoreBackupVC alloc]init];
            vc.isWallet = YES;
            vc.identityDic = _dic;
            vc.passwordString = _confirmPwd;
            vc.name = _dic[@"name"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            
            if ([[[Common dictionaryWithJsonString:[Common getEncryptedContent:ASSET_ACCOUNT]
                   ]valueForKey:@"address"] isEqualToString:[_identArr[_btnTag] valueForKey:@"address"]]) {
             
                MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletCanNotDeleted") message:nil image:nil];
                MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                    
                }];
                action.titleColor =MainColor;
                [pop addAction:action];
                [pop show];
                pop.showCloseButton = NO;
                return;
            }
            
            //删除数据，和删除动画
            [_identArr removeObjectAtIndex:_btnTag];
            [[NSUserDefaults standardUserDefaults] setObject:_identArr forKey:ALLASSET_ACCOUNT];
            [self.myTable reloadData];
            
        }
        
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _identArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:ALLASSET_ACCOUNT]] ;
    [_myTable reloadData];

}

- (void)configNav {
    [self setNavTitle:Localized(@"Walletmanage")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#6A797C"],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]}];
}

- (void)navLeftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTable{
    
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setExtraCellLineHidden:self.myTable];
    self.importDIBtn.layer.masksToBounds = YES;
    self.importDIBtn.layer.cornerRadius = 1;
    [self.importDIBtn setTitle:Localized(@"ImportWallet") forState:UIControlStateNormal];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    // Return the number of sections.
    [tableView tableViewDisplayWitMsg:Localized(@"NoWallet") ifNecessaryForRowCount:_identArr.count];
    return _identArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger status = [[self.expandArr objectAtIndex:indexPath.section] integerValue];
    
    if(0 == status)
    {
        return 83;
    }
    return 170;
    
}


-(NSMutableArray *)expandArr
{
    if (!_expandArr) {
        _expandArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in self.identArr) {
            [_expandArr addObject:@0];
        }
    }
    return _expandArr;
}

#pragma mark pivate
-(void)changeExpandArrAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger status = [[self.expandArr objectAtIndex:indexPath.section] integerValue];

       [_expandArr removeAllObjects];
    for (NSDictionary *dic in self.identArr) {
                [_expandArr addObject:@0];
            }
    
    if (0 == status) {
        [self.expandArr replaceObjectAtIndex:indexPath.section withObject:@1];
    }
    
    [self.myTable reloadData];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger status = [[self.expandArr objectAtIndex:indexPath.section] integerValue];

    static NSString *CellIdentifier = @"WallManageCell";
    //通过xib的名称加载自定义的cell
    WallManageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];

    }
    
    if (status==0) {
        cell.bottomView.hidden = YES;
    }else{
        cell.bottomView.hidden = NO;
    }

//<<<<<<< HEAD
//    cell.userIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"随机icon%ld",(long)(indexPath.section+1)%4+1]];
//    cell.backUpBtn.tag = indexPath.section;
//    [cell.backUpBtn addTarget:self action:@selector(backUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_identArr[indexPath.section] isKindOfClass:[NSDictionary class]] && _identArr[indexPath.section][@"label"]) {
        cell.nameLabel.text = [_identArr[indexPath.section] valueForKey:@"label"];
        cell.addressL.text = [_identArr[indexPath.section] valueForKey:@"address"];
    }else{
        cell.nameLabel.text = [_identArr[indexPath.section] valueForKey:@"sharedWalletName"];
        cell.addressL.text = [_identArr[indexPath.section] valueForKey:@"sharedWalletAddress"];
    }
//=======
//    cell.nameLabel.text = [_identArr[indexPath.section] valueForKey:@"label"];
//    cell.addressL.text = [_identArr[indexPath.section] valueForKey:@"address"];
//>>>>>>> network_dev
    
    cell.exportBtn.tag = indexPath.section;
    cell.deleteBtn.tag = indexPath.section+10;

    [cell.exportBtn addTarget:self action:@selector(exportClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
   return cell;
        

}

- (SendConfirmView *)sendConfirmV {
    
    if (!_sendConfirmV) {
        
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            
            weakSelf.confirmPwd = password;
            
        
            [weakSelf loadJS];
            
        }];
    }
    return _sendConfirmV;
}

- (void)exportClick:(UIButton*)sender{
    
    if ([_identArr[sender.tag] isKindOfClass:[NSDictionary class]]&& _identArr[sender.tag][@"sharedWalletAddress"]) {
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"ShareWalletExportError") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }
    _btnTpye = 0;
    _address = [_identArr[sender.tag] valueForKey:@"address"];
    _dic = _identArr[sender.tag];
    _key = [_identArr[sender.tag] valueForKey:@"key"];
    _salt = [_identArr[sender.tag] valueForKey:@"salt"];

    _btnTag = sender.tag;
    
//    UIWindow  *window= [[[UIApplication sharedApplication]windows] objectAtIndex:0];
//    [window makeKeyAndVisible];
//
//    [window addSubview:self.sendConfirmV];
    [self.view addSubview:self.sendConfirmV];
    self.sendConfirmV.paybyStr = @"";
    self.sendConfirmV.amountStr = @"";
    self.sendConfirmV.isWalletBack = YES;
    [self.sendConfirmV show];
    
}

- (void)deleteClick:(UIButton*)sender{
    NSDictionary *dic =_identArr[sender.tag-10];
    if ([dic isKindOfClass:[NSDictionary class]]&& dic[@"sharedWalletAddress"]) {
        
        if ([[[Common dictionaryWithJsonString:[Common getEncryptedContent:ASSET_ACCOUNT]
               ]valueForKey:@"sharedWalletAddress"] isEqualToString:dic[@"sharedWalletAddress"]]) {
            
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletCanNotDeleted") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            return;
        }
        
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"ShareWalletDelete") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            //删除数据，和删除动画
            [_identArr removeObjectAtIndex:sender.tag-10];
            [[NSUserDefaults standardUserDefaults] setObject:_identArr forKey:ALLASSET_ACCOUNT];
            [self.myTable reloadData];
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
    
    _btnTpye = 1;
    _address = [_identArr[sender.tag-10] valueForKey:@"address"];
    _dic = _identArr[sender.tag-10];
    _key = [_identArr[sender.tag-10] valueForKey:@"key"];
    _salt = [_identArr[sender.tag-10] valueForKey:@"salt"];

    _btnTag = sender.tag-10;

    [self.view addSubview:self.sendConfirmV];
    self.sendConfirmV.paybyStr = @"";
    self.sendConfirmV.amountStr = @"";
    self.sendConfirmV.isWalletBack = YES;
    [self.sendConfirmV show];
}




-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"replaceData.plist" ofType:nil]];
    }
    return _dataArr;
}

- (void)backUpBtnClick:(UIButton *)sender{
    
    [self pushBackupVCWithIndex:sender.tag];
    
}


- (void)pushBackupVCWithIndex:(NSInteger)index{
    
        WalletDetailViewController *vc = [[WalletDetailViewController alloc]init];
        vc.address = [_identArr[index] valueForKey:@"address"];
        vc.identityDic = _identArr[index];
        vc.name = [_identArr[index] valueForKey:@"label"];
        [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self changeExpandArrAtIndexPath:indexPath];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
    
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return NO;
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
    //在这里实现删除操作
    
    if ([[[Common dictionaryWithJsonString:[Common getEncryptedContent:ASSET_ACCOUNT]
]valueForKey:@"address"] isEqualToString:[_identArr[indexPath.section] valueForKey:@"address"]]) {
      
        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"WalletCanNotDeleted") message:nil image:nil];
        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
            
        }];
        action.titleColor =MainColor;
        [pop addAction:action];
        [pop show];
        pop.showCloseButton = NO;
        return;
    }

    //删除数据，和删除动画
    [_identArr removeObjectAtIndex:indexPath.section];
    [[NSUserDefaults standardUserDefaults] setObject:_identArr forKey:ALLASSET_ACCOUNT];
    [self.myTable reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


@end

