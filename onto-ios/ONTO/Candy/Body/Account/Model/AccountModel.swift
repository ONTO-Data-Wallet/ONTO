//
//  BoxListModel.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper


class ACNameModel: BaseAdapterMappable {
    
    var title:String?
    var content:String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        content <- map["content"]
    }
}


class AccountModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var content:String?
    var hot:String?
    var currency:String?
    var balanceModels:[ACBalanceItemModel]?
    var recordModels:[ACRecordModel]?
    var addressModels:[ACAdressModel]?
    var addressWithdrawModels:[ACAdressModel]?
    
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
        
        balanceModels <- map["data.Balance"]
        recordModels <- map["data.Record"]
        addressModels <- map["data.Address"]
        addressWithdrawModels <- map["data.rows"]
        count <- map["data.count"]
        pageCount <- map["data.pageCount"]
        
    }
}

class ACBalanceListModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var content:String?
    var hot:String?
    var currency:String?
    var items:[ACBalanceItemModel]?
    
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
        
        let transform = TransformOf<[ACBalanceItemModel],[[String:String]]>(fromJSON:{ (value: [[String:String]]?) -> [ACBalanceItemModel]? in
            
            if value == nil {
                return nil;
            }
            
            let arr =  Mapper<ACBalanceItemModel>().mapArray(JSONArray: value!)
            return   arr
        },toJSON:{ (value: [ACBalanceItemModel]?) -> [[String:String]]? in
            
            if value == nil {
                return nil;
            }
            
            let arr = Mapper<ACBalanceItemModel>().toJSONArray(value!);
            return arr as? [[String : String]];
        })
        items <- (map["arr"],transform)
    }
}

//"Balance" : [
//{
//"TokenName" : "OneToken",
//"TotalAmount" : "10.000000000000000000",
//"Logo" : "http:\/\/47.100.77.82:7001\/public\/images\/project\/1.png",
//"ProjectId" : 1
//}
//],
class ACBalanceItemModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var content:String?
    var hot:String?
    var blockChainName:String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
        override func mapping(map: Map) {
        super.mapping(map: map)
        
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
        itemId <- (map["ProjectId"],transform)
        headImg <- map["Logo"]
        title <- map["TokenName"]
        content <- map["TotalAmount"]
        hot <- map["hot"]
        blockChainName <- map["BlockChainName"]
            
    }
}


class ACRecordModel: BaseAdapterMappable {

    var headImg:String?
    var bCheck:String?
    var title:String?
    var hot:String?
    var currency:String?
    var time:String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    
//    "Record" : [
//    {
//    "CreateDate" : 1500000000,
//    "TokenName" : "OneToken",
//    "Status" : 1,
//    "DispAmount" : "-50",
//    "Logo" : "http:\/\/47.100.77.82:7001\/public\/images\/project\/1.png",
//    "ProjectId" : 1
//    }
//    ]
        override func mapping(map: Map) {
        super.mapping(map: map)
        
        var transform = TransformOf<String, Int>(fromJSON: { (value: Int?) -> String? in
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
        itemId <- (map["ProjectId"],transform)
        headImg <- map["Logo"]
        bCheck <- map["bCheck"]
        title <- map["TokenName"]
        hot <- map["hot"]
        status <- map["Status"]
        currency <- map["DispAmount"]
            
             transform = TransformOf<String, Int>(fromJSON: { (value: Int?) -> String? in
                if let v = value {
                    let str = "\(v)";
                    return str.toTime(nil);
                }
                return nil;
                
            }, toJSON: { (value: String?) -> Int? in
                if let v = value {
                    return Int(v);
                }
                
                return nil
            })
            time <- (map["CreateDate"],transform)
    }

}

class ACRecordListModel: BaseAdapterMappable {
    
    var data:[String:Any]?
    var items:[ACRecordModel]?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
        override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
        let transform = TransformOf<[ACRecordModel],[[String:Any]]>(fromJSON:{ (value: [[String:Any]]?) -> [ACRecordModel]? in
            
            if value == nil {
                return nil;
            }
            
            let arr =  Mapper<ACRecordModel>().mapArray(JSONArray: value!)
            return   arr
        },toJSON:{ (value: [ACRecordModel]?) -> [[String:Any]]? in
            
            if value == nil {
                return nil;
            }
            
            let arr = Mapper<ACRecordModel>().toJSONArray(value!);
            return arr;
        })
        items <- (map["data.rows"],transform)
        pageCount <- map["data.pageCount"]
    }
}

class ACAdressModel: BaseAdapterMappable {
    
    var headImg:String?
//    var title:String?
    var content:String?
    var blockChainName:String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
//    "Address" : [
//    {
//    "Logo" : "http:\/\/47.100.77.82:7001\/public\/images\/icon\/ont.png",
//    "Address" : "DDEFASDFDS",
//    "BlockChainName" : "ONT"
//    }
//    ]
        override func mapping(map: Map) {
        super.mapping(map: map)
        
        headImg <- map["Logo"]
//        title <- map["tokenName"]
        content <- map["Address"]
        blockChainName <- map["BlockChainName"]
    }
}

class ACAdressListModel: BaseAdapterMappable {
    
    var data:[String:Any]?
    var items:[ACAdressModel]?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
        override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
        
        let transform = TransformOf<[ACAdressModel],[[String:Any]]>(fromJSON:{ (value: [[String:Any]]?) -> [ACAdressModel]? in
            
            if value == nil {
                return nil;
            }
            
            let arr =  Mapper<ACAdressModel>().mapArray(JSONArray: value!)
            return   arr
        },toJSON:{ (value: [ACAdressModel]?) -> [[String:Any]]? in
            
            if value == nil {
                return nil;
            }
            
            let arr = Mapper<ACAdressModel>().toJSONArray(value!);
            return arr;
        })
        items <- (map["data.rows"],transform)
        pageCount <- map["data.pageCount"]
        
    }
}

class BlankModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var content:String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
        override func mapping(map: Map) {
        super.mapping(map: map)
        
        headImg <- map["headImg"]
        title <- map["title"]
        content <- map["content"]
        
    }
}

class WDConfirmModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var content:String?
    var pwd:String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
        override func mapping(map: Map) {
        super.mapping(map: map)
        
        headImg <- map["headImg"]
        title <- map["title"]
        content <- map["content"]
        pwd <- map["pwd"]
        
    }
}
