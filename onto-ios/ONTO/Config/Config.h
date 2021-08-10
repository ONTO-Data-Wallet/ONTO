//
//  Config.h
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

#ifndef Config_h
#define Config_h

#import <YYKit/YYKit.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "BaseNavigationViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Common.h"
#import "UIViewController+HUD.h"
#import "UIImage+LXQRCode.h"
#import "OTAlertView.h"
#import "SGQRCode.h"
#import "CCRequest.h"
#import "ToastUtil.h"
#import "UIButton+Block.h"
#import "MGPopController.h"
#import "AppHelper.h"
#import "UIImage+GradientColor.h"
#import "UserModel.h"
#import "UIButton+EnlargeTouchArea.h"
#import "UILabel+changeSpace.h"

#define USERMODEL   [UserModel shareInstance]
//Nav、Tab颜色字体
#define NAVBACKCOLOR [UIColor colorWithHexString:@"#FFFFFF"]
#define NAVTITLECOLOR [UIColor colorWithHexString:@"#565656"]
#define NAVFONT [UIFont systemFontOfSize:17.0]
#define MAINBACKCOLOR [UIColor colorWithHexString:@"#212121"]
#define TABBARTITLECOLOR [UIColor colorWithHexString:@"#212121"]
#define TABBARTITLECOLORSELECTED [UIColor colorWithHexString:@"#33A4BE"]
#define TABITEMFONT [UIFont systemFontOfSize:10.0]
#define DHC [UIColor colorWithHexString:@"#33c4dc"]

#define MAINAPPCOLOR [UIColor colorWithHexString:@"#20c0db"]
#define TABLEBACKCOLOR [UIColor colorWithHexString:@"#f4f4f4"]

#define GREENLINE [UIColor colorWithHexString:@"#60A614"]
#define LIGHTGRAYBG [UIColor colorWithHexString:@"#F6F8F9"]
#define LIGHTGRAYLB [UIColor colorWithHexString:@"#AAB3B4"]
#define BLACKLB [UIColor colorWithHexString:@"#2B4045"]
#define BLUELB [UIColor colorWithHexString:@"#35BFDF"]
#define DARKBLUELB [UIColor colorWithHexString:@"#0AA5C9"]
#define BUTTONBG [UIColor colorWithHexString:@"#EDF2F5"]
#define LINEBG [UIColor colorWithHexString:@"#E9EDEF"]
#define LIGHTBLACK [UIColor colorWithHexString:@"#a7b0b1"]
#define LIGHTTEXTCOLOR [UIColor colorWithHexString:@"#6A797C" ]


#define K20FONT [UIFont systemFontOfSize:20]
#define K18FONT [UIFont systemFontOfSize:18]
#define K17FONT [UIFont systemFontOfSize:17]
#define K16FONT [UIFont systemFontOfSize:16]
#define K15FONT [UIFont systemFontOfSize:15]
#define K14FONT [UIFont systemFontOfSize:14]
#define K12FONT [UIFont systemFontOfSize:12]

#define K20MFONT [UIFont systemFontOfSize:20 weight:UIFontWeightMedium]
#define K18MFONT [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]
#define K17MFONT [UIFont systemFontOfSize:17 weight:UIFontWeightMedium]
#define K16MFONT [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]
#define K15MFONT [UIFont systemFontOfSize:15 weight:UIFontWeightMedium]
#define K14MFONT [UIFont systemFontOfSize:14 weight:UIFontWeightMedium]
#define K12MFONT [UIFont systemFontOfSize:12 weight:UIFontWeightMedium]

#define K20BFONT [UIFont boldSystemFontOfSize:20]
#define K18BFONT [UIFont boldSystemFontOfSize:18]
#define K17BFONT [UIFont boldSystemFontOfSize:17]
#define K16BFONT [UIFont boldSystemFontOfSize:16]
#define K15BFONT [UIFont boldSystemFontOfSize:15]
#define K14BFONT [UIFont boldSystemFontOfSize:14]
#define K12BFONT [UIFont boldSystemFontOfSize:12]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define TabTitleFont [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold]
#define HomeLanguage @"userLanguage"
#define FIRSTINITLANGUAGE @"FIRSTINITLANGUAGE"
#define UNIT @"unit"
#define kAppVersion @"appVersion"
#define ENORCN [[[NSUserDefaults standardUserDefaults] valueForKey:HomeLanguage] isEqualToString:@"en"]?@"en":@"cn"

