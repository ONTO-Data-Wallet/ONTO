//
//  CZTagButtons.m
//  CZTagButtons
//
//  Created by Cyzing on 17/3/2.
//  Copyright © 2017年 Cyzing. All rights reserved.
//

#import "CZTagButtons.h"
#import <objc/runtime.h>
#import "Config.h"
#define M_W [UIScreen mainScreen].bounds.size.width

CGFloat const INTERSTICE = 10;
CGFloat const TagMargin  = 10;
CGFloat const TagH = 36;

const char completionHandlerKey;

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

@interface CZTypographyButton ()

@end

@implementation CZTypographyButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor  whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor colorWithHexString:@"#0AA5C9"] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
//        self.layer.borderColor = MAINAPPCOLOR.CGColor;
//        self.layer.borderWidth = 0.5;
//        self.layer.cornerRadius = TagH/2.0;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
    self.width += 2 * TagMargin;
    self.height = TagH;
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

@interface CZTagButtons ()
@property (nonatomic, strong) NSMutableArray *tagButtons;
@property(nonatomic,strong)UIButton *currentBtn;
@property(nonatomic,strong)NSMutableArray *buttons;
@property(nonatomic,strong)NSMutableArray *currenTitle;

@end

@implementation CZTagButtons
 CGRect  _viewRect;
- (NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (NSMutableArray *)currenTitle
{
    if (!_currenTitle) {
        _currenTitle = [NSMutableArray array];
    }
    return _currenTitle;
}

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttons;
}

- (instancetype)initWithCompletionHandlerBlock:(void(^)(CZTypographyButton *button , NSInteger index ))completionHandler
                        typographyButtonTitles:(NSArray *)buttonTitles withSuperViewF:(CGRect)viewF{
    self = [super init];
    if (self) {
        _viewRect = viewF;
        self.frame = viewF;
        [self.tagButtons addObjectsFromArray:buttonTitles];
        [self loadSubViews];
        objc_setAssociatedObject(self, &completionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

-(void)layoutSubviews{
    if (self.buttons.count) {
        CZTypographyButton *lastedBtn = (CZTypographyButton *)self.buttons[self.buttons.count -1];
        self.height = CGRectGetMaxY(lastedBtn.frame) +INTERSTICE;
    }
}

-(void)loadSubViews{
    for (NSInteger i =0; i < self.tagButtons.count; i++) {
        CZTypographyButton *button  =[CZTypographyButton buttonWithType:UIButtonTypeSystem];
        [self.buttons addObject:button];
        button.tag = i;
        [button setTitle:self.tagButtons[i] forState:UIControlStateNormal];
        [button setTitle:[Common dislodgeNumericcharacte:self.tagButtons[i]] forState:UIControlStateNormal];
        
        [button setTitleColor:MainColor forState:UIControlStateNormal];

        if ([self.currenTitle containsObject:self.tagButtons[i]]) {
            
            
            
        button.userInteractionEnabled = NO;
        button.backgroundColor = MAINAPPCOLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = 2;
        [self addSubview:button];
    }
    [self  refreshBtnF];
}
-(void)refreshBtnF{
    CGFloat buttonX = 5;
    CGFloat buttonY = 5;
    for (NSInteger i =0; i< self.buttons.count; i++) {
        CZTypographyButton *button = (CZTypographyButton *)self.buttons[i];
        if (i==0) {
            button.x = buttonX;
            button.y = buttonY;
        }else{
            UIButton *lastButton = (CZTypographyButton *)self.buttons[i-1];
            CGFloat lastBtnX = CGRectGetMaxX(lastButton.frame);
            CGFloat lastBtnY = CGRectGetMinY(lastButton.frame);
            button.x =  lastBtnX + INTERSTICE;
            button.y = lastBtnY;
            if (CGRectGetMaxX(button.frame) > (_viewRect.size.width? _viewRect.size.width :M_W)) {
                button.y = CGRectGetMaxY(lastButton.frame)+ INTERSTICE;
                button.x = buttonX;
                
            }
        }
    }
    [self layoutIfNeeded];
}

-(void)btnClick:(CZTypographyButton *)button{
    void(^completHandleBlock)(CZTypographyButton *btn,NSInteger index) = objc_getAssociatedObject(self, &completionHandlerKey);
    !completHandleBlock?:completHandleBlock(button,button.tag);
    
    for (__strong CZTypographyButton *btn in self.buttons) {
        [btn removeFromSuperview];
        btn = nil;
    }
    
    [self.buttons removeAllObjects];
    [self.currenTitle addObject:self.tagButtons[button.tag]];
    self.tagButtons = [NSMutableArray arrayWithArray:[Common getRandomArrFrome:self.tagButtons]];
    [self loadSubViews];
    
  
}

- (void)removeCurrenWithTitle:(NSString*)title{
    
    for (__strong CZTypographyButton *btn in self.buttons) {
        [btn removeFromSuperview];
        btn = nil;
    }

    [self.buttons removeAllObjects];
//    [self.currenTitle removeObject:title];
    for (NSString *str in  self.currenTitle) {
        //字条串是否包含有某字符串
        if ([str rangeOfString:title].location == NSNotFound) {

        } else {
             [self.currenTitle removeObject:str];
            
            self.tagButtons = [NSMutableArray arrayWithArray:[Common getRandomArrFrome:self.tagButtons]];
            [self loadSubViews];
            return;
        }
    }
    

    
}


-(void)setCz_backgroundColor:(UIColor *)cz_backgroundColor{
    _cz_backgroundColor = cz_backgroundColor;
    self.backgroundColor = cz_backgroundColor;
}
-(void)setCz_buttonTitleColor:(UIColor *)cz_buttonTitleColor{
    _cz_buttonTitleColor = cz_buttonTitleColor;
    for (NSInteger i =0; i<self.buttons.count; i++) {
        CZTypographyButton *btn  =(CZTypographyButton *)self.buttons[i];
        [btn setTitleColor:cz_buttonTitleColor forState:UIControlStateNormal];
    }
}
-(void)setCz_buttonBackgroundColor:(UIColor *)cz_buttonBackgroundColor{
    _cz_backgroundColor = cz_buttonBackgroundColor;
    for (NSInteger i =0; i<self.buttons.count; i++) {
        CZTypographyButton *btn  =(CZTypographyButton *)self.buttons[i];
        btn.backgroundColor = cz_buttonBackgroundColor;
    }
}

@end
