//
//  LKLPayCodeCollectionViewCell.h
//  LakalaClient
//
//  Created by Apple on 2017/10/12.
//  Copyright © 2017年 LR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LKLPayCodeCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSIndexPath *indePath;    // 需添加在 cellType 之前
@property (nonatomic, assign) NSInteger cellNum;        // 需添加在 cellType 之前
@property (nonatomic, strong) UIColor *cellBorderColor; // 设置边框颜色(默认黑色)
@property (nonatomic, copy)   NSString *titleString;
@property (nonatomic, assign) BOOL      isPWD;     // 是否密码（默认NO）
-(void)setNewFrame;
@end
