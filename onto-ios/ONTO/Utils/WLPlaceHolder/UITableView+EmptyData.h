//
//  UITableView+WLEmptyPlaceHolder.h
//  WLPlaceHolder
//
//  Created by 王林 on 16/5/11.
//  Copyright © 2016年 com.ptj. All rights reserved.
//

@import UIKit;

@interface UITableView (EmptyData)
//添加一个方法
- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end


