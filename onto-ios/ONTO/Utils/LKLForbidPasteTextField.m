//
//  LKLForbidPasteTextField.m
//  LakalaClient
//
//  Created by Apple on 2017/10/12.
//  Copyright © 2017年 LR. All rights reserved.
//

#import "LKLForbidPasteTextField.h"

@implementation LKLForbidPasteTextField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController*menuController = [UIMenuController sharedMenuController];
    
    if(menuController) {
        
        [UIMenuController sharedMenuController].menuVisible=NO;
        
    }
    
    return NO;
    
}

@end
