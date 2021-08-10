//
//  ONTODAppHomeAlertView.h
//  ONTO
//
//  Created by onchain on 2019/5/22.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ONTODAppHomeAlertView;
@protocol ONTODAppHomeAlertViewDelegate <NSObject>
@optional
/** Accepte */
-(void)alertViewAcceptedBtnSlot:(ONTODAppHomeAlertView*)alertView;

@end
@interface ONTODAppHomeAlertView : UIView

+(ONTODAppHomeAlertView *)CreatWalletTipsAlertViewWithDelegate:(id<ONTODAppHomeAlertViewDelegate>)delegate;

@property (nonatomic, weak) id<ONTODAppHomeAlertViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
