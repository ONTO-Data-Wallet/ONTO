//
//  SelfieControlModel.h
//  SelfieApp
//
//  Created by junyufr on 2017/4/5.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface SelfieControlModel : NSObject


//获取自拍照
-(UIImage*)getFacePhoto;

//设置标题
-(void)setTitleTxt:(NSString *)text;

//设置播放区域
-(void)setVideoFrame:(CGRect)rect;


/*
 //内部使用
 */
-(NSString*)getTitleTxt;
-(void)setMySelfie:(UIImage *)img;
-(CGRect)getVideoFrame;
-(void)setData:(NSData *)data;
-(NSData *)getData;



@end
