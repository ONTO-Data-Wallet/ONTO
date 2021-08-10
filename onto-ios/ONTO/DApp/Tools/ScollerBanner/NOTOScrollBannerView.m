//
//  VIPScrollBannerView.m
//  VIPStudent
//
//  Created by Wen xu on 2018/3/2.
//  Copyright © 2018年 VIPractice. All rights reserved.
//

#import "NOTOScrollBannerView.h"
#import "UIImageView+WebCache.h"
#import "ONTODAppHomeBannerModel.h"

#define ScrollView_Width self.mainScrollView.frame.size.width
#define ScrollView_Height self.mainScrollView.frame.size.height
@interface NOTOScrollBannerView()<UIScrollViewDelegate>
{
//    NSArray                 *_defaultArr;
}
@property(nonatomic,strong)UIPageControl                 *pageControl;
@property(nonatomic,strong)UIScrollView                  *mainScrollView;
@property(nonatomic,strong)UIImageView                   *leftImageView;
@property(nonatomic,strong)UIImageView                   *centerImageView;
@property(nonatomic,strong)UIImageView                   *rightImageView;
@property(nonatomic,assign)NSUInteger                    currentImageIndex;
@property(nonatomic,assign)CGFloat                       imgWidth;
@property(nonatomic,assign)CGFloat                       itemMargnPadding;
@property(nonatomic,assign)NSInteger                     imgCount;
@property(nonatomic,weak)NSTimer                         *timer;
@end
@implementation NOTOScrollBannerView

+(instancetype)initWithFrame:(CGRect)frame
                imageSpacing:(CGFloat)imageSpacing
                  imageWidth:(CGFloat)imageWidth
{
    NOTOScrollBannerView *scrollView = [[self alloc] initWithFrame:frame];
    scrollView.imgWidth = imageWidth;
    scrollView.itemMargnPadding = imageSpacing;
    return scrollView;
}

+(instancetype)initWithFrame:(CGRect)frame
                imageSpacing:(CGFloat)imageSpacing
                  imageWidth:(CGFloat)imageWidth
                        data:(NSArray *)data
{
    NOTOScrollBannerView *scrollView = [[self alloc] initWithFrame:frame];
    scrollView.imgWidth = imageWidth;
    scrollView.itemMargnPadding = imageSpacing;
    scrollView.data = data;
    return scrollView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imgWidth = ScrollView_Width;
        [self p_initSetting];
        [self p_initUI];
    }
    return self;
}

#pragma mark - Properties
-(void)p_initSetting
{
    _initAlpha = 1;
    _autoScrollTimeInterval = 2.5;
    _imageHeightPoor = 0;
    self.otherPageControlColor = [UIColor grayColor];
    self.curPageControlColor = [UIColor whiteColor];
    _showPageControl = YES;
    _hidesForSinglePage = YES;
    _autoScroll = YES;
    self.data = [NSArray array];

    self.userInteractionEnabled = YES;
}

-(void)p_initUI
{
    [self addSubview:self.mainScrollView];
    //图片视图:左边
    [self.mainScrollView addSubview:self.leftImageView];
    
    //图片视图:中间
    [self.mainScrollView addSubview:self.centerImageView];
    
    //图片视图:右边
    [self.mainScrollView addSubview:self.rightImageView];
    
    [self updateViewFrameSetting];
}

- (void)setImageHeightPoor:(CGFloat)imageHeightPoor
{
    _imageHeightPoor = imageHeightPoor;
    [self updateViewFrameSetting];
}

//创建页码指示器
-(void)createPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview];
    if (self.data.count == 0) return;
    if ((self.data.count == 1) && self.hidesForSinglePage) return;
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width - 200)/2, ScrollView_Height - 30, 200, 30)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = self.data.count;
    [self addSubview:_pageControl];
    _pageControl.pageIndicatorTintColor = self.otherPageControlColor;
    _pageControl.currentPageIndicatorTintColor = self.curPageControlColor;
    
    _pageControl.hidden = !_showPageControl;
}

