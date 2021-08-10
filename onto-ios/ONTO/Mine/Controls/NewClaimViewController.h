//
//  NewClaimViewController.h
//  ONTO
//
//  Created by Apple on 2018/11/22.
//  Copyright © 2018 Zeus. All rights reserved.
//

#import "BaseViewController.h"


@interface NewClaimViewController : BaseViewController
@property (nonatomic, copy) NSString *claimId;
@property (nonatomic, copy) NSString *claimImage;
@property (nonatomic, copy) NSString *claimContext;
@property (nonatomic, copy) NSString *H5ReqParam;

@property (nonatomic, assign) BOOL isPending;
@property (nonatomic, assign) NSInteger stauts;
@property (nonatomic, assign) BOOL isFace;
@end

