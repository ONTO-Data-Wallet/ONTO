//
//  ONTODAppHomeView.m
//  ONTO
//
//  Created by onchain on 2019/5/20.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHomeView.h"
#import <MJRefresh/MJRefresh.h>
#import "UIView+Banner.h"
#import <YYKit.h>
#import "Config.h"
#import "ONTODAppHomeBannerTableViewCell.h"
#import "ONTODAppHomeRecommendTableViewCell.h"
#import "ONTODAppSectionTitleTableViewCell.h"
#import "ONTODAppHomeDescribeTableViewCell.h"
#import "ONTODAppHomeRootModel.h"

@interface ONTODAppHomeView ()<UITableViewDataSource,UITableViewDelegate,ONTODAppHomeDescribeTableViewCellDelegate,ONTODAppHomeBannerTableViewCellDelegate,ONTODAppHomeRecommendTableViewCellDelegate>
{
    ONTODAppHomeRootModel               *_rootModel;
    int                                 _rowCount;
}
@property(nonatomic,strong)UITableView                  *listTableView;
@end
@implementation ONTODAppHomeView
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self p_initUI];
    }
    return self;
}

#pragma mark - Private
-(void)p_initUI
{
    [self addSubview:self.listTableView];
}

-(NSInteger)p_getTableViewRowCount
{
    if (!_rootModel) return 0;
    return (_rootModel.banner.count>0?1:0) + (_rootModel.recommend.count>0?1:0) + (_rootModel.cooperation.count>0?1:0) + (_rootModel.app.count>0?_rootModel.app.count:0) + 1;
}

#pragma mark - Public Method
-(void)stopRefreshWithisMore:(BOOL)isMore
{
    if (isMore)
    {
        [self.listTableView.mj_footer endRefreshing];
        [self.listTableView.mj_header endRefreshing];
    }
    else
    {
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void)refreshTableViewWithModel:(ONTODAppHomeRootModel*)model
{
    _rootModel = model;
    [self.listTableView reloadData];
}

#pragma mark - Cell Delegate
- (void)enterDappGameWithUrlStr:(NSString*)urlStr
{
    NSLog(@"%@",urlStr);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterWebviewWithUrl:)])
    {
        [self.delegate enterWebviewWithUrl:urlStr];
    }
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self p_getTableViewRowCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==0)
    {
        return 0.39*self.width;
    }
    else if ([indexPath row]==1||[indexPath row]==2)
    {
        return 170;
    }
    else if ([indexPath row]==3)
    {
        return 35;
    }
    else
    {
        return 85;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==0)
    {
        static NSString* identify = @"ONTODAppHomeBannerTableViewCell";
        ONTODAppHomeBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell)
        {
            cell = [[ONTODAppHomeBannerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault AndCellWidth:self.width reuseIdentifier:identify];
            cell.delegate = self;
        }
        
        [cell refreshCellWtihList:_rootModel.banner];
        
        return cell;
    }
    else if ([indexPath row]==1)
    {
        static NSString* identify = @"ONTODAppHomeRecommendTableViewCell";
        ONTODAppHomeRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell)
        {
            cell = [[ONTODAppHomeRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.delegate = self;
        }
        
        [cell refreshCellWtihDAppList:_rootModel.recommend];
        [cell changeTitleWithName:Localized(@"DappRecommended")];

        return cell;
    }
    else if ([indexPath row]==2)
    {
        static NSString* identify = @"ONTODAppHomeCooperationTableViewCell";
        ONTODAppHomeRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell)
        {
            cell = [[ONTODAppHomeRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.delegate = self;
        }
        
        [cell refreshCellWtihDAppList:_rootModel.cooperation];
        [cell changeTitleWithName:Localized(@"DappRooperation")];
        
        return cell;
    }
    else if ([indexPath row]==3)
    {
        
        static NSString* identify = @"ONTODAppSectionTitleTableViewCell";
        ONTODAppSectionTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell)
        {
            cell = [[ONTODAppSectionTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        return cell;
    }
    else
    {
        static NSString* identify = @"ONTODAppHomeDescribeTableViewCell";
        ONTODAppHomeDescribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell)
        {
            cell = [[ONTODAppHomeDescribeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.delegate = self;
        }
        
        NSInteger rowIndex = [indexPath row]-4;
        if (rowIndex<_rootModel.app.count)
        {
            NSArray *tmpList = _rootModel.app;
            ONTODAppHomeAppModel *model = tmpList[rowIndex];
            [cell refreshCellWtihModel:model];
        }
    
        return cell;
    }
        
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowIndex = [indexPath row]-4;
    if (rowIndex<_rootModel.app.count)
    {
        NSArray *tmpList = _rootModel.app;
        ONTODAppHomeAppModel *model = tmpList[rowIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(enterWebviewWithUrl:)])
        {
            [self.delegate enterWebviewWithUrl:model.link];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - Properties
-(UITableView*)listTableView
{
    if (!_listTableView)
    {
        _listTableView = [[UITableView alloc]initWithFrame:self.bounds];
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellEditingStyleNone;
        _listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewRefreshWithDirectionType:AndView:)])
            {
                [self.delegate tableViewRefreshWithDirectionType:ONTODAppHomeView_pullDown AndView:self];
            }
        }];
    }
    return _listTableView;
}



@end
