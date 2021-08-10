//
//  SelfieControlModel.m
//  SelfieApp
//
//  Created by junyufr on 2017/4/5.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import "SelfieControlModel.h"
#import "SelfieViewController.h"

@interface SelfieControlModel ()<selfieControlDelegate>
{
    CGRect _videoRect;
}

@property(nonatomic,strong) UIImage *Selfie;//保存自拍照
@property(nonatomic,strong) NSString *text;//标题名
@property (nonatomic,strong)NSData* jpgData;

@end


@implementation SelfieControlModel

//单实例
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static SelfieControlModel *model;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        if(model == nil)
        {
            model = [super allocWithZone:zone];
        }
    });
    return model;
}


//开始
-(void)show:(id)VC
{
    //获取到控制器
    SelfieViewController *selfieVC = [[SelfieViewController alloc] init];
    selfieVC.delegate = self;//记住一定要指定代理
    //跳转
    [VC presentViewController:selfieVC animated:NO completion:nil];
}

//销毁
-(void)destroy:(id)SelfieVC
{
    [SelfieVC dismissViewControllerAnimated:NO completion:nil];
}

//跳转
-(void)toNextViewController:(id)NextVC SelfieViewController:(id)SelfieVC
{
    [SelfieVC presentViewController:NextVC animated:NO completion:nil];
}

//返回自拍照
-(UIImage *)getFacePhoto
{
    if (_Selfie != nil) {
        return _Selfie;
    }else
    {
        return nil;
    }
}

-(void)setTitleTxt:(NSString *)text
{
    _text = text;
}

//获取标题
-(NSString *)getTitleTxt
{
    if (_text)
        return _text;
    else
        return @"环境检测";
}


//设置自拍照
-(void)setMySelfie:(UIImage *)img
{
    _Selfie = img;
}

//设置视频区域
-(void)setVideoFrame:(CGRect)rect
{
    _videoRect = rect;
}

//获取视频区域
-(CGRect)getVideoFrame
{
    if (_videoRect.size.height != 0){
        return _videoRect;
    }
    else{
        CGRect rx = [ UIScreen mainScreen ].bounds;
        return CGRectMake(50+15, 80+20+24+40-5 ,rx.size.width-100-40+10 , (rx.size.width-100-40+10)/60*77);//尺寸
    }
}


-(void)setData:(NSData *)data
{
    _jpgData = data;
}

-(NSData *)getData
{
    return self.jpgData;
}


@end
