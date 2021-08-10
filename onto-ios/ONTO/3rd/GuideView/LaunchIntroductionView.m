//
//  LaunchIntroductionView.m
//  ZYGLaunchIntroductionDemo
//
//  Created by ZhangYunguang on 16/4/7.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "LaunchIntroductionView.h"
#import "Config.h"
#import <EllipsePageControl/EllipsePageControl.h>

@interface LaunchIntroductionView ()<UIScrollViewDelegate,EllipsePageControlDelegate>
{
    UIScrollView  *launchScrollView;
    EllipsePageControl *page;
    
    NSMutableArray * imageArr;
    
}

@end

@implementation LaunchIntroductionView
NSArray *images;
BOOL isScrollOut;//在最后一页再次滑动是否隐藏引导页
CGRect enterBtnFrame;
NSString *enterBtnImage;
static LaunchIntroductionView *launch = nil;
NSString *storyboard;
NSArray *firstArray;
NSArray *secondArray;


#pragma mark - 创建对象-->>不带button
+(instancetype)sharedWithImages:(NSArray *)imageNames First:(NSArray *)firstTitles Second:(NSArray *)secondTitles{
    images = imageNames;
    firstArray = firstTitles;
    secondArray = secondTitles;
    isScrollOut = YES;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}

#pragma mark - 创建对象-->>带button
+(instancetype)sharedWithImages:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame{
    images = imageNames;
    isScrollOut = NO;
    enterBtnFrame = frame;
    enterBtnImage = buttonImageName;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 用storyboard创建的项目时调用，不带button
+ (instancetype)sharedWithStoryboardName:(NSString *)storyboardName images:(NSArray *)imageNames {
    images = imageNames;
    storyboard = storyboardName;
    isScrollOut = YES;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 用storyboard创建的项目时调用，带button
+ (instancetype)sharedWithStoryboard:(NSString *)storyboardName images:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame{
    images = imageNames;
    isScrollOut = NO;
    enterBtnFrame = frame;
    storyboard = storyboardName;
    enterBtnImage = buttonImageName;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addObserver:self forKeyPath:@"currentColor" options:NSKeyValueObservingOptionNew context:nil];
//        [self addObserver:self forKeyPath:@"nomalColor" options:NSKeyValueObservingOptionNew context:nil];
        if ([self isFirstLauch]) {
            UIStoryboard *story;
            if (storyboard) {
                story = [UIStoryboard storyboardWithName:storyboard bundle:nil];
            }
            [self addImages];
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            if (story) {
                UIViewController * vc = story.instantiateInitialViewController;
                window.rootViewController = vc;
                [vc.view addSubview:self];
            }else {
                [window addSubview:self];
            }
            
        }else{
            [[UIApplication sharedApplication]setStatusBarHidden:NO];
            [self removeFromSuperview];
        }
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL )isFirstLauch{
//    return YES;
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录
    if (version == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //移除keychain
           [Common removeKeyChain];
        [Common deleteEncryptedContent:APP_ACCOUNT];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - 添加引导页图片
-(void)addImages{
//    self.currentColor = [UIColor blueColor];
    [self createScrollView];
}
#pragma mark - 创建滚动视图
-(void)createScrollView{
    launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launchScrollView.showsHorizontalScrollIndicator = NO;
    launchScrollView.bounces = NO;
    launchScrollView.pagingEnabled = YES;
    launchScrollView.delegate = self;
    launchScrollView.contentSize = CGSizeMake(kScreen_width * 3, kScreen_height);
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [self addSubview:launchScrollView];
    
    for (int i =0; i<3; i++) {
        UIImageView * shadowImage = [[UIImageView alloc] init];
        shadowImage.image = [UIImage imageNamed:@"introduction shadow"];
        [launchScrollView addSubview:shadowImage];
        
        UIImageView * rightImage = [[UIImageView alloc]init];
        rightImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"introduction_%dR",i+1]];
        [launchScrollView addSubview:rightImage];
        
        UIImageView * leftImage = [[UIImageView alloc]init];
        leftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"introduction_%dL",i+1]];
        [launchScrollView addSubview:leftImage];
        
        UILabel * topTitle = [[UILabel alloc]init];
        topTitle.textAlignment = NSTextAlignmentCenter;
        topTitle.numberOfLines = 0;
        NSString * topString = [NSString stringWithFormat:@"Introduce_%d_top",i+1];
        topTitle.text = Localized(topString);
        topTitle.font = [UIFont systemFontOfSize:26 weight:UIFontWeightMedium];
        [launchScrollView addSubview:topTitle];
        
        UILabel * topContent = [[UILabel alloc]init];
        topContent.numberOfLines = 0;
        NSString * topContentString = [NSString stringWithFormat:@"Introduce_%d_content",i+1];
        topContent.text = Localized(topContentString);
        topContent.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [topContent changeSpace:3 wordSpace:0];
        topContent.alpha = 0.6;
        topContent.textAlignment = NSTextAlignmentCenter;
        [launchScrollView addSubview:topContent];
        
        NSLog(@"SCALE_H=%f",SCALE_H);
        [shadowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(launchScrollView).offset( 74*SCALE_W + kScreenWidth*i);
            make.width.mas_offset(230*SCALE_W/SCALE_H);
            make.height.mas_offset(43*SCALE_W/SCALE_H);
            make.top.equalTo(launchScrollView).offset(414*SCALE_W/SCALE_H -LL_TopHeight);
        }];
        
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(launchScrollView).offset(110*SCALE_W + kScreenWidth*i);
            if (i == 0) {
                make.width.mas_offset(110*SCALE_W/SCALE_H);
                make.height.mas_offset(257*SCALE_W/SCALE_H);
            }else if (i == 1){
                make.width.mas_offset(184*SCALE_W/SCALE_H);
                make.height.mas_offset(256*SCALE_W/SCALE_H);
            }else{
                make.width.mas_offset(108*SCALE_W/SCALE_H);
                make.height.mas_offset(256*SCALE_W/SCALE_H);
            }
            
            make.top.equalTo(launchScrollView).offset(185*SCALE_W/SCALE_H -LL_TopHeight);
        }];
        
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i == 0) {
                make.left.equalTo(launchScrollView).offset(185*SCALE_W);
                make.width.mas_offset(98*SCALE_W/SCALE_H);
                make.height.mas_offset(159*SCALE_W/SCALE_H);
                make.top.equalTo(launchScrollView).offset(155*SCALE_W/SCALE_H -LL_TopHeight);
            }else if (i == 1){
                make.left.equalTo(launchScrollView).offset(140*SCALE_W+ kScreenWidth);
                make.width.mas_offset(181*SCALE_W/SCALE_H );
                make.height.mas_offset(131*SCALE_W/SCALE_H);
                make.top.equalTo(launchScrollView).offset(144*SCALE_W/SCALE_H -LL_TopHeight);
            }else{
                make.left.equalTo(launchScrollView).offset(53*SCALE_W+ kScreenWidth*2);
                make.width.mas_offset(255*SCALE_W/SCALE_H);
                make.height.mas_offset(140*SCALE_W/SCALE_H);
                make.top.equalTo(launchScrollView).offset(117*SCALE_W/SCALE_H -LL_TopHeight);
            }
        }];
        
        [topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(launchScrollView).offset(25*SCALE_W + kScreenWidth*i);
            make.width.mas_offset(kScreenWidth - 50*SCALE_W);
            make.top.equalTo(shadowImage.mas_bottom).offset(50*SCALE_W/SCALE_H);
        }];
        
        [topContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(launchScrollView).offset(25*SCALE_W + kScreenWidth*i);
            make.width.mas_offset(kScreenWidth - 50*SCALE_W);
            make.top.equalTo(topTitle.mas_bottom).offset(20*SCALE_W/SCALE_H);
        }];
        
        if (i == 2) {
            UIButton *comfirmBtn = [[UIButton alloc]init];
            [comfirmBtn setTitle:Localized(@"IntroduceStart") forState:UIControlStateNormal];
            comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
            [comfirmBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            comfirmBtn.layer.borderColor = [[UIColor blackColor] CGColor];
            comfirmBtn.layer.borderWidth = 2;
            comfirmBtn.layer.cornerRadius = 5;
            [comfirmBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [launchScrollView addSubview:comfirmBtn];
            
            [comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(launchScrollView.mas_left).offset(kScreenWidth*2 +127*SCALE_W);
                make.width.mas_offset(kScreenWidth - 127*2*SCALE_W);
                make.top.equalTo(topContent.mas_bottom).offset(40*SCALE_W/SCALE_H);
                make.height.mas_offset(39*SCALE_W/SCALE_H);
            }];
        }
        
    }
    
    
    page = [[EllipsePageControl alloc] init];//WithFrame:CGRectMake(kScreen_width/3, kScreen_height - 78, kScreen_width/3, 5)];
    if (KIsiPhoneX) {
        page.frame =CGRectMake(kScreen_width/3, kScreen_height - 60-34, kScreen_width/3, 5);
    }else if (KIsiPhone5){
        page.frame =CGRectMake(kScreen_width/3, kScreen_height - 20, kScreen_width/3, 5);
    } else{
//        page.frame =CGRectMake(kScreen_width/3, kScreen_height - 60/SCALE_H, kScreen_width/3, 5);
       page.frame = CGRectMake(kScreen_width/3, kScreen_height - 60/SCALE_H+20, kScreen_width/3, 5);
    }
    page.numberOfPages = 3;//images.count;
