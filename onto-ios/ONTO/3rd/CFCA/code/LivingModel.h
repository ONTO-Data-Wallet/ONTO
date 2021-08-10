//
//  LivingModel.h
//  LivingApp
//
//  Created by junyufr on 2017/4/6.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


@interface LivingModel : NSObject

// 动作名称
@property (nonatomic, copy) NSString* name;
// 动作帧的图片
@property (nonatomic, strong) NSArray* images;
// 动作提示音播放器
@property (nonatomic, strong) AVAudioPlayer* soundPlayer;



+(id)actionNamed:(NSString*)name images:(NSArray*)images;

+(id)actionNamed:(NSString*)name images:(NSArray*)images sound:(NSString*)soundName;

@end
