//
//  COTAlertV.m
//  ONTO
//
//  Created by Apple on 2018/8/8.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "BackupV.h"
@interface BackupV()
@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UIView   *maskView;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *imageString;
@property (nonatomic, copy)   NSString *buttonString;
@property (nonatomic, copy)   NSString *rightbuttonString;
@property(nonatomic,strong)UIWindow         *window;
@end
@implementation BackupV
-(instancetype)initWithTitle:(NSString*)title imageString:(NSString*)imageString leftButtonString:(NSString*)leftButtonString  rightButtonString:(NSString*)rightButtonString{
    self = [super init];
    if (self) {
        self.title         =title;
        self.imageString   =imageString;
        self.buttonString  =leftButtonString;
        self.rightbuttonString  = rightButtonString;
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
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake((SYSWidth - 84*SCALE_W)/2 - 32.5*SCALE_W, 24*SCALE_W, 65*SCALE_W, 65*SCALE_W)];
    image.image =[UIImage imageNamed:self.imageString];
    [_bgView addSubview:image];
    //
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(15*SCALE_W, 110*SCALE_W, SYSWidth -84*SCALE_W - 30*SCALE_W, 60*SCALE_W)];
    title.textColor = [UIColor blackColor];
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    title.attributedText = [self getAttributedWithString:self.title WithLineSpace:2 kern:1*SCALE_W font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] color:[UIColor blackColor]];
    title.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:title];
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, 190*SCALE_W, (SYSWidth - 84*SCALE_W)/2, 50*SCALE_W)];
    button.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    [button setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
    button.titleLabel.attributedText = [self getAttributedWithString:self.buttonString WithLineSpace:0 kern:2 font:[UIFont systemFontOfSize:18 weight:UIFontWeightBold] color:[UIColor colorWithHexString:@"#9b9b9b"]];
    button.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [button setAttributedTitle:[self getAttributedWithString:self.buttonString WithLineSpace:0 kern:2 font:[UIFont systemFontOfSize:18 weight:UIFontWeightBold]color:[UIColor colorWithHexString:@"#9b9b9b"]] forState:UIControlStateNormal];
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        if (_callleftback) {
            _callleftback(@"");
        }
        [self dismiss];
    }];
    [_bgView addSubview:button];
    
    UIButton* rbutton = [[UIButton alloc]initWithFrame:CGRectMake((SYSWidth - 84*SCALE_W)/2, 190*SCALE_W, (SYSWidth - 84*SCALE_W)/2, 50*SCALE_W)];
    rbutton.backgroundColor = [UIColor blackColor];
    [rbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rbutton.titleLabel.attributedText = [self getAttributedWithString:self.rightbuttonString WithLineSpace:0 kern:2 font:[UIFont systemFontOfSize:18 weight:UIFontWeightBold] color:[UIColor whiteColor]];
    rbutton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [rbutton setAttributedTitle:[self getAttributedWithString:self.rightbuttonString WithLineSpace:0 kern:2 font:[UIFont systemFontOfSize:18 weight:UIFontWeightBold] color:[UIColor whiteColor] ] forState:UIControlStateNormal];
    [rbutton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (_callback) {
            _callback(@"");
        }
        [self dismiss];
    }];
    [_bgView addSubview:rbutton];
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
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(42*SCALE_W, 180*SCALE_W, SYSWidth - 84*SCALE_W, 240*SCALE_W)];
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
    //    NSInteger y =  Screen_Width==375 ?Screen_height+43:Screen_height ;
    //
    //    _bgView.frame = CGRectMake(0, y , Screen_Width - (SCALE_W * 0), 524*SCALE_W);
    
    [UIView animateWithDuration:.2 animations:^{
        //        _bgView.frame = CGRectMake(0, SYSHeight-524*SCALE_W , Screen_Width - (SCALE_W * 0), 524*SCALE_W);
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(42*SCALE_W, 180*SCALE_W, SYSWidth - 84*SCALE_W, 240*SCALE_W)];
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
