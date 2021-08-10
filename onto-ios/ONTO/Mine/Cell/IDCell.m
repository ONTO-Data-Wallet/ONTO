//
//  IDCell.m
//  ONTO
//
//  Created by 赵伟 on 2018/3/9.
/*
 * **************************************************************************************
 *  Copyright © 2014-2018 Ontology Foundation Ltd.
 *  All rights reserved.
 *
 *  This software is supplied only under the terms of a license agreement,
 *  nondisclosure agreement or other written agreement with Ontology Foundation Ltd.
 *  Use, redistribution or other disclosure of any parts of this
 *  software is prohibited except in accordance with the terms of such written
 *  agreement with Ontology Foundation Ltd. This software is confidential
 *  and proprietary information of Ontology Foundation Ltd.
 *
 * **************************************************************************************
 *///

#import "IDCell.h"
#import "Config.h"
#import "UIViewController+HUD.h"
@implementation IDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _ontIDLabel.text = [NSString stringWithFormat:@"ONT ID: %@",[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]];
    _nameLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:IDENTITY_NAME]];
    _iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"随机icon%ld",(long)([[[NSUserDefaults standardUserDefaults]valueForKey:SELECTINDEX]integerValue]+1)%5+1]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)ontidCopyAction:(id)sender {
    
//    [self showHint:Localized(@"OntidCopySuccess")];
    [Common showToast:Localized(@"OntidCopySuccess")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [[NSUserDefaults standardUserDefaults]valueForKey:ONT_ID];
    
}

- (void)showHint:(NSString *)hint {
    if (![hint isKindOfClass:[NSString class]]) {
        hint= @"出错了";
    }
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    if (hint.length) {
        hud.label.text = hint;
        
    }else{
        hud.label.text = @"未知错误";
        
    }
    hud.margin = 5.f;
    hud.offset = CGPointMake(0,  250.f);
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}


@end
