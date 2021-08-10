//
//  ThirdpartyViewController.h
//  ONTO
//
//  Created by 赵伟 on 30/05/2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"

@interface ThirdpartyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *myTitleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitle1;

@property (nonatomic,copy) NSDictionary *dic;
@property (nonatomic,copy) NSString *thirdOntId;
@property (nonatomic,copy) NSString *seesion;

@end
