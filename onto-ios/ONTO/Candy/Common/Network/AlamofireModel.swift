//
//  AlamofireModel.swift
//  SNSBasePro
//
//  Created by zhan zhong yi on 2018/5/19.
//  Copyright © 2018年 zhan zhong yi. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SwiftyJSON
import MBProgressHUD

//enum MethodType:Int {
//    case get
//    case post
//}

var severUrl: String {
    get {
        
        if Const.url.kTDGeneralURLEx.hasPrefix("http") == false {
            return  "http://" + Const.url.kTDGeneralURLEx;
        }
        
        return Const.url.kTDGeneralURLEx;
    }
}


class AlamofireModel: NSObject {
    
    var arrRes:[[String:AnyObject]]!;
    
    private static var _instance: AlamofireModel! = {
        let ins = AlamofireModel();
        return ins;
    }()
    
    
    public class func shared() -> AlamofireModel! {
        return _instance;
    }

    //MARK:common
    class func bReturnStatus(dict:Dictionary<String,Any>?) -> Bool {
        
        if dict == nil {
            print("error! dict is not dict!");
            return false;
        }
        
        let d:Dictionary<String,Any> = dict!
        var status = d["code"] as? String
        if (status != nil) && Int(status!)! == 0 {
            return true;
        }
        
        let st = d["code"] as? NSNumber
        if (st != nil) && st!.intValue == 0 {
            return true;
        }
        
        status = d["content"] as? String
        if (status != nil) && Int(status!)! > 0 {
            return true;
        }
        
        status = d["status"] as? String
        if (status != nil) && Int(status!)! > 0 {
            return true;
        }
        
        let myDict = d["body"] as? Dictionary<String,Any>;
        if myDict != nil {
            status = myDict!["status"] as? String
            if (status != nil) && Int(status!)! > 0 {
                return true;
            }
        }
        
        //用户未登录
        status = d["content"] as? String
        if (status != nil) && Int(status!)! == 1 {
            return true;
        }
        
        
        return false;
    }
    
    //需要签名的参数
    class func loginHeaderParams() -> [String:String] {
        
        var d = [String:String]();
        let version = ZYUtilsSW.appVersion();
        d["OS"] = "1" //ios:1 android:2
        d["Version"] = version
        
        debugPrint("timeStamp:\(d)");
        return d;
    }
    
    class func commonHeaderParams() -> [String:String] {
        
        var d = [String:String]();
        let version = ZYUtilsSW.appVersion();
        d["Lang"] = CommonOCAdapter.getUserLanguage()
        d["OntId"] = ZYUtilsSW.getOntId()
        d["OS"] = "1" //ios:1 android:2
        d["Version"] = version
        d["Authorization"] = (UserCenter.share()?.token_type ?? "")! + " " + (UserCenter.share()?.access_token ?? "")!
//        d["Authorization"] = "Bearer JhbGciOiJzI1nR5qDmsHcSo2-Vcn49Cv3pBjFSfceZPHQ"
        
        debugPrint("timeStamp:\(d)");
        return d;
    }
    
    //基本参数
    class func baseParams() -> [String:String] {

//        let d = self.signParams();
//        let last  = asendParams(d);
//        print("asend:\(last)")
//
//
//        let ontParams = ZYUtilsSW.ontForCanyParams();
//        d += ontParams;
//        print("last:\(d)")

        var d = [String:String]();
//        d["OntId"] = ZYUtilsSW.getOntId()
        return d;
    }
    
    class func asendParams(_ params:[String:String]!) -> String {
        
        var arr = [String]()
        let d = params.keys.sorted(by: <)
        for i in 0..<d.count {
            let key = d[i];
            let s = key + "=" + params[key]!
            arr.append(s);
        }
        
        return arr.joined(separator: "&")
    }
    
    class func hash() -> String {
        let asd = asendParams(commonHeaderParams())
        return asd;
    }
    

    //清除一些不必要的参数，为了打印需要
    class func baseParamsDelete(_ params:Dictionary<String,Any>) -> Dictionary<String,Any> {
    
        var last = params;
        let delKeys = ["Version","OS"];
        for (key,_) in last {
            
            if delKeys.contains(key) {
                last[key] = nil;
            }
        }
        
        return last;
    }
    
    //打印一下，为了调试的时候使用
    class func log<T>(_ response:DataResponse<T>,_ params:[String:String]) {
        
        let baseUrl = response.request?.url?.absoluteString;
        
        var fullUrl = "";
        var arr:[String]! = [String]();
        for (key,value) in params {
            let str = key + "=" + value;
            arr.append(str);
        }
        if(arr.count > 0){
            let last  = arr.joined(separator: "&");
            fullUrl = baseUrl! + "?" + last;
        }
        print("fullUrl:\(fullUrl)");
        print("url:\(String(describing: baseUrl))\n params:\(params.json)")
        
        let json = JSON(response.data!)
        print("json:\(json)")
    }
    
    //拼接url，为了打印
    class func getFullUrl(_ url:String,_ params:[String:String]) -> String{
        
        let lastParams = AlamofireModel.baseParamsDelete(params) as! [String:String];
        let baseUrl = url;
        
        var fullUrl = "";
        var arr:[String]! = [String]();
        for (key,value) in lastParams {
            let str = key + "=" + value;
            arr.append(str);
        }
        if(arr.count > 0){
            let last  = arr.joined(separator: "&");
            fullUrl = baseUrl + "?" + last;
        }
     
        return fullUrl;
    }
    
