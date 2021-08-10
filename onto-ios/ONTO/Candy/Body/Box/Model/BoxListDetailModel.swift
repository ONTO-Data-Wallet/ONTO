//
//  BoxListDetailModel.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/24.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper


//MARK: - DetailTop
class BoxDetailModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var content:String?
    var hot:String?
    var currency:String?
    var items:[BoxListDetailMissionItemModel]?
    var website:String?
    var url:String?
    var webContent:String?
    var obtain:Int?
    var tokenName:String?
    var onceAmount:String?
    var itemSocials:[BoxListDetailItemModel]?
    var startDate:Int?
    var endDate:Int?
    var dispStatus:Int?
    var airdropRule:String?
    var logo1:String?
    var logo2:String?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        headImg <- map["data.Logo"]
        title <- map["data.ProjectName"]
        content <- map["data.Brief"]
        hot <- map["data.hot"]
        currency <- map["data.currency"]
        website <- map["data.webSite"]
        url <- map["data.Website"]
        webContent <- map["data.Description"]
        obtain <- map["data.ObtainStatus"]
        status <- map["data.Status"]
        tokenName <- map["data.TokenName"]
        onceAmount <- map["data.OnceAmount"]
        itemSocials <- map["data.Socials"]
        startDate <- map["data.StartDate"]
        endDate <- map["data.EndDate"]
        dispStatus <- map["data.DispStatus"]
        airdropRule <- map["data.AirdropRule"]
        logo1 <- map["data.Logo1"]
        logo2 <- map["data.Logo2"]
        
        let transform = TransformOf<[BoxListDetailMissionItemModel],[[String:Any]]>(fromJSON:{ (value: [[String:Any]]?) -> [BoxListDetailMissionItemModel]? in
            
            if value == nil {
                return nil;
            }
            
            let arr =  Mapper<BoxListDetailMissionItemModel>().mapArray(JSONArray: value!)
            return   arr
        },toJSON:{ (value: [BoxListDetailMissionItemModel]?) -> [[String:Any]]? in
            
            if value == nil {
                return nil;
            }
            
            let arr = Mapper<BoxListDetailMissionItemModel>().toJSONArray(value!);
            return arr;
        })
        items <- (map["data.Missions"],transform)
        
        let transform1 = TransformOf<String, Int>(fromJSON: { (value: Int?) -> String? in
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
        itemId <- (map["data.ProjectId"],transform1)
    }
    
    
    //是否过期
    func bExpired() -> Bool {
        
        guard  let ob = self.dispStatus else {
            debugPrint("warning！ status is nil!")
            return false;
        }
        
        if ob == 6 {
            return true;
        }
        
        return false;
    }
}


class BoxListDetailItemModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var bOk:String?;
    var url:String?
    
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
        title <- map["SocialMediaName"]
        bOk <- map["bOk"]
        url <- map["Url"]
    }
    
}

//MARK: - Mission
class BoxListDetailMissionModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var content:String?
    var hot:String?
    var currency:String?
    var items:[BoxListDetailMissionItemModel]?
    
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
        
        let transform = TransformOf<[BoxListDetailMissionItemModel],[[String:String]]>(fromJSON:{ (value: [[String:String]]?) -> [BoxListDetailMissionItemModel]? in
            
            if value == nil {
                return nil;
            }
            
            let arr =  Mapper<BoxListDetailMissionItemModel>().mapArray(JSONArray: value!)
            return   arr
        },toJSON:{ (value: [BoxListDetailMissionItemModel]?) -> [[String:String]]? in

            if value == nil {
                return nil;
            }
            
            let arr = Mapper<BoxListDetailMissionItemModel>().toJSONArray(value!);
            return arr as? [[String : String]];
        })
        items <- (map["Missions"],transform)
    }
    
}

class BoxListDetailMissionItemModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var bOk:String?;
    var url:String?
    var missionCode:String?
    var refInfo:String?
    var url_scheme:String?
    
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
        itemId <- (map["MissionId"],transform)
        headImg <- map["headImg"]
        title <- map["MissionName"]

        refInfo <- map["RefInfo"] //refInfo 要对应两个值，这个是为了kyc使用的
        url <- map["RefInfo"] //refInfo 要对应两个值,这个是为telegram使用的
        bOk <-  (map["IsCompleted"],transform)
        missionCode <- map["MissionCode"]
        url_scheme <- map["RefInfo_tg"]
    }
    
}

//MARK: - InfoModel
class InfoModel: BaseAdapterMappable {
    
    var headImg:String?
    var title:String?
    var bOk:String?;
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        headImg <- map["headImg"]
        title <- map["title"]
        bOk <- map["bOk"]
    }
    
}