#define ENORCNDAXIE [[[NSUserDefaults standardUserDefaults] valueForKey:HomeLanguage] isEqualToString:@"en"]?@"EN":@"CN"

//Tab设置

/** 钱包 **/
#define TABONEIMAGE [UIImage imageNamed:@"Me_ID"]
#define TABONEIMAGESELECTED [UIImage imageNamed:@"Me_ID-B"]
#define TABONETITLE Localized(@"TabWalletTitle")

#define TABONECOLOR [UIColor colorWithHexString:@"#BBBBBB"]
#define TABONECOLORSELECTED [UIColor colorWithHexString:@"#000000"]
/** ONT ID **/
#define TABTWOIMAGE [UIImage imageNamed:@"Me_A"]
#define TABTWOIMAGESELECTED [UIImage imageNamed:@"Me_A-b"]
#define TABTWOTITLE Localized(@"TabOntIdTitle")

#define TABTWOCOLOR [UIColor colorWithHexString:@"#BBBBBB"]
#define TABTWOCOLORSELECTED [UIColor colorWithHexString:@"#000000"]

/** DApp **/
#define DAPPUNSELECTEDIMAGE [UIImage imageNamed:@"DApp_unselected"]
#define TABTHREEIMAGENOTIFICAION [UIImage imageNamed:@"Me_More_h"]

#define DAPPSELECTEDIMAGE [UIImage imageNamed:@"DApp_selected"]
#define TABTHREETITLE Localized(@"TabDAppTitle")

/** 我的 **/
#define TABTHREEIMAGE [UIImage imageNamed:@"more_unselected"]
#define TABTHREEIMAGENOTIFICAION [UIImage imageNamed:@"Me_More_h"]

#define TABTHREEIMAGESELECTED [UIImage imageNamed:@"more_selected"]
#define TABFOURTITLE Localized(@"TabMineTitle")

#define TABTHREECOLOR [UIColor colorWithHexString:@"#BBBBBB"]
#define TABTHREECOLORSELECTED [UIColor colorWithHexString:@"#000000"]

#define TABFOURIMAGE [UIImage imageNamed:@"tab_me"]
#define TABFOURIMAGESELECTED [UIImage imageNamed:@"tab_me_selected"]
#define APPWINDOW [[[UIApplication sharedApplication]windows] objectAtIndex:0]

//国际化
#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"] 

//节点
#define SERVERNODE  [NSString stringWithFormat:@"Ont.SDK.setServerNode('%@')",[[NSUserDefaults standardUserDefaults]valueForKey:TESTNETADDR]]

//预执行节点
#define PRESERVERNODE  [NSString stringWithFormat:@"Ont.SDK.setServerNode('%@')",[[NSUserDefaults standardUserDefaults]valueForKey:PRENODE]]

//iPhone X
#define KIsiPhoneX1 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define KIsiPhoneX2 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define KIsiPhoneX3 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define KIsiPhoneX (KIsiPhoneX1 || KIsiPhoneX2 || KIsiPhoneX3)
// iphone5/se
#define KIsiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// UIScreen width.

#define  LL_ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define  LL_ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define  LL_PreBang (LL_ScreenWidth == 414.f && LL_ScreenHeight == 896.f ? YES : NO)
#define  LL_iPhoneXPre (LL_ScreenWidth == 375.f && LL_ScreenHeight == 812.f ? YES : NO)
#define  LL_iPhoneX  (LL_PreBang || LL_iPhoneXPre)
#define  LL_StatusBarHeight      (LL_iPhoneX ? 44.f : 20.f)
#define  LL_NavigationBarHeight  44.f

#define  LL_TabbarHeight         (LL_iPhoneX ? (49.f+34.f) : 49.f)
#define  LL_TabbarSafeBottomMargin         (LL_iPhoneX ? 34.f : 0.f)
#define  LL_StatusBarAndNavigationBarHeight  (LL_iPhoneX ? 88.f : 64.f)
#define  LL_TopHeight  (LL_iPhoneX ? 24.f : 0.f)
#define  LL_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

