//
//  ONTODAppHomeRecommendTableViewCell.m
//  ONTO
//
//  Created by onchain on 2019/5/20.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHomeRecommendTableViewCell.h"
#import "ONTODAppHomeRecommendCollecViewCell.h"
#import "ONTODAppHomeAppModel.h"
#import <Masonry/Masonry.h>
#import <YYKit.h>

@interface ONTODAppHomeRecommendTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSArray         *_modelList;
}
@property(nonatomic,strong)UILabel                       *titleLabel;
@property(nonatomic,strong)UICollectionViewFlowLayout    *collectViewFlowLayout;
@property(nonatomic,strong)UICollectionView              *collectionView;
@end
@implementation ONTODAppHomeRecommendTableViewCell
#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

#pragma mark - Layout
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
}

#pragma mark - Private
-(void)p_initUI
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
}

#pragma mark - Public
-(void)refreshCellWtihDAppList:(NSArray*)list
{
    _modelList = list;
    [self.collectionView reloadData];
}

-(void)changeTitleWithName:(NSString*)str
{
    self.titleLabel.text = str;
}

#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _modelList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75,120);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ONTODAppHomeRecommendCollecViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Recommend_Cell" forIndexPath:indexPath];
    if ([indexPath row]<_modelList.count)
    {
        ONTODAppHomeAppModel *model = _modelList[[indexPath row]];
        [cell refreshCollectCellModel:model];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ONTODAppHomeAppModel *model = _modelList[[indexPath row]];
    
    NSString *urlStr = model.link;
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterDappGameWithUrlStr:)])
    {
        [self.delegate enterDappGameWithUrlStr:urlStr];
    }
}

#pragma mark - Properties
-(UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#677578"];
        _titleLabel.text = @"推荐";
    }
    return _titleLabel;
}

-(UICollectionViewFlowLayout*)collectViewFlowLayout
{
    if (!_collectViewFlowLayout)
    {
        _collectViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectViewFlowLayout.minimumInteritemSpacing = 0;
        _collectViewFlowLayout.minimumLineSpacing = 15;
        _collectViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _collectViewFlowLayout;
}

-(UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectViewFlowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ONTODAppHomeRecommendCollecViewCell class] forCellWithReuseIdentifier:@"Recommend_Cell"];
    }
    return _collectionView;
}

@end
