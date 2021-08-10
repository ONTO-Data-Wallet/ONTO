//
//  CommonExtension.swift
//  SNSBasePro
//
//  Created by zhan zhong yi on 2018/3/9.
//  Copyright © 2018年 zhan zhong yi. All rights reserved.
//

import UIKit

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toInt() -> Int {
        
        return Int(self)!;
    }
    
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
    //timeStamp for time
     func toTime(_ format:String?) -> String {
        
        let unixTimestamp = TimeInterval(self)
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone =  TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        if let fmt = format {
            dateFormatter.dateFormat = fmt //Specify your format that you want
        }else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        }
        let time = dateFormatter.string(from: date)
        return time;
    }
    
//    func mySubString(to index: Int) -> String {
//        return String(self[..<self.index(self.startIndex, offsetBy: index)])
//    }
//
//    func mySubString(from index: Int) -> String {
//        return String(self[self.index(self.startIndex, offsetBy: index)...])
//    }
    
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            
            return String(subString)
        } else {
            return self
        }
    }
    
    //获取部分字符串，如果不在范围内，返回nil.如果end大于字符串长度，那么截取到最后
    subscript (start: Int, end: Int) -> String? {
        if start > self.count || start < 0 || start > end {
            return nil
        }
        let begin = self.index(self.startIndex, offsetBy: start)
        var terminal: Index
        let length = self.count;
        if end >= length {
            terminal = self.index(self.startIndex, offsetBy: count)
        } else {
            terminal = self.index(self.startIndex, offsetBy: end + 1)
        }
        let range = (begin ..< terminal)
        return self.substring(with: range)
    }
    //获取某个字符，如果不在范围内，返回nil
    subscript (index: Int) -> Character? {
        if index > self.count - 1 || index < 0 {
            return nil
        }
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    func toHex() -> String {
        let data = Data(self.utf8)
        let hex = data.map{ String(format:"%02x", $0) }.joined()
        return hex;
    }
    
    static func numberOfChars(_ str: String) -> Int {
        var number = 0
        
        guard str.characters.count > 0 else {return 0}
        
        for i in 0...str.characters.count - 1 {
            let c: unichar = (str as NSString).character(at: i)
            
            if (c >= 0x4E00) {
                number += 2
            }else {
                number += 1
            }
        }
        return number
    }
    
    /// 用GBK编码时的长度
    var gbkLength: Int {
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        let gbkData = (self as NSString).data(using: encoding)!
        let gbkBytes = [UInt8](gbkData)
        return gbkBytes.count
    }
    
    /** 按GBK编码后，截取maxLen长度的字符，中文字符切不开则退避1个字节 */
    func trimToGBKLength(_ maxLen: Int) -> String {
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        let gbkData = (self as NSString).data(using: encoding)!
        let gbkBytes = [UInt8](gbkData)
        if maxLen >= gbkBytes.count {
            return self
        } else if maxLen < 1 {
            return ""
        } else {
            if let str = NSString(data: gbkData[0..<maxLen], encoding: encoding) {
                return str as String
            } else if let str = NSString(data: gbkData[0..<maxLen - 1], encoding: encoding) {
                return str as String
            } else {
                return ""
            }
        }
    }
    
//    mutating func hiddenString(_ target:Int) -> String {
//        return hiddenString(target, offset: 0)
//    }
//
//    mutating func hiddenString(_ target:Int,offset:Int) -> String {
//
//        let selfCount = self.count
//        if selfCount <= target {
//            return self;
//        }
//
//        let rp = "***"
//        var cnt = selfCount - target;
//        if(cnt <= 0){
//            return self;
//        }
//
//        cnt += rp.count;
//        var os = offset;
//        if os >= (target/2 - rp.count/2) {
//            os = 0;
//        }
//
//        let c = selfCount/2 + os;
//        let start = c - cnt/2;
//        let end = c + (cnt - cnt/2) - 1;
//
//
//        let ra = NSRange.init(location: start, length: (end - start + 1))
//        let range = Range.init(ra, in: self)
//        self.replaceSubrange(range!, with: rp)
//
//        if self.count < target {
//            debugPrint("error! self: \(self.count) \(self)")
//        }
//
//        return self;
//    }
    
    func replaceOnt(_ max:Int,_ offset:Int) -> String {
        
        let cnt = self.count;
        var c = cnt/2 + offset;
        let r = cnt%2
        if cnt < max {
            return self;
        }
        
        let with = "***"
        let rCnt = cnt - max + with.count
        
        //奇数
        if r > 0 {
            let start = c - rCnt/2;
            let end =  start + rCnt;
            return replaceByRange(start, end,with)
        }
        
        c = c - 1;
        let start = c - rCnt/2;
        let end =  start + rCnt;
        return replaceByRange(start, end,with)
    }

    func repalceBy(_ with:String) -> String {
        
        let cnt = self.count;
        var c = cnt/2;
        let r = cnt%2
        
        let max = cnt;
        let rCnt = cnt - max + with.count
        
        //奇数
        if r > 0 {
            let start = c - rCnt/2;
            let end =  start + rCnt;
           return replaceByRange(start, end,with)
        }
        
        c = c - 1;
        let start = c - rCnt/2;
        let end =  start + rCnt;
        return replaceByRange(start, end,with)
    }
    
    func replaceByRange(_ start:Int,_ end:Int,_ withString:String) -> String {
        
        if (start < self.count && end < self.count) == false {
            debugPrint("error! start:%d,end:%d",start,end)
            return self;
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
        return self.replacingCharacters(in: range, with: withString)
    }
    
    public func validatedByRex(_ regex:String) -> Bool {
        
        let text = self.trimmingCharacters(in: CharacterSet.whitespaces)
//        let regex =  "^((13[0-9])|(14[5,7])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@",regex)
        let result = predicate.evaluate(with: text)
        return result
    }
}

extension Bool {
    
    func  toIntString() -> String {
        
        if self == true {
            return "1";
        }
        
        return "0";
    }
}


extension NSObject {
    
    public class var classNameEx: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }

    class var getClass: AnyClass {       // computed type property
        let name = self.classNameEx;
        return NSClassFromString(name)!;
    }
}

extension String {
    
    public func intValue() -> Int {
        return Int(self)!;
    }
}


extension NSNumber {
    
    @objc open func length() -> NSInteger {
        return 0;
    }
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
    
    public static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach({ lhs[$0] = $1})
    }

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
}

extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

//用于swift下的runtime 只执行一次
public extension DispatchQueue {
    private static var onceTracker = [String]()
    public class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}

@IBDesignable
class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}