    //MARK: request action
    class func loadData(path: String,_ type : MethodType, parameters : [String : String]? = nil,headers:[String:String]? = nil, inView:UIView? = nil, finishedCallback : @escaping (_ bSuccess:Bool, _ result : Any) -> ()) {
        return AlamofireModel.loadData(url: severUrl, path: path, type, parameters: parameters,headers:headers,inView: inView, finishedCallback: finishedCallback);
    }
    
    //manual url
    class func loadData(url:String,path: String,_ type : MethodType, parameters : [String : String]? = nil, headers:[String:String]? = nil,inView:UIView? = nil, finishedCallback : @escaping (_ bSuccess:Bool, _ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        var params = AlamofireModel.baseParams()
        if parameters != nil {
            params = params.merged(with: parameters!)
        }
        
        var URL = url;
        if path.count > 0 {
            URL = URL + "/" + path;
        }
        // 2.发送网络请求
        if(inView != nil){
            MBProgressHUD.showAdded(to: inView!, animated: true);
        }
        Alamofire.request(URL, method: method, parameters: params,headers:headers).responseJSON { (response) in
            
            AlamofireModel.log(response,params);
            
            if(inView != nil){
                MBProgressHUD.hide(for: inView!, animated: false);
            }
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                var d = [String:String]();
                d["msg"] = Const.msg.kServerStateErrorEx;
                finishedCallback(false,d);
                return
            }
            
            let last = result as! Dictionary<String,Any>;
            if self.bReturnStatus(dict: last) == false {
                
                var d = [String:Any]();
                d["msg"] = last["msg"] as? String;
                if last["code"] is NSNumber {
                    d["code"] = (last["code"] as! NSNumber).stringValue;
                }else {
                   d["code"] = last["code"];
                }
                finishedCallback(false,d);
                return;
            }
            
            // 4.将结果回调出去
            finishedCallback(true,last)
        }
    }
    
    
     class func loadModel(path: String, _ type : MethodType, parameters : [String : String]? = nil, _ classType:AnyClass, inView:UIView? = nil,finishedCallback :  @escaping (_ bSuccess:Bool,_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        var params = AlamofireModel.baseParams()
        if parameters != nil {
            params = params.merged(with: parameters!)
        }
    
        var URL =  severUrl
        if path.count > 0 {
            URL = URL + "/" + path;
        }
        // 2.发送网络请求
        if(inView != nil){
            MBProgressHUD.showAdded(to: inView!, animated: true);
        }
        Alamofire.request(URL, method: method, parameters: params).responseJSON { (response) in
            
             AlamofireModel.log(response,params);
            if(inView != nil){
                MBProgressHUD.hide(for: inView!, animated: false);
            }
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                let mod = BaseAdapterMappable();
                mod.msg = Const.msg.kServerStateErrorEx;
                finishedCallback(false,mod);
                return
            }
            
            let swiftyJsonVar = JSON(result)
            if let resData = swiftyJsonVar["contacts"].arrayObject {
                let arr = resData as! [[String:AnyObject]]
                print(arr.debugDescription)
            }
            
            // 4.将结果回调出去
            finishedCallback(true,result)
        }
    }
    
    public func loadModelEx<T: Mappable>(path: String,type : HTTPMethod, parameters : [String : String]? = nil,inView:UIView? = nil, finishedCallback:  @escaping (_ bSuccess:Bool,_ response:DataResponse<T>) -> Void ) {
        
        let headers = AlamofireModel.commonHeaderParams();
        self.loadModelEx(path: path, type:type, parameters: parameters, headers: headers, inView: inView, finishedCallback: finishedCallback)
    }
    
    public func loadModelEx<T: Mappable>(path: String,type : HTTPMethod, parameters : [String : String]? = nil,headers:[String:String]? = nil,inView:UIView? = nil, finishedCallback:  @escaping (_ bSuccess:Bool,_ response:DataResponse<T>) -> Void ) {
        
        var URL = severUrl;
        if path.count > 0 {
            URL = URL + "/" + path;
        }
        self.loadModelEx(url: URL, type: type, parameters: parameters, headers: headers, inView: inView, finishedCallback: finishedCallback)
    }
    
    public func loadModelEx<T: Mappable>(url: String,type : HTTPMethod, parameters : [String : String]? = nil,headers:[String:String]? = nil,inView:UIView? = nil, finishedCallback:  @escaping (_ bSuccess:Bool,_ response:DataResponse<T>) -> Void ) {
        
        var params = AlamofireModel.baseParams()
        if parameters != nil {
            params = params.merged(with: parameters!)
        }
        
        if(inView != nil){
            MBProgressHUD.showAdded(to: inView!, animated: true);
        }
    
        _ = Alamofire.request(url, method: type,parameters:params,headers:headers).responseObject { (response: DataResponse<T>) in
            
            //            print(response.request?.debugDescription);
            //            print(response.response.debugDescription);
            //            print(response.result.debugDescription);
            if(inView != nil){
                MBProgressHUD.hide(for: inView!, animated: false);
            }
            AlamofireModel.log(response,params);
            
            let statusCode = response.response?.statusCode
            if  let code = statusCode {
                    if code == 401 && url.hasSuffix("user/login") == false {
                        finishedCallback(false,response);
                        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName.kLoginExpired), object: nil, userInfo: nil);
                        return;
                    }
            }
            
            finishedCallback(true,response);
        }
    }

    
    //MARK: upload - common
    class func asURLRequest(_ path:String,params:[String:Any]) throws -> URLRequest {
    
        var URL = severUrl;
        if path.count > 0 {
            URL = URL + "/" + path;
        }
        let urlEx = try (URL).asURL()
        
        var request = URLRequest(url: urlEx)
        request.httpMethod = HTTPMethod.post.rawValue;
//        request.setValue(Constants.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000) //10s
        
        return try URLEncoding.default.encode(request, with: params)
    }

}

