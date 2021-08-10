//
//  XWCountryCodeController.m
//  XWCountryCodeDemo
//
//  Created by 邱学伟 on 16/4/19.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "NewCountryCodeViewController.h"
#import "UISearchBar+JCSearchBarPlaceholder.h"

//判断系统语言
#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex:0])
#define LanguageIsEnglish ([CURR_LANG isEqualToString:@"en-US"] || [CURR_LANG isEqualToString:@"en-CA"] || [CURR_LANG isEqualToString:@"en-GB"] || [CURR_LANG isEqualToString:@"en-CN"] || [CURR_LANG isEqualToString:@"en"])

@interface NewCountryCodeViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    //国际代码主tableview
    UITableView *countryCodeTableView;
    //搜索
    UISearchDisplayController *searchController;
    //    UISearchController *searchController;
    UISearchBar *searchBar;
    //代码字典
    NSDictionary *sortedNameDict; //代码字典
    
    NSArray *indexArray;
    NSMutableArray *searchResultValuesArray;
    
    NSArray *dataArr;
}

@end

@interface NewCountryCodeViewController ()

@end

@implementation NewCountryCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //背景
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //顶部标题
    //    [self.navigationItem setTitle:@"国家代码"];
    
    //创建子视图
    [self creatSubviews];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"cotback"] Title:Localized(@"Back")];
    
}
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    searchController.searchBar.tintColor = [UIColor whiteColor];
}
//创建子视图
-(void)creatSubviews{
    searchResultValuesArray = [[NSMutableArray alloc] init];
    
    
    if (KIsiPhoneX) {
        countryCodeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20-64 - 34) style:UITableViewStylePlain];
    }else{
        countryCodeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20-64) style:UITableViewStylePlain];
    }
    [self.view addSubview:countryCodeTableView];
    //自动调整自己的宽度，保证与superView左边和右边的距离不变。
    [countryCodeTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [countryCodeTableView setDataSource:self];
    [countryCodeTableView setDelegate:self];
    [countryCodeTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SYSWidth, 49*SCALE_W)];
    //    searchBar.placeholder = Localized(@"newSearch");
    searchBar.barTintColor = [UIColor colorWithHexString:@"#86C5FD"] ;
    searchBar.tintColor =[UIColor whiteColor];
    searchBar.backgroundImage = [self imageWithColor:[UIColor colorWithHexString:@"#86C5FD"] size:searchBar.bounds.size];
    [searchBar setDelegate:self];
    //关闭系统自动联想和首字母大写功能
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [countryCodeTableView setTableHeaderView:searchBar];
    
    [searchBar setImage:[UIImage imageNamed:@"newRectangle-1"]forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar changeLeftPlaceholder:Localized(@"newSearch")];
    searchBar.showsCancelButton = NO;
    //    for (id cencelButton in [searchBar.subviews[0] subviews])
    //    {
    //        if([cencelButton isKindOfClass:[UIButton class]])
    //        {
    //            UIButton *btn = (UIButton *)cencelButton;
    //            [btn setTitle:Localized(@"Cancel")  forState:UIControlStateNormal];
    ////            btn.titleLabel.textColor = [UIColor whiteColor];
    //            btn.titleLabel.font =[UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    ////            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        }
    //    }
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor colorWithHexString:@"#86C5FD"];
    // 输入文本颜色
    searchField.textColor = [UIColor blackColor];
    searchField.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    // 默认文本颜色
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [searchController setDelegate:self];
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    
//    NSString *plistPathCH = [[NSBundle mainBundle] pathForResource:@"sortedChnames" ofType:@"plist"];
//    NSString *plistPathEN = [[NSBundle mainBundle] pathForResource:@"sortedEnames" ofType:@"plist"];
//
//    //判断当前系统语言
//    if ([[Common getUserLanguage]isEqualToString:@"en"]) {
//        sortedNameDict = [[NSDictionary alloc] initWithContentsOfFile:plistPathEN];
//    }else{
//        sortedNameDict = [[NSDictionary alloc] initWithContentsOfFile:plistPathCH];
//    }
    
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    dataArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *plistPathCH = [[NSBundle mainBundle] pathForResource:@"sortedChnames" ofType:@"plist"];
    NSString *plistPathEN = [[NSBundle mainBundle] pathForResource:@"sortedEnames" ofType:@"plist"];
    
    //判断当前系统语言
    if ([[Common getUserLanguage]isEqualToString:@"en"]) {
        sortedNameDict = [[NSDictionary alloc] initWithContentsOfFile:plistPathEN];
    }else{
        sortedNameDict = [[NSDictionary alloc] initWithContentsOfFile:plistPathCH];
    }
    
    indexArray = [[NSArray alloc] initWithArray:[[sortedNameDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }]];
    
}
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    searchBar.barTintColor = [UIColor colorWithHexString:@"#86C5FD"] ;
    searchBar.alpha = 1;
    searchBar.backgroundImage = [self imageWithColor:[UIColor colorWithHexString:@"#86C5FD"] size:searchBar.bounds.size];
    searchController.searchBar.alpha =1;
    searchController.searchBar.backgroundImage = [self imageWithColor:[UIColor colorWithHexString:@"#86C5FD"] size:searchBar.bounds.size];
    searchController.searchBar.showsCancelButton = YES;
    for (id searchbutton in searchBar.subviews){
        UIView *view = (UIView *)searchbutton;
        UIButton *cancelButton = (UIButton *)[view.subviews objectAtIndex:2];
        cancelButton.enabled = YES;
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:Localized(@"Cancel")  forState:UIControlStateNormal];//文字
        break;
    }
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    for (id cencelButton in [searchBar.subviews[0] subviews])
    {
        if([cencelButton isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:Localized(@"Cancel")  forState:UIControlStateNormal];
            //                        btn.titleLabel.textColor = [UIColor whiteColor];
            btn.titleLabel.font =[UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
            //            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
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
//搜索
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [searchResultValuesArray removeAllObjects];
    
//    for (NSArray *array in [sortedNameDict allValues]) {
//        for (NSString *value in array) {
//
//            if ([[value lowercaseString] containsString:[searchBar.text lowercaseString]]) {
//                [searchResultValuesArray addObject:value];
//            }
//        }
//    }
    for (NSDictionary * dic in dataArr) {
        //判断当前系统语言
        NSString * ceshiStr;
        if ([[Common getUserLanguage]isEqualToString:@"en"]) {
            ceshiStr = dic[@"en"];
        }else{
            ceshiStr = dic[@"zh"];
        }
        if ([[ceshiStr lowercaseString] containsString:[searchBar.text lowercaseString]]) {
            [searchResultValuesArray addObject:ceshiStr];
        }
    }
    [searchController.searchResultsTableView reloadData];
}

#pragma mark - UITableView
//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (tableView == countryCodeTableView) {
//        return [sortedNameDict allKeys].count;
//    }else{
        return 1;
//    }
}
//row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == countryCodeTableView) {
        
//        NSArray *array = [sortedNameDict objectForKey:[indexArray objectAtIndex:section]];
        return dataArr.count;
        
    }else{
        return [searchResultValuesArray count];
    }
}
//height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54*SCALE_W;
}
//初始化cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == countryCodeTableView) {
        static NSString *ID1 = @"cellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID1];
        }
        //初始化cell数据!
