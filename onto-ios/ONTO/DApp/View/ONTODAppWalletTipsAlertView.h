//
//  ONTODAppWalletTipsAlertView.h
//  ONTO
//
//  Created by onchain on 2019/5/14.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONTODAppWalletTipsAlertView;
NS_ASSUME_NONNULL_BEGIN
@protocol ONTODAppWalletTipsAlertViewDelegate <NSObject>
@optional
/** 创建钱包点击 */
-(void)walletTipsAlertCreateBtnSlot:(ONTODAppWalletTipsAlertView*)alertView;
/** 导入钱包点击 */
-(void)walletTipsAlertInputBtnSlot:(ONTODAppWalletTipsAlertView*)alertView;
@end
@class ONTODAppWalletTipsAlertView;

@interface ONTODAppWalletTipsAlertView : UIView

+(ONTODAppWalletTipsAlertView *)CreatWalletTipsAlertView;

@property (nonatomic, weak) id<ONTODAppWalletTipsAlertViewDelegate> delegate;
@property (nonatomic, assign)BOOL isDapp;
@end
NS_ASSUME_NONNULL_END
