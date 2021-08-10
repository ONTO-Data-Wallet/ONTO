//
//  ONTODAppHomeBannerTableViewCell.m
//  ONTO
//
//  Created by onchain on 2019/5/20.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "ONTODAppHomeBannerTableViewCell.h"
#import "NOTOScrollBannerView.h"
#import "ONTODAppHomeBannerModel.h"
#define weakify(var) __weak typeof(var) AHKWeak_##var = var;
#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = AHKWeak_##var; \
_Pragma("clang diagnostic pop")

@interface ONTODAppHomeBannerTableViewCell ()
{
    CGFloat         _rowWidth;
    NSArray         *_modelList;
}
@property(nonatomic,strong)NOTOScrollBannerView         *bannerView;
@end
@implementation ONTODAppHomeBannerTableViewCell
#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style AndCellWidth:(CGFloat)cellWidth reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _rowWidth = cellWidth;
        [self p_initSetting];
        [self p_initUI];
    }
    return self;
}

#pragma mark - Private
-(void)p_initSetting
{
    self.height = 0.39*self.width;
}

-(void)p_initUI
{
    [self addSubview:self.bannerView];
}

#pragma mark - Public
-(void)refreshCellWtihList:(NSArray*)list
{
    _modelList = list;
    self.bannerView.data = _modelList;
}

#pragma mark - Properties
-(NOTOScrollBannerView*)bannerView
{
    if (!_bannerView)
    {
        _bannerView = [NOTOScrollBannerView initWithFrame:CGRectMake(0, 0, _rowWidth, 0.39*_rowWidth) imageSpacing:0 imageWidth:_rowWidth];
        _bannerView.autoScroll = YES;
        _bannerView.showPageControl = NO;
        _bannerView.placeHolderImage = [UIImage imageNamed:@""];
        weakify(self);
        _bannerView.clickImageBlock = ^(NSInteger currentIndex) {
            strongify(self);
            NSLog(@"%lu",currentIndex);
            if (currentIndex<self.bannerView.data.count)
            {
                ONTODAppHomeBannerModel *Model = self.bannerView.data[currentIndex];
                NSString *urlStr = Model.link;
                if (self.delegate && [self.delegate respondsToSelector:@selector(enterDappGameWithUrlStr:)])
                {
                    [self.delegate enterDappGameWithUrlStr:urlStr];
                }
            }
        };
    }
    return _bannerView;
}

@end
