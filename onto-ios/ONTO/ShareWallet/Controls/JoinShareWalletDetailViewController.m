//
//  CreateShareWalletViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/9.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "JoinShareWalletDetailViewController.h"
#import "ShareWalletCell.h"
#import "shareAddressCell.h"
#import "AddShareWalletAddressViewController.h"
#import "blackView.h"
#import "ConfirmJoinView.h"
@interface JoinShareWalletDetailViewController ()
    <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSDictionary *dataDic;
@property(nonatomic, strong) UIButton *createBtn;
@property(nonatomic, strong) UIWindow *window;

@end

@implementation JoinShareWalletDetailViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  [self createUI];
  [self createNav];
  [self getData];
  // Do any additional setup after loading the view.
}
- (void)createUI {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.tableView];
  [self.view addSubview:self.createBtn];

}

- (void)getData {
  NSDictionary *params = @{@"sharedWalletAddress": self.shareWalletAddress};
  [[CCRequest shareInstance]
      requestWithHMACAuthorization:GetShareWalletDetail
                        MethodType:MethodTypeGET
                            Params:params
                           Success:^(id responseObject, id responseOriginal) {
                             if (![Common dx_isNullOrNilWithObject:responseOriginal]
                                 && [[responseOriginal valueForKey:@"error"] integerValue] > 0) {
                               [Common showToast:[NSString stringWithFormat:@"%@:%@",
                                       Localized(@"Systemerror"), [responseOriginal valueForKey:@"error"]]];
                               return;
                             }
                             self.dataDic = responseOriginal;
                             self.dataArray = responseOriginal[@"coPayers"];
                             [_tableView reloadData];

                           }
                           Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
                               //共享钱包地址错误导致Crash-bug
                              [Common showToast:Localized(@"shareWalletAddressError")];
                              [self.navigationController popViewControllerAnimated:YES];
                           }];
}
- (void)createNav {
  [self setNavTitle:Localized(@"leadShareWallet")];
  [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];

}
- (void)navLeftAction {
  [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 3;
  }
  return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 82 * SCALE_W;
  }
  return 51 * SCALE_W;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    static NSString *cellID = @"shareCell";
    ShareWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
      cell = [[ShareWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row == 0) {
      cell.nameField.hidden = NO;
      cell.nameField.userInteractionEnabled = NO;
      cell.nameField.tag = 10000;
      cell.titleLB.text = Localized(@"ShareWalletName");
      cell.nameField.text = self.dataDic[@"sharedWalletName"];
    } else if (indexPath.row == 1) {
      cell.totalNumField.hidden = NO;
      cell.totalNumField.userInteractionEnabled = NO;
      cell.totalNumField.tag = 10001;
      cell.titleLB.text = Localized(@"TotalCopayersNum");
      cell.totalNumField.text = [NSString stringWithFormat:@"%ld", [self.dataDic[@"totalNumber"] integerValue]];
    } else if (indexPath.row == 2) {
      cell.requiredNumField.hidden = NO;
      cell.requiredNumField.userInteractionEnabled = NO;
      cell.requiredNumField.tag = 10002;
      cell.titleLB.text = Localized(@"RequiredCopayersNum");
      cell.requiredNumField.text =
          [NSString stringWithFormat:@"%ld", [self.dataDic[@"requiredNumber"] integerValue]];
    }
    cell.rightImage.hidden = YES;
    return cell;
  } else {
    static NSString *cellID = @"addressCell";
    shareAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
      cell = [[shareAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.nameLB.text = dic[@"name"];
    cell.addressLB.text = dic[@"address"];

    return cell;
  }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYSWidth, 41.5 * SCALE_W)];
    headerV.backgroundColor = [UIColor whiteColor];

    UILabel *LB = [[UILabel alloc]
        initWithFrame:CGRectMake(24 * SCALE_W, 16 * SCALE_W, SYSWidth - 48 * SCALE_W, 22 * SCALE_W)];
    LB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    LB.textAlignment = NSTextAlignmentLeft;
    LB.textColor = BLACKLB;
    LB.text = Localized(@"AddressesCopayersAll");
    [headerV addSubview:LB];

    return headerV;
  }
  return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    return 41.5 * SCALE_W;
  }
  return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  if (section == 1) {
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYSWidth, 1)];

    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(24 * SCALE_W, 0, SYSWidth - 48 * SCALE_W, 1)];
    headerV.backgroundColor = LINEBG;
    [bgV addSubview:headerV];

    return bgV;
  }
  return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if (section == 1) {
    return 1;
  }
  return 0.01;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc]
        initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight - 49 - 64) style:UITableViewStylePlain];
    if (KIsiPhoneX) {
      _tableView.frame = CGRectMake(0, 0, SYSWidth, SYSHeight - 49 - 64 - 34 - 24);
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
  }
  return _tableView;
}

