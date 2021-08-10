//
//  SwiftCommon.swift
//  ONTO
//
//  Created by 赵伟 on 2018/8/2.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class SwiftCommon: NSObject {
    /*********颜色***********/
    //RGB转换
    func RGB(r:CGFloat,g:CGFloat,b:CGFloat) ->UIColor{
        //
        return UIColor(red: r/225.0, green: g/225.0, blue: b/225.0, alpha: 1.0)
    }
    
    //主题色
    public let THEME_COLOR=UIColor(red: 33/255.0, green: 41/255.0, blue: 54/255.0, alpha: 1.0)
    //背景色
    public let BG_COLOR=UIColor(red: 246/225.0, green: 246/225.0, blue: 246/225.0, alpha: 1.0)
    //分割线颜色
    public let LINE_COLOR=UIColor(red: 217/225.0, green: 217/225.0, blue: 217/225.0, alpha: 1.0)
    
    /*********尺寸***********/
    
    //设备屏幕尺寸
    
    public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

    
    //获取视图尺寸
    public func VIEW_WIDTH(view:UIView)->CGFloat{
        return view.frame.size.width
    }
    public func VIEW_HEIGHT(view:UIView)->CGFloat{
        return view.frame.size.height
    }

    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let IS_IPHONE_P_OR_MORE  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH >= 736.0
        static let SCALE_W              = UIScreen.main.bounds.size.width/375
    }
    
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
        static let isPhoneX             = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
        static let isPhoneXR            = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
        static let isBang               = SwiftCommon.DeviceType.isPhoneX || SwiftCommon.DeviceType.isPhoneXR
        
    }
    
    struct BarHeight {
        static let NavBarHeight: CGFloat = (SwiftCommon.DeviceType.isBang ? 44 : 20)
        static let TabBarHeight: CGFloat = (SwiftCommon.DeviceType.isBang ? 34 : 0)  
    }
}
