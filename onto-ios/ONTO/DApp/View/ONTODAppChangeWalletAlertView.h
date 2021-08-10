//
//  ONTODAppChangeWalletAlertView.h
//  ONTO
//
//  Created by Apple on 2019/5/16.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ONTODAppChangeWalletAlertView;
NS_ASSUME_NONNULL_BEGIN
@protocol ONTODAppChangeWalletAlertViewDelegate <NSObject>
@optional
/** 切换钱包点击 */
-(void)walletTipsAlertChangeBtnSlot:(ONTODAppChangeWalletAlertView*)alertView;
@end
@class ONTODAppChangeWalletAlertView;

@interface ONTODAppChangeWalletAlertView : UIView

+(ONTODAppChangeWalletAlertView *)CreatWalletTipsAlertView;

@property (nonatomic, weak) id<ONTODAppChangeWalletAlertViewDelegate> delegate;
@property (nonatomic, assign)BOOL isDapp;
@end
NS_ASSUME_NONNULL_END
