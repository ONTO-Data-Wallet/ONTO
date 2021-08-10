//
//  CZTagTextButtons.m
//  CZTagTextButtons
//
//  Created by Cyzing on 17/3/2.
//  Copyright © 2017年 Cyzing. All rights reserved.
//

#import "CZTagTextButtons.h"
#import <objc/runtime.h>
#import "Config.h"
#define M_W1 [UIScreen mainScreen].bounds.size.width

CGFloat const INTERSTICE1 = 8;
CGFloat const TagMargin1  = 5;
CGFloat const TagH1 = 25;

const char completionHandlerKey1;

//辅助 类别
@interface UIView (Extension)

@end
@implementation UIView (Extension)

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

@end

@interface CZTypographyButton1 ()

@end

@implementation CZTypographyButton1

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor  whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor colorWithHexString:@"#0AA5C9"] forState:UIControlStateNormal];
        self.layer.borderColor = MAINAPPCOLOR.CGColor;
        self.layer.borderWidth = 0.5;
//        self.layer.cornerRadius = ;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
    self.width += 2 * TagMargin1;
    self.height = TagH1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //    self.titleLabel.x = TagMargin;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.highlighted = true;
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.highlighted = false;
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.highlighted = false;
    [super touchesCancelled:touches withEvent:event];
}
@end

@interface CZTagTextButtons ()
@property(nonatomic,strong)UIButton *currentBtn;
@property(nonatomic,strong)NSMutableArray *buttons;

@end

@implementation CZTagTextButtons
CGRect  _viewRect1;
- (NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttons;
}

- (instancetype)initWithCompletionHandlerBlock:(void(^)(CZTypographyButton1 *button , NSInteger index ))completionHandler
                        typographyButtonTitles:(NSArray *)buttonTitles withSuperViewF:(CGRect)viewF{
    self = [super init];
    if (self) {
        _viewRect1 = viewF;
        self.frame = viewF;
        [self.tagButtons addObjectsFromArray:buttonTitles];
        [self loadSubViews];
        objc_setAssociatedObject(self, &completionHandlerKey1, completionHandler, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

-(void)layoutSubviews{
    if (self.buttons.count) {
        CZTypographyButton1 *lastedBtn = (CZTypographyButton1 *)self.buttons[self.buttons.count -1];
//        self.height = CGRectGetMaxY(lastedBtn.frame) +INTERSTICE1;
        self.height = 125;

    }
}

-(void)loadSubViews{
    for (NSInteger i =0; i < self.tagButtons.count; i++) {
        CZTypographyButton1 *button  =[CZTypographyButton1 buttonWithType:UIButtonTypeSystem];
        [self.buttons addObject:button];
        button.tag = i;
        [button setTitle:self.tagButtons[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithHexString:@"#F6F8F9"]];

        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    [self  refreshBtnF];
}

-(void)refreshBtnF{
    CGFloat buttonX = 24;
    CGFloat buttonY = 16;
    for (NSInteger i =0; i< self.buttons.count; i++) {
        CZTypographyButton1 *button = (CZTypographyButton1 *)self.buttons[i];
        if (i==0) {
            button.x = buttonX;
            button.y = buttonY;
        }else{
            UIButton *lastButton = (CZTypographyButton1 *)self.buttons[i-1];
            CGFloat lastBtnX = CGRectGetMaxX(lastButton.frame);
            CGFloat lastBtnY = CGRectGetMinY(lastButton.frame);
            button.x =  lastBtnX + INTERSTICE1;
            button.y = lastBtnY;
            if (CGRectGetMaxX(button.frame) > (_viewRect1.size.width? _viewRect1.size.width :M_W1)) {
                button.y = CGRectGetMaxY(lastButton.frame)+ INTERSTICE1;
                button.x = buttonX;
                
            }
        }
    }
    [self layoutIfNeeded];
}

-(void)btnClick:(CZTypographyButton1 *)button{
    void(^completHandleBlock)(CZTypographyButton1 *btn,NSInteger index) = objc_getAssociatedObject(self, &completionHandlerKey1);
    !completHandleBlock?:completHandleBlock(button,button.tag);
    
    for (__strong CZTypographyButton1 *btn in self.buttons) {
        [btn removeFromSuperview];
        btn = nil;
    }
    
    [self.buttons removeAllObjects];
    [self.tagButtons removeObjectAtIndex:button.tag];
//    [self.tagButtons removeAllObjects];
    [self loadSubViews];
}


- (void)removeAllTextTitle{
    for (__strong CZTypographyButton1 *btn in self.buttons) {
        [btn removeFromSuperview];
        btn = nil;
    }
    
    [self.buttons removeAllObjects];
        [self.tagButtons removeAllObjects];
    [self loadSubViews];
    
}

- (void)addButtonWithTitle:(NSString*)title{
    
    for (__strong CZTypographyButton1 *btn in self.buttons) {
        [btn removeFromSuperview];
        btn = nil;
    }
    
    [self.buttons removeAllObjects];
    [self.tagButtons addObject:title];
    [self loadSubViews];
    
}


-(void)setCz_backgroundColor:(UIColor *)cz_backgroundColor{
    _cz_backgroundColor = cz_backgroundColor;
    self.backgroundColor = cz_backgroundColor;
}

-(void)setCz_buttonTitleColor:(UIColor *)cz_buttonTitleColor{
    _cz_buttonTitleColor = cz_buttonTitleColor;
    for (NSInteger i =0; i<self.buttons.count; i++) {
        CZTypographyButton1 *btn  =(CZTypographyButton1 *)self.buttons[i];
        [btn setTitleColor:cz_buttonTitleColor forState:UIControlStateNormal];
    }
}

- (NSString*)getContent{
    
    NSString *tempString = [_tagButtons componentsJoinedByString:@" "];
    return tempString;
}

-(void)setCz_buttonBackgroundColor:(UIColor *)cz_buttonBackgroundColor{
    _cz_backgroundColor = cz_buttonBackgroundColor;
    for (NSInteger i =0; i<self.buttons.count; i++) {
        CZTypographyButton1 *btn  =(CZTypographyButton1 *)self.buttons[i];
        btn.backgroundColor = cz_buttonBackgroundColor;
    }
}

@end

