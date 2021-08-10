//
//  ShareTradeModel.h
//  ONTO
//
//  Created by Apple on 2018/7/22.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "copayerSignModel.h"
@interface ShareTradeModel : NSObject
@property(nonatomic,copy)NSString        *createtimestamp;
@property(nonatomic,copy)NSString        *receiveaddress;
@property(nonatomic,copy)NSString        *sendaddress;
@property(nonatomic,copy)NSString        *transactionbodyhash;
@property(nonatomic,copy)NSString        *transactionidhash;
@property(nonatomic,copy)NSString        *gaslimit;
@property(nonatomic,copy)NSString        *gasprice;
@property(nonatomic,copy)NSString        *amount;
@property(nonatomic,assign)BOOL          isRead;
@property(nonatomic,strong)NSArray<copayerSignModel*> *coPayerSignVOS;
@end
