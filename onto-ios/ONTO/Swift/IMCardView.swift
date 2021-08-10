//
//  IMCardView.swift
//  ONTO
//
//  Created by 赵伟 on 2018/8/8.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
let G_HEADIMAGE_HEIGHT:CGFloat = 30

class IMCardView: UIView{
var typeImageView:UIImageView?
var typeL : UILabel?
var statusImageView:UIImageView?
var statusL : UILabel?
    
var successstatusImageArr:NSMutableArray?
var typeArr :NSMutableArray!
var typeImageArr :NSMutableArray!
var statusImageArr :NSMutableArray!
var statusArr :NSMutableArray!

var cardStatus1 :NSInteger!
var claimContext:String!
var isNeedSuport:NSInteger!


override init(frame:CGRect){
    super.init(frame: frame)
    setupSubViews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

func setupSubViews() {
    
    typeArr = NSMutableArray.init(array: [self.loacalkey(key: "IM_IDCard"),self.loacalkey(key: "IM_Passort"),self.loacalkey(key: "IM_DriverLicense")])
    typeImageArr = NSMutableArray.init(array: ["blueid","bluepassport","bluedrive"])
    statusImageArr = NSMutableArray.init(array: ["success","inreview","fail"])
    statusArr = NSMutableArray.init(array: [self.loacalkey(key: "IM_Success"),self.loacalkey(key: "IM_InReview"),self.loacalkey(key: "Im_Fail")])
    successstatusImageArr = NSMutableArray.init(array: ["cardid","cardpassport","carddrive"])

    self.layer.masksToBounds = true
    self.layer.cornerRadius = 2
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor(hexString:"#ECEFF8")?.cgColor
    
    typeL = UILabel.init(frame: CGRect(x:0,y:10,width:240,height:30))
    typeL?.textAlignment = NSTextAlignment.center
    typeL?.textColor = UIColor.black
    self.addSubview(typeL!)
    typeL?.textColor = UIColor(hexString:"#2B4045")
    
    typeImageView = UIImageView.init(frame: CGRect(x:90,y:50,width:60,height:60))
    statusImageView = UIImageView.init(frame: CGRect(x:185,y:115,width:20,height:20))
    self.addSubview(typeImageView!)
    self.addSubview(statusImageView!)

    statusL = UILabel.init(frame: CGRect(x:0,y:130,width:220,height:30))
    self.addSubview(statusL!)

//    statusL?.mas_makeConstraints({ (make) in
//        make?.top.equalTo()(self.statusImageView?.mas_bottom)?.offset()(20)
//        make?.centerX.equalTo()(self.statusImageView)
//        make?.height.equalTo()(30)
//    })
    
    statusL?.textAlignment = NSTextAlignment.right
    statusL?.font = UIFont.systemFont(ofSize: 12)
    statusL?.textColor = UIColor(hexString:"#CDCED5")
    
    
}

    // cardStatus
//0成功 //1待审核 //2失败
    
    //status
    //            0 初始状态
    //            提交过来就处于审核中，flag是3
    //            审核成功：9
    //            审核失败：8
func setStauts(status:NSInteger, type:NSInteger)  {
    
    var cardStatus :NSInteger = 0
    
    if status==0 {
        
        cardStatus = 4
        
    }else  if status==3 {
        
        cardStatus = 1
        
    }else if status==8 {
        
        cardStatus = 2
        
    }else if status==9 {
        
        cardStatus = 0
    }

    let model :ClaimModel = DataBase.shared().getCalimWithClaimContext(claimContext, andOwnerOntId: UserDefaults.standard.string(forKey:ONT_ID)!)
    
    if  model.ownerOntId==nil  {
        cardStatus1 = status
    }else{
        cardStatus = 0
        cardStatus1 = 10
    }

    if cardStatus==4 {
        statusL?.isHidden = true
        statusImageView?.isHidden  = true
   
    } else{
        if cardStatus==0{
            self.backgroundColor = UIColor(hexString:"#9FCAFF")
            typeImageView?.image=UIImage.init(named:(self.successstatusImageArr![type] as? String)!)
            statusL?.textColor = UIColor.white
            typeL?.textColor = UIColor.white
         statusImageView?.image=UIImage.init(named:"success")

            
//            let dic1 :NSDictionary = Common.claimdencode(model.content)! as NSDictionary
//            let dic2 :NSDictionary = dic1.value(forKey: "claim") as! NSDictionary
//            let str :NSInteger = dic2.value(forKey: "exp") as! NSInteger
//
//            let time1=Common.getTimeFromTimestamp(String(format: "%ld", str))
//
//            statusL?.text =  time1

        }else{
            statusImageView?.image=UIImage.init(named:(self.statusImageArr[cardStatus] as? String)!)

                statusL?.centerX = (statusImageView?.centerX)!
                statusL?.textAlignment = .center
            
        }

        statusL?.text = self.statusArr[cardStatus] as? String

    }
    
    if cardStatus==0{
        self.backgroundColor = UIColor(hexString:"#9FCAFF")
        typeImageView?.image=UIImage.init(named:(self.successstatusImageArr![type] as? String)!)
        statusL?.textColor = UIColor.white
        typeL?.textColor = UIColor.white
        statusImageView?.image=UIImage.init(named:"success")

        if  model.ownerOntId==nil  {
            cardStatus1 = status
            statusL?.text =  self.loacalkey(key: "GettheVerificationClaim")

        }else{
            let contentDic = Common.dictionary(withJsonString: model.content) as NSDictionary
            print(contentDic)
            let dic1 :NSDictionary =  Common.claimdencode(contentDic.value(forKey: "EncryptedOrigData") as! String)! as NSDictionary
            print("===>\(dic1)")
                    let dic2 :NSDictionary = dic1.value(forKey: "claim") as! NSDictionary
                    let str :NSInteger = dic2.value(forKey: "exp") as! NSInteger
            
                    let time1=Common.getTimeFromTimestamp(String(format: "%ld", str))
                    let IM_Success = self.loacalkey(key: "IM_Success")
                    statusL?.text =  IM_Success + time1!
            
//            if (time1 as!NSString).length == 0 {
//               statusL?.text =  self.loacalkey(key: "GettheVerificationClaim")
//            }
            
        }


        
    }
    
}
    
    
// 1身份证 2护照   3驾照
    func settype(type:NSInteger,claim:Bool)  {
        
   typeImageView?.image = UIImage.init(named:(self.typeImageArr[type] as? String)!)
   typeL?.text = self.typeArr[type] as? String

    
        if claim{
            let contextArr = ["claim:sfp_idcard_authentication","claim:sfp_passport_authentication","claim:sfp_dl_authentication"]
            
            claimContext = contextArr[type]
            
        }else{
            let contextArr = ["claim:idm_idcard_authentication","claim:idm_passport_authentication","claim:idm_dl_authentication"]
            
            claimContext = contextArr[type]
        }
    
    }
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        return bundle
        
    }
    
override func layoutSubviews() {
    super.layoutSubviews()

}
    
}

