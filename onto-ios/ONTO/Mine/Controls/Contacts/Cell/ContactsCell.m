//
//  ContactsCell.m
//  ONTO
//
//  Created by 赵伟 on 16/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "ContactsCell.h"
#import "Config.h"
#import "UIView+Scale.h"
@implementation ContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_iconImage scaleFrameBaseWidth];
    [_contactsL scaleFrameBaseWidth];
    [_addrL scaleFrameBaseWidth];

    //描边
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = 20*SCALE_W;
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
