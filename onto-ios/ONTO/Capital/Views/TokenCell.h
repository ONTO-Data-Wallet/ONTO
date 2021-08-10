//
//  TokenCell.h
//  ONTO
//
//  Created by Apple on 2019/1/4.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TokenCell : UITableViewCell
@property(nonatomic,strong)UILabel         *nameLB;
@property(nonatomic,strong)UILabel         *typeLB;
@property(nonatomic,strong)UIImageView     *tokenImage;
@property(nonatomic,strong)UISwitch        *showButton;
-(void)reloadCellByDic:(NSDictionary*)dic ;
@end


