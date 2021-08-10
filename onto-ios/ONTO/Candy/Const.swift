//
//  Const.swift
//  LocationU
//
//  Created by zhan zhong yi on 17/1/4.
//  Copyright © 2017年 zhan zhong yi. All rights reserved.
//

import UIKit
import Darwin;

func LocalizeEx(_ key:String) -> String {
    
    let p = UserDefaults.standard.object(forKey: "userLanguage") as! String
    let path = Bundle.main.path(forResource: p, ofType: "lproj")
    let bundle = Bundle.init(path: path!)
    let v = bundle?.localizedString(forKey: key, value: nil, table: "Localizable")
    return v ?? "";
}

func bLocalizeZh() -> Bool {
    
    let p = UserDefaults.standard.object(forKey: "userLanguage") as! String
    if p.contains("zh") == true {
        return true
    }
    
    return false;
}

class Const: NSObject {

    static let bDebug = false;
    static let kBundleIdEx =  "com."
    
    struct url {
        
//        "https://candybox-testnet.onto.app";//测试环境
//        "https://candybox.onto.app";//生产环境
        #if CANDY_SEVER
        static let kTDDomainEx = "http://47.52.72.227:7001" //"https://candybox-testnet.onto.app"
        #else
        static let kTDDomainEx = "https://candybox.onto.app"
        #endif
        static let kTDGeneralURLEx = kTDDomainEx + "";
        
    }
    
    struct msg {
    
        static let print_default = "打印信息出错！"
        static let kServerStateErrorEx = LocalizeEx("candy_kSeverState_error") + "!"
    }
    
    struct value {
        static let kSectionHeight = 10
        static let kPageSize5 =     5
    }

    func RGBCOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor
    {
        return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
    }
    
    struct GlobalConstants {
        
