//
//  COTAlertV.m
//  ONTO
//
//  Created by Apple on 2018/8/8.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "CheckView.h"
#import "YYImage.h"
@interface CheckView()
@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UIView   *maskView;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *imageString;
@property (nonatomic, copy)   NSString *buttonString;
@property(nonatomic,strong)UIWindow         *window;
@end
@implementation CheckView
-(instancetype)initWithTitle:(NSString *)title imageString:(NSString *)imageString buttonString:(NSString *)buttonString{
    self = [super init];
    if (self) {
        self.title         =title;
        self.imageString   =imageString;
        self.buttonString  =buttonString;
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
    
//    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake((SYSWidth - 84*SCALE_W)/2 - 27.5*SCALE_W, 34*SCALE_W, 55*SCALE_W, 55*SCALE_W)];
//    image.image =[UIImage imageNamed:self.imageString];
//    [_bgView addSubview:image];
    
    YYImage *image = [YYImage imageNamed:@"selfLoding.gif"];
    YYAnimatedImageView * imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((SYSWidth - 84*SCALE_W)/2 -40*SCALE_W, 20*SCALE_W, 80*SCALE_W, 80*SCALE_W);
    [_bgView addSubview:imageView];
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
        //        42*SCALE_W, y: 180*SCALE_W, width: SYSWidth - 84*SCALE_W, height: 200*SCALE_W)
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(42*SCALE_W, 180*SCALE_W, SYSWidth - 84*SCALE_W, 200*SCALE_W)];
        _bgView.clipsToBounds =YES;
        _bgView.backgroundColor =[UIColor clearColor];
    }
    return _bgView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}

- (void)show {
    //    NSInteger y =  Screen_Width==375 ?Screen_height+43:Screen_height ;
    //
    //    _bgView.frame = CGRectMake(0, y , Screen_Width - (SCALE_W * 0), 524*SCALE_W);
    
    [UIView animateWithDuration:.2 animations:^{
        //        _bgView.frame = CGRectMake(0, SYSHeight-524*SCALE_W , Screen_Width - (SCALE_W * 0), 524*SCALE_W);
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(42*SCALE_W, 180*SCALE_W, SYSWidth - 84*SCALE_W, 200*SCALE_W)];
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
        //        CGRect rect = _bgView.frame;
        //        rect.origin.y += _bgView.bounds.size.height;
        //        _bgView.frame = rect;
        _maskView.alpha =0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.superview.hidden = YES;
    }];
}
@end
