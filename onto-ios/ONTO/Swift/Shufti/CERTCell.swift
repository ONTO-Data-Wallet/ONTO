//
//  CERTCell.swift
//  ONTO
//
//  Created by Apple on 2018/11/8.
//  Copyright © 2018 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class CERTCell: UITableViewCell {

    var typeImage:UIImageView!
    var nameLB:UILabel!
    var statusLB:UILabel!
    var feeLB:UILabel!
    var ontLB:UILabel!
    var timeLB:UILabel!
    var rightImage:UIImageView!
    var line:UIView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        nameLB = UILabel()
        nameLB.text = "Shufti Pro-Identification Card"
        nameLB.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLB.changeSpace(0, wordSpace: 1)
        nameLB.textAlignment = .left
        nameLB.numberOfLines = 0
        addSubview(nameLB)
        
        statusLB = UILabel()
        statusLB.text = "Success"
        statusLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        statusLB.textColor = UIColor(hexString: "#196BD8")
        statusLB?.textAlignment = .left
        addSubview(statusLB)
        
        feeLB = UILabel()
        feeLB.text = "Fee: 0.1 ONG"
        feeLB.textColor = UIColor(hexString: "#6E6F70")
        feeLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        feeLB.textAlignment = .left
        addSubview(feeLB)
        
        ontLB = UILabel()
        ontLB.text = "ONT ID: Fy31d…lysoN"
        ontLB.lineBreakMode = .byTruncatingMiddle 
        ontLB.textColor = UIColor(hexString: "#6E6F70")
        ontLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        ontLB.textAlignment = .left
        addSubview(ontLB)
        
        timeLB = UILabel()
        timeLB.text = "Create Time: Sep 27, 2018"
        timeLB.textColor = UIColor(hexString: "#6E6F70")
        timeLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        timeLB.textAlignment = .left
        addSubview(timeLB)
        
        line = UIView()
        line.backgroundColor = UIColor(hexString: "#DDDDDD")
        addSubview(line)
        
        rightImage = UIImageView()
        rightImage.image = UIImage(named: "candy_right_arrow")
        addSubview(rightImage)
        
        typeImage = UIImageView()
        typeImage.image = UIImage(named: "shuftiLogo")
        addSubview(typeImage)
        
        nameLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(108*SCALE_W)
            make?.top.equalTo()(self)?.offset()(20*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-13*SCALE_W)
            
        }
        
        typeImage.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(30*SCALE_W)
            make?.top.equalTo()(nameLB.mas_bottom)?.offset()(12*SCALE_W)
            make?.width.height()?.equalTo()(58*SCALE_W)
        }
        
        statusLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(nameLB)
            make?.top.equalTo()(nameLB.mas_bottom)?.offset()(10*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
        }
        
        feeLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(nameLB)
            make?.top.equalTo()(statusLB.mas_bottom)?.offset()(5*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
        }
        
        ontLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(nameLB)
            make?.top.equalTo()(feeLB.mas_bottom)?.offset()(5*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
        }
        
        timeLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(nameLB)
            make?.top.equalTo()(ontLB.mas_bottom)?.offset()(5*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(timeLB.mas_bottom)?.offset()(25*SCALE_W)
            make?.height.equalTo()(1*SCALE_W)
            make?.bottom.equalTo()(self.mas_bottom)
        }
        
        rightImage.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(timeLB.mas_bottom)
            make?.width.height()?.equalTo()(20*SCALE_W)
        }
        
    }
    public func reloadCellByDic(dic: NSDictionary){
        print("shuftipro=\(dic)")
        let ContextInfo = dic["ContextInfo"] as! NSDictionary
        let ChargeInfo = dic["ChargeInfo"] as! NSDictionary
        
        nameLB.text = (ContextInfo["Name"] as! String)
        typeImage.sd_setImage(with: URL.init(string: ContextInfo.value(forKey: "Logo") as! String)) { (_, _, _, _) in
        }
        
        let Status = "\(dic["Status"] ?? "1")"
        if (Status as NSString).isEqual(to: "1") {
            statusLB.text = LocalizeEx("AuthSuccess")
            statusLB.textColor = UIColor(hexString: "#196BD8")
        }else{
            statusLB.text = LocalizeEx("AuthFail")
            statusLB.textColor = UIColor(hexString: "#EE2C44")
        }
        ontLB.text = "ONT ID: \(dic["OwnerOntId"] ?? "")"
        if ChargeInfo.count > 0 {
            let str = Common.getshuftiStr(ChargeInfo.value(forKey: "Amount") as? String)
            feeLB.text = "\(LocalizeEx("Fee")) \(str ?? "0") ONG"
        }else{
            feeLB.text = "\(LocalizeEx("Fee")) 0 ONG"
        }
        
        let time = Common.getTimeFromTimestamp("\(dic["CreateTime"] ?? "")")
        timeLB.text = "\(LocalizeEx("COTCreated")): \(time ?? "")"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
