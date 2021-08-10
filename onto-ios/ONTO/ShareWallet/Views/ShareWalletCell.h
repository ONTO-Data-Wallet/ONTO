//
//  ShareWalletCell.h
//  ONTO
//
//  Created by Apple on 2018/7/9.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareWalletCell : UITableViewCell
@property(nonatomic,strong)UILabel          * titleLB;
@property(nonatomic,strong)UITextField      * nameField;
@property(nonatomic,strong)UITextField      * totalNumField;
@property(nonatomic,strong)UITextField      * requiredNumField;
@property(nonatomic,strong)UITextField      * addressField;
@property(nonatomic,strong)UIImageView      * rightImage;
@end
