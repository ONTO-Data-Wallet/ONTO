//
//  SwapListCell.h
//  ONTO
//
//  Created by Apple on 2018/7/16.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwapListCell : UITableViewCell
@property(nonatomic,strong)UILabel     *moneyNumLB;
@property(nonatomic,strong)UILabel     *timeLB;
@property(nonatomic,strong)UILabel     *addressLB;
@property(nonatomic,strong)UILabel     *statusLB;
-(void)reloadCellByDic:(NSDictionary*)dic ;
@end