#define  LL_iPhone5S (LL_ScreenWidth == 320.f? YES : NO)

#define weakify(var) __weak typeof(var) AHKWeak_##var = var;
#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = AHKWeak_##var; \
_Pragma("clang diagnostic pop")





#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
//节点方法
//#define LOADJS1 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setServerNode('polaris1.ont.io')" completionHandler:nil]
#define LOADJS1 [self.browserView.wkWebView evaluateJavaScript:SERVERNODE completionHandler:nil]

#define LOADJSPRE  [self.browserView.wkWebView evaluateJavaScript:PRESERVERNODE completionHandler:nil] //Ont.SDK.setServerNode('%@')
#define LOADJS2 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setSocketPort('20335')" completionHandler:nil]
#define LOADJS3 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setRestPort('20334')" completionHandler:nil]

#define LOADJS [self.browserView.wkWebView evaluateJavaScript:SERVERNODE completionHandler:nil]; \
[self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setSocketPort('20335')" completionHandler:nil]; \
[self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setRestPort('20334')" completionHandler:nil];

#define APP_ACCOUNT @"DEFAULTACCOUTN"
#define ASSET_ACCOUNT @"ASSETACCOUNT"
#define ALLASSET_ACCOUNT @"ALLASSETACCOUNT"
#define ALLCONTACT_LIST @"ALLCONTACT_LIST"
#define ALLSWAP @"ALLSWAP"
#define INVOKEPASSWORDFREE @"INVOKEPASSWORDFREE"

#define IDENTITY_CREATED @"IDENTITY_CREATED"
#define IDENTITY_BACKUPED @"IDENTITY_BACKUPED"
#define IDENTITY_EXISIT @"IDENTITY_EXISIT"

#define ONT_ID @"ONT_ID"
#define DEVICE_CODE @"DEVICE_CODE"
#define ENCRYPTED_PRIVATEKEY @"ENCRYPTED_PRIVATEKEY"
#define ISFIRST_BACKUP @"ISFIRST_BACKUP"
#define IDENTITY_NAME @"IDENTITYNAME"
#define NOTICETIONTIME @"NOTICETIONTIME"
#define ISTOUCHIDON @"ISTOUCHIDON"




#define START @"START"
#define SELECTINDEX @"selectIndex"
#define NOTIFICATIONSELECTINDEX @"NOTIFICATIONSELECTINDEX"
#define SELECTWALLET @"SELECTWALLET"
#define ISBACKUPONTID @"ISBACKUPONTID"


#define WALLETSELECTINDEX @"WALLETSELECTINDEX"
#define NOTIFICATION_SOCKET_GETCLAIM @"NOTIFICATION_SOCKET_GETCLAIM"
#define NOTIFICATION_SOCKET_LOGOUT @"NOTIFICATION_SOCKET_LOGOUT"
#define NOTIFICATION_SOCKET_APPACTIVE @"NOTIFICATION_SOCKET_APPACTIVE"
#define ISNOTIFICATION @"ISNOTIFICATION"
#define GETNETNOTIFICATION @"GETNETNOTIFICATION"  //有网络通知
#define NONNETNOTIFICATION @"NONNETNOTIFICATION"  //无网络通知
#define EXPIRENOTIFICATION @"EXPIRENOTIFICATION"  //过期重新登录
#define EXPIREMANAGENOTIFICATION @"EXPIREMANAGENOTIFICATION"  //切换身份过期重新登录
#define RESPONSIBLENOTIFICATION @"RESPONSIBLENOTIFICATION"  //免责声明通知
#define CHECKTRANSFER @"CHECKTRANSFER"  //检查交易成功通知
#define NEEDLOGIN_NOTIFICATION @"NEEDLOGIN_NOTIFICATION"  //需要指纹登录通知

#define MYCHECKTRANSFER @"MYCHECKTRANSFER"  //检查交易成功通知

#define CHECKTRANSFERTOMORE @"CHECKTRANSFERTOMORE"  //给more页面发送检查交易成功通知
#define APPTERMS @"https://onto.app/terms"  //用户条款链接
#define APPPRIVACY @"https://onto.app/privacy"  //隐私策略链接

