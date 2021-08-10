//
//  BaseAdapterMappable.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseAdapterMappable: Mappable {
    
    var itemId:String?;
    var code:Int?;
    var status:Int?;
    var msg:String?;
    var beginId:String?;
    var hasMore:NSNumber?;
    var results:Dictionary<String,Any>?;
    var ids:String?;
    var count:Int?
    var pageCount:Int?
    var message:String?
    
    init(){}
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        
        itemId <- map["id"]
        code <- map["code"]
        msg <- map["msg"]
        status <- map["status"]
        results <- map["results"]
        ids <- map["ids"]
        msg <- map["msg"]
        count <- map["count"]
        pageCount <- map["pageCount"]
        message <- map["message"]
//        pageCount <- map["pageCount"]
    }
    
    //是否有更多页
    func hasMore(_ page:Int) -> Bool {
        
        guard let p = self.pageCount else {
            return false;
        }
        
        if page < p {
            return true;
        }
        
        return false;
    }
    
}
