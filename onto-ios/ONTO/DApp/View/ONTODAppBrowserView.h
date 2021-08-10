//
//  ONTODAppBrowserView.h
//  ONTO
//
//  Created by onchain on 2019/5/9.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ONTODAppBrowserViewDelegate <NSObject>

-(void)ONTODAppBrowserEnterWebWithUrlStr:(NSString*)urlStr;

@end
@interface ONTODAppBrowserView : UIView

@property(nonatomic,weak)id<ONTODAppBrowserViewDelegate>     delegate;

@end

NS_ASSUME_NONNULL_END
