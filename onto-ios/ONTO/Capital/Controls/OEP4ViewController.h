//
//  OEP4ViewController.h
//  ONTO
//
//  Created by Apple on 2019/1/4.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import "BaseViewController.h"


@interface OEP4ViewController : BaseViewController
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *exchange;
@property (nonatomic, copy) NSString *GoalType;
@property (nonatomic, strong) NSDictionary *walletDict;
@property (nonatomic, copy) NSString *ongAppove;
@property (nonatomic, copy) NSString *ongAmount;
@property (nonatomic, copy) NSString *ontAmount;

@property (nonatomic, copy) NSString *waitboundong;
@property (nonatomic, strong) NSDictionary *tokenDict;
@end


