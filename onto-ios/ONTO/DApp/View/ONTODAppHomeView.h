//
//  ONTODAppHomeView.h
//  ONTO
//
//  Created by onchain on 2019/5/20.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONTODAppHomeView;
@class ONTODAppHomeRootModel;
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AONTODAppHomeViewDirectionType) {
    ONTODAppHomeView_PullUp        = 0,
    ONTODAppHomeView_pullDown      = 1
};
@protocol ONTODAppHomeViewDelegate <NSObject>

- (void)tableViewRefreshWithDirectionType:(AONTODAppHomeViewDirectionType)type AndView:(ONTODAppHomeView*)view;

- (void)enterWebviewWithUrl:(NSString*)urlStr;

@end
@interface ONTODAppHomeView : UIView

@property(nonatomic,weak)id<ONTODAppHomeViewDelegate>  delegate;

//Refresh-List
-(void)stopRefreshWithisMore:(BOOL)isMore;

//Refresh-Model
-(void)refreshTableViewWithModel:(ONTODAppHomeRootModel*)model;

@end

NS_ASSUME_NONNULL_END
