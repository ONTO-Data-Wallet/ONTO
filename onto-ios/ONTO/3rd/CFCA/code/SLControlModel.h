//
//  SLControlModel.h
//  Selfie_Living_App
//
//  Created by junyufr on 2017/4/13.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LivingViewController.h"


//动作类型选择
enum eActionType
{
    ACTION_EYE = 1<<0,  //眨眼
    ACTION_MOUTH = 1<<1,  //张嘴
    ACTION_HEAD_TOP = 1<<2,  //抬头
    
    ACTION_ALL = (ACTION_EYE | ACTION_MOUTH | ACTION_HEAD_TOP),  //三个动作全选
};


@protocol SLDelegate <NSObject>

@optional

////////////////////////////////////////////////////////////////////////
//回调                                                                //
///////////////////////////////////////////////////////////////////////

//回调函数 活体检测完成
-(void)SLOnOK:(id)SLVC result:(BOOL)Result;


//回调函数 点击返回按钮
-(void)SLOnBack:(id)SLVC;



@end
@interface SLControlModel : NSObject <LivingControlDelegate>



//代理指针
@property (nonatomic,weak) id<SLDelegate> delegate;


//开始活体 （呼出检测控制器
-(void)show:(id)CurrentVC;

//销毁
-(void)destroy;

//跳转
-(void)toNextViewController:(id)NextVC SLVC:(id)SLVC;

//获取dat包
-(NSData *)getPackagedDat;

//获取抓拍数组
-(NSArray *)getLivingArray;

//获取自拍照
-(UIImage*)getFacePhoto;

//是否开启倒计时声音(开启传YES 关闭传NO)
-(void)tickPlayer:(BOOL)enabled;

//设定照片张数。范围在1-3
-(void)setPictureNumber:(int)number;

//设定细节：次数(1~3)  返回yes:设置成功  返回no:设置失败
-(BOOL)setTypeWithNumber:(int)number;

//设定难度 传参(1:简单 2:普通 3:困难)  返回yes:设置成功  返回no:设置失败
-(BOOL)setTypeWithDifficulty:(int)difficulty;

//设置动作 (参数详情见eActionType枚举类型)
-(BOOL)setTypeWithAction:(int)action;


//设置活体检测标题文字
-(void)setLivingTitleTxt:(NSString*)text;

//设置环境检测标题文字
-(void)setSelfieTitleTxt:(NSString *)text;


@end
