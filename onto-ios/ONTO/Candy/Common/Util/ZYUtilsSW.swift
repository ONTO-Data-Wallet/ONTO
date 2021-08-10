//
//  ZYUtilsSW.swift
//  LocationU
//
//  Created by zhan zhong yi on 17/1/4.
//  Copyright © 2017年 zhan zhong yi. All rights reserved.
//

import UIKit
import Foundation;

class ZYUtilsSW: NSObject {

    class func getColor(hexColor:String)->UIColor{
    
        let a:CGFloat = 1.0;
        return ZYUtilsSW.getColor(hex: hexColor, alpha: a);
    }
    
    class func getColor (hex:String,alpha:CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    class func imageFromColor(_ color: UIColor) -> UIImage
    {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!;
    }
    
    func snapshot(rect: CGRect? = nil,view:UIView) -> UIImage? {
        // snapshot entire view
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // if no `rect` provided, return image of whole view
        guard let image = wholeImage, let rect = rect else { return wholeImage }
        
        // otherwise, grab specified `rect` of image
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }

    
    class func setCornerGrid(view:UIView!,corner:Double!) -> Void {
        
        view.layer.cornerRadius = CGFloat(corner);
        view.layer.masksToBounds = true;
        //        view.layer.borderWidth = 1.0;
        //        view.layer.borderColor = Const.color.kAPPDefaultBlackColor.cgColor;
    }
    
     class func bundleId() -> String {
        
        let info = Bundle.main.infoDictionary;
        let bundleId = info!["CFBundleIdentifier"] as! String;
        return bundleId;
    }
    
    class func appName() ->String {
        
        let d = Bundle.main.localizedInfoDictionary;
        if d != nil {
            let name = d!["CFBundleDisplayName"] as? String;
            if name != nil {
                return name!;
            }
        }
        
        let myD = Bundle.main.infoDictionary;
        let myName = myD!["CFBundleDisplayName"] as? String ?? "";
        return myName;
    }
    
    class func appVersion() ->String {
        
        let myD = Bundle.main.infoDictionary;
        let myName = myD!["CFBundleShortVersionString"] as! String
        return myName;
    }
    
    class func stringFromDate(_ date:Date,formater:String) -> String{
        
        let dateformatter = DateFormatter();
//        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.dateFormat = formater;
        let locale = NSLocale.autoupdatingCurrent
        dateformatter.locale = locale;
        let str = dateformatter.string(from: date)
        return str;
    }
    
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        return today_string
        
    }
    
    class func timeStamp() -> String {
        
        let timestamp = NSDate().timeIntervalSince1970
        return "\(Int(timestamp))"
    }
    
    class func timeByTimeStamp(_ inter:String?,_ format:String?) -> String {
        
        if inter == nil {
            debugPrint("error! time stamp is nil!")
            return "";
        }
        
        let unixTimestamp = inter
        let t = TimeInterval(unixTimestamp!)!
        return ZYUtilsSW.timeByTimeStampInter(t, format)
    }
    
    class func timeByTimeStampInter(_ inter:TimeInterval?,_ format:String?) -> String {
        
        if inter == nil {
            debugPrint("error! time stamp is nil!")
            return "";
        }
        
        let date = Date(timeIntervalSince1970: inter!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        if let fmt = format {
            dateFormatter.dateFormat = fmt //Specify your format that you want
        }else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        }
        let time = dateFormatter.string(from: date)
        return time;
    }

    class func openUrl(_ ur:String?) -> Bool{
        
        //goto url
        if ur == nil {
            debugPrint("ur is nil!")
            return false;
        }
        
        if ur?.isEmpty == true {
            debugPrint("url is empty")
            return false;
        }
        
        let url = URL.init(string: ur!)
        UIApplication.shared.open(url!) { (bSuccess) in
        }
        
        return true;
    }
    
