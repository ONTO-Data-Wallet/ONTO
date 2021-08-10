//
//  ShareView.m
//  天巢网
//
//  Created by 赵贺 on 15/11/20.
//  Copyright © 2015年 tangjp. All rights reserved.
//

#import "ShareView.h"
#import "Config.h"

/*   <!-- 应用规范字体大小 -->*/
#define  text_size_big_1    21
#define  text_size_big_2    20
#define  text_size_big_3    19
#define  text_size_middle_1 18
#define  text_size_middle_2 17
#define  text_size_middle_3 15
#define  text_size_little_1 14
#define  text_size_little_2 13
#define  text_size_little_3 12
#define  text_size_little_4 10
#define  text_size_other    16

#define  AppFont(c_font) [UIFont systemFontOfSize:c_font]
#define ApplicationframeValue [[UIScreen mainScreen]bounds].size


//**提示框宏定义
CG_INLINE void AlertLog (NSString *titleStr,NSString *message,NSString *button1,NSString *button2)
{
    if(!titleStr)
        titleStr = @"";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: titleStr
                                                        message: message
                                                       delegate: nil
                                              cancelButtonTitle: button1
                                              otherButtonTitles: button2,
                              nil];
    [alertView show];
    
}
@interface ShareView ()
@property (nonatomic,strong)NSArray *imageArr;
@property (nonatomic,strong)NSArray *titleArr;

@end



@implementation ShareView


-(NSArray *)imageArr
{

    if (!_imageArr) {
        _imageArr = [NSArray arrayWithObjects:@"share_email-light",@"share_Wechat",@"share_Facebook",nil];
    }
    return _imageArr;
}

-(NSArray *)titleArr
{
    
    if (!_titleArr) {
        _titleArr = [NSArray arrayWithObjects:@"E-mail",@"Wechat",@"Facebook",nil];
    }
    return _titleArr;
}

