//
//  ImportViewController.h
//  ONTO
//
//  Created by Zeus.Zhang on 2018/2/27.
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

#import "BaseViewController.h"

typedef enum:NSInteger {
    
    ScanNormal = 0,
    ScanWithDraw
    
}ScanType;

@interface ImportViewController : BaseViewController

//todo 枚举
@property (nonatomic, assign) BOOL isWallet; //创建钱包
@property (nonatomic, assign) BOOL isVerb;   //转账流程二维码
@property (nonatomic, assign) BOOL isReceiverAddress; //接收地址信息
@property (nonatomic, assign) BOOL isShareWalletAddress; //共享钱包
@property (nonatomic, assign) BOOL isCOT;//cot
@property (nonatomic, copy) void (^callback)(NSString *);
@property (nonatomic, assign) BOOL isImportWallet; //重新导入
@property (nonatomic, assign) BOOL isKeyStore;//keystore导入
@property (nonatomic, assign) BOOL isThired;//第三方
@property (nonatomic, assign) BOOL isPay;//支付
@property(nonatomic, assign) ScanType scanType;
@property(nonatomic, strong) NSDictionary *refInfoDic; //kyc认证的数据

@end
