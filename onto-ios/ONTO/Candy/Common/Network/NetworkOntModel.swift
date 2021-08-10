//
//  NetworkModel.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/28.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class NetworkOntModel: NSObject {

    private static var _instance: NetworkOntModel! = {
        let ins = NetworkOntModel();
        return ins;
    }()
    
    public class func shared() -> NetworkOntModel! {
        return _instance;
    }
    
    func test() {
        //        let url = "http://192.168.18.33:7001/project/getProjectList";
        let url = "http://47.100.77.82:7001/project/getProjectList";
        let params = [String:String]();
        CCRequest.shareInstance().request(withURLString: url, methodType: .GET, params: params, success: { (responseObject, responseOriginal) in
            
            let dic = responseOriginal as! NSDictionary
            print("dic:\(dic)")
            _ = dic.value(forKey: "Description") as? String
        }) { (error, errorDesc, responseOriginal) in
            debugPrint("error descrption!\(error?.localizedDescription ?? "nil")")
        }
    }
    
    
    class func baseParams() -> [String:String] {
        
        var d = [String:String]()
        d["ver"] = "1.0"
        
        return d;
    }
    
    class func log(_ url:String, _ response:[String:Any],_ params:[String:String]) {
        
        let baseUrl = url
        
        var fullUrl = "";
        var arr:[String]! = [String]();
        for (key,value) in params {
            let str = key + "=" + value;
            arr.append(str);
        }
        if(arr.count > 0){
            let last  = arr.joined(separator: "&");
            fullUrl = baseUrl + "?" + last;
        }
        print("fullUrl:\(fullUrl)");
        print("url:\(String(describing: baseUrl))\n params:\(params.json)")
        
//        let json = JSON(response.data!)
//        print("json:\(json)")
    }
}
