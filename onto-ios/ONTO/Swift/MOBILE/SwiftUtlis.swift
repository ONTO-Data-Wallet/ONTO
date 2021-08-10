//
//  SwiftUtlis.swift
//  ONTO
//
//  Created by Apple on 2018/8/29.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class SwiftUtlis: NSObject {
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        return bundle
        
    }
    public func getColorAttrString1(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat,defaultColor: UIColor,cColor: UIColor,cColorLocation:Int,cColorLength:Int) -> NSMutableAttributedString {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: font, range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttribute( kCTParagraphStyleAttributeName as NSAttributedStringKey , value: paragraphStyle, range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [ NSAttributedStringKey.foregroundColor : defaultColor], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttribute( NSAttributedStringKey.foregroundColor , value: cColor, range: NSRange(location:cColorLocation,length:cColorLength))
        return attributedString
    }
    public func getAttrString(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat) -> NSMutableAttributedString {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttributes([kCTFontAttributeName as NSAttributedStringKey : font], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [kCTParagraphStyleAttributeName as NSAttributedStringKey : paragraphStyle], range: .init(location: 0, length: ((str as NSString).length)))
        return attributedString
    }
    func appendColorStrWithString(str:String,font:CGFloat,color:UIColor) -> NSMutableAttributedString {
        var attributedString : NSMutableAttributedString
        let attStr = NSMutableAttributedString.init(string: str, attributes: [kCTFontAttributeName as NSAttributedStringKey : UIFont.systemFont(ofSize: font),kCTForegroundColorAttributeName as NSAttributedStringKey:color])
        attributedString = NSMutableAttributedString.init(attributedString: attStr)
        return attributedString
    }
    
    public func getSize(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat) -> CGSize {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttributes([kCTFontAttributeName as NSAttributedStringKey : font], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [kCTParagraphStyleAttributeName as NSAttributedStringKey : paragraphStyle], range: .init(location: 0, length: ((str as NSString).length)))
        
        let attSize = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue))), context: nil).size  //NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
        return attSize
    }
}
