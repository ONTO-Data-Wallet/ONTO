//
//  PumDetailCell.swift
//  ONTO
//
//  Created by Apple on 2018/10/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class PumDetailCell: UITableViewCell {

    var moneyLB:UILabel!
    var addressLB:UILabel!
    var timeLB:UILabel!
    var statusLB:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        moneyLB = UILabel.init()
        moneyLB.text = "-2"
        moneyLB.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        moneyLB.changeSpace(0, wordSpace: 1)
        moneyLB.textAlignment = .left
        addSubview(moneyLB)
        
        addressLB = UILabel.init()
        addressLB.text = "AQbmC…5r2zC9"
        addressLB.lineBreakMode = .byTruncatingMiddle
        addressLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addressLB.changeSpace(0, wordSpace: 1)
        addressLB.textAlignment = .left
        addSubview(addressLB)
        
        timeLB = UILabel.init()
        timeLB.text = "2018-11-12 10:23:24"
        timeLB.textColor = UIColor(hexString: "#6E6F70")
        timeLB.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        timeLB.changeSpace(0, wordSpace: 1)
        timeLB.textAlignment = .right
        addSubview(timeLB)
        
        statusLB = UILabel.init()
        statusLB.text = "Success"
        statusLB.textColor = UIColor(hexString: "#196BD8")
        statusLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        statusLB.changeSpace(0, wordSpace: 1)
        statusLB.textAlignment = .right
        addSubview(statusLB)
        
        let line = UIView.init()
        line.backgroundColor = Const.color.kAPPDefaultLineColor
        addSubview(line)
        
        moneyLB.mas_makeConstraints { (make) in
            make?.left.top()?.equalTo()(self)?.offset()(20*SCALE_W)
        }
        
        addressLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.top.equalTo()(moneyLB.mas_bottom)?.offset()(10*SCALE_W)
            make?.width.equalTo()(SYSWidth/2)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.bottom.equalTo()(self)?.offset()(-1)
            make?.height.equalTo()(1)
        }
        
        timeLB.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
//            make?.top.equalTo()(self)?.offset()(20*SCALE_W)
            make?.centerY.equalTo()(moneyLB.mas_centerY)
            
        }
        
        statusLB.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
//            make?.top.equalTo()(timeLB.mas_bottom)?.offset()(15*SCALE_W)
            make?.centerY.equalTo()(addressLB.mas_centerY)
        }
    }
    func reloadCellByDic(dic:NSDictionary,address:NSString) {
        let  ConfirmFlag:Int = dic.value(forKey: "ConfirmFlag") as! Int
        if ConfirmFlag == 1 {
            statusLB.text = LocalizeEx("WalletManageSuccess")
            statusLB.textColor = UIColor(hexString: "#196BD8")
        }else if ConfirmFlag == 2{
            statusLB.text = LocalizeEx("CreateFailed")
            statusLB.textColor = UIColor(hexString: "#EE2C44")
        }else{
            statusLB.text = LocalizeEx("Processing")
            statusLB.textColor = UIColor(hexString: "#196BD8")
        }
        //
        
        let arr = dic.value(forKey: "TransferList") as! NSArray
        let subDic = arr[0] as! NSDictionary
        let fromAddress = subDic["FromAddress"] as! NSString
        addressLB.text = (subDic.value(forKey: "FromAddress") as! String)
        addressLB.lineBreakMode = .byTruncatingMiddle
        timeLB.text = Common.getTimeFromTimestamp("\(dic["TxnTime"] ?? 1540379353)")
        let str = subDic["Amount"] as! NSString
        let arr1 = str.components(separatedBy: ".") as NSArray
        print("arr =\(arr1)")
        if address.isEqual(to: fromAddress as String) {
            moneyLB.text = "-\(arr1[0])"
            moneyLB.textColor = UIColor.black
        }else{
            moneyLB.text = "+\(arr1[0])"
            moneyLB.textColor = UIColor(hexString: "#8DD63E")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
