//
//  UIViewController+IFStyle.m
//  flow
//
//  Created by 赵弈宇 on 17/2/20.
//  Copyright © 2017年 赵弈宇. All rights reserved.
//

#import "UIViewController+IFStyle.h"

static const void *tagKey = &tagKey;

@implementation UIViewController (IFStyle)

- (NSString *)vc {
    return objc_getAssociatedObject(self, tagKey);
}

- (void)setVc:(UIViewController *)vc {
    objc_setAssociatedObject(self, tagKey, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setupControllerWithTitle:(NSString *)title {
    
    [self setupControllerWithTitle:title showBack:NO];
}

- (void)setupControllerWithTitle:(NSString *)title backTitle:(NSString *)backTitle {
    
    self.navigationItem.title = title;
    
    self.navigationItem.leftBarButtonItem = [self backItemWithTitle:backTitle image:[UIImage imageNamed:@"nav_bar_arrow_back"] action:@selector(viewBack)];
}

- (void)setupControllerWithTitle:(NSString *)title showBack:(BOOL)showBack {
    
    self.navigationItem.title = title;
    if (showBack) {
        self.navigationItem.leftBarButtonItem = [self backItemWithImage:[UIImage imageNamed:@"nav_bar_arrow_back"] action:@selector(viewBack)];
    }else{
        self.navigationItem.leftBarButtonItem = [self backItemWithImage:[UIImage imageNamed:@""] action:@selector(viewBack)];
    }
}


- (void)setupControllerWithTitle:(NSString *)title showBack:(BOOL)showBack andVC:(UIViewController*)vc{
    
    self.navigationItem.title = title;
    self.vc=vc;
    if (showBack) {
        self.navigationItem.leftBarButtonItem = [self backItemWithImage:[UIImage imageNamed:@"nav_bar_arrow_back"] action:@selector(viewBackToRoot:)];
    }
}

-(void)viewBackToRoot:(id)btn{
    
    [self.navigationController popToViewController:self.vc animated:YES];
}


- (UIViewController *)pushVCWithName:(NSString *)name params:(NSDictionary *)params animated:(BOOL)animated {
    if (!name) {
        return nil;
    }
    
    
    Class clazz = NSClassFromString(name);
    if (!clazz) {
        return nil;
    }
    id vc = [[clazz alloc] init];
    
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [vc setValue:obj forKey:key];
        }];
    }
    [self.navigationController pushViewController:vc animated:animated];
    return vc;
}

- (UIViewController *)presentVCWithName:(NSString *)name params:(NSDictionary *)params animated:(BOOL)animated inNavigationController:(BOOL)inNavigationController {
    if (!name) {
        return nil;
    }
    Class clazz = NSClassFromString(name);
    if (!clazz) {
        return nil;
    }
    
    id vc = [[clazz alloc] init];
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [vc setValue:obj forKey:key];
        }];
    }
    
    if (inNavigationController) {
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navC animated:animated completion:nil];
    }else {
        [self presentViewController:vc animated:animated completion:nil];
    }
    return vc;
}

- (UINavigationController*)myNavigationController
{
    UINavigationController* nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (id)self;
    }
    else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            nav = ((UITabBarController*)self).selectedViewController.myNavigationController;
        }
        else {
            nav = self.navigationController;
        }
    }
    return nav;
}


+ (void)setupNavigationBarStyle {
    
    /*解决导航栏颜色不一致的问题*/
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//    
//    [[UINavigationBar appearance] setTranslucent:NO];
//    [[UINavigationBar appearance] setBarTintColor:IF_BACKGROUND_COLOR];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    
//    //IOS 8闪退
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.f]}];
//    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(171, 171, 171),NSFontAttributeName:[UIFont systemFontOfSize:12.f]} forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(49, 208, 194),NSFontAttributeName:[UIFont systemFontOfSize:12.f]} forState:UIControlStateSelected];
//    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -4)];
//    
//    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(119, 119, 119)} forState:UIControlStateNormal];
    
    
}


@end