    //MARK: - ui
    class func topController() -> UIViewController {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate;
        var baseController = appDelegate.window.rootViewController!
        while baseController.presentedViewController != nil {
            baseController = baseController.presentedViewController!;
        }
        
        return baseController;
    }
 
    class func showAlert(title:String!,message:String!,cancelBtn:String!,okBtn:String?, handler:SFRequestCommonBlock!) -> Void {

        let  av  = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        var title:String;
        var action:UIAlertAction;
        if okBtn != nil {
            title = okBtn!;
            action = UIAlertAction.init(title: title, style: UIAlertActionStyle.default) { (ac) in
                handler(true,nil);
            }
            av.addAction(action);
        }

        title = cancelBtn;
        action = UIAlertAction.init(title: title, style: UIAlertActionStyle.cancel, handler: { (ac) in
            handler(false,nil);
        })
        av.addAction(action);
       ZYUtilsSW.topController().present(av, animated: true) {

        };
    }
    
    class func showAlertAttr(titleAttr:NSMutableAttributedString!,msgAttr:NSMutableAttributedString!,cancelBtn:String?,okBtn:String?, handler:SFRequestCommonBlock!) -> Void {

        let  av  = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)

//        let attributesBlack = [NSAttributedStringKey.font: Const.font.kAPPFont30,NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultBlackColor];
//
//        let attributesRed  =  [NSAttributedStringKey.font: Const.font.kAPPFont30,NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultRedColor];
//        let attrText = NSMutableAttributedString.init();
//        var part = NSMutableAttributedString(string:" 收到的扇贝兑换人民币: ", attributes: attributesBlack)
//        attrText.append(part)
//        part = NSMutableAttributedString(string:"4", attributes: attributesRed)
//        attrText.append(part);
//        part = NSMutableAttributedString(string:" 元", attributes: attributesBlack)
//        attrText.append(part);

//        let titleAttr = NSMutableAttributedString(string:title, attributes: attributesBlack);
//        let msgAttr = NSMutableAttributedString(string:message, attributes: attributesBlack);
        av.setValue(titleAttr, forKey: "attributedTitle")
        av.setValue(msgAttr, forKey: "attributedMessage")

        var title:String;
        var action:UIAlertAction;
        if okBtn != nil {
            title = okBtn!;
            action = UIAlertAction.init(title: title, style: UIAlertActionStyle.default) { (ac) in
                handler(true,nil);
            }
            av.addAction(action);
        }

        if cancelBtn != nil {
            title = cancelBtn!;
            action = UIAlertAction.init(title: title, style: UIAlertActionStyle.cancel, handler: { (ac) in
                handler(false,nil);
            })
            av.addAction(action);
        }
        ZYUtilsSW.topController().present(av, animated: true) {

        };
    }
    
    //MARK: - ONT ID
    class func ontParams() -> [String:String] {
        let params = ["OwnerOntId":UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "",
                      "DeviceCode": UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? "" ,//[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
            "ClaimId":"",
            "Status":"8"
        ];
        return params;
    }
    
    class func ontForCanyParams() -> [String:String] {
        let d = self.ontParams();
        let params = ["ontId":d["OwnerOntId"]!,
                      "deviceCode":d["DeviceCode"]!
        ];
        return params;
    }
    
    //获取本地存在的OntId
    @objc class func getOntId() -> String {
        guard  let ontID = UserDefaults.standard.value(forKey: ONT_ID) as? String else {
            return "";
        }
    
        return ontID;
        //return String(ontID.suffix(8));
    }

    //本地是否存在OntId
    class func bHasOntId() -> Bool {
        guard (UserDefaults.standard.value(forKey: ONT_ID) as? String) != nil else {
            return false;
        }
        
        return true;
    }
    
    //获取ontName的名字
    class func getOntName() -> String {
        guard  let v = UserDefaults.standard.value(forKey: IDENTITY_NAME) as? String else {
            return "";
        }
        
        return v;
    }
    
}

