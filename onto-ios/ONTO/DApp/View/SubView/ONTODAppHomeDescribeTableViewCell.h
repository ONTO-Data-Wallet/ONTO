//
//  ONTODAppHomeDescribeTableViewCell.h
//  ONTO
//
//  Created by onchain on 2019/5/21.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONTODAppHomeAppModel;
NS_ASSUME_NONNULL_BEGIN
@protocol ONTODAppHomeDescribeTableViewCellDelegate <NSObject>

- (void)enterDappGameWithUrlStr:(NSString*)urlStr;

@end
@interface ONTODAppHomeDescribeTableViewCell : UITableViewCell

@property(nonatomic,weak)id<ONTODAppHomeDescribeTableViewCellDelegate>  delegate;

-(void)refreshCellWtihModel:(ONTODAppHomeAppModel*)model;

@end

NS_ASSUME_NONNULL_END
