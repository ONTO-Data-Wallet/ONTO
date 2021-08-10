//
//  SettingViewController.h
//  TestSTLivenessController
//
//  Created by huoqiuliang on 16/5/9.
//  Copyright © 2016年 SunLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STLivenessDetectionEnumType.h"
@interface SettingViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *arrActions;
@property (nonatomic, assign) STIDLivenessFaceComplexity liveComplexity;
@property (nonatomic, assign) BOOL bVoicePrompt;

@end
