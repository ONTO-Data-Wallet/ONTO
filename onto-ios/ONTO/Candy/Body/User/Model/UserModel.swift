//
//  UserModel.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/30.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper

class UserCenter: BaseAdapterMappable {
    
    var headImg:String?
    var token_type:String?
    var access_token:String?
    var expires_in:String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        headImg <- map["data.headImg"]
        token_type <- map["data.token_type"]
        access_token <- map["data.access_token"]
        
        let transform = TransformOf<String, Int>(fromJSON: { (value: Int?) -> String? in
            if let v = value {
                return "\(v)";
            }
            return nil;
            
        }, toJSON: { (value: String?) -> Int? in
            if let v = value {
                return Int(v);
            }

            return nil
        })
        expires_in <- (map["data.expires_in"],transform)
        
    }
    
    //MARK: - common
    class func share() -> UserCenter? {
        return LoginCenter.shared().userCenter;
    }
    
    func bExpired() -> Bool {
        
        let timestamp = ZYUtilsSW.timeStamp();
        guard let expire = expires_in else {
            debugPrint("errror! exirpes_in is not exist!")
            return true;
        }
        
        if timestamp < expire {
            return false
        }
        
        return false;
    }
    
}

class UserCdModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var content:String?
    var hot:String?
    var currency:String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map: map)
        
        headImg <- map["headImg"]
        title <- map["title"]
        content <- map["content"]
        hot <- map["hot"]
        currency <- map["currency"]
        
    }
    
}

