//
//  ContactsViewController.m
//  ONTO
//
//  Created by 赵伟 on 16/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsCell.h"
#import "AddContactViewController.h"
#import "WeChatStylePlaceHolder.h"
#import "CYLTableViewPlaceHolder.h"
#import "ContactDetailVC.h"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate,WeChatStylePlaceHolderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *contactsArr;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTable];
    [self configNav];

}

- (UIView *)makePlaceHolderView {
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}

- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.myTable.frame];
    [weChatStylePlaceHolder setContacts];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}

- (void)emptyOverlayClicked:(id)sender{
    
}

- (void)configNav {
    [self setNavTitle:Localized(@"Contacts")];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"nav_back"] Title:Localized(@"Back")];
//    [self setNavRightImageIcon:[UIImage imageNamed:@"ONTSend-SAO"] Title:nil];
        [self setNavRightImageIcon:[UIImage imageNamed:@"icon_create_s_blue copy 2"] Title:nil];

}

-(void)navRightAction {
    
    AddContactViewController *vc = [[AddContactViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _contactsArr =   [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:ALLCONTACT_LIST]];
//    _contactsArr =  [NSMutableArray arrayWithArray:@[@{@"name":@"xiaoming",@"address":@"jnadfjhjksd"}]] ;
    [_myTable cyl_reloadData];
}

- (void)setTable{
    
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    [self setExtraCellLineHidden:self.myTable];
//    self.myTable.backgroundColor = [];
//    self.view.backgroundColor = TABLEBACKCOLOR;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = TABLEBACKCOLOR;
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    // Return the number of sections.
////    [tableView tableViewDisplayWitMsg:Localized(@"NoWallet") ifNecessaryForRowCount:_contactsArr.count];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
    return _contactsArr.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 83*([[UIScreen mainScreen] bounds].size.width/375);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ContactsCell";
    //通过xib的名称加载自定义的cell
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    
    cell.contactsL.text = [_contactsArr [indexPath.row] valueForKey:@"name"];
    cell.addrL.text = [_contactsArr [indexPath.row] valueForKey:@"address"];
   
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_callback) {
        
        _callback([_contactsArr [indexPath.row] valueForKey:@"address"]);
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        ContactDetailVC *vc = [[ContactDetailVC alloc]init];
        vc.name = [_contactsArr [indexPath.row] valueForKey:@"name"];
        vc.address = [_contactsArr [indexPath.row] valueForKey:@"address"];
        vc.index = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0.1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
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

    //删除数据，和删除动画
    [_contactsArr removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:_contactsArr forKey:ALLCONTACT_LIST];
    [self.myTable cyl_reloadData];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 50;
//    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}


@end
