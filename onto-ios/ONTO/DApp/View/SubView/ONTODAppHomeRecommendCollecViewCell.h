//
//  ONTODAppHomeRecommendCollecViewCell.h
//  ONTO
//
//  Created by onchain on 2019/5/20.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONTODAppHomeAppModel;
NS_ASSUME_NONNULL_BEGIN

@interface ONTODAppHomeRecommendCollecViewCell : UICollectionViewCell

-(void)refreshCollectCellModel:(ONTODAppHomeAppModel*)model;

@end

NS_ASSUME_NONNULL_END
