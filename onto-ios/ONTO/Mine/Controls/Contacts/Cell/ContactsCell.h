//
//  ContactsCell.h
//  ONTO
//
//  Created by 赵伟 on 16/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *contactsL;
@property (weak, nonatomic) IBOutlet UILabel *addrL;

@end
