//
//  ShareView.h
//  天巢网
//
//  Created by 赵贺 on 15/11/20.
//  Copyright © 2015年 tangjp. All rights reserved.
//分享视图

#import <UIKit/UIKit.h>

@interface ShareView : UIView


@property (nonatomic, strong) UIControl *overlayView;
@property(nonatomic,strong)UIView *viewS;
@property (nonatomic, copy) void (^callBack)(NSInteger);


//需在实现代码中添加的属性

/**标题*/
@property (nonatomic, strong) NSString *title;
/**内容简介*/
@property (nonatomic, strong) NSString *message;
/**分享展示的图片*/
@property (nonatomic, strong) NSString *pictureName;
/**跳转到哪里*/
@property (nonatomic, strong) NSString *shareUrl;
-(void)show;
-(void)dismiss;
@end
