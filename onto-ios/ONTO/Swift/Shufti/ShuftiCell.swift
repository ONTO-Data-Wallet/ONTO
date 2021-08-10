//
//  ShuftiCell.swift
//  ONTO
//
//  Created by Apple on 2018/11/7.
//  Copyright © 2018 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class ShuftiCell: UITableViewCell {

    var nameLB:UILabel!
    var addressLB:UILabel!
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
        nameLB.text = "123111"
        nameLB.textColor = UIColor(hexString: "#6E6F70")
        nameLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLB.changeSpace(0, wordSpace: 1)
        nameLB.textAlignment = .left
        addSubview(nameLB)
        
        addressLB = UILabel()
        addressLB.text = "WA9fnuAZyrsZtCJoRBQUvGiDAG4ufgUf3t"
        addressLB.textColor = UIColor(hexString: "#000000")
        addressLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addressLB.textAlignment = .left
        addSubview(addressLB)
        
        line = UIView()
        line.backgroundColor = UIColor(hexString: "#DDDDDD")
        addSubview(line)
        
        nameLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.top.equalTo()(self)?.offset()(19*SCALE_W)
        }
        
        addressLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(nameLB)
            make?.top.equalTo()(nameLB.mas_bottom)?.offset()(6*SCALE_W)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.height.equalTo()(1)
            make?.bottom.equalTo()(self)?.offset()(-1)
        }
    }
    public func reloadCellByDic(dic: NSDictionary,defaultDic:NSDictionary){
        nameLB.text = (dic.value(forKey: "label") as! String)
        addressLB.text = (dic.value(forKey: "address") as! String)
        let defaultStr = defaultDic.value(forKey: "label") as! NSString
        let str = dic.value(forKey: "label") as! NSString
        if defaultStr.isEqual(to: str as String) {
            self.backgroundColor = UIColor(hexString: "#196BD8")
            nameLB.textColor = UIColor.white
            addressLB.textColor = UIColor.white
            line.isHidden = true
        }else{
            self.backgroundColor = UIColor.white
            nameLB.textColor = UIColor(hexString: "#6E6F70")
            addressLB.textColor = UIColor.black
            line.isHidden = false
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
