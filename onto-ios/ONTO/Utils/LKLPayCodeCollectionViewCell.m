//
//  LKLPayCodeCollectionViewCell.m
//  LakalaClient
//
//  Created by Apple on 2017/10/12.
//  Copyright © 2017年 LR. All rights reserved.
//

#import "LKLPayCodeCollectionViewCell.h"
#import "Config.h"
@interface LKLPayCodeCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *rightLine;

@end

@implementation LKLPayCodeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setCell];
    }
    return self;
}
-(void)setCell{
//    [self topLine];
//    [self leftLine];
    [self bottomLine];
//    [self rightLine];
    
//    [self setNewFrame];
    

}
-(void)setNewFrame{
//    if (self.indePath.row == 0) {
//        self.leftLine.frame = CGRectMake(0, 0, 1, self.frame.size.height);
//    } else {
//        self.leftLine.frame = CGRectMake(-0.5, 0, 0.5, self.frame.size.height);
//    }    
//    if (self.indePath.row == self.cellNum-1) {
//        self.rightLine.frame = CGRectMake(self.frame.size.width-1, 0, 1, self.frame.size.height);
//    } else {
//        self.rightLine.frame = CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height);
//    }
}
#pragma mark ---------------  Lazy Loading  ---------------

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#196BD8"];
        if (self.isPWD == YES) {
            _titleLabel.textColor = [UIColor blackColor];
        }
        _titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium ];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UIView *)topLine {
    if (!_topLine) {
        
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        _topLine.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_topLine];
    }
    return _topLine;
}

- (UIView *)leftLine {
    if (!_leftLine) {
        
        _leftLine = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 0, 0.5, self.frame.size.height)];
        _leftLine.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_leftLine];
    }
    return _leftLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(3.5, self.frame.size.height-1, self.frame.size.width - 7, 1)];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [self.contentView addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (UIView *)rightLine {
    if (!_rightLine) {
        
        _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
        _rightLine.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_rightLine];
    }
    return _rightLine;
}


#pragma mark -----
#pragma mark ---------------  Setter、Getter  ---------------

- (void)setIndePath:(NSIndexPath *)indePath {
    
    _indePath = indePath;
}

- (void)setCellNum:(NSInteger)cellNum {
    
    _cellNum = cellNum;
}
- (void)setCellBorderColor:(UIColor *)cellBorderColor {
    
    _cellBorderColor = cellBorderColor;
    
    
    if (cellBorderColor) {            
            self.topLine.backgroundColor = cellBorderColor;
            self.leftLine.backgroundColor = cellBorderColor;
            self.bottomLine.backgroundColor = cellBorderColor;
            self.rightLine.backgroundColor = cellBorderColor;

    }
}


- (void)setTitleString:(NSString *)titleString {
    
    _titleString = titleString;
    
    self.titleLabel.text = titleString;
}

@end
