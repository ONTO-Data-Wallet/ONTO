//
//  InfoAlert.m
//  ONTO
//
//  Created by Apple on 2018/12/18.
//  Copyright © 2018 Zeus. All rights reserved.
//



#import "InfoAlert.h"
@interface InfoAlert()
@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UIView   *maskView;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *msgString;
@property (nonatomic, copy)   NSString *buttonString;
@property (nonatomic, copy)   NSString *leftString;
@property(nonatomic,strong)UIWindow         *window;
@end
@implementation InfoAlert
-(instancetype)initWithTitle:(NSString *)title msgString:(NSString *)msgString buttonString:(NSString *)buttonString leftString:(NSString*)leftString{
    self = [super init];
    if (self) {
        self.title         =title;
        self.msgString   =msgString;
        self.buttonString  =buttonString;
        self.leftString = leftString;
        [self configUI];
    }
    return self;
}
-(void)configUI{
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    [self createDetailView];
}
-(void)createDetailView{
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(0, 34*SCALE_W, SYSWidth -84*SCALE_W, 19*SCALE_W)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:16];
    title.attributedText = [self getAttributedWithString:self.title WithLineSpace:0 kern:1 font:[UIFont systemFontOfSize:14]];
    title.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:title];
    
    UITextView * textview = [[UITextView alloc] initWithFrame:CGRectMake(20*SCALE_W, 70*SCALE_W, SYSWidth - 124*SCALE_W, 180*SCALE_W)];
    textview.editable = NO;
    textview .font = [UIFont systemFontOfSize:16];
    textview.text = self.msgString;
    textview.layer.borderWidth = 1;
    textview.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [_bgView  addSubview:textview    ];
    
    if ([Common isBlankString:self.leftString]) {
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, 270*SCALE_W, SYSWidth - 84*SCALE_W, 50*SCALE_W)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = LINEBG.CGColor;
        button.titleLabel.attributedText = [self getAttributedWithString:self.buttonString WithLineSpace:0 kern:2 font:[UIFont systemFontOfSize:18 weight:UIFontWeightBold]];
        button.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        [button setAttributedTitle:[self getAttributedWithString:self.buttonString WithLineSpace:0 kern:2 font:[UIFont systemFontOfSize:18 weight:UIFontWeightBold]] forState:UIControlStateNormal];
        [button handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            if (_callback) {
                _callback(@"");
            }
            [self dismiss];
        }];
        [_bgView addSubview:button];
    }else{
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake((SYSWidth - 84*SCALE_W)/2, 270*SCALE_W, (SYSWidth - 84*SCALE_W)/2, 50*SCALE_W)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = LINEBG.CGColor;
        button.titleLabel.attributedText = [self getAttributedWithString:self.buttonString WithLineSpace:0 kern:2 font:[UIFont systemFontOfSize:18 weight:UIFontWeightBold]];
        button.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        [button setAttributedTitle:[self getAttributedWithString:self.buttonString WithLineSpace:0 kern:2 font:[UIFont systemFontOfSize:18 weight:UIFontWeightBold]] forState:UIControlStateNormal];
        [button handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            if (_callback) {
                _callback(@"");
            }
            [self dismiss];
        }];
        [_bgView addSubview:button];
        
        UIButton* leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 270*SCALE_W, (SYSWidth - 84*SCALE_W)/2, 50*SCALE_W)];
        [leftbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftbutton.layer.borderWidth = 1;
        leftbutton.layer.borderColor = LINEBG.CGColor;
        leftbutton.titleLabel.attributedText = [self getAttributedWithString:self.leftString WithLineSpace:0 kern:2 font:[UIFont systemFontOfSize:18 weight:UIFontWeightBold]];
        leftbutton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        [leftbutton setAttributedTitle:[self getAttributedWithString:self.leftString WithLineSpace:0 kern:2 font:[UIFont systemFontOfSize:18 weight:UIFontWeightBold]] forState:UIControlStateNormal];
        [leftbutton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            if (_callleftback) {
                _callleftback(@"");
            }
            [self dismiss];
        }];
        [_bgView addSubview:leftbutton];
    }
    
}
- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}
-(UIView*)bgView{
    if (!_bgView) {
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(42*SCALE_W, 180*SCALE_W, SYSWidth - 84*SCALE_W, 320*SCALE_W)];
        _bgView.clipsToBounds =YES;
        _bgView.backgroundColor =[UIColor whiteColor];
    }
    return _bgView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}

- (void)show {
    
    [UIView animateWithDuration:.2 animations:^{
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(42*SCALE_W, 180*SCALE_W, SYSWidth - 84*SCALE_W, 320*SCALE_W)];
        _maskView.alpha = .5;
        
        _window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
        [_window addSubview:self];
        [_window makeKeyAndVisible];
        
        
    }];
}
- (NSAttributedString *)getAttributedWithString:(NSString *)string WithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern),
                                NSFontAttributeName:font};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:attriDict];
    return attributedString;
}
- (void)dismiss {
    [UIView animateWithDuration:.2 animations:^{
        _maskView.alpha =0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.superview.hidden = YES;
    }];
}
@end