//防止重复加入钱包
-(NSMutableSet*)p_creatSetWtihArr:(NSArray*)arr
{
    NSArray *datas = arr;
    NSMutableSet *mSet = [NSMutableSet setWithArray:datas];
    return mSet;
}

-(NSMutableArray*)p_creatMarrWithObjc:(NSDictionary*)dict
{
    NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    NSMutableArray *newArray;
    if (allArray) {
        newArray = [[NSMutableArray alloc] initWithArray:allArray];
    } else {
        newArray = [[NSMutableArray alloc] init];
    }
    
    NSMutableSet *mSet = [self p_creatSetWtihArr:allArray];
    [mSet addObject:dict];
    newArray = [NSMutableArray arrayWithArray:mSet.allObjects];
    return newArray;
}

- (UIButton *)createBtn {
  if (!_createBtn) {
    _createBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SYSHeight - 64 - 49, SYSWidth, 49)];
    if (KIsiPhoneX) {
      _createBtn.frame = CGRectMake(0, SYSHeight - 64 - 49 - 34 - 24, SYSWidth, 49);
    }
    [_createBtn setTitle:Localized(@"JoinShareWallet") forState:UIControlStateNormal];
    [_createBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    _createBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
    [_createBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [self createConfirmV];

//      NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
//      NSMutableArray *newArray;
//      if (allArray) {
//        newArray = [[NSMutableArray alloc] initWithArray:allArray];
//      } else {
//        newArray = [[NSMutableArray alloc] init];
//      }
//      //存在重复加入的问题
//      [newArray addObject:self.dataDic];
        
        
      NSMutableArray *newArray = [self p_creatMarrWithObjc:self.dataDic];
        
      [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:ALLASSET_ACCOUNT];

      NSString *jsonStr = [Common dictionaryToJson:newArray[newArray.count - 1]];
      [Common setEncryptedContent:jsonStr WithKey:ASSET_ACCOUNT];
      [[NSUserDefaults standardUserDefaults] synchronize];

//            [ToastUtil shortToast:self.view value:Localized(@"JoinShareWalletSuccess")];

      [self performSelector:@selector(toPop) withObject:nil afterDelay:1];
    }];

  }
  return _createBtn;
}
- (void)toPop {
  [self.navigationController popToRootViewControllerAnimated:YES];

}
- (void)createConfirmV {

//    BOOL isHave =NO;
//    for (NSDictionary *dic in self.dataArray) {
//        if ([dic[@"address"] isEqualToString:@""]) {
//            isHave =YES;
//        }
//    }
//    if (isHave ==NO) {
//        MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"NotShareWalletCopayers") message:nil image:nil];
//        MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
//        }];
//        action.titleColor =MainColor;
//        [pop addAction:action];
//        [pop show];
//        pop.showCloseButton = NO;
//        return;
//    }
//    ConfirmJoinView *optionsView =[[ConfirmJoinView alloc]init];
//    [optionsView setCallback:^(NSString *addressString, NSString *pwdString,NSDictionary *selectDic) {
//        
//    }];
//    _window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
//    [_window addSubview:optionsView];
//    [_window makeKeyAndVisible];
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
