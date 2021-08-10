//
//  ONTODAppHistoryTableViewCell.h
//  ONTO
//
//  Created by onchain on 2019/5/9.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONTODAppHistoryListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ONTODAppHistoryTableViewCell : UITableViewCell

-(void)setCellShowWithModel:(ONTODAppHistoryListModel*)model;

@end

NS_ASSUME_NONNULL_END
