//
//  AuthListCell.swift
//  ONTO
//
//  Created by Apple on 2018/10/22.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class AuthListCell: UITableViewCell {

    var cotImage:UIImageView!
    var cotLB:UILabel!
    var cotStatusLB:UILabel!
    var ontIDLB:UILabel!
    var createTime:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
       
        cotImage = UIImageView.init()
        cotImage.image = UIImage(named: "COTAUTH")
        addSubview(cotImage)
        
        cotLB = UILabel.init()
        cotLB.text = "COT"
        cotLB.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        cotLB.textAlignment = .left
        cotLB.changeSpace(0, wordSpace: 1)
        addSubview(cotLB)
        
        cotStatusLB = UILabel.init()
        cotStatusLB.text = "Success"
        cotStatusLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cotStatusLB.textAlignment = .left
        cotStatusLB.changeSpace(0, wordSpace: 1)
        addSubview(cotStatusLB)
        
        ontIDLB = UILabel.init()
        ontIDLB.text = "ONT ID: Fy31d…lysoN"
        ontIDLB.lineBreakMode = .byTruncatingMiddle 
        ontIDLB.textColor = UIColor(hexString: "#6E6F70")
        ontIDLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        ontIDLB.textAlignment = .left
        ontIDLB.changeSpace(0, wordSpace: 1)
        addSubview(ontIDLB)
        
        createTime = UILabel.init()
        createTime.text = "Create Time: Sep 27, 2018"
        createTime.textColor = UIColor(hexString: "#6E6F70")
        createTime.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        createTime.textAlignment = .left
        createTime.changeSpace(0, wordSpace: 1)
        addSubview(createTime)
        
        let rightImage = UIImageView.init()
        rightImage.image = UIImage(named: "candy_right_arrow")
        addSubview(rightImage)
        
        let line = UIView.init()
        line.backgroundColor = Const.color.kAPPDefaultLineColor
        addSubview(line)
        
        cotImage.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(30*SCALE_W)
            make?.top.equalTo()(self)?.offset()(55*SCALE_W)
            make?.width.height()?.equalTo()(57*SCALE_W)
        }
        
        cotLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(cotImage.mas_right)?.offset()(20*SCALE_W)
            make?.top.equalTo()(self)?.offset()(20*SCALE_W)
        }
        
        cotStatusLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(cotImage.mas_right)?.offset()(20*SCALE_W)
            make?.top.equalTo()(cotLB.mas_bottom)?.offset()(11*SCALE_W)
        }
        
        ontIDLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(cotImage.mas_right)?.offset()(20*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(cotStatusLB.mas_bottom)?.offset()(5*SCALE_W)
        }
        
        createTime.mas_makeConstraints { (make) in
            make?.left.equalTo()(cotImage.mas_right)?.offset()(20*SCALE_W)
            make?.top.equalTo()(ontIDLB.mas_bottom)?.offset()(5*SCALE_W)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.bottom.equalTo()(self)
            make?.height.equalTo()(1)
        }
        
        rightImage.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(self)?.offset()(115*SCALE_W)
            make?.width.height()?.equalTo()(20*SCALE_W)
        }
    }

    public func reloadCellByDic(dic: NSDictionary){
        print("dic=\(dic)")
        if (dic["Status"] as! Int) == 0 {
            cotStatusLB.text = LocalizeEx("WalletManageSuccess")
            cotStatusLB.textColor = UIColor(hexString: "#196BD8")
        }else{
            cotStatusLB.text = LocalizeEx("CreateFailed")
            cotStatusLB.textColor = UIColor(hexString: "#EE2C44")
        }
        if dic.isKind(of: NSDictionary.self) && (dic.value(forKey: "ThirdParty") != nil){
            let subDic = dic["ThirdParty"] as! NSDictionary
            cotLB.text = "\(subDic["Name"]!)"
            cotImage.sd_setImage(with: URL.init(string: subDic.value(forKey: "Logo") as! String)) { (_, _, _, _) in
            }
        }else{
            cotLB.text = "COT"
            cotImage.image = UIImage(named: "COTAUTH")
        }
        
        ontIDLB.text = "\(LocalizeEx("ListOnt"))\(UserDefaults.standard.value(forKey: ONT_ID)!)"
        
        createTime.text = "\(LocalizeEx("COTCreated")):\(dic["AuthTime"]!)"
    }
}
