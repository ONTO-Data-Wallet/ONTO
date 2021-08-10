//
//  LivingControlModel.h
//  LivingApp
//
//  Created by junyufr on 2017/4/6.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface LivingControlModel : NSObject


@property (nonatomic) BOOL success;//是否通过本地检测



//设定照片张数。范围在1-3
-(void)setPictureNumber:(int)number;


-(void)setTitleTxt:(NSString *)txt;

//获取抓拍数组
-(NSArray *)getLivingArray;

//获取dat包
-(NSData *)getPackagedDat;



/*
 内部使用
 */
-(void)setLivingArray:(NSArray*)array;
-(void)setPackagedDat:(NSData *)packagedat;
-(int)getPictureNumber;
-(NSString *)getTitleTxt;

@end
