//
//  LivingControlModel.m
//  LivingApp
//
//  Created by junyufr on 2017/4/6.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import "LivingControlModel.h"
#import "LivingViewController.h"

@interface LivingControlModel ()<LivingControlDelegate>

@property(nonatomic,strong) NSArray *LivingArray;//保存抓拍照
@property (nonatomic, strong) NSData* packagedData;// 打包待上传数据
@property(nonatomic,strong) NSString *text;//标题名

@property (nonatomic,assign) int number;

@end


@implementation LivingControlModel



//单实例
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static LivingControlModel *model;
    
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
    LivingViewController *LivingVC = [[LivingViewController alloc] init];
    LivingVC.delegate = self;//记住一定要指定代理
    //跳转
    [VC presentViewController:LivingVC animated:NO completion:nil];
}


//销毁
-(void)destroy:(id)LivingVC
{
    [LivingVC dismissViewControllerAnimated:NO completion:nil];
}

//跳转
-(void)toNextViewController:(id)NextVC LivingViewController:(id)LivingVC
{
    [LivingVC presentViewController:NextVC animated:NO completion:nil];
}


//设置标题栏
-(void)setTitleTxt:(NSString*)txt
{
    _text = txt;
}

//获取标题
-(NSString *)getTitleTxt
{
    if (_text)
        return _text;
    else
        return @"活体检测";
}

//设置抓拍照张数
-(void)setPictureNumber:(int)number
{
    if (number>=1&&number<=3) {
        if (number == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"PIC_NUNBER"];
        }
        else if (number == 2) {
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"PIC_NUNBER"];
        }
        else if (number == 3) {
            [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"PIC_NUNBER"];
        }
    }
    else
        _number = 0;
}



//获取抓拍数组
-(NSArray *)getLivingArray
{
    return _LivingArray;
}

//设置抓拍数组
-(void)setLivingArray:(NSArray*)array
{
    _LivingArray = array;
}

//设置data包
-(void)setPackagedDat:(NSData *)packagedat
{
    _packagedData = packagedat;
}

//获取data包
-(NSData *)getPackagedDat
{
    return _packagedData;
}




//获取抓拍照张数
-(int)getPictureNumber
{
    NSString *picNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"PIC_NUNBER"];
    
    if (picNumber) {
        if ([picNumber  isEqual: @"1"]) {
            _number = 0;
        }
        else if ([picNumber  isEqual: @"2"]) {
            _number = 1;
        }
        else if ([picNumber  isEqual: @"3"]) {
            _number = 2;
        }
    }else
        _number = 0;
    
    return _number;
}



@end