//        NSInteger section = indexPath.section;
//        NSInteger row = indexPath.row;
        NSDictionary * dic =dataArr[indexPath.row];
        //判断当前系统语言
        if ([[Common getUserLanguage]isEqualToString:@"en"]) {
            cell.textLabel.text = dic[@"en"];
        }else{
            cell.textLabel.text = dic[@"zh"];
        }
//        cell.textLabel.text = [[sortedNameDict objectForKey:[indexArray objectAtIndex:section]] objectAtIndex:row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        return cell;
    }else{
        static NSString *ID2 = @"cellIdentifier2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID2];
        }
        if ([searchResultValuesArray count] > 0) {
            cell.textLabel.text = [searchResultValuesArray objectAtIndex:indexPath.row];
        }
        return cell;
    }
}
//indexTitle
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == countryCodeTableView) {
        return nil;
    }else{
        return nil;
    }
}
//
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (tableView == countryCodeTableView) {
        return index;
    }else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == countryCodeTableView) {
        if (section == 0) {
            return 0;
        }
        return 30;
    }else {
        return 0;
    }
    
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [indexArray objectAtIndex:section];
}

#pragma mark - 选择国际获取代码
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //    //1.代理传值
    if (self.deleagete && [self.deleagete respondsToSelector:@selector(returnCountryCode:)]) {
        [self.deleagete returnCountryCode:cell.textLabel.text];
    }
    NSString * codeStr;
    NSString * reginStr;
    for (NSDictionary *dic in dataArr) {
        //判断当前系统语言
        if ([[Common getUserLanguage]isEqualToString:@"en"]) {
            if ([dic[@"en"]isEqualToString:cell.textLabel.text]) {
                codeStr = [NSString stringWithFormat:@"%@ %@",cell.textLabel.text, dic[@"code"]];
                reginStr = dic[@"locale"];
            }
        }else{
            if ([dic[@"zh"]isEqualToString:cell.textLabel.text]) {
                codeStr = [NSString stringWithFormat:@"%@ %@",cell.textLabel.text, dic[@"code"]];
                reginStr = dic[@"locale"];
            }
        }
    }
    //2.block传值
    if (self.returnCountryCodeReginBlock != nil) {
        self.returnCountryCodeReginBlock(codeStr,reginStr);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //
    //    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 代理传值
-(void)toReturnCountryCode:(returnCountryCodeReginBlock)block{
    self.returnCountryCodeReginBlock = block;
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
