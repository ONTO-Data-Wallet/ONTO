//
//  AddShareWalletAddressViewController.m
//  ONTO
//
//  Created by Apple on 2018/7/9.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "AddShareWalletAddressViewController.h"
#import "CreateShareWalletDoneViewController.h"
#import "BrowserView.h"
#import "WalletAddressCell.h"
@interface AddShareWalletAddressViewController ()
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)UIButton         *addBtn;
@property(nonatomic,strong)NSMutableArray   *dataArray;
@property(nonatomic,strong)BrowserView      *browserView;

@property(nonatomic,copy)NSString           *addressString;
@property(nonatomic,strong)NSIndexPath      *path;

@property(nonatomic,assign)BOOL             isLoad;
@end

@implementation AddShareWalletAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoad=NO;
    [self createUI];
    [self createNav];
}
-(void)createUI{
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.browserView];
    self.dataArray =[NSMutableArray array];
}
-(void)createNav{
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
}
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110*SCALE_W;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _totalNum;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"addressCell%ld",indexPath.row];
    WalletAddressCell *cell =[self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell =[[WalletAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.tag = indexPath.row;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

    }
    cell.nameField.delegate = self;
    cell.keyField.delegate = self;
    [cell.nameField addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
//    UITextField *name =(UITextField*)[cell.contentView viewWithTag:1000];
    cell.nameField.placeholder  =[NSString stringWithFormat:Localized(@"NameOfCopayer"),indexPath.row+1];
    


    return cell;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (textField.tag ==1000) {
        if (textField.text.length <= 0 || textField.text.length > 12) {
            textField.text =@"";
            [Common showToast:Localized(@"SelectAlert")];
            //            [ToastUtil shortToast:self.view value:Localized(@"SelectAlert")];
            if (_dataArray.count>0) {
                for (NSMutableDictionary * dic in _dataArray) {
                    if ([indexPath isEqual:dic[@"row"]]) {
                        [dic setObject:@"" forKey:@"name"];
                    }
                }
            }
            return;
        }
        if (![AppHelper checkName:textField.text]) {
            MGPopController *pop = [[MGPopController alloc] initWithTitle:Localized(@"CorrectName") message:nil image:nil];
            MGPopAction *action =   [MGPopAction actionWithTitle:Localized(@"OK") action:^{
                textField.text=@"";
                if (_dataArray.count>0) {
                    for (NSMutableDictionary * dic in _dataArray) {
                        if ([indexPath isEqual:dic[@"row"]]) {
                            [dic setObject:@"" forKey:@"name"];
                        }
                    }
                }
            }];
            action.titleColor =MainColor;
            [pop addAction:action];
            [pop show];
            pop.showCloseButton = NO;
            return;
        }
    }
    
    
    if (_dataArray.count==0) {
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        if (textField.tag ==1000) {
            [dic setObject:textField.text forKey:@"name"];
        }else{
            [dic setObject:textField.text forKey:@"publickey"];
            _addressString =textField.text;
            self.path =indexPath;
            self.isLoad =YES;
            [self loadJS];
        }
        [dic setObject:indexPath  forKey:@"row"];
        [_dataArray addObject:dic];
    }else{
        BOOL isHave =NO;
        for (NSMutableDictionary * dic in _dataArray) {
            if ([indexPath isEqual:dic[@"row"]]) {
                isHave =YES;
                if (textField.tag ==1000) {
                    [dic setObject:textField.text forKey:@"name"];
                }else{
                    [dic setObject:textField.text forKey:@"publickey"];
                    _addressString =textField.text;
                    self.path =indexPath;
                    self.isLoad =YES;
                    [self loadJS];
                }
                [dic setObject:indexPath  forKey:@"row"];
            }
        }
        if (isHave ==NO) {
            NSMutableDictionary *dic =[NSMutableDictionary dictionary];
            if (textField.tag ==1000) {
                [dic setObject:textField.text forKey:@"name"];
            }else{
                [dic setObject:textField.text forKey:@"publickey"];
                _addressString =textField.text;
                self.path =indexPath;
                self.isLoad =YES;
                [self loadJS];
            }
            [dic setObject:indexPath  forKey:@"row"];
            [_dataArray addObject:dic];
        }
    }
    
    BOOL isAll =YES;
    if (_dataArray.count ==_totalNum) {
        for (NSMutableDictionary *dic in _dataArray) {
            if ([dic isKindOfClass:[NSDictionary class]] && !dic[@"name"]) {
                isAll =NO;
            }
            if ([NSString stringWithFormat:@"%@",dic[@"name"]].length==0) {
                isAll =NO;
            }
            
            if ([dic isKindOfClass:[NSDictionary class]] && !dic[@"publickey"]) {
                isAll =NO;
            }
            if ([NSString stringWithFormat:@"%@",dic[@"publickey"]].length==0 ) {
                isAll =NO;
            }
            //            if ([NSString stringWithFormat:@"%@",dic[@"publickey"]].length<66) {
            //                [ToastUtil shortToast:self.view value:@"公钥不对"];
            //                return;
            //            }
        }
    }else{
        isAll =NO;
    }
    if (isAll) {
        [_addBtn setTitleColor:BLUELB forState:UIControlStateNormal];
        _addBtn.userInteractionEnabled =YES;
    }else{
        [_addBtn setTitleColor:LIGHTGRAYLB forState:UIControlStateNormal];
        _addBtn.userInteractionEnabled =NO;
    }
}
- (void)loadJS{
    
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.adderssFromPublicKey('%@','adderssFromPublicKey')",_addressString];
    
    LOADJS1;
    LOADJS2;
    LOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    
}
- (void)handlePrompt:(NSString *)prompt{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([[obj valueForKey:@"error"] integerValue] > 0) {
        return;
    }
    
    if ([[obj valueForKey:@"error"] integerValue] == 0) {
        if (self.isLoad ==NO) {
            return;
        }
        self.isLoad =NO;
        if (_dataArray.count==0) {
            NSMutableDictionary *dic =[NSMutableDictionary dictionary];
            [dic setObject:obj[@"result"] forKey:@"address"];
            [dic setObject:self.path  forKey:@"row"];
            [_dataArray addObject:dic];
        }else{
            BOOL isHave =NO;
            for (NSMutableDictionary * dic in _dataArray) {
                if ([self.path isEqual:dic[@"row"]]) {
                    isHave =YES;
                    [dic setObject:obj[@"result"] forKey:@"address"];
                    
                }
            }
            if (isHave ==NO) {
                NSMutableDictionary *dic =[NSMutableDictionary dictionary];
                [dic setObject:obj[@"result"] forKey:@"address"];
                [dic setObject:self.path  forKey:@"row"];
                [_dataArray addObject:dic];
            }
        }
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
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight-49-64) style:UITableViewStylePlain];
        if (KIsiPhoneX) {
            _tableView.frame =CGRectMake(0, 0, SYSWidth, SYSHeight-49-64-34-24);
        }
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.backgroundColor =[UIColor whiteColor];
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource =self;
    }
    return _tableView;
}
-(UIButton*)addBtn{
    if (!_addBtn) {
        _addBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, SYSHeight-64-49, SYSWidth, 49)];
        if (KIsiPhoneX) {
            _addBtn.frame =CGRectMake(0, SYSHeight-64-49-34-24, SYSWidth, 49);
        }
        [_addBtn setTitle:Localized(@"ShareAddShort") forState:UIControlStateNormal];
        [_addBtn setTitleColor:LIGHTGRAYLB forState:UIControlStateNormal];
        _addBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        [_addBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
        [_addBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            
            //修改未添加可以点击的bug
            if (_dataArray.count<=0)
            {
                [Common showToast:[NSString stringWithFormat:Localized(@"shareInputName"),1]];
                return;
            }
            
            for (NSMutableDictionary *dic in _dataArray) {
                NSIndexPath *path =dic[@"row"];
                if ([dic isKindOfClass:[NSDictionary class]] && !dic[@"name"]) {
                    [Common showToast:[NSString stringWithFormat:Localized(@"shareInputName"),path.row+1]];
                    return;
                }
                if ([NSString stringWithFormat:@"%@",dic[@"name"]].length==0) {
                    [Common showToast:[NSString stringWithFormat:Localized(@"shareInputName"),path.row+1]];
                    return;
                }
                
                if ([dic isKindOfClass:[NSDictionary class]] && !dic[@"publickey"]) {
                    [Common showToast:[NSString stringWithFormat:Localized(@"shareInputKey"),path.row+1]];
                    return;
                }
                if ([NSString stringWithFormat:@"%@",dic[@"publickey"]].length==0 ) {
                    [Common showToast:[NSString stringWithFormat:Localized(@"shareInputKey"),path.row+1]];
                    return;
                }
                if ([NSString stringWithFormat:@"%@",dic[@"publickey"]].length<66) {
                    [Common showToast:[NSString stringWithFormat:Localized(@"WrongKey"),path.row+1]];
                    return;
                }
                if ([NSString stringWithFormat:@"%@",dic[@"address"]].length==0) {
                    [Common showToast:[NSString stringWithFormat:Localized(@"WrongKey"),path.row+1]];

                    return;
                }
            }
            
            for (int i=0; i<_dataArray.count; i++) {
                NSDictionary *dic =_dataArray[i];
                for (int j=i+1; j<_dataArray.count; j++) {
                    NSDictionary *dic1 =_dataArray[j];
                    if ([dic[@"publickey"] isEqualToString:dic1[@"publickey"]]) {
                        [Common showToast:[NSString stringWithFormat:Localized(@"SameKey"),i+1,j+1]];
                        return;
                    }
                }
            }
            CreateShareWalletDoneViewController *vc =[[CreateShareWalletDoneViewController alloc]init];
            vc.nameStr =self.nameStr;
            vc.totalNum =self.totalNum;
            vc.requiredNum =self.requiredNum;
            vc.dataArray =_dataArray;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    }
    return _addBtn;
}
- (void)textFieldDidChange1:(UITextField *)textField{
    
    if (textField.tag ==1000) {
        if (textField.text.length > 12) {
            textField.text = [textField.text substringToIndex:12];
        }
    }
    
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
