//
//  LivingViewController.h
//  LivingApp
//
//  Created by junyufr on 2017/4/1.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// 活体检测状态回调协议声明
@protocol JYActionDelegate <NSObject>

@required

// 接收单个动作检测状态
-(void)actionCheckCompleted:(BOOL)success;

// 接收最终检测状态
-(void)actionFinishCompleted:(BOOL)success;

@optional


// 接收需要执行指令动作
-(void)requestActionType:(int)actionType;
// 接收需要执行动作次数
-(void)requestActionCount:(int)actionCount;
// 接收当前动作幅度
-(void)responseActionRange:(int)actionRange;
// 接收总成功次数
-(void)responseTotalSuccessCount:(int)count;
// 接收总失败次数
-(void)responseTotalFailCount:(int)count;
// 接收可用时间
-(void)responseClockTime:(int)time;
// 接收动作完成的次数
-(void)responseDoneOperationCount:(int)count;
// 接收动作完成的幅度
-(void)responseDoneOperationRange:(int)range;
// 接收信息提示
-(void)responseHintMsg:(int)hint;

@end



@protocol LivingControlDelegate <NSObject>

@optional


-(void)livingInspectOk:(id)LivingVC;


@end

@interface LivingViewController : UIViewController

@property (nonatomic,weak) id <LivingControlDelegate> delegate;
@end
