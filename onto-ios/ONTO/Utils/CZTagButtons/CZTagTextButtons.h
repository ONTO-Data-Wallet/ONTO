//
//  CZTagButtons.h
//  CZTagButtons
//
//  Created by Cyzing on 17/3/2.
//  Copyright © 2017年 Cyzing. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const INTERSTICE1;
UIKIT_EXTERN CGFloat const TagMargin1;
UIKIT_EXTERN CGFloat const GTagH1;

@interface CZTypographyButton1 :UIButton

@end


@interface CZTagTextButtons : UIView
//view背景颜色
@property(nonatomic,strong)UIColor *cz_backgroundColor;

//按钮的字体颜色
@property(nonatomic,strong)UIColor *cz_buttonTitleColor;
//按钮的背景颜色
@property(nonatomic,strong)UIColor *cz_buttonBackgroundColor;
//添加文字助记词
- (void)addButtonWithTitle:(NSString*)title;

- (void)removeAllTextTitle;

@property (nonatomic, strong) NSMutableArray *tagButtons;

//获取当前输入文字
- (NSString*)getContent;
/**
 *  Description
 *
 *  @param completionHandler   回调block
 *  @param buttonTitles 按钮的总个数
 *  @param viewF 设置当前frame  -warning   frame.h 设置无效
 
 */

- (instancetype)initWithCompletionHandlerBlock:(void(^)(CZTypographyButton1 *button , NSInteger index ))completionHandler
                        typographyButtonTitles:(NSArray *)buttonTitles
                                withSuperViewF:(CGRect)viewF;




@end

