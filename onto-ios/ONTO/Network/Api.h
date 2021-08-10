//
//  Api.h
//  ONTO
//
//  Created by Zeus.Zhang on 2018/1/31.
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

//#ifndef Api_h
#define Api_h






#ifdef DEBUG


//开发环境
//#define BaseURL @"https://app.ont.io"
//#define H5URL @"https://app.ont.io"
//#define SokectURL @"ws://app.ont.io"
//#define CapitalURL @"https://polarisexplorer.ont.io"


#define BaseURL @"https://service.onto.app"
#define H5URL @"https://service.onto.app"
#define SokectURL @"ws://service.onto.app"
#define CapitalURL @"https://explorer-tool.ont.io"//https://ontoexplorer.ont.io

#define DebugLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#define CANDY_SEVER 0

#else

#define CANDY_SEVER 1

//生产环境
#define BaseURL @"https://service.onto.app"
#define H5URL @"https://service.onto.app"
#define SokectURL @"ws://service.onto.app"
#define CapitalURL @"https://ontoexplorer.ont.io"

#define DebugLog(...)
#endif


//s1
#define Devicecode_gain @"/S1/api/v1/ontpass/devicecode/gain"//获取devicecode
#define Devicecode_regain @"/S1/api/v1/ontpass/devicecode/regain" // 重新获取devicecode
#define Brief_query @"/S1/api/v1/ontpass/claim/brief/query"
#define Claim_query @"/S1/api/v1/ontpass/claim/query"  //claim详情接口
#define Claim_confirm @"/S1/api/v1/ontpass/claim/confirm"  //更改claim状态
#define claimcard_query @"/S1/api/v1/ontpass/claimcard/brief/query" //用户可信卡片基本信息查询
#define Ontpassclaimcardquery @"/S1/api/v1/ontpass/claimcard/query"// 用户可信卡片详情查询
#define Claimcard_generate  @"/S1/api/v1/ontpass/claimcard/generate"//生成可信卡片并做可信存储
#define Claimcard_update @"/S1/api/v1/ontpass/claimcard/update"//更新可信卡片
#define Notice_query @"/S1/api/v1/ontpass/notice/query"//用户历史通知消息查询
#define Ontidregister  @"/S1/api/v1/ontpass/ontid/register" //创建身份调用的接口
#define DDOUpdate @"/S1/api/v1/ontpass/ddo/update" //用户确认接收某个可信声明并将其写入到DDO时，调该接口
#define Assettransfer  @"/S1/api/v1/ontpass/asset/transferSelfPay" //资产转账自付API
#define AssettransferotherPay  @"/S1/api/v1/ontpass/asset/transfer" //资产转账代付API
#define PayforClaimOng @"/S1/api/v1/ontpass/asset/payforClaimOng" //代付Ong的提取

#define ThirdpartyInfo @"/S1/api/v1/ontpass/thirdparty/info"//第三方信息
#define ThirdpartyVerification @"/S1/api/v1/ontpass/thirdparty/verification"//用户发送可信声明用于场景方认证
#define LocalizationConfirm @"/S1/api/v1/ontpass/localization/confirm" //可信声明本地化确认

//s3
#define Email_Send @"/S3/api/v1/onto/email/send"//邮件发送
#define MobileCodeSend @"/S3/api/v1/onto/sms/verificationcode/send"//手机验证码发送
#define MobileCodeCheck @"/S3//api/v1/onto/sms/verificationcode/verification"//手机验证码验证
#define EmailCodeSend @"/S3/api/v1/onto/email/verificationcode/send"//邮箱验证码发送
#define EmailCodeCheck @"/S3/api/v1/onto/email/verificationcode/verification"//邮箱验证码验证

#define Trustanchor_query @"/S2/api/v1/trustanchor/list" // Trust Anchor列表
#define Ongamount_query @"/S3/api/v1/onto/appconfig/query"//获取链上配置
//#define History_trade @"/api/v1/explorer/address/"//分页查询某个地址的所有转账交易信息
#define GetAfterTimeWithLanguages @"/S3/api/v1/onto/SystemMessage/GetAfterTimeWithLanguages"
#define History_trade @"/S1/api/v1/ontpass/address/queryinfo"
#define TradeList @"/api/v1/explorer/address" // 某个地址的某种资产

#define Version_update @"/S3/api/v1/onto/appclientversion/query?platform=ios&currentVersionCode="
#define Get_UNIT @"/S3/api/v1/onto/exchangerate/reckon/ont/USD/1"
#define FaceAuth @"/S2/api/v1/trustanchor/face/auth"// CFCA实名认证签发
#define ShangTangAuth @"/S2/api/v1/trustanchor/shangtang/verifyLivenessId" // 商汤
#define Claimissue @"/S2/api/v1/trustanchor/claim/issue"//linkedin及facebook可信声明签发
#define COTInfo @"/S1/api/v1/ontpass/thirdparty/info" //COT
#define COTConfirm  @"/S1/api/v1/ontpass/auth/confirm"//授权确认API
#define COTAuthList @"/S1/api/v1/ontpass/authentication/record/"  // 授权记录
#define AUTHList    @"/S2/api/v1/trustanchor/transfertxn"    // 认证记录
#define NEWAUTHLIST @"/S1/api/v1/ontpass/claim/record"  //可信声明认证记录

#define CreateSharedWallet @"/S1/api/v1/ontpass/SharedWallet/create" //创建共享钱包
#define GetShareWalletDetail @"/S1/api/v1/ontpass/SharedWallet/getBySharedWalletAddress" //共享钱包详情
#define GetShareWalletPending @"/S1/api/v1/ontpass/SharedTransfer/listSigningBeforeTime" //共享钱包交易列表
#define CreateSharedWalletTrade @"/S1/api/v1/ontpass/SharedTransfer/create" //创建共享钱包交易
#define SignSharedWalletTrade @"/S1/api/v1/ontpass/SharedTransfer/sign" //签名共享钱包交易
#define SendTradeToChain @"/S1/api/v1/ontpass/SharedTransfer/isSendToChain" //上链共享交易
#define CheckCompleteTrade @"/api/v1/explorer/address/timeandpage" //完成状态共享交易

#define New_History_trade @"/S1/api/v1/ontpass/address/queryinfoBeforeTime2"
#define Get_Blance @"/api/v1/explorer/address/balance"
#define New_txnstate @"https://swap.ont.io/api/v1/onttxn/txnstate"


#define IdentityMind_API "/S2/api/v1/trustanchor/identitymind/apply"  //IdentityMind认证
#define IdentityMind_Info "/S2/api/v1/trustanchor/identitymind/inreview/info" //审核中信息
#define ShuftiPro     "/S2/api/v1/trustanchor/shuftipro/apply"  // shuftipro 认证
#define Shufti_Info "/S2/api/v1/trustanchor/shuftipro/inreview/info" // shuftipro 审核中信息
#define App_Id @"VSBaRKF1"
#define App_Secret @"peSWkLosxs1flqq9s6AkaQ=="

#define DragonList @"http://hyd-ont-api.alfakingdom.com/get-dragon-list"     //云斗龙列表
