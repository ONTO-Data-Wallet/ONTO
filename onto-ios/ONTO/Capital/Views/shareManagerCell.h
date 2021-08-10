//
//  shareManagerCell.h
//  ONTO
//
//  Created by Apple on 2018/7/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shareManagerCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *typeImage;
@property(nonatomic,strong)UILabel     *typeLB;
-(void)sizeToFitHeight:(NSString*)string;
@end
