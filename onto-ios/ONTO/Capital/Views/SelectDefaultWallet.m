//
//  SelectDefaultWallet.m
//  ONTO
//
//  Created by Apple on 2019/5/16.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "SelectDefaultWallet.h"


#import "Config.h"
#import "shareManagerCell.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SPACE 10

@interface SelectDefaultWallet ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionView2;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) NSArray *optionsArr;
@property (nonatomic, strong) NSArray *actionArr;
@property (nonatomic, strong) NSArray *shareArray;
@property (nonatomic,   copy) NSString *cancelTitle;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic,   copy) void(^actionBlock)( void);
@end

@implementation SelectDefaultWallet
-(instancetype)initWithOptionsArr:(NSArray *)optionsArr shareArray:(NSArray *)shareArray cancelTitle:(NSString *)cancelTitle actionBlock:(void(^)(void ))actionBlock{
    if (self = [super init]) {
        _optionsArr = optionsArr;
        _shareArray = shareArray;
        _cancelTitle = cancelTitle;
        _actionBlock = actionBlock;
        NSString *str =[NSString stringWithFormat:@"%@",Localized(@"CreateWallet")];
        [self craetUI];
    }
    return self;
}

- (void)craetUI {
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.topView];
    [self.topView addSubview:self.collectionView];
    [self.bgView addSubview:self.cancelBtn];
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
-(UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc ]initWithFrame:CGRectMake(0, 0, SYSWidth-16*SCALE_W, 132*SCALE_W) collectionViewLayout:flowLayout] ;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds =YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator =NO;
        [_collectionView registerClass:[shareManagerCell class] forCellWithReuseIdentifier:@"shareManager"];
    }
    return _collectionView;
}
-(UIView*)bgView{
    if (!_bgView) {
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(8*SCALE_W, SYSHeight-331*SCALE_W +132*SCALE_W, Screen_Width - (SCALE_W * 16), (331-132)*SCALE_W)];
        _bgView.clipsToBounds =YES;
    }
    return _bgView;
}
-(UIView*)topView{
    if (!_topView) {
        _topView =[[UIView alloc]initWithFrame:CGRectMake(0,0, Screen_Width - (SCALE_W * 16), 132*SCALE_W)];
        _topView.layer.cornerRadius =5;
        _topView.clipsToBounds =YES;
        _topView.backgroundColor =[UIColor whiteColor];
    }
    return _topView;
}
-(UIButton*)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 140*SCALE_W, SYSWidth -16*SCALE_W, 50*SCALE_W)];
        _cancelBtn.backgroundColor =[UIColor whiteColor];
        _cancelBtn.layer.cornerRadius =5;
        [_cancelBtn setTitle:Localized(@"Cancel") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:BLACKLB forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        [_cancelBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [self dismiss];
        }];
    }
    return _cancelBtn;
}
-(UIView*)line{
    if (!_line) {
        _line =[[UIView alloc]initWithFrame:CGRectMake(0, 132*SCALE_W-0.5, SYSWidth-16*SCALE_W, 1)];
        _line.backgroundColor =LINEBG;
    }
    return _line;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_collectionView isEqual:collectionView]) {
        return _optionsArr.count;
    }
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    shareManagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shareManager" forIndexPath:indexPath];
    if ([collectionView isEqual:_collectionView]) {
        cell.typeLB.text =self.optionsArr[indexPath.row];
        [cell sizeToFitHeight:self.optionsArr[indexPath.row]];
        cell.typeImage.image =[UIImage imageNamed:@"newWallet"];
        if (self.shareArray.count>0) {
            for (int i=0; i<self.shareArray.count; i++) {
                if ([self.shareArray[i]intValue] == indexPath.row ) {
                    
                    cell.typeImage.image =[UIImage imageNamed:@"newShare"];
                }
            }
        }
        if (indexPath.row==[[[NSUserDefaults standardUserDefaults]valueForKey:SELECTWALLET] integerValue]) {
            cell.typeLB.textColor =  [UIColor colorWithHexString:@"#0AA5C9"];
        }
    }else{
        NSDictionary *dic =self.actionArr[indexPath.row];
        cell.typeLB.text =dic[@"title"];
        cell.typeImage.image =[UIImage imageNamed:dic[@"image"]];
        [cell sizeToFitHeight:dic[@"title"]];
    }
    return cell ;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary* walletDict = array[indexPath.row];
    NSString *jsonStr = [Common dictionaryToJson:walletDict];
    [Common setEncryptedContent:jsonStr WithKey:ASSET_ACCOUNT];
    self.actionBlock();
    [self dismiss];
}
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80*SCALE_W, 132*SCALE_W);
}
//调节item边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0*SCALE_W, 0, 0*SCALE_W);
}
- (void)show {
    NSInteger y =  Screen_Width==375 ?Screen_height+43:Screen_height ;
    
    _bgView.frame = CGRectMake(8*SCALE_W, y , Screen_Width - (SCALE_W * 16), (331-131)*SCALE_W);
    
    [UIView animateWithDuration:.2 animations:^{
        _bgView.frame = CGRectMake(8*SCALE_W, SYSHeight-331*SCALE_W+132*SCALE_W , Screen_Width - (SCALE_W * 16), (331-132)*SCALE_W);
        _maskView.alpha = .5;
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y += _bgView.bounds.size.height;
        _bgView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.superview.hidden = YES;
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
