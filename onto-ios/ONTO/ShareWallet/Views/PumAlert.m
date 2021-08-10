//
//  PumAlert.m
//  ONTO
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "PumAlert.h"
@interface PumAlert()
@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UIView   *maskView;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *imageString;
@property (nonatomic, copy)   NSString *buttonString;
@property (nonatomic, copy)   NSString *numString;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) BOOL     isCandybox;
@property (nonatomic, copy)   NSMutableAttributedString * titleAttr;
@end
@implementation PumAlert

-(instancetype)initWithTitle:(NSString*)title imageString:(NSString*)imageString numString:(NSString*)numString  buttonString:(NSString*)buttonString{
    self = [super init];
    if (self) {
        self.title         =title;
        self.imageString   =imageString;
        self.buttonString  =buttonString;
        self.numString     =numString;
        self.isCandybox    =NO;
        [self configUI];
    }
    return self;
}
-(instancetype)initWithTitle:(NSMutableAttributedString*)title imageString:(NSString*)imageString numString:(NSString*)numString  buttonString:(NSString*)buttonString isCandy:(BOOL)isCandy{
    self = [super init];
    if (self) {
        self.titleAttr       =title;
        self.imageString     =imageString;
        self.buttonString    =buttonString;
        self.numString       =numString;
        self.isCandybox      =YES;
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
    UILabel * titleLB = [[UILabel alloc]init];
    if (self.isCandybox) {
        titleLB.attributedText = self.titleAttr;
    }else{
        titleLB.text = self.title;
    }
    titleLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleLB.numberOfLines = 0;
    [titleLB changeSpace:2 wordSpace:1];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:titleLB];
    
    UIImageView * pumImage =[[UIImageView alloc]init];
    if (self.isCandybox) {
        [pumImage sd_setImageWithURL:[NSURL URLWithString:self.imageString]];
    }else{
        pumImage.image = [UIImage imageNamed:self.imageString];
    }
    [_bgView addSubview:pumImage];
    
    UILabel * numLB =[[UILabel alloc]init];
    numLB.text = self.numString;
    numLB.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    numLB.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:numLB];
    
    UIView * line =[[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#CDCED5"];
    [_bgView addSubview:line];
    
    UIButton * btn = [[UIButton alloc]init];
    [btn setTitle:self.buttonString forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [btn.titleLabel changeSpace:0 wordSpace:3];
    [_bgView addSubview:btn];
    
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(20*SCALE_W);
        make.top.equalTo(_bgView).offset(10*SCALE_W);
        make.right.equalTo(_bgView).offset(-20*SCALE_W);
        make.height.mas_offset(44*SCALE_W);
    }];
    
    [pumImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLB.mas_bottom).offset(20*SCALE_W);
        make.centerX.equalTo(_bgView.mas_centerX);
        make.width.height.mas_offset(80*SCALE_W);
    }];
    
    [numLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView.mas_centerX );
        make.top.equalTo(pumImage.mas_bottom).offset(10*SCALE_W);
        make.height.mas_offset(20*SCALE_W);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(20*SCALE_W);
        make.top.equalTo(numLB.mas_bottom).offset(20*SCALE_W);
        make.right.equalTo(_bgView).offset(-20*SCALE_W);
        make.height.mas_offset(1);
    }];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bgView);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(_bgView);
    }];
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (_callback) {
            _callback(@"");
        }
        [self dismiss];
    }];
    
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
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(42*SCALE_W, 180*SCALE_W, SYSWidth - 84*SCALE_W, 260*SCALE_W)];
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
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(42*SCALE_W, 180*SCALE_W, SYSWidth - 84*SCALE_W, 260*SCALE_W)];
        _maskView.alpha = .5;
        _window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
        [_window addSubview:self];
        [_window makeKeyAndVisible];
        
        
    }];
}
- (NSAttributedString *)getAttributedWithString:(NSString *)string WithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font color:(UIColor*)color{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern),
                                NSFontAttributeName:font,NSForegroundColorAttributeName:color};
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