//    page.backgroundColor = [UIColor clearColor];
    page.currentPage = 0;
    page.otherColor=[UIColor colorWithHexString:@"#F2F2F2"];
    page.currentColor=[UIColor colorWithHexString:@"#000000"];
    page.delegate=self;
    [self addSubview:page];
}
#pragma mark - 进入按钮
-(void)enterBtnClick{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];

    [self hideGuidView];
}

#pragma mark - 隐藏引导页
-(void)hideGuidView{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
        
    }];
}
#pragma mark - scrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;

//    if (cuttentIndex == 0) {
//
//        if ([self isScrolltoLeft:scrollView]) {
//
//       UIImageView *imageView1 = (UIImageView *)[self viewWithTag:11];
//        NSMutableArray *imageArr = [NSMutableArray array];
//            [imageArr removeAllObjects];
//        for (NSInteger j=10; j<47; j++) {
//
//            NSString * imageStr = [NSString stringWithFormat:@"1动画_000%ld",j];
//
//            [imageArr addObject:[UIImage imageNamed:imageStr]];
//        }
//
//        imageView1.animationImages = imageArr;
//        imageView1.animationDuration = 2.0;
//        imageView1.animationRepeatCount = 1;
//        [imageView1 startAnimating];
//        }
//    }
//
//    if (cuttentIndex == 1) {
//
//        if ([self isScrolltoLeft:scrollView]) {
//
//            UIImageView *imageView2 = (UIImageView *)[self viewWithTag:12];
//            NSMutableArray *imageArr = [NSMutableArray array];
//             [imageArr removeAllObjects];
//            for (NSInteger j=10; j<47; j++) {
//
//                NSString * imageStr = [NSString stringWithFormat:@"1动画_000%ld",j];
//                [imageArr addObject:[UIImage imageNamed:imageStr]];
//
//            }
//
//            imageView2.animationImages = imageArr;
//            imageView2.animationDuration = 2.0;
//            imageView2.animationRepeatCount = 1;
//            [imageView2 startAnimating];
//        }
//    }
    
    
//    if (cuttentIndex == images.count - 1) {
//        if ([self isScrolltoLeft:scrollView]) {
//            if (!isScrollOut) {
//                return ;
//            }
//            [[UIApplication sharedApplication]setStatusBarHidden:NO];
//            [self hideGuidView];
//        }
//    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == launchScrollView) {
        int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
        page.currentPage = cuttentIndex;
    }
}
#pragma mark - 判断滚动方向
-(BOOL )isScrolltoLeft:(UIScrollView *) scrollView{
    //返回YES为向左反动，NO为右滚动
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - KVO监测值的变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentColor"]) {
//        page.currentPageIndicatorTintColor = self.currentColor;
    }
    if ([keyPath isEqualToString:@"nomalColor"]) {
//        page.pageIndicatorTintColor = self.nomalColor;
    }
}

@end
