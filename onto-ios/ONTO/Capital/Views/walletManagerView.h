//
//  walletManagerView.h
//  ONTO
//
//  Created by Apple on 2018/7/10.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface walletManagerView : UIView
- (instancetype)initWithOptionsArr:(NSArray*)optionsArr
                    shareArray:(NSArray *)shareArray 
                      cancelTitle:(NSString*)cancelTitle
                    defaultWalletBlock:(void(^)(NSIndexPath *))defaultWalletBlock
                     selectedBlock:(void(^)(NSIndexPath *))selectedBlock;;
@end
