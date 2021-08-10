//
//  ONTODAppHomeBannerTableViewCell.h
//  ONTO
//
//  Created by onchain on 2019/5/20.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ONTODAppHomeBannerTableViewCellDelegate <NSObject>

- (void)enterDappGameWithUrlStr:(NSString*)urlStr;

@end
@interface ONTODAppHomeBannerTableViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style AndCellWidth:(CGFloat)cellWidth reuseIdentifier:(NSString *)reuseIdentifier;

-(void)refreshCellWtihList:(NSArray*)list;

@property(nonatomic,weak)id<ONTODAppHomeBannerTableViewCellDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
