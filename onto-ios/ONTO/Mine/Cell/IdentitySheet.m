//
//  SureCustomActionSheet.m
//  SureCustomActionSheet
//
//  Created by 刘硕 on 2017/5/5.
//  Copyright © 2017年 刘硕. All rights reserved.
//

#import "IdentitySheet.h"
#import "WalletListCell.h"
#import "Config.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SPACE 10
@interface IdentitySheet ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *optionsArr;
@property (nonatomic,   copy) NSString *cancelTitle;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic,   copy) void(^selectedBlock)(NSIndexPath *);
@property (nonatomic,   copy) void(^cancelBlock)();
@end
@implementation IdentitySheet

- (instancetype)initWithTitleView:(UIView*)titleView
                       optionsArr:(NSArray*)optionsArr
                      cancelTitle:(NSString*)cancelTitle
                    selectedBlock:(void(^)(NSIndexPath *))selectedBlock
                      cancelBlock:(void(^)(NSIndexPath *))cancelBlock {
    if (self = [super init]) {
        _headView = titleView;
        _optionsArr = optionsArr;
        _cancelTitle = cancelTitle;
        _selectedBlock = selectedBlock;
        _cancelBlock = cancelBlock;
        [self craetUI];
    }
    return self;
}

- (void)craetUI {
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 2;
        _tableView.clipsToBounds = YES;
        _tableView.rowHeight = 50;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = self.headView;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Navi_Cell"];
    }
    return _tableView;
}
#pragma mark TableViewDel
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return (section == 0)?_optionsArr.count:1;
    
    if (section == 0) {
        return _optionsArr.count;
    }else {
        return 1;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WalletListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WalletListCell" owner:self options:nil] lastObject];
    
    if (indexPath.section == 0) {
        
        cell.nameLabel.text = _optionsArr[indexPath.row];
        if (indexPath.row == _optionsArr.count - 1) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                                      CGRectMake(0, 0, Screen_Width - (SPACE * 2), tableView.rowHeight) byRoundingCorners:
                                      UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:
                                      CGSizeMake(2, 2)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
            maskLayer.frame = cell.contentView.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
            
        }
        
        if (indexPath.section==0&&indexPath.row==0) {
            
            cell.rightImage.image = [UIImage imageNamed:@"dark 2"];
            cell.nameLabel.text = Localized(@"BUId");
            
        }else if (indexPath.section==0&&indexPath.row==1) {
            cell.rightImage.image = [UIImage imageNamed:@"s_dark_2"];
            cell.nameLabel.text = Localized(@"SwithId");
        }
        
    }  else {
        
        cell.nameLabel.text = _cancelTitle;
        cell.nameLabel.textColor = [UIColor colorWithHexString:@"#2B4045"];
        cell.layer.cornerRadius = 2;
        cell.rightImage.hidden = YES;
        cell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold"size:18];
        cell.nameLabel.textAlignment = NSTextAlignmentCenter;
        
        {
            
            if (indexPath.row==0) {
                
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                                          CGRectMake(0, 0, Screen_Width - (SPACE * 2), tableView.rowHeight) byRoundingCorners:
                                          UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:
                                          CGSizeMake(2, 2)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
                maskLayer.frame = cell.contentView.bounds;
                maskLayer.path = maskPath.CGPath;
                cell.layer.mask = maskLayer;
            }else if (indexPath.row==2){
                
                
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                                          CGRectMake(0, 0, Screen_Width - (SPACE * 2), tableView.rowHeight) byRoundingCorners:
                                          UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:
                                          CGSizeMake(2, 2)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
                maskLayer.frame = cell.contentView.bounds;
                maskLayer.path = maskPath.CGPath;
                cell.layer.mask = maskLayer;
            }
        }
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.section == 0) {
    //        if (self.selectedBlock) {
    //            self.selectedBlock(indexPath);
    //        }
    //    }    else {
    //        if (self.cancelBlock) {
    //            self.cancelBlock();
    //        }
    //    }
    self.selectedBlock(indexPath);
    
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 8)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}

- (void)show {
    
    
    
    NSInteger y =  Screen_Width==375 ?Screen_height+210:Screen_height+190;
    
    
    _tableView.frame = CGRectMake(SPACE, y, Screen_Width - (SPACE * 2), _tableView.rowHeight * (_optionsArr.count + 1+2) + _headView.bounds.size.height + (SPACE * 2)+50+50);
    if (_optionsArr.count>=4) {
        _tableView.frame = CGRectMake(SPACE, y, Screen_Width - (SPACE * 2), _tableView.rowHeight * (4 + 1+2) + _headView.bounds.size.height + (SPACE * 2)+50+50);
    }
    
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = _tableView.frame;
        rect.origin.y -= _tableView.bounds.size.height+10;
        _tableView.frame = rect;
        _maskView.alpha = .5;
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = _tableView.frame;
        rect.origin.y += _tableView.bounds.size.height;
        _tableView.frame = rect;
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
