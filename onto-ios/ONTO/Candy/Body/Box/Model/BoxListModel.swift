//
//  BoxListModel.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper

class BoxListModel: BaseAdapterMappable {

    var headImg:String?
    var title:String?
    var content:String?
    var isTop:Int?
    var isHot:Int?
    var currency:String?
    var startDate:Int?
    var endDate:Int?
    var obtain:Int?
    var iconImg:String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
//    {
//    "TokenName" : "ShouyouToken",
//    "Status" : 1,
//    "TokenStandard" : "ERC721",
//    "IsHot" : 0,
//    "Logo" : "http:\/\/47.100.77.82:7001\/public\/images\/project\/8.png",
//    "ProjectName" : "区块链博彩游戏",
//    "BlockChainLogo" : "http:\/\/47.100.77.82:7001\/public\/images\/icon\/ont.png",
//    "BlockChainName" : "ONT",
//    "Brief" : "旷日持久的Fomo3D首轮之战终于在8月22日落下帷幕。",
//    "ProjectId" : 8
//    }
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
        title <- map["ProjectName"]
        content <- map["Brief"]
        isTop <- map["IsTop"]
        isHot <- map["IsHot"]
        currency <- map["TokenStandard"]
        startDate <- map["StartDate"]
        endDate <- map["EndDate"]
        status <- map["Status"]
        obtain <- map["ObtainStatus"]
        status <- map["Status"]
        iconImg <- map["BlockChainLogo"]
        
    }
    
    //是否过期
    func bExpired() -> Bool {
        
        guard  let ob = self.status else {
            debugPrint("warning！ status is nil!")
            return false;
        }
        
        if ob == 3 {
            return true;
        }
        
        return false;
    }
    
//    func bExpired() -> Bool {
//        let inter = NSDate().timeIntervalSince1970
//        if self.endDate == nil {
//            return true;
//        }
//
//        if self.endDate != nil && TimeInterval(self.endDate!) < inter {
//            return false;
//        }
//
//        return true;
//    }
    
    //obtain Text
    func obtainText() -> String {
        
        guard  let ob = obtain else {
            debugPrint("warning！ obtain is nil!")
            return "";
        }
        
        var str = "";
        switch ob {
        case 0:
            str = "未完成"
        case 1:
            str = "完成但不可领取"
        case 2:
            str = "完成可领取"
        case 3:
            str = "Obtained"
        case 4:
            str = "withdrawing"
        case 5:
            str = "withdrawing"
        case 6:
            str = "withdrawing"
        case 7:
            str = "failure"
        case 8:
            str = "failure"
        case 9:
            str = "completed"
        default:
            debugPrint("error！ obtain is not exit!")
        }
        
        return str;
    }
    
    //状态文字
    func statusText() -> String {
        
        guard  let ob = self.status else {
            debugPrint("warning！ status is nil!")
            return "";
        }

        var str = ""
        switch ob {
        case 1:
            str = LocalizeEx("candy_ongoing") //"Ongoing"
        case 2:
            str = LocalizeEx("candy_obtained") //"Obtained"
        case 3:
            str = LocalizeEx("candy_expired") //"Expired"
            
        default:
            debugPrint("error！ status value is not exit!")
        }
        
        return str;
    }
    
    func isOngoing() -> Bool {
        
        guard  let ob = self.status else {
            debugPrint("warning！ status is nil!")
            return false;
        }
        
        if ob == 1 {
            return true;
        }
        
        return false;
    }
    
    func isObtained() -> Bool {
        
        guard  let ob = self.status else {
            debugPrint("warning！ status is nil!")
            return false;
        }
        
        if ob == 2 {
            return true;
        }
        
        return false;
    }
    
    func isHotValue() -> Bool {
        
        guard  let ob = self.isHot else {
            debugPrint("warning！ status is nil!")
            return false;
        }
        
        if ob == 1 {
            return true;
        }
        
        return false
    }
    
    func hotText() -> String {
        
        guard  let ob = self.isHot else {
            debugPrint("warning！ status is nil!")
            return "";
        }
        
        if ob == 1 {
            return LocalizeEx("candy_hot") //"HOT";
        }
        
        return ""
    }
    
    func  topText() -> String {
        
        guard  let ob = self.isTop else {
            debugPrint("warning！ status is nil!")
            return "";
        }
        
        if ob == 1 {
            return "置顶";
        }
        
        return ""
    }
    
    func hotOngoing() -> String {
        
        if bExpired() == true {
            return statusText();
        }
        
        if isHotValue() == true {
            return hotText();
        }
        
       return statusText();
    }
    
}

class BoxListGroupModel: BaseAdapterMappable {
    
    var data:[String:Any]?
    var items:[BoxListModel]?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
        
        let transform = TransformOf<[BoxListModel],[[String:Any]]>(fromJSON:{ (value: [[String:Any]]?) -> [BoxListModel]? in
            
            if value == nil {
                return nil;
            }
            
            let arr =  Mapper<BoxListModel>().mapArray(JSONArray: value!)
            return   arr
        },toJSON:{ (value: [BoxListModel]?) -> [[String:Any]]? in
            
            if value == nil {
                return nil;
            }
            
            let arr = Mapper<BoxListModel>().toJSONArray(value!);
            return arr;
        })
        items <- (map["data.rows"],transform)
        pageCount <- map["data.pageCount"]
        count <- map["data.count"]
        
    }
    
//    func bHasMore() -> Bool {
//        guard  let page = pageCount, let cnt = count else {
//            return false;
//        }
//        
//        
//    }
}
