//
//  ShareWalletPayCell.h
//  ONTO
//
//  Created by Apple on 2018/7/13.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashLine.h"
#import "copayerSignModel.h"
@interface ShareWalletPayCell : UITableViewCell
@property(nonatomic,strong)UILabel     *nameLB;
@property(nonatomic,strong)UILabel     *addressLB;
@property(nonatomic,strong)UIImageView *statusImage;
@property(nonatomic,strong)UIButton    *sentButton;
@property(nonatomic,strong)UIView      *line;
@property(nonatomic,strong)UILabel     *indexLB;
@property(nonatomic,strong)DashLine      *topBlueLine;
@property(nonatomic,strong)DashLine      *topGrayLine;
@property(nonatomic,strong)DashLine      *bottomBlueLine;
@property(nonatomic,strong)DashLine      *bottomGrayLine;
-(void)reloadCellByDic:(copayerSignModel*)dic row:(NSInteger)row nowRow:(NSInteger)nowRow;
@end
