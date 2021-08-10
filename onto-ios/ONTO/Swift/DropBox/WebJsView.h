//
//  WebJsView.h
//  ONTO
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebJsView : UIView
-(instancetype)initWithIdetity:(BOOL)isIdetity textViewText:(NSString*)textViewText pwd:(NSString*)pwd;
@property (nonatomic, copy) void (^callback)(NSString *);
@end

