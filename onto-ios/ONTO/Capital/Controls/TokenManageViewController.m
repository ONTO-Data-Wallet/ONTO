//
//  TokenManageViewController.m
//  ONTO
//
//  Created by Apple on 2019/1/3.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "TokenManageViewController.h"
#import "config.h"
#import "TokenCell.h"
@interface TokenManageViewController ()
<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)UITableView      *searchtableView;
@property(nonatomic,strong)UISearchBar      *searchBar;
@property(nonatomic,strong)NSMutableArray   *dataArray;
@property(nonatomic,strong)NSMutableArray   *searchResultValuesArray;
@end

@implementation TokenManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self configNav];
    [self configUI];
}
-(void)initData{
    NSArray * arr = @[@{@"ShortName":@"ONT",@"picImage":@"newOnt"},
  @{@"ShortName":@"ONG",@"picImage":@"newOng"}];
    
    NSArray * arr1 = @[@{@"ShortName":@"totalpumpkin",@"picImage":@"pumkinRectangle 7",@"Type":@"OEP-8",@"ShortName_1":@"PUMPKIN"},
                      @{@"ShortName":@"HyperDragons",@"picImage":@"dragonRectangle_1",@"Type":@"OEP-5",@"ShortName_1":@"HyperDragons"}];
    NSArray * tokenArray = [[NSUserDefaults standardUserDefaults]valueForKey:TOKENLIST];
    NSArray * defaultTokenArray = [[NSUserDefaults standardUserDefaults]valueForKey:DEFAULTTOKENLIST];
    self.dataArray = [NSMutableArray array];
    self.searchResultValuesArray = [NSMutableArray array ];
    [self.dataArray addObjectsFromArray:arr];
    [self.dataArray addObjectsFromArray:defaultTokenArray];
    [self.dataArray addObjectsFromArray:arr1];
    [self.dataArray addObjectsFromArray:tokenArray];
    
    //pax存在重复-bug
    self.dataArray = [self p_romveRepetitionWithArr:self.dataArray];
}

-(NSMutableArray*)p_romveRepetitionWithArr:(NSMutableArray*)arr
{
    NSArray *tmpArr = arr;
    NSSet *tmpSet = [NSSet setWithArray:tmpArr];
    NSMutableArray *marr = [NSMutableArray arrayWithArray:tmpSet.allObjects];
    return marr;
}

