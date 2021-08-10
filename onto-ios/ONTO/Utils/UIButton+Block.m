//
//  UIButton+Block.m
//  LakalaClient
//
//  Created by Apple on 2017/9/26.
//  Copyright © 2017年 LR. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>
@implementation UIButton (Block)
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block
{
    if(!event)
    event=UIControlEventTouchUpInside;
    objc_setAssociatedObject(self, &"myBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(blockEvent:) forControlEvents:event];

}
-(void)blockEvent:(UIButton *)sender
{
    ActionBlock block=objc_getAssociatedObject(self, &"myBlock");
    if(block)
    {
        block();
    }
}


@end
