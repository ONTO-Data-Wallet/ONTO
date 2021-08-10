//
//  TradeModel.h
//  ONTO
//
//  Created by 张超 on 2018/3/26.
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

#import <Foundation/Foundation.h>

@interface TransferModel : NSObject

//@property (nonatomic, copy) NSString *Amount;
//@property (nonatomic, copy) NSString *FromAddress;
//@property (nonatomic, copy) NSString *ToAddress;

@end

@interface TradeModel : NSObject

//"transferhash": "0a428d60af5b555f6751453e3c97bfa582a046148b5d23e5c98cf0d93eb95ad7",
//"sendaddress": "ATc5gXifZQ1C1gMCoRMrGEvhWxhvQ5w1RG",
//"receiveaddress": "AX2kRrJWLqdcrC9fq7CUswPjdXz6hGLBRe",
//"assetname": "ont",
//"amount": 1,
//"amoutStr": "1.000000000",
//"issuccess": null,
//"createtime": "2018-06-21T16:00:00.000+0000",
//"createTimeLong": 1529596800000
@property (nonatomic, copy) NSString *amoutStr;
@property (nonatomic, copy) NSString *createTimeLong;
@property (nonatomic, copy) NSString *receiveaddress;
@property (nonatomic, copy) NSString *sendaddress;
@property (nonatomic, copy) NSString *Status;
@property (nonatomic, copy) NSString *myaddress;
@property (nonatomic, copy) NSString *issuccess;
@property (nonatomic, copy) NSString *transferhash;

@end
