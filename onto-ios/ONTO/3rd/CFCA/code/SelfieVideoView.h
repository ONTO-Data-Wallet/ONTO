//
//  SelfieVideoView.h
//  SelfieApp
//
//  Created by junyufr on 2017/4/1.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;


@interface SelfieVideoView : UIView



@property (nonatomic) AVCaptureSession *session;

@end
