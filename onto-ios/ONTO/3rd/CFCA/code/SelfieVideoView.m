//
//  SelfieVideoView.m
//  SelfieApp
//
//  Created by junyufr on 2017/4/1.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import "SelfieVideoView.h"
#import <AVFoundation/AVFoundation.h>

@implementation SelfieVideoView


+(Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
    self.clipsToBounds = YES;
    [(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer*)[self layer];
    switch (contentMode)
    {
        case UIViewContentModeScaleAspectFill:
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        case UIViewContentModeScaleToFill:
            layer.videoGravity = AVLayerVideoGravityResize;
            break;
        default:
            layer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
    }
}

@end
