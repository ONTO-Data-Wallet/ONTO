//
//  blackView.h
//  亲爱哒
//
//  Created by haitao on 15/8/21.
//  Copyright (c) 2015年 HTKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface blackView : UIView
{
    bool    bBlack;
}
+(UIView *) initWithForView:(UIView *)addToView;

+(UIView *) initWithForView:(UIView *)addBgView withOriginY:(CGFloat)originY;
//@property(nonatomic,assign)bool    bBlack;
@end
