//
//  ONTODAppHistoryListModel.h
//  ONTO
//
//  Created by onchain on 2019/5/13.
//  Copyright © 2019 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONTODAppHistoryListModel : NSObject
//历史记录的搜索标题
@property(nonatomic,copy)NSString       *historyTitle;
//历史记录的搜索Url地址
@property(nonatomic,copy)NSString       *historyUrlStr;

@end

NS_ASSUME_NONNULL_END