-(id)initWithFrame:(CGRect)frame
{
    float Margin = ceilf(ApplicationframeValue.width/self.imageArr.count/2);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *viewS = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ApplicationframeValue.width, self.frame.size.height)];
        viewS.backgroundColor =[UIColor whiteColor];
        [self addSubview:viewS];
    
       
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140, ApplicationframeValue.width, 1)];
        lineImage.alpha = 0.5f;
        lineImage.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4f];
        [viewS addSubview:lineImage];
     
        for (int i = 0; i < [self.imageArr count]; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i +1;
            btn.frame = CGRectMake(Margin/2+2*Margin*i,30, Margin, Margin);
            [btn setBackgroundImage:[UIImage imageNamed:self.imageArr[i]] forState:UIControlStateNormal];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Margin/2+2*Margin*i, CGRectGetMaxY(btn.frame)+10, Margin, 15)];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.text = self.titleArr[i];
            label.font = AppFont(text_size_little_2);
            label.adjustsFontSizeToFitWidth = YES;
            [btn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
            [viewS addSubview:label];
            label.textColor = [UIColor grayColor];
            [viewS addSubview:btn];
            
            
          
        }
        
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(200,155, 200, 20);
        [cancleBtn setTitle:@"Cancle" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#2295d4"] forState:UIControlStateNormal];
        cancleBtn.centerX = self.centerX;
        [viewS addSubview:cancleBtn];
        [cancleBtn addTarget:self action:@selector(onCancleBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}



-(void)onBtn:(UIButton *)sender{
    
    if (_callBack) {
        _callBack(sender.tag);
    }
    
    
    
//    switch (sender.tag) {
//        //朋友圈
//        case 1:{
//            if ([WXApi isWXAppInstalled]) {
//                id<ISSContent> publishContent = [ShareSDK content:nil defaultContent:nil image:nil title:nil url:nil description:nil             mediaType:SSPublishContentMediaTypeNews];
//                [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]content:self.message?self.message:INHERIT_VALUE
//                    title:self.title?self.title:INHERIT_VALUE  url:self.shareUrl?self.shareUrl:INHERIT_VALUE
//
//                                                   thumbImage:[ShareSDK imageWithPath:[[NSBundle mainBundle] pathForResource:self.pictureName ofType:@"png"]]
//                                                        image:INHERIT_VALUE
//                                                 musicFileUrl:nil
//                                                      extInfo:nil
//                                                     fileData:nil
//                                                 emoticonData:nil];
//
//                [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline container:nil content:publishContent statusBarTips:NO authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                    if (state == SSResponseStateSuccess)
//                    {
//                        AlertLog(@"", @"分享成功", @"确定", nil);
//                    }
//                    else if (state == SSResponseStateFail)
//                    {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"分享失败,错误码:%ld,错误描述:%@",(long)[error errorCode], [error errorDescription]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                        [alert show];
//                    }
//
//                }];
//            }
//
//            else{
//                AlertLog(@"", @"没有安装微信客户端，无法进行微信分享", @"确定", nil);
//            }
//        }
//            break;
//
//
//        //微信好友
//        case 2:{
//            if ([WXApi isWXAppInstalled]) {
//                id<ISSContent> publishContent = [ShareSDK content:nil defaultContent:nil image:nil title:nil url:nil description:nil mediaType:SSPublishContentMediaTypeText];
//                [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
//                                                     content:self.message?self.message:INHERIT_VALUE
//                                                       title:self.title?self.title:INHERIT_VALUE
//                                                         url:self.shareUrl?self.shareUrl:INHERIT_VALUE
//                                                  thumbImage:[ShareSDK imageWithPath:[[NSBundle mainBundle] pathForResource:self.pictureName ofType:@"png"]]
//                                                       image:INHERIT_VALUE
//                                                musicFileUrl:nil
//                                                     extInfo:nil
//                                                    fileData:nil
//                                                emoticonData:nil];
//
//
//                [ShareSDK showShareViewWithType:ShareTypeWeixiSession container:nil content:publishContent statusBarTips:NO authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                    if (state == SSResponseStateSuccess)
//                    {
//                        AlertLog(@"", @"分享成功", @"确定", nil);
//                    }
//                    else if (state == SSResponseStateFail)
//                    {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"分享失败,错误码:%ld,错误描述:%@",(long)[error errorCode], [error errorDescription]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                        [alert show];
//                    }
//
//                }];
//            }
//            else{
//                AlertLog(@"", @"没有安装微信客户端，无法进行微信分享", @"确定", nil);
//            }
//        }
//        break;
//         //QQ好友
//        case 3:{
//            if ([QQApiInterface isQQInstalled]) {
//                id<ISSContent> publishContent = [ShareSDK content:nil defaultContent:nil image:nil title:nil url:nil description:nil mediaType:SSPublishContentMediaTypeNews];
//                [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
//                                          content:self.message?self.message:INHERIT_VALUE
//                                            title:self.title?self.title:INHERIT_VALUE
//                                              url:self.shareUrl?self.shareUrl:INHERIT_VALUE
//                                              image:[ShareSDK imageWithPath:[[NSBundle mainBundle] pathForResource:self.pictureName ofType:@"png"]]];
//
//
//                 [ShareSDK showShareViewWithType:ShareTypeQQ container:nil content:publishContent statusBarTips:NO authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                     if (state == SSResponseStateSuccess)
//                     {
//                         AlertLog(@"", @"分享成功", @"确定", nil);
//                     }
//                     else if (state == SSResponseStateFail)
//                     {
//                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"分享失败,错误码:%ld,错误描述:%@",(long)[error errorCode], [error errorDescription]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                         [alert show];
//                     }
//
//                 }];
//            }
//            else{
//                AlertLog(@"", @"没有安装QQ客户端，无法进行QQ分享", @"确定", nil);
//
//                 }
//            }
//                 break;
//
//    }
    
    [self dismiss];
}

-(void)onCancleBtn{

    [self dismiss];

}


- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.overlayView];
    [keywindow addSubview:self];
    
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

//弹入层
- (void)fadeIn
{

    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
       
        self.alpha = 1;
 
    }];
    
}

//弹出层
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{

        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self.overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}


@end
