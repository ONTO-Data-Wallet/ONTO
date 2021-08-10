//
//  SelectDefaultWallet.h
//  ONTO
//
//  Created by Apple on 2019/5/16.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectDefaultWallet : UIView
- (instancetype)initWithOptionsArr:(NSArray*)optionsArr
                        shareArray:(NSArray *)shareArray
                       cancelTitle:(NSString*)cancelTitle
                actionBlock:(void(^)(void ))actionBlock;
@end

NS_ASSUME_NONNULL_END