#pragma mark - 设置初始尺寸
-(void)updateViewFrameSetting
{
    //设置偏移量
    self.mainScrollView.contentOffset = CGPointMake(ScrollView_Width, 0.0);
    //图片视图:左边
    self.leftImageView.frame = CGRectMake(self.itemMargnPadding/2, self.imageHeightPoor, self.imgWidth, ScrollView_Height-self.imageHeightPoor*2);
    //图片视图:中间
    self.centerImageView.frame = CGRectMake(ScrollView_Width + self.itemMargnPadding/2, 0.0, self.imgWidth, ScrollView_Height);
    //图片视图:右边
    self.rightImageView.frame = CGRectMake(ScrollView_Width * 2.0 + self.itemMargnPadding/2, self.imageHeightPoor, self.imgWidth, ScrollView_Height-self.imageHeightPoor*2);
    self.mainScrollView.contentSize = CGSizeMake(ScrollView_Width * 3, ScrollView_Height);
}

- (void)setImageRadius:(CGFloat)imageRadius
{
    _imageRadius = imageRadius;
}

- (void)setData:(NSArray *)data
{
    if (data.count < _data.count)
    {
        [_mainScrollView setContentOffset:CGPointMake(ScrollView_Width, 0) animated:NO];
    }
    _data = data;
    self.currentImageIndex = 0;
    self.imgCount = data.count;
    self.pageControl.numberOfPages = self.imgCount;
    [self setInfoByCurrentImageIndex:self.currentImageIndex];
    
    if (data.count != 1)
    {
        self.mainScrollView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    }
    else
    {
        [self invalidateTimer];
        self.mainScrollView.scrollEnabled = ScrollView_Width < self.frame.size.width ?YES : NO;
    }
    
    [self createPageControl];
}

- (void)setInfoByCurrentImageIndex:(NSUInteger)currentImageIndex
{
    if(self.imgCount == 0)
    {
        return;
    }

    ONTODAppHomeBannerModel *cModel = _data[currentImageIndex];
    
//    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:cModel.image] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached];

    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:cModel.image] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        NSLog(@"%@", error);
        
    }];
    
    NSInteger leftIndex = (unsigned long)((_currentImageIndex - 1 + self.imgCount) % self.imgCount);
    ONTODAppHomeBannerModel *lModel = _data[leftIndex];
//    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:lModel.image]];
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:lModel.image] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached];

    NSInteger rightIndex = (unsigned long)((_currentImageIndex + 1) % self.imgCount);
    ONTODAppHomeBannerModel *rModel = _data[rightIndex];
//    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:rModel.image]];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:rModel.image] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached];
    
    _pageControl.currentPage = currentImageIndex;
}

- (void)reloadImage
{
    if(self.imgCount == 0)
      return;
    
    CGPoint contentOffset = [self.mainScrollView contentOffset];
    if (contentOffset.x > ScrollView_Width)
    {
        //向左滑动
        _currentImageIndex = (_currentImageIndex + 1) % self.imgCount;
    }
    else if (contentOffset.x < ScrollView_Width)
    {
        //向右滑动
        _currentImageIndex = (_currentImageIndex - 1 + self.imgCount) % self.imgCount;
    }
    
    [self setInfoByCurrentImageIndex:_currentImageIndex];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll)
    {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadImage];
    [self.mainScrollView setContentOffset:CGPointMake(ScrollView_Width, 0) animated:NO];
    self.pageControl.currentPage = self.currentImageIndex;
//    if (self.clickImageBlock)
//    {
//        self.clickImageBlock(self.currentImageIndex);
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll)
    {
        [self createTimer];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark -- action
-(void)leftTapGes
{
    
}

-(void)rightTapGes
{
    
}

-(void)centerTapGes
{
    
}

-(void)createTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)automaticScroll
{
    if (0 == _imgCount) return;
    if(self.mainScrollView.scrollEnabled == NO) return;
    [self.mainScrollView setContentOffset:CGPointMake(ScrollView_Width*2, 0.0) animated:YES];
}

