//
//  UIButton+Block.h
//  LakalaClient
//
//  Created by Apple on 2017/9/26.
//  Copyright © 2017年 LR. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionBlock)(void);//无返回值,无入参的block,应用在大多数位置
@interface UIButton (Block)
/*
 *  handleControlEvent:withBlock:
 *  使用block处理button事件
 *  入参:event 触发类型                 例: UIControlEventTouchUpInside
 *      block 满足触发条件后的事件        例:^{}
 *  注:最后入参有效,同时只能保存一个block触发事件
 */

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block;



@end
