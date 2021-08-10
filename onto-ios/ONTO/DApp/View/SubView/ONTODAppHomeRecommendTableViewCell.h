//
//  ONTODAppHomeRecommendTableViewCell.h
//  ONTO
//
//  Created by onchain on 2019/5/20.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ONTODAppHomeRecommendTableViewCellDelegate <NSObject>

- (void)enterDappGameWithUrlStr:(NSString*)urlStr;

@end
@interface ONTODAppHomeRecommendTableViewCell : UITableViewCell

-(void)refreshCellWtihDAppList:(NSArray*)list;

@property(nonatomic,weak)id<ONTODAppHomeRecommendTableViewCellDelegate>  delegate;

-(void)changeTitleWithName:(NSString*)str;

@end

NS_ASSUME_NONNULL_END
