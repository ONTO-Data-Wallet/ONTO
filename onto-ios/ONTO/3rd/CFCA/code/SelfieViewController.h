//
//  SelfieViewController.h
//  SelfieApp
//
//  Created by junyufr on 2017/4/1.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol selfieControlDelegate <NSObject>

@optional



-(void)selfieTouchBack:(id)SelfieVC;


@end

@interface SelfieViewController : UIViewController

@property (nonatomic,weak) id <selfieControlDelegate> delegate;

//旋转区
@property (nonatomic,strong)UIImageView * tmpImageview;
@property (nonatomic,strong)UIActivityIndicatorView *testActivityIndicator; //正在载入旋转控件

@end
