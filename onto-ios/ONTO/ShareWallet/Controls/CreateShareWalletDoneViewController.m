//
//  CreateShareWalletViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/9.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "CreateShareWalletDoneViewController.h"
#import "ShareWalletCell.h"
#import "shareAddressCell.h"
#import "AddShareWalletAddressViewController.h"
#import "blackView.h"
#import "BrowserView.h"
@interface CreateShareWalletDoneViewController ()
    <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITableView *numTableView;
@property(nonatomic, strong) UIButton *createBtn;

@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIView *animateV;
@property(nonatomic, strong) UIPickerView *numPicker;
@property(nonatomic, assign) NSInteger selectRow;
@property(nonatomic, strong) NSIndexPath *selectAll;

@property(nonatomic, strong) BrowserView *browserView;
@property(nonatomic, assign) BOOL isLoad;
@property(nonatomic, copy) NSString *addressString;
@property(nonatomic, strong) NSMutableArray *numArray;
@property(nonatomic, assign) BOOL isChanged;
@end

@implementation CreateShareWalletDoneViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoad = NO;
    self.isChanged = NO;
    [self createUI];
    [self createNav];
    // Do any additional setup after loading the view.
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.createBtn];
    [self.view addSubview:self.browserView];

}
- (void)createNav {
    [self setNavTitle:Localized(@"createShareWallet")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];

}
- (void)navLeftAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:_numTableView]) {
        return 1;
    }
    if (self.isChanged == YES) {
        return 1;
    }
    return 2;
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section==0) {
//        return 3;
//    }
//    return self.dataArray.count;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   {
//    if (indexPath.section==0) {
//        return 82*SCALE_W;
//    }
//    return 51*SCALE_W;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_tableView]) {
        if (self.isChanged == YES) {
            return 4;
        } else {

            if (section == 0) {
                return 3;
            }
            return self.dataArray.count;
        }
    }
    return self.numArray.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableView]) {
        if (self.isChanged == YES) {
            return 82 * SCALE_W;
        } else {
            if (indexPath.section == 0) {
                return 82 * SCALE_W;
            }
            return 51 * SCALE_W;
        }

    }
    return 51 * SCALE_W;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableView]) {
        if (self.isChanged == YES) {
            static NSString *cellID = @"shareCell";
            ShareWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[ShareWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (indexPath.row == 0) {
                cell.nameField.hidden = NO;
                cell.nameField.delegate = self;
                cell.nameField.tag = 10000;
                cell.rightImage.hidden = YES;
                cell.titleLB.text = Localized(@"ShareWalletName");
                [cell
                    .nameField addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
                cell.nameField.text = self.nameStr;
            } else if (indexPath.row == 1) {
                cell.totalNumField.hidden = NO;
                cell.requiredNumField.hidden = YES;
                cell.totalNumField.delegate = self;
                cell.totalNumField.tag = 10001;
                cell.rightImage.hidden = NO;
                cell.titleLB.text = Localized(@"TotalCopayersNum");
                cell.totalNumField.text = [NSString stringWithFormat:@"%ld", self.totalNum];
            } else if (indexPath.row == 2) {
                cell.requiredNumField.hidden = NO;
                cell.totalNumField.hidden = YES;
                cell.requiredNumField.delegate = self;
                cell.requiredNumField.tag = 10002;
                cell.titleLB.text = Localized(@"RequiredCopayersNum");
                cell.requiredNumField.text = [NSString stringWithFormat:@"%ld", self.requiredNum];
                cell.rightImage.hidden = NO;
            } else if (indexPath.row == 3) {
                cell.addressField.hidden = NO;
                //        cell.addressField.delegate =self;
                cell.rightImage.hidden = NO;
                cell.titleLB.text = Localized(@"AddressesCopayersAll");
            }
            return cell;
        } else {

            if (indexPath.section == 0) {
                static NSString *cellID = @"shareCell";
                ShareWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[ShareWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                if (indexPath.row == 0) {
                    cell.nameField.hidden = NO;
                    cell.nameField.delegate = self;
                    cell.nameField.tag = 10000;
                    cell.rightImage.hidden = YES;
                    cell.titleLB.text = Localized(@"ShareWalletName");
                    cell.nameField.text = self.nameStr;
                } else if (indexPath.row == 1) {
                    cell.totalNumField.hidden = NO;
                    cell.totalNumField.delegate = self;
                    cell.totalNumField.tag = 10001;
                    cell.rightImage.hidden = NO;
                    cell.titleLB.text = Localized(@"TotalCopayersNum");
                    cell.totalNumField.text = [NSString stringWithFormat:@"%ld", self.totalNum];
                } else if (indexPath.row == 2) {
                    cell.requiredNumField.hidden = NO;
                    cell.requiredNumField.delegate = self;
                    cell.requiredNumField.tag = 10002;
                    cell.requiredNumField.text = [NSString stringWithFormat:@"%ld", self.requiredNum];
                    cell.titleLB.text = Localized(@"RequiredCopayersNum");
                    cell.rightImage.hidden = NO;
                }
                return cell;
            } else {
                static NSString *cellID = @"addressCell";
                shareAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[shareAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                NSMutableDictionary *dic = self.dataArray[indexPath.row];
                cell.nameLB.text = dic[@"name"];
                cell.addressLB.text = dic[@"address"];
                if (indexPath.row == self.dataArray.count / 2) {
                    cell.rightImage.hidden = NO;
                }
                return cell;
            }
        }
    } else {
        static NSString *numCellId = @"numCellId";
        UITableViewCell *cell = [_numTableView dequeueReusableCellWithIdentifier:numCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UIView
                *numLine = [[UIView alloc] initWithFrame:CGRectMake(0, 51 * SCALE_W - 1, SYSWidth - 32 * SCALE_W, 1)];
            numLine.backgroundColor = LINEBG;
            [cell.contentView addSubview:numLine];
        }

        cell.textLabel.text = [NSString stringWithFormat:@"%ld", [self.numArray[indexPath.row] integerValue]];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#6A797C"];
//        if (indexPath.row ==_selectRow) {
//            cell.textLabel.textColor = [UIColor colorWithHexString:@"#0AA5C9"];
//            cell.backgroundColor =LIGHTGRAYBG;
//        }else{
//            cell.backgroundColor =[UIColor whiteColor];
//        }
        return cell;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:_tableView]) {
        if (self.isChanged) {
            return nil;
        }
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
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:_tableView]) {
        if (self.isChanged) {
            return 0.01;
        }
        if (section == 1) {
            return 41.5 * SCALE_W;
        }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableView]) {
        if (self.isChanged == YES) {
            if (indexPath.row == 1 || indexPath.row == 2) {

                [self createSelectNumV:indexPath];
            }
            if (indexPath.row == 3) {

                if (self.nameStr.length ==0) {
                    [Common showToast:Localized(@"InputWalletName")];
                    return;
                }
                if (_totalNum ==-1) {
                    [Common showToast:Localized(@"InputAllPerple")];
                    return;
                }
                if (_requiredNum ==-1) {
                    [Common showToast:Localized(@"InputRequiredPerple")];
                    return;
                }
                AddShareWalletAddressViewController *vc = [[AddShareWalletAddressViewController alloc] init];
                vc.nameStr = _nameStr;
                vc.totalNum = _totalNum;
                vc.requiredNum = _requiredNum;
                [self.navigationController pushViewController:vc animated:YES];

            }
        } else {
            if (indexPath.section == 0) {
                if (indexPath.row == 1 || indexPath.row == 2) {
                    NSLog(@"total");
                    [self createSelectNumV:indexPath];
                }

            }else{
                if (self.nameStr.length ==0) {
                    [Common showToast:Localized(@"InputWalletName")];
//                    [ToastUtil shortToast:self.view value:Localized(@"InputWalletName")];
                    return;
                }
                if (_totalNum ==-1) {
                    [Common showToast:Localized(@"InputAllPerple")];
//                    [ToastUtil shortToast:self.view value:Localized(@"InputAllPerple")];
                    return;
                }
                if (_requiredNum ==-1) {
                    [Common showToast:Localized(@"InputRequiredPerple")];
//                    [ToastUtil shortToast:self.view value:Localized(@"InputRequiredPerple")];
                    return;
                }
                AddShareWalletAddressViewController *vc = [[AddShareWalletAddressViewController alloc] init];
                vc.nameStr = _nameStr;
                vc.totalNum = _totalNum;
                vc.requiredNum = _requiredNum;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
    } else {
        NSIndexPath *path = [NSIndexPath indexPathForRow:_selectRow inSection:0];
        UITableViewCell *cell1 = (UITableViewCell *) [tableView cellForRowAtIndexPath:path];
        cell1.backgroundColor = [UIColor whiteColor];
        cell1.textLabel.textColor = [UIColor colorWithHexString:@"#6A797C"];

        UITableViewCell *cell = (UITableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = LIGHTGRAYBG;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#0AA5C9"];
        //记录下滚动结束时的行数
        _selectRow = indexPath.row;
        NSInteger selectedRow = [_numArray[indexPath.row] integerValue];
        if (self.selectAll.row == 1) {

            if (_totalNum == selectedRow) {
                _totalNum = selectedRow;
            } else {
                _totalNum = selectedRow;
                [_dataArray removeAllObjects];
                self.isChanged = YES;
                [_tableView reloadData];
            }

        } else {
            _requiredNum = selectedRow;
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectAll, nil] withRowAnimation:UITableViewRowAnimationNone];
        }

        [self performSelector:@selector(disAppear) withObject:nil afterDelay:0.5];
    }

}
- (void)disAppear {
    [self dismissScreenBgView];
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
- (UIButton *)createBtn {
    if (!_createBtn) {
        //        __weak typeof(self) weakSelf = self;
        _createBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SYSHeight - 64 - 49, SYSWidth, 49)];
        if (KIsiPhoneX) {
            _createBtn.frame = CGRectMake(0, SYSHeight - 64 - 49 - 34 - 24, SYSWidth, 49);
        }
        [_createBtn setTitle:Localized(@"createONT") forState:UIControlStateNormal];
        [_createBtn setTitleColor:BLUELB forState:UIControlStateNormal];
        _createBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        [_createBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
        //        [_createBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        //            weakSelf.isLoad =YES;
        //            [weakSelf loadJS];
        //        }];
        [_createBtn addTarget:self action:@selector(toLoadJS) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}
- (void)toLoadJS {

    self.isLoad = YES;
    [self loadJS];
}
- (void)loadJS {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        [array addObject:dic[@"publickey"]];
    }
    NSString *jsStr =
        [NSString stringWithFormat:@"Ont.SDK.createSharedWallet('%@','%@','createSharedWallet')", [NSString stringWithFormat:@"%ld", self
            .requiredNum], [self arrayToJSONString:array]];

    LOADJS1;
    LOADJS2;
    LOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
}
- (void)handlePrompt:(NSString *)prompt {
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj =
        [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        return;
    }

    if ([[obj valueForKey:@"error"] integerValue] == 0) {
        if (self.isLoad == NO) {
            return;
        }
        self.isLoad = NO;
        self.addressString = obj[@"result"];
        [self toCreateWallet];

    }
}
- (void)toCreateWallet {
    for (NSMutableDictionary *dic in self.dataArray) {
        [dic removeObjectForKey:@"row"];
    }
    NSDictionary *params = @{@"sharedWalletAddress": self.addressString, @"sharedWalletName": self.nameStr,
                             @"totalNumber": [NSNumber numberWithInteger:self.totalNum], @"requiredNumber": [NSNumber numberWithInteger:self
                                                                                                             .requiredNum], @"coPayers": self.dataArray, @"isShareWallet": @1};
    [[CCRequest shareInstance]
     requestWithHMACAuthorization:CreateSharedWallet MethodType:MethodTypePOST Params:params
     Success:^(id responseObject, id responseOriginal) {
         
         // 后台有可能返回空导致崩溃：https://jira.ont.io/browse/ODM-94
         if (![Common dx_isNullOrNilWithObject: responseOriginal]
             &&[[responseOriginal objectForKey:@"error"] integerValue] > 0
             ) {
             [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[responseOriginal valueForKey:@"error"]]];
             return;
         }
         NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
         NSMutableArray *newArray;
         if (allArray) {
             newArray = [[NSMutableArray alloc] initWithArray:allArray];
         } else {
             newArray = [[NSMutableArray alloc] init];
         }
         [newArray addObject:params];
         [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:ALLASSET_ACCOUNT];
         
         NSString *jsonStr = [Common dictionaryToJson:newArray[newArray.count - 1]];
         [Common setEncryptedContent:jsonStr WithKey:ASSET_ACCOUNT];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         [self.navigationController popToRootViewControllerAnimated:YES];
         
     }
         Failure:^(NSError *error, NSString *errorDesc, id responseOriginal)
       {
         if (![Common dx_isNullOrNilWithObject: responseOriginal]
             && [[responseOriginal objectForKey:@"Error"] integerValue] == 61002)
         {
             [Common showToast:Localized(@"ExistShareWallet")];
             return;
         }
//         else
//         {
//             [Common showToast:Localized(@"Networkerrors")];
//         }
         
     }];
}
/*
- (void)toCreateWallet {
    for (NSMutableDictionary *dic in self.dataArray) {
        [dic removeObjectForKey:@"row"];
    }

    NSDictionary *params = @{@"sharedWalletAddress":self.addressString,@"sharedWalletName":self.nameStr,@"totalNumber":[NSNumber numberWithInteger:self.totalNum],@"requiredNumber":[NSNumber numberWithInteger:self.requiredNum],@"coPayers":self.dataArray,@"isShareWallet":@1};
    [[CCRequest shareInstance] requestWithURLStringNoLoading:CreateSharedWallet MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {

      // 后台有可能返回空导致崩溃：https://jira.ont.io/browse/ODM-94
      if (![Common dx_isNullOrNilWithObject: responseOriginal]
          &&[[responseOriginal objectForKey:@"error"] integerValue] > 0
          ) {
            [Common showToast:[NSString stringWithFormat:@"%@:%@",Localized(@"Systemerror"),[responseOriginal valueForKey:@"error"]]];
            return;
        }
        NSArray *allArray = [[NSUserDefaults standardUserDefaults] objectForKey:ALLASSET_ACCOUNT];
        NSMutableArray *newArray;
        if (allArray) {
            newArray = [[NSMutableArray alloc] initWithArray:allArray];
        } else {
            newArray = [[NSMutableArray alloc] init];
        }
        [newArray addObject:params];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:ALLASSET_ACCOUNT];
        
        NSString *jsonStr = [Common  dictionaryToJson:newArray[newArray.count-1]];
        [Common setEncryptedContent:jsonStr WithKey:ASSET_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        NSLog(@"responseOriginal=%@",responseOriginal    );
        if (![Common dx_isNullOrNilWithObject: responseOriginal]
            && [[responseOriginal objectForKey:@"Error"] integerValue] == 61002) {
            [Common showToast:Localized(@"ExistShareWallet")];
            return;
        }else{
            [Common showToast:Localized(@"Networkerrors")];
        }
    }];
}
 */
- (void)createSelectNumV:(NSIndexPath *)indexPath {
    self.selectAll = indexPath;
    _numArray = [NSMutableArray array];
    if (indexPath.row == 1) {
        [_numArray removeAllObjects];
        if (_totalNum == -1) {
            _selectRow = -1;
        }
        if (_requiredNum == -1) {

            for (NSInteger i = 2; i <= 12; i++) {
                [_numArray addObject:[NSNumber numberWithInteger:i]];
            }
        } else {
            for (NSInteger i = _requiredNum; i <= 12; i++) {
                [_numArray addObject:[NSNumber numberWithInteger:i]];
            }
        }
    }else{
        if (_totalNum ==-1) {
            _selectRow =-1;
            [Common showToast:Localized(@"FirstSelectAllPerple")];
//            [ToastUtil shortToast:self.view value:Localized(@"FirstSelectAllPerple")];
            return;
        }
        if (_requiredNum == -1) {
            _selectRow = -1;
        }
        [_numArray removeAllObjects];
        for (NSInteger i = 2; i <= _totalNum; i++) {
            [_numArray addObject:[NSNumber numberWithInteger:i]];
        }
    }
    AppDelegate *appdelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.bottomView removeFromSuperview];
    self.bottomView = [blackView initWithForView:appdelegate.window];
    self.bottomView.alpha = 0;

    //    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissScreenBgView)];
    //    tapGesture.cancelsTouchesInView = YES;
    //    [self.bottomView  addGestureRecognizer:tapGesture];

    self.animateV = [[UIView alloc] initWithFrame:CGRectMake(0, SYSHeight, SYSWidth, 168 * SCALE_W + 96 * SCALE_W)];
    [self.bottomView addSubview:self.animateV];

    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(16 * SCALE_W, 0, SYSWidth - 32 * SCALE_W, 197 * SCALE_W)];
    bgV.backgroundColor = [UIColor whiteColor];
    bgV.layer.cornerRadius = 2.f;
    [self.animateV addSubview:bgV];

    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SYSWidth - 32 * SCALE_W, 35 * SCALE_W)];
    titleLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleLB.textColor = LIGHTGRAYLB;
    titleLB.textAlignment = NSTextAlignmentCenter;
    if (indexPath.row == 1) {
        titleLB.text = Localized(@"TotalCopayersNum");
    } else {
        titleLB.text = Localized(@"RequiredCopayersNum");
    }
    [bgV addSubview:titleLB];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 34 * SCALE_W, SYSWidth - 32 * SCALE_W, 1 * SCALE_W)];
    line.backgroundColor = LINEBG;
    [bgV addSubview:line];

    UIButton *sureBtn =
        [[UIButton alloc] initWithFrame:CGRectMake(16 * SCALE_W, 86 * SCALE_W, SYSWidth - 32 * SCALE_W, 50 * SCALE_W)];
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
    }];
    [bgV addSubview:sureBtn];

    //    _numPicker= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35*SCALE_W, SYSWidth-32*SCALE_W, 153*SCALE_W)];
    ////    _selectRow =1;
    //    _numPicker.userInteractionEnabled =YES;
    //    _numPicker.dataSource = self;
    //    _numPicker.delegate = self;
    //    [bgV addSubview:_numPicker];
    //    [_numPicker selectRow:1 inComponent:0 animated:NO];

    _numTableView = [[UITableView alloc]
        initWithFrame:CGRectMake(0, 35 * SCALE_W, SYSWidth - 32 * SCALE_W, 153 * SCALE_W) style:UITableViewStylePlain];
    _numTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _numTableView.showsVerticalScrollIndicator = NO;
    _numTableView.delegate = self;
    _numTableView.dataSource = self;
    [bgV addSubview:_numTableView];

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 187 * SCALE_W, SYSWidth - 32 * SCALE_W, 1 * SCALE_W)];
    line2.backgroundColor = LINEBG;
    [bgV addSubview:line2];

    UIButton *cancleBtn =
        [[UIButton alloc] initWithFrame:CGRectMake(16 * SCALE_W, 206 * SCALE_W, SYSWidth - 32 * SCALE_W, 50 * SCALE_W)];
    cancleBtn.layer.cornerRadius = 2.f;
    cancleBtn.backgroundColor = [UIColor whiteColor];
    [cancleBtn setTitleColor:BLACKLB forState:UIControlStateNormal];
    [cancleBtn setTitle:Localized(@"Cancel") forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [self.animateV addSubview:cancleBtn];

    [UIView animateWithDuration:.2 animations:^{
      self.animateV.frame = CGRectMake(0, SYSHeight - 168 * SCALE_W - 96 * SCALE_W, SYSWidth, SYSHeight);
      self.bottomView.alpha = 1;
    }];

    [cancleBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
      [self dismissScreenBgView];
    }];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SYSWidth - 32 * SCALE_W;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 51 * SCALE_W;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return [NSString stringWithFormat:@"%ld", row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //设置分割线的颜色
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = LINEBG;
        }
    }

    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.text = [NSString stringWithFormat:@"%ld", row];
    genderLabel.font = [UIFont systemFontOfSize:18];
    genderLabel.backgroundColor = [UIColor whiteColor];
    genderLabel.textColor = [UIColor colorWithHexString:@"#6A797C"];
    if (row == _selectRow) {
        genderLabel.textColor = [UIColor colorWithHexString:@"#0AA5C9"];
        genderLabel.backgroundColor = LIGHTGRAYBG;
    }
    return genderLabel;
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
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //记录下滚动结束时的行数
    _selectRow = row;
    //刷新picker，看上面的代理
    [pickerView reloadComponent:component];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if (textField.tag == 10000) {
    } else if (textField.tag == 10001) {
    } else if (textField.tag == 10002) {
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 10000) {
        if (textField.text.length <= 0 || textField.text.length > 12) {

            textField.text =@"";
            [Common showToast:Localized(@"SelectAlert")];
            return;
        }
        if (![AppHelper checkName:textField.text]) {
            MGPopController
                *pop = [[MGPopController alloc] initWithTitle:Localized(@"CorrectName") message:nil image:nil];
            MGPopAction *action = [MGPopAction actionWithTitle:Localized(@"OK") action:^{
              textField.text = @"";
              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
              [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            action.titleColor = MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            return;
        }
        self.nameStr = textField.text;
    } else if (textField.tag == 10001) {
    } else if (textField.tag == 10002) {
    }
}
- (NSString *)arrayToJSONString:(NSArray *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonResult;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidChange1:(UITextField *)textField {

    if (textField.tag == 10000) {
        if (textField.text.length > 12) {
            textField.text = [textField.text substringToIndex:12];
        }
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