#pragma mark -- properties
-(void)setItemMargnPadding:(CGFloat)itemMargnPadding
{
    _itemMargnPadding = itemMargnPadding;
    self.mainScrollView.frame = CGRectMake((ScrollView_Width - (self.imgWidth + itemMargnPadding))/2, 0, self.imgWidth + itemMargnPadding, ScrollView_Height);
    [self updateViewFrameSetting];
}

-(void)setCurPageControlColor:(UIColor *)curPageControlColor
{
    _curPageControlColor = curPageControlColor;
    _pageControl.currentPageIndicatorTintColor = curPageControlColor;
}

-(void)setOtherPageControlColor:(UIColor *)otherPageControlColor
{
    _otherPageControlColor = otherPageControlColor;
    _pageControl.pageIndicatorTintColor = otherPageControlColor;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.autoScroll];
}

-(void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    if (_autoScroll)
    {
        [self createTimer];
    }
}

-(void)setPlaceHolderImage:(UIImage *)placeHolderImage
{
    _placeHolderImage = placeHolderImage;
}

-(void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    self.pageControl.hidden = !_showPageControl;
}

- (void)setInitAlpha:(CGFloat)initAlpha
{
    _initAlpha = initAlpha;
}

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView)
    {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.clipsToBounds = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapImageView)];
        [_mainScrollView addGestureRecognizer:tap];
    }
    return _mainScrollView;
}

#pragma mark - life circles
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
    {
        [self invalidateTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc
{
    _mainScrollView.delegate = nil;
    [self invalidateTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.itemMargnPadding > 0)
    {
        CGFloat currentX = scrollView.contentOffset.x - ScrollView_Width;
        CGFloat bl = currentX/ScrollView_Width*(1-self.initAlpha);
        CGFloat variableH = currentX/ScrollView_Width*self.imageHeightPoor*2;
        if (currentX > 0)
        {
            //左滑
            self.centerImageView.alpha = 1 - bl;
            self.rightImageView.alpha = self.initAlpha + bl;
            self.centerImageView.height = ScrollView_Height - variableH;
            self.centerImageView.y = currentX/ScrollView_Width*self.imageHeightPoor;
            self.rightImageView.height = ScrollView_Height-2*self.imageHeightPoor+variableH;
            self.rightImageView.y = self.imageHeightPoor-currentX/ScrollView_Width*self.imageHeightPoor;
        }
        else if (currentX < 0)
        {
            // 右滑
            self.centerImageView.alpha = 1 + bl;
            self.leftImageView.alpha = self.initAlpha - bl;
            self.centerImageView.height = ScrollView_Height + variableH;
            self.centerImageView.y = -currentX/ScrollView_Width*self.imageHeightPoor;
            self.leftImageView.height = ScrollView_Height-2*self.imageHeightPoor-variableH;
            self.leftImageView.y = self.imageHeightPoor+currentX/ScrollView_Width*self.imageHeightPoor;
        }
        else
        {
            self.leftImageView.alpha = self.initAlpha;
            self.centerImageView.alpha = 1;
            self.rightImageView.alpha = self.initAlpha;
            self.leftImageView.height = ScrollView_Height-2*self.imageHeightPoor;
            self.centerImageView.height = ScrollView_Height;
            self.rightImageView.height = ScrollView_Height-2*self.imageHeightPoor;
            self.leftImageView.y = self.imageHeightPoor;
            self.centerImageView.y = 0;
            self.rightImageView.y = self.imageHeightPoor;
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return _mainScrollView;
}

//图片的点击
-(void)p_tapImageView
{
    NSLog(@"%lu", self.currentImageIndex);
    if (self.clickImageBlock)
    {
        self.clickImageBlock(self.currentImageIndex);
    }
}

#pragma mark - Properties
-(UIImageView*)leftImageView
{
    if (!_leftImageView)
    {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

-(UIImageView*)centerImageView
{
    if (!_centerImageView)
    {
        _centerImageView = [[UIImageView alloc] init];
    }
    return _centerImageView;
}

-(UIImageView*)rightImageView
{
    if (!_rightImageView)
    {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

@end
