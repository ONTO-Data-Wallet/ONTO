//
//  SLControlModel.m
//  Selfie_Living_App
//
//  Created by junyufr on 2017/4/13.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import "SLControlModel.h"
#import "LivingControlModel.h"
#import "SelfieControlModel.h"
#import "SelfieViewController.h"
#import "LivingViewController.h"


@interface SLControlModel () <selfieControlDelegate>

@property (nonatomic,strong) LivingControlModel * LModel;

@property (nonatomic,strong) SelfieControlModel * SModel;

@property (nonatomic,weak) SelfieViewController *selfieVC;

@end


@implementation SLControlModel



//单实例
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static SLControlModel *model;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        if(model == nil)
        {
            model = [super allocWithZone:zone];
        }
    });
    return model;
}





//开始
-(void)show:(id)CurrentVC
{
    //获取到控制器
    SelfieViewController *selfieVC = [[SelfieViewController alloc] init];
    selfieVC.delegate = self;//记住一定要指定代理
    //跳转
    [CurrentVC presentViewController:selfieVC animated:NO completion:nil];
}


//销毁
-(void)destroy
{
//    id CurrentVC = [self getCurrentVC];
    id CurrentVC = [self currentViewController];
    if ([CurrentVC isKindOfClass:[SelfieViewController class]]) {
        [((SelfieViewController*)CurrentVC) dismissViewControllerAnimated:NO completion:nil];
    }
    else if([CurrentVC  isKindOfClass: [LivingViewController class]])
    {
        [((LivingViewController*)CurrentVC).presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
}


//跳转
-(void)toNextViewController:(id)NextVC SLVC:(id)SLVC
{
    [SLVC presentViewController:NextVC animated:NO completion:nil];
}


//获取dat包
-(NSData *)getPackagedDat
{
    if (!_LModel) {
        _LModel = [[LivingControlModel alloc] init];
    }
    
    return [_LModel getPackagedDat];
}


//获取抓拍数组
-(NSArray *)getLivingArray
{
    if (!_LModel) {
        _LModel = [[LivingControlModel alloc] init];
    }
    
    return [_LModel getLivingArray];
}



//是否开启倒计时声音
-(void)tickPlayer:(BOOL)enabled
{
    
    if (enabled) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"switchTick"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"switchTick"];
    }
}




//设置抓拍照张数
-(void)setPictureNumber:(int)number
{
    
    if (!_LModel) {
        _LModel = [[LivingControlModel alloc] init];
    }
    
    [_LModel setPictureNumber:number];
}




-(BOOL)setTypeWithNumber:(int)number
{
    if (number > 3 || number < 1) {
        return NO;
    }
    
    if (number == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"actionNumber"];
    }
    else if(number == 2)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"actionNumber"];
    }
    else if(number == 3)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"actionNumber"];
    }
    
    return YES;
}

-(BOOL)setTypeWithDifficulty:(int)difficulty
{
    
    if ( difficulty > 3 || difficulty < 1 ) {
        return NO;
    }
    
    if (difficulty == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"actionDifficulty"];
    }
    else if (difficulty == 2)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"actionDifficulty"];
    }
    else if (difficulty == 3)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"actionDifficulty"];
    }
    
    return YES;
}


-(BOOL)setTypeWithAction:(int)action
{
    if (ACTION_EYE!=action && ACTION_MOUTH!=action && ACTION_HEAD_TOP!=action && (ACTION_EYE|ACTION_MOUTH)!=action && (ACTION_EYE|ACTION_HEAD_TOP)!=action && (ACTION_MOUTH|ACTION_HEAD_TOP)!=action && ACTION_ALL!=action){
        return NO;
    }
    
    if (action == ACTION_EYE)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectOne"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectTwo"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectThree"];
        return YES;
    }
    
    if (action == ACTION_MOUTH)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectTwo"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectOne"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectThree"];
        return YES;
    }
    
    if (action == ACTION_HEAD_TOP)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectThree"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectOne"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectTwo"];
        return YES;
    }
    
    if ((ACTION_EYE|ACTION_MOUTH) == action)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectOne"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectTwo"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectThree"];
        return YES;
    }
    
    if ((ACTION_EYE|ACTION_HEAD_TOP) == action)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectOne"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectThree"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectTwo"];
        return YES;
    }
    
    if ((ACTION_MOUTH|ACTION_HEAD_TOP) == action)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectTwo"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectThree"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"actionSelectOne"];
        return YES;
    }
    
    if (ACTION_ALL == action)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectOne"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectTwo"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"actionSelectThree"];
        return YES;
    }
    return NO;
}


//设置标题栏
-(void)setLivingTitleTxt:(NSString*)text
{
    if (!_LModel) {
        _LModel = [[LivingControlModel alloc] init];
    }
    
    [_LModel setTitleTxt:text];
}

//设置环境检测标题
-(void)setSelfieTitleTxt:(NSString *)text
{
    if (!_SModel) {
        _SModel = [[SelfieControlModel alloc] init];
    }
    
    [_SModel setTitleTxt:text];
}

//获取自拍照
-(UIImage*)getFacePhoto
{
    if (!_SModel) {
        _SModel = [[SelfieControlModel alloc] init];
    }
    
    return [_SModel getFacePhoto];
}




//代理
-(void)livingInspectOk:(id)LivingVC
{
    if([_delegate respondsToSelector:@selector(SLOnOK:result:)])
    {
        LivingControlModel *mode = [[LivingControlModel alloc] init];
        [_delegate SLOnOK:LivingVC result:mode.success];
        
    }
    
}

-(void)selfieTouchBack:(id)SelfieVC
{
    if([_delegate respondsToSelector:@selector(SLOnBack:)])
    {
        [_delegate SLOnBack:SelfieVC];
    }
    
}


//获取Window当前显示的ViewController
- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

-(UIViewController *)getCurrentVC {
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        return nil;
    }
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    
    id nextResponder = [tempView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
//
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
    }
    
    UIViewController *topVC = (UIViewController *)nextResponder;
    
    while (1) {
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        else
            break;
    }
    return topVC;
}

@end
