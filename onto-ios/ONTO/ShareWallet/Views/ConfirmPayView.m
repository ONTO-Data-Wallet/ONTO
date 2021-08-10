//
//  ConfirmPayView.m
//  ONTO
//
//  Created by Apple on 2018/7/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "ConfirmPayView.h"
#import "Config.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SPACE 10

@interface ConfirmPayView()
@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UIView   *maskView;
@property (nonatomic, assign) BOOL      isONT;
@property (nonatomic, copy)   NSString *money;
@property (nonatomic, copy)   NSString *fromAddress;
@property (nonatomic, copy)   NSString *toAddress;
@property (nonatomic, copy)   NSString *fee;
@end
@implementation ConfirmPayView

-(instancetype)initWithType:(BOOL)isONT money:(NSString *)money fromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress fee:(NSString *)fee{
    self = [super init];
    if (self) {
        self.isONT       =isONT;
        self.money       =money;
        self.fromAddress =fromAddress;
        self.toAddress   =toAddress;
        self.fee         =fee;
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
    UIButton * leftImage =[[UIButton alloc]initWithFrame:CGRectMake(16*SCALE_W, 12*SCALE_W, 22*SCALE_W, 22*SCALE_W)];
    [leftImage setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftImage handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismiss];
    }];
    [self.bgView addSubview:leftImage];
    
    UILabel* titleLB =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 47*SCALE_W)];
    titleLB.textAlignment =NSTextAlignmentCenter;
    titleLB.font =[UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLB.text =Localized(@"PaymentConfirmation");
    titleLB.textColor =[UIColor colorWithHexString:@"#6A797C"];
    [self.bgView addSubview:titleLB];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 47*SCALE_W-1, SYSWidth, 1)];
    line.backgroundColor =LINEBG;
    [self.bgView addSubview:line];
    
    NSString *moneyStr =[NSString stringWithFormat:@"%@%@",self.money,self.isONT? @" ONT":@" ONG"];
    NSMutableAttributedString* attrStr =[[NSMutableAttributedString alloc]initWithString:moneyStr
                                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24 weight:UIFontWeightMedium]}];
    [attrStr addAttribute:NSForegroundColorAttributeName value:BLUELB range:NSMakeRange(0, self.money.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:LIGHTBLACK range:NSMakeRange(self.money.length, 4)];
    UILabel * money =[[UILabel alloc]initWithFrame:CGRectMake(0, 72*SCALE_W, SYSWidth, 30*SCALE_W)];
    money.textAlignment =NSTextAlignmentCenter;
    money.attributedText =attrStr;
    [self.bgView addSubview:money];
    
    for (int i=0; i<2; i++) {
        UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(24*SCALE_W, 182*SCALE_W+88*SCALE_W*i, SYSWidth-48*SCALE_W, 1)];
        line1.backgroundColor =LINEBG;
        [self.bgView addSubview:line1];
        
        UILabel *LB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 160*SCALE_W +89*SCALE_W*i, SYSWidth-48*SCALE_W, 14.5*SCALE_W)];
        LB.textAlignment =NSTextAlignmentRight;
        LB.textColor =LIGHTGRAYLB;
        LB.font =[UIFont systemFontOfSize:12];
        if (i==0) {
            LB.text=self.fromAddress;
        }else{
            LB.text =self.toAddress;
        }
        [self.bgView addSubview:LB];
    }
    UILabel* fromLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 126*SCALE_W, 100*SCALE_W, 17*SCALE_W)];
    fromLB.textAlignment =NSTextAlignmentLeft;
    fromLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    fromLB.textColor =BLACKLB;
    fromLB.text =Localized(@"ShareFrom");
    [self.bgView addSubview:fromLB];
    
    UILabel* walletLB =[[UILabel alloc]initWithFrame:CGRectMake(74*SCALE_W, 126*SCALE_W, 100*SCALE_W, 17*SCALE_W)];
    walletLB.textAlignment =NSTextAlignmentLeft;
    walletLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    walletLB.textColor =BLUELB;
    walletLB.text =Localized(@"SharedWallet");
    [self.bgView addSubview:walletLB];
    
    UILabel* toLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 215*SCALE_W, 100*SCALE_W, 17*SCALE_W)];
    toLB.textAlignment =NSTextAlignmentLeft;
    toLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    toLB.textColor =BLACKLB;
    toLB.text =Localized(@"ShareTo");
    [self.bgView addSubview:toLB];
    
    UILabel* feeLB =[[UILabel alloc]initWithFrame:CGRectMake(24*SCALE_W, 288*SCALE_W, 100*SCALE_W, 17*SCALE_W)];
    feeLB.textAlignment =NSTextAlignmentLeft;
    feeLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    feeLB.textColor =BLACKLB;
    feeLB.text =Localized(@"ShareFees");
    [self.bgView addSubview:feeLB];
    
    UILabel* feeNumLB =[[UILabel alloc]initWithFrame:CGRectMake(64*SCALE_W, 288*SCALE_W, 100*SCALE_W, 17*SCALE_W)];
    feeNumLB.textAlignment =NSTextAlignmentLeft;
    feeNumLB.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    feeNumLB.textColor =LIGHTGRAYLB;
    feeNumLB.text =[NSString stringWithFormat:@"%@",self.fee];
    [self.bgView addSubview:feeNumLB];
    
    UIButton * sureBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 476*SCALE_W, SYSWidth, 48*SCALE_W)];
    if (LL_iPhoneX) {
        sureBtn.frame = CGRectMake(0, 476*SCALE_W-LL_TabbarSafeBottomMargin, SYSWidth,48*SCALE_W);
    }
    [sureBtn setTitle:Localized(@"Confirm") forState:UIControlStateNormal];
    [sureBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    sureBtn.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [sureBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDF2F5"]];
    [sureBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (_callback) {
            _callback(@"");
        }
        [self dismiss];
    }];
    [self.bgView addSubview:sureBtn];
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
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(0, SYSHeight-524*SCALE_W , Screen_Width, 524*SCALE_W)];
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
    NSInteger y =  Screen_Width==375 ?Screen_height+43:Screen_height ;
    
    _bgView.frame = CGRectMake(0, y , Screen_Width - (SCALE_W * 0), 524*SCALE_W);
    
    [UIView animateWithDuration:.2 animations:^{
        _bgView.frame = CGRectMake(0, SYSHeight-524*SCALE_W , Screen_Width - (SCALE_W * 0), 524*SCALE_W);
        _maskView.alpha = .5;
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y += _bgView.bounds.size.height;
        _bgView.frame = rect;
        _maskView.alpha =0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.superview.hidden = YES;
    }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self dismiss];
}
@end