-(void)configUI{
    _searchBar =[[UISearchBar alloc]init];
    _searchBar.placeholder = Localized(@"SEARCHTOKEN");
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#196BD8"] ;
    _searchBar.tintColor =[UIColor whiteColor];
    _searchBar.delegate =self;
    _searchBar.backgroundImage = [self imageWithColor:[UIColor colorWithHexString:@"#86C5FD"] size:_searchBar.bounds.size];
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    //这里是搜索框的圆角
    searchField.layer.cornerRadius = 0.0f;
    searchField.layer.masksToBounds = YES;
    
    [searchField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] forKeyPath:@"_placeholderLabel.font"];
   
    //关闭系统自动联想和首字母大写功能
    [_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [_searchBar setImage:[UIImage imageNamed:@"searchImage"]forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    [self.view addSubview:_searchBar];
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator =NO;
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.hidden = NO;
    [self.view addSubview:_tableView];
    [self.tableView reloadData];
    
    _searchtableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _searchtableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _searchtableView.showsVerticalScrollIndicator =NO;
    _searchtableView.delegate =self;
    _searchtableView.dataSource =self;
    _searchtableView.hidden = YES;
    [self.view addSubview:_searchtableView];

//    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(self.view);
//        make.height.mas_offset(59);
//    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34);
        }else{
            make.bottom.equalTo(self.view);
        }
    }];
    [_searchtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34);
        }else{
            make.bottom.equalTo(self.view);
        }
    }];
    
}
//搜索
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _tableView.hidden =YES;
    _searchtableView.hidden = NO;
    [_searchResultValuesArray removeAllObjects];
    for (NSDictionary * dic in self.dataArray) {
        NSString * assetStr = dic[@"ShortName"];
    
        if ([[assetStr lowercaseString] containsString:[_searchBar.text lowercaseString]]) {
            [_searchResultValuesArray addObject:dic];
        }
    }
    [self.searchtableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView])
    {
        return self.dataArray.count;
    }
    else
    {
        return self.searchResultValuesArray.count;
        
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cell";
    TokenCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[TokenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    NSDictionary * dic;
    if ([tableView isEqual:_tableView]) {
        dic = self.dataArray[indexPath.row];
    }else{
        dic = self.searchResultValuesArray[indexPath.row];
    }
    
    [cell reloadCellByDic:dic];
    cell.showButton.tag = indexPath.row;
    [cell.showButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSDictionary * tokenDic = self.dataArray[switchButton.tag];
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
    NSDictionary *walletDic = [Common dictionaryWithJsonString:jsonStr];
    NSMutableArray *showArray = [NSMutableArray array];
    [showArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@%@",walletDic[@"address"],TOKENLISTSHOW]]];
    if (isButtonOn) {
        if (showArray.count >0) {
            BOOL isHave = NO;
            for (NSInteger i =0; i<showArray.count; i++) {
                NSDictionary * subDic = showArray[i];
                if ([subDic[@"AssetName"] isEqualToString:tokenDic[@"ShortName"]]) {
                    isHave = YES;
                    NSDictionary * changDic = @{@"AssetName":tokenDic[@"ShortName"],@"isShow":@"0"};
                    [showArray replaceObjectAtIndex:i withObject:changDic];
                    [[NSUserDefaults standardUserDefaults] setValue:showArray forKey:[NSString stringWithFormat:@"%@%@",walletDic[@"address"],TOKENLISTSHOW]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            if (isHave == NO) {
                NSDictionary * dic = @{@"AssetName":tokenDic[@"ShortName"],@"isShow":@"0"};
                [showArray addObject:dic];
                [[NSUserDefaults standardUserDefaults] setValue:showArray forKey:[NSString stringWithFormat:@"%@%@",walletDic[@"address"],TOKENLISTSHOW]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }else{
            NSDictionary * dic = @{@"AssetName":tokenDic[@"ShortName"],@"isShow":@"0"};
            [showArray addObject:dic];
            [[NSUserDefaults standardUserDefaults] setValue:showArray forKey:[NSString stringWithFormat:@"%@%@",walletDic[@"address"],TOKENLISTSHOW]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }else {
        if (showArray.count >0) {
            BOOL isHave = NO;
            for (NSInteger i =0; i<showArray.count; i++) {
                NSDictionary * subDic = showArray[i];
                if ([subDic[@"AssetName"] isEqualToString:tokenDic[@"ShortName"]]) {
                    isHave = YES;
                    NSDictionary * changDic = @{@"AssetName":tokenDic[@"ShortName"],@"isShow":@"1"};
                    [showArray replaceObjectAtIndex:i withObject:changDic];
                    [[NSUserDefaults standardUserDefaults] setValue:showArray forKey:[NSString stringWithFormat:@"%@%@",walletDic[@"address"],TOKENLISTSHOW]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            if (isHave == NO) {
                NSDictionary * dic = @{@"AssetName":tokenDic[@"ShortName"],@"isShow":@"1"};
                [showArray addObject:dic];
                [[NSUserDefaults standardUserDefaults] setValue:showArray forKey:[NSString stringWithFormat:@"%@%@",walletDic[@"address"],TOKENLISTSHOW]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }else{
            NSDictionary * dic = @{@"AssetName":tokenDic[@"ShortName"],@"isShow":@"1"};
            [showArray addObject:dic];
            [[NSUserDefaults standardUserDefaults] setValue:showArray forKey:[NSString stringWithFormat:@"%@%@",walletDic[@"address"],TOKENLISTSHOW]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}
// 导航栏设置
- (void)configNav {
    [self setTitle:Localized(@"MANAGETOKEN")];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#000000"],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:21 weight:UIFontWeightBold],
                                                                      NSKernAttributeName: @2
                                                                      }];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"cotback"] Title:Localized(@"Back")];
    
}

// 返回
- (void)navLeftAction
{
    //发送刷新钱包界面的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh_Home" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

/** 取消searchBar背景色 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
