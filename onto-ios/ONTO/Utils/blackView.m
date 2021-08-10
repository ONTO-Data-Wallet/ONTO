//
//  blackView.m
//  亲爱哒
//
//  Created by haitao on 15/8/21.
//  Copyright (c) 2015年 HTKJ. All rights reserved.
//

#import "blackView.h"
#import "Config.h"
@implementation blackView

+(UIView *) initWithForView:(UIView *)addToView {
    
    CGFloat viewY=0;
    
    UIView *localView=[[UIView alloc] initWithFrame:CGRectMake(0, viewY, addToView.frame.size.width, addToView.frame.size.height)];
    localView.backgroundColor=[[UIColor colorWithHexString:@"#0D181A"] colorWithAlphaComponent:0.7];
    //  localView.backgroundColor=[UIColor blueColor];
    
    [localView removeFromSuperview];
    [addToView addSubview:localView];
    
    return localView;
}
+(UIView *) initWithForView:(UIView *)addBgView withOriginY:(CGFloat)originY{
    UIView *localView=[[UIView alloc] initWithFrame:CGRectMake(0, originY, addBgView.frame.size.width, addBgView.frame.size.height-originY )];
    localView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.35];
    //  localView.backgroundColor=[UIColor blueColor];
    
    [localView removeFromSuperview];
    [addBgView addSubview:localView];
    
    return localView;
}
@end
