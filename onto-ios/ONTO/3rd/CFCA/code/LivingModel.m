//
//  LivingModel.m
//  LivingApp
//
//  Created by junyufr on 2017/4/6.
//  Copyright © 2017年 junyufr.com. All rights reserved.
//

#import "LivingModel.h"

@implementation LivingModel



+(id)actionNamed:(NSString*)name images:(NSArray*)images
{
    LivingModel *actionInfo = [[LivingModel alloc] init];
    actionInfo.name = name;
    actionInfo.images = images;
    return actionInfo;
}

+(id)actionNamed:(NSString*)name images:(NSArray*)images sound:(NSString*)soundName
{
    LivingModel *actionInfo = [[LivingModel alloc] init];
    actionInfo.name = name;
    actionInfo.images = images;

    NSURL *bundleUrl = [[NSBundle mainBundle] bundleURL];
    NSBundle* jyResourceBundle = [NSBundle bundleWithURL:bundleUrl];
    
    actionInfo.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[jyResourceBundle URLForResource:soundName withExtension:@"wav"] error:nil];
    [actionInfo.soundPlayer prepareToPlay];

    return actionInfo;
}


@end
