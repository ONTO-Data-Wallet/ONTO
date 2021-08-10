//
//  VIPScrollBannerView.h
//  VIPStudent
//
//  Created by Wen xu on 2018/3/2.
//  Copyright © 2018年 VIPractice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Banner.h"

@interface NOTOScrollBannerView : UIView
/**
 图片间有间距  又要有翻页效果
 @param imageSpacing 图片间 间距
 @param imageWidth 图片宽
 */
+(instancetype)initWithFrame:(CGRect)frame
                imageSpacing:(CGFloat)imageSpacing
                  imageWidth:(CGFloat)imageWidth;

/**
 图片间有间距  又要有翻页效果
 @param imageSpacing 图片间 间距
 @param imageWidth 图片宽
 @param data 数据
 */
+(instancetype)initWithFrame:(CGRect)frame
                imageSpacing:(CGFloat)imageSpacing
                  imageWidth:(CGFloat)imageWidth
                        data:(NSArray *)data;

//点击中间图片的回调
@property(nonatomic,copy)void          (^clickImageBlock)(NSInteger currentIndex);
//图片的圆角半径
@property(nonatomic,assign)CGFloat     imageRadius;
//数据源
@property(nonatomic,strong)NSArray     *data;
//图片高度差 默认0
@property(nonatomic,assign)CGFloat     imageHeightPoor;
//初始alpha默认1
@property(nonatomic,assign)CGFloat     initAlpha;
//是否显示分页控件
@property(nonatomic,assign)BOOL        showPageControl;
//当前小圆点颜色
@property(nonatomic,retain)UIColor     *curPageControlColor;
//其余小圆点颜色
@property(nonatomic,retain)UIColor     *otherPageControlColor;
//占位图
@property(nonatomic,strong)UIImage     *placeHolderImage;
//是否在只有一张图时隐藏pagecontrol，默认为YES
@property(nonatomic,assign)BOOL        hidesForSinglePage;
//自动滚动间隔时间,默认2s
@property(nonatomic,assign)CGFloat     autoScrollTimeInterval;
//是否自动滚动,默认Yes
@property(nonatomic,assign)BOOL        autoScroll;
@end