#define WAKEPAY_NOTIFICATION @"WAKEPAY_NOTIFICATION"  //唤醒支付通知

#define FEE               @"FEE"
#define LOGOUTTIME        @"LOGOUTTIME"
#define TESTNETADDR       @"TESTNETADDR"
#define ONTPASSADDRSS     @"ONTPASSADDRSS"

#define PUMPKINHASH       @"PUMPKINHASH"
#define PUMPKINGASLIMIT   @"PUMPKINGASLIMIT"
#define PUMPKINGASPRICE   @"PUMPKINGASPRICE"

#define SHUFTINEEDPAY     @"SHUFTINEEDPAY"
#define SHUFTIADDRESS     @"SHUFTIADDRESS"
#define SHIFTIAMOUT       @"SHIFTIAMOUT"
#define SHIFTIASSETNAME   @"SHIFTIASSETNAME"

#define NETNAME           @"NETNAME"

#define ONTIDGASPRICE     @"ONTIDGASPRICE"
#define ONTIDGASLIMIT     @"ONTIDGASLIMIT"
#define ASSETGASPRICE     @"ASSETGASPRICE"
#define ASSETGASLIMIT     @"ASSETGASLIMIT"
#define GASPRICEMAX       @"GASPRICEMAX"
#define ISONGSELFPAY      @"ISONGSELFPAY"

#define MINCLAIMABLEONG   @"MINCLAIMABLEONG"
#define MINUNBOUNDONG     @"MINUNBOUNDONG"

#define IDAUTHARR         @"IDAUTHARR"
#define SOCIALAUCHARR     @"SOCIALAUCHARR"
#define APPAUCHARR        @"APPAUCHARR"
#define APPMAUCHARR       @"APPMAUCHARR"

#define SYSTEMNOTIFICATIONLIST @"SYSTEMNOTIFICATIONLIST"
#define LAQUSYSTEMNOTIFICATIONLIST @"LAQUSYSTEMNOTIFICATIONLIST"

#define ONTNEP5 @"ONT (NEP-5)"

#define DRAGONCODEHASH @"DRAGONCODEHASH"
#define DRAGONLISTURL  @"DRAGONLISTURL"
#define PRENODE        @"PRENODE"

#define TOKENLIST      @"TOKENLIST"
#define DEFAULTTOKENLIST @"DEFAULTTOKENLIST"
#define TOKENLISTSHOW      @"TOKENLISTSHOW"
//屏幕宽高
#define SYSHeight [UIScreen mainScreen].bounds.size.height
#define SYSWidth  [UIScreen mainScreen].bounds.size.width
#define SCALE_W  ([[UIScreen mainScreen] bounds].size.width/375)
#define SafeAreaTopHeight (kScreenHeight == 812.0 || 896.0 ? 88 : 64)
#define StatusBarHeight (kScreenHeight == 812.0 || 896.0 ? 44 : 20)
#define MainColor [UIColor colorWithHexString:@"#32A4BE"]
#define TUSIHeight (kScreenHeight == 812.0 || 896.0 ? 169 : 135)
#define SafeBottomHeight (kScreenHeight == 812.0 || 896.0 ? 34 : 0)
#define PhotoBottomHeight  (kScreenHeight == 812 || 896.0 ? 83 : 0)
#define PhotoTopHeight  (kScreenHeight == 812.0 || 896.0 ? 64 : 0)

#define SCALE_H   (LL_iPhoneX ? 1 : ((SYSHeight > 667) ?  ([[UIScreen mainScreen] bounds].size.height/667) : 1.2) )

#define ONG_PRECISION_STR @"1000000000"
#define NEP5_PRECISION_STR @"100000000"
#define ONG_ZERO @"0.000000000"

#define ONTIDTX @"ONTIDTX"
#define DEFAULTONTID @"DEFAULTONTID"
#define DEFAULTACCOUTNKEYSTORE @"DEFAULTACCOUTNKEYSTORE"
#define DEFAULTIDENTITY @"DEFAULTIDENTITY"
#define ONTIDAUTHINFO @"ONTIDAUTHINFO"

typedef void (^pwdBlock)(id callBack);

#endif /* Config_h */

