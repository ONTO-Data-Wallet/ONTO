//
//  AuthDetailCell.swift
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
class AuthDetailCell: UITableViewCell {

    var titleLB :UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        titleLB = UILabel.init()
        titleLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLB.changeSpace(0, wordSpace: 1)
        titleLB.textAlignment = .left
        addSubview(titleLB)
        
        titleLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.top.equalTo()(self)?.offset()(6*SCALE_W)
        }
        
    }
    public func reloadCellByDic(dic: NSDictionary,index:IndexPath) {
        if index.section == 0 {
            if (dic["Status"] as! Int) == 0 {
                titleLB.text = LocalizeEx("WalletManageSuccess")
                titleLB.textColor = UIColor(hexString: "#196BD8")
            }else{
                titleLB.text = LocalizeEx("CreateFailed")
                titleLB.textColor = UIColor(hexString: "#EE2C44")
            }
        }else if index.section == 1{
            if dic.isKind(of: NSDictionary.self) && (dic.value(forKey: "ThirdParty") != nil){
                let subDic = dic["ThirdParty"] as! NSDictionary
                titleLB.text = "\(subDic["Name"]!)"
            }else{
                titleLB.text = "COT"
            }
        }else if index.section == 2{
            titleLB.text = (dic["AuthId"] as! String)
        }else if index.section == 3{
            let subArr = dic["Claims"] as! NSArray
            let subDic = subArr[index.row] as! NSDictionary
            titleLB.text = (subDic["Name"] as! String)
        }else if index.section == 4{
            titleLB.text = (UserDefaults.standard.value(forKey: ONT_ID)! as! String)
        }
        else if index.section == 5{
            titleLB.text = (dic["AuthTime"] as! String)
        }
    
    }
}
