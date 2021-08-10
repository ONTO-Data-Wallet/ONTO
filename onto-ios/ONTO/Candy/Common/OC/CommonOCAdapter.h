//
//  CommonOCAdapter.h
//  ONTO
//
//  Created by PC-269 on 2018/8/27.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ONTID_CANDY_AMOUNT    @"ONTID_CANDY_AMOUNT"
#define ONTID_CANDY_SESSION   @"ONTID_CANDY_SESSION"
#define ONTID_CANDY_SING      @"ONTID_CANDY_SING"
#define Content_Limit_Count  140

typedef void (^RequestCommonBlock)(BOOL bSucces,id callBacks);

@class SendConfirmView;
@interface CommonOCAdapter : NSObject

@property(nonatomic, strong) NSDictionary *refInfoDic;

+ (CommonOCAdapter *)share;
+ (NSString *)getUserLanguage;
+ (NSArray *)getWalletList;
+ (NSString *)getPublicKey;
+ (NSDictionary *)getWalletDict;
+ (NSString *)getWalletAddress;
-(void)confirmPwd:(NSString *)pwd handler:(RequestCommonBlock)handler;
-(UITabBarController *)tabController;
-(NSInteger)indexByName:(NSString *)className;
-(void)setTabIndex:(NSString *)className;
- (void)showQrScan:(UIViewController *)baseController handler:(RequestCommonBlock)handler;
-(void)createCOT:(NSString*)string inCv:(UIViewController *)cv handler:(RequestCommonBlock)handler;
- (SendConfirmView *)showConfirmV:(UIViewController *)cv content:(NSString *)content handler:(RequestCommonBlock)handler;
-(void)signContent:(NSString *)content pwd:(NSString *)confirmPwd handler:(RequestCommonBlock)handler; //对content进行签名
-(NSDictionary *)getOntAccount;
-(BOOL)bKycVerfied;
-(void)saveOntSession:(NSString *)results;
-(BOOL)deleteOntSession;
-(NSString *)getOntSession;;
-(void)saveInKeyChain:(NSString *)value key:(NSString *)key;
-(NSString *)valueInKeyChain:(NSString *)key;
-(void)saveDic:(NSDictionary *)dict byKey:(NSString *)key;
-(id)objectValueForKey:(NSString *)key;
-(NSString *)getOntAmout;
-(void)saveOntCount:(NSDictionary *)dict;
-(NSDictionary *)getOntDictionary;
-(BOOL)deleteItemInKeyChain:(NSString *)key;

@end
