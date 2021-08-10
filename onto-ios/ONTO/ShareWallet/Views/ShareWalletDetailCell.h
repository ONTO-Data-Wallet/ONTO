//
//  ShareWalletDetailCell.h
//  ONTO
//
//  Created by Apple on 2018/7/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTradeModel.h"
@interface ShareWalletDetailCell : UITableViewCell
@property(nonatomic,strong)UILabel     *moneyNumLB;
@property(nonatomic,strong)UIImageView *redDot;
@property(nonatomic,strong)UILabel     *timeLB;
@property(nonatomic,strong)UILabel     *addressLB;
@property(nonatomic,strong)UILabel     *statusLB;
-(void)reloadCell:(ShareTradeModel*)model isONT:(BOOL)isONT;
@end
