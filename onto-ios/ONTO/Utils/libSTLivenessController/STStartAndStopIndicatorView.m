//
//  STSrartAndStopIndicatorView.m
//  STSilentLivenessController
//
//  Created by huoqiuliang on 16/12/7.
//  Copyright © 2016年 sensetime. All rights reserved.
//

#import "STStartAndStopIndicatorView.h"

@implementation STStartAndStopIndicatorView

static UIActivityIndicatorView *indicator = nil;
+ (void)sharedIndicatorStartAnimate {
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
        if (indicator == nil) {
            indicator =
                [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [indicator setFrame:CGRectMake(0, 0, 60, 60)];
            [indicator setBackgroundColor:[UIColor clearColor]];
            indicator.color = [UIColor colorWithRed:0 / 255.0 green:121 / 255.0 blue:255 / 255.0 alpha:1];

            [indicator setHidesWhenStopped:YES];
        }

        [indicator setCenter:[self lastWindow].center];

        if ([indicator superview] != [self lastWindow]) {
            [[self lastWindow] addSubview:indicator];
            if (![indicator isAnimating]) {
                [indicator startAnimating];
            }
        }
    }];
}

+ (void)sharedIndicatorStopAnimate {
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
        if ([indicator superview] == [self lastWindow]) {
            if ([indicator isAnimating]) {
                [indicator stopAnimating];
            }
            [indicator removeFromSuperview];
        }
    }];
}

+ (UIWindow *)lastWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))

            return window;
    }

    return [UIApplication sharedApplication].keyWindow;
}

@end