        //  Device IPHONE,Constant Variable.
        static let kBirthDate                     =    "DateOfBirth"
        static let kFirstName                     =    "FirstName"
        static let kLastName                      =    "LastName"
    }
    
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let IS_IPHONE_P_OR_MORE  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH >= 736.0
    }
    
    let IS_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    let IS_IPHONE = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    struct DeviceType
    {
        static let IS_IPHONE            = UIDevice.current.userInterfaceIdiom == .phone
        static let IS_IPHONE_4_OR_LESS  = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_7          = IS_IPHONE_6
        static let IS_IPHONE_7P         = IS_IPHONE_6P
        static let isPhoneX             = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IS_IPAD_PRO_9_7      = IS_IPAD
        static let IS_IPAD_PRO_12_9     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
        
        let IS_IPHONE_4_OR_LESS = (IS_IPHONE && UIScreen.main.bounds.size.height < 568.0)
        let IS_IPHONE_5 = (IS_IPHONE && UIScreen.main.bounds.size.height == 568.0)
        let IS_IPHONE_6 = (IS_IPHONE && UIScreen.main.bounds.size.height == 667.0)
        let IS_IPHONE_6P = (IS_IPHONE && UIScreen.main.bounds.size.height == 736.0)
    }
    
    struct Version{
        static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
        static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
        static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
        static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
        static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
        
        //MARK: System Version
        let IS_OS_7_OR_LATER = Version.SYS_VERSION_FLOAT >= 7.0
        let IS_OS_8_OR_LATER = Version.SYS_VERSION_FLOAT >= 8.0
        let IS_OS_9_OR_LATER = Version.SYS_VERSION_FLOAT >= 9.0
    }
    
    
    static let SCREEN_BOUNDS = UIScreen.main.bounds
    static let SCREEN_SCALE = UIScreen.main.bounds
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    struct font {
        
        static let kAPPFont120_Bold  = UIFont.boldSystemFont(ofSize: 60);
        static let kAPPFont36_Bold  = UIFont.boldSystemFont(ofSize: 18);
        static let kAPPFont30_Bold = UIFont.boldSystemFont(ofSize: 15.0);
        static let kAPPFont24_Bold = UIFont.boldSystemFont(ofSize: 12.0);
        static let kAPPFont36 = UIFont.systemFont(ofSize: 18.0);
        static let kAPPFont32 = UIFont.systemFont(ofSize: 16.0);
        static let kAPPFont30 = UIFont.systemFont(ofSize: 15.0);
        static let kAPPFont24 = UIFont.systemFont(ofSize: 12.0);
        static let kAPPFont20 = UIFont.systemFont(ofSize: 10.0);
        static let kAPPFont18 = UIFont.systemFont(ofSize: 9.0);
        static let kAPPFont16 = UIFont.systemFont(ofSize: 8.0);
        
        enum TypeFont:Int {
            case bold
            case medium
            case black
        }
        
        static func DINProFontType(_ type:TypeFont, _ s:CGFloat) -> UIFont! {
//            var name = ""
//            if type == .bold {
//                name = "DINPro-Bold"
//            }else if type == .medium {
//                name = "DINPro-Medium"
//            }else {
//                name = "DINPro-Black"
//            }
            
            if type == .bold {
                return UIFont.boldSystemFont(ofSize: s)
            }else if type == .medium {
                return UIFont.systemFont(ofSize: s)
            }
        
            return UIFont.systemFont(ofSize: s)
        }
        
        static func DINProFont(_ name:String,_ s:CGFloat) -> UIFont! {
            return UIFont.systemFont(ofSize: s);
            //return UIFont.init(name: name, size: s) ?? Const.font.kAPPFont30
        }
    }
    
    struct color {
        
        static let kAPPDefaultBorderColor = ZYUtilsSW.getColor(hexColor: "c7c8cc");
        static let kAPPDefaultBgColor = ZYUtilsSW.getColor(hexColor: "ffffff");
        static let kAPPDefaultBgLightGrayColor = ZYUtilsSW.getColor(hexColor: "f3f3f3");
        static let kAPPDefaultBlackColor = ZYUtilsSW.getColor(hexColor: "000000");
        static let kAPPDefaultGrayColor = ZYUtilsSW.getColor(hexColor: "6E6F70");
        static let kAPPDefaultLightGrayColor = ZYUtilsSW.getColor(hexColor: "cccccc");
        static let kAPPDefaultWhiteColor = ZYUtilsSW.getColor(hexColor: "ffffff");
        static let kAPPDefaultRedColor = ZYUtilsSW.getColor(hexColor: "fa4c4e");
        static let kAPPDefaultNavBarTextColor = ZYUtilsSW.getColor(hexColor: "ffffff");
        static let kAPPDefaultNavBarBgColor = ZYUtilsSW.getColor(hexColor: "fa414b");
        static let kAPPDefaultTabBarTextColor = ZYUtilsSW.getColor(hexColor: "838383");
        static let kAPPDefaultTabBarTextSeletColor = ZYUtilsSW.getColor(hexColor: "973ae2");
        static let kAPPDefaultTabBarBgColor = ZYUtilsSW.getColor(hexColor: "ffffff");
        static let kAPPDefaultBlackExColor = ZYUtilsSW.getColor(hexColor: "2f2f2f");
        static let kAPPDefaultGoldColor = ZYUtilsSW.getColor(hexColor: "fee82f");
        static let kAPPDefaultLineColor = ZYUtilsSW.getColor(hexColor: "DDDDDD");
        static let kAPPDefaultBottleBlueColor = ZYUtilsSW.getColor(hexColor: "4ed6f7");
        static let kAPPDefaultVipColor = ZYUtilsSW.getColor(hexColor: "fa4c4e");
        static let kAPPDefaultBlueColor = ZYUtilsSW.getColor(hexColor: "1B6DFF");
        static let kAPPDefaultBlueSysColor = ZYUtilsSW.getColor(hexColor: "196BD8");
        static let kAPPDefaultBlueLBColor = ZYUtilsSW.getColor(hexColor: "226ed5");
    
    }

}

