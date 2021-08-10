//
//  PumpkinCell.swift
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
class PumpkinCell: UITableViewCell {

    var pumImage:UIImageView!
    var pumNum:UILabel!
    var pumColor:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        pumImage = UIImageView.init()
        pumImage.image = UIImage(named: "OrangePum")
        addSubview(pumImage)
        
        pumNum = UILabel.init()
        pumNum.text = "20"
        pumNum.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        pumNum.changeSpace(0, wordSpace: 1)
        pumNum.textAlignment = .left
        addSubview(pumNum)
        
        pumColor = UILabel.init()
        pumColor.text = "Green"
        pumColor.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        pumColor.changeSpace(0, wordSpace: 1)
        pumColor.textAlignment = .left
        addSubview(pumColor)
        
        let rightImage = UIImageView.init()
        rightImage.image = UIImage(named: "candy_right_arrow")
        addSubview(rightImage)
        
        let line = UIView.init()
        line.backgroundColor = Const.color.kAPPDefaultLineColor
        addSubview(line)
        
        pumImage.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.centerY.equalTo()(self)
            make?.width.height()?.equalTo()(50*SCALE_W)
        }
        
        pumNum.mas_makeConstraints { (make) in
            make?.left.equalTo()(pumImage.mas_right)?.offset()(15*SCALE_W)
            make?.centerY.equalTo()(self)
        }
        
        pumColor.mas_makeConstraints { (make) in
            make?.left.equalTo()(pumImage.mas_right)?.offset()(60*SCALE_W)
            make?.centerY.equalTo()(self)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.bottom.equalTo()(self)
            make?.height.equalTo()(1)
        }
        
        rightImage.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.centerY.equalTo()(self)
            make?.width.height()?.equalTo()(20*SCALE_W)
        }
    }

    func reloadCellByDic(dic:NSDictionary) {
        pumNum.text = (dic["Balance"] as! String)
        let pumtype = dic["AssetName"] as! NSString
        if pumtype.isEqual(to: "pumpkin01") {
            pumImage.image = UIImage(named: "CoralPum")
            pumColor.text = LocalizeEx("PumpkinRed")
        }else if pumtype.isEqual(to: "pumpkin02"){
            pumImage.image = UIImage(named: "OrangePum")
            pumColor.text = LocalizeEx("PumpkinOrange")
        }else if pumtype.isEqual(to: "pumpkin03"){
            pumImage.image = UIImage(named: "YellowPum")
            pumColor.text = LocalizeEx("PumpkinYellow")
        }else if pumtype.isEqual(to: "pumpkin04"){
            pumImage.image = UIImage(named: "GreenPum")
            pumColor.text = LocalizeEx("PumpkinGreen")
        }else if pumtype.isEqual(to: "pumpkin05"){
            pumImage.image = UIImage(named: "TurquoisePum")
            pumColor.text = LocalizeEx("PumpkinIndigo")
        }else if pumtype.isEqual(to: "pumpkin06"){
            pumImage.image = UIImage(named: "BluePum")
            pumColor.text = LocalizeEx("PumpkinBlue")
        }else if pumtype.isEqual(to: "pumpkin07"){
            pumImage.image = UIImage(named: "VioletPum")
            pumColor.text = LocalizeEx("PumpkinPurple")
        }else if pumtype.isEqual(to: "pumpkin08"){
            pumImage.image = UIImage(named: "goldenPum")
            pumColor.text = LocalizeEx("PumpkinGolden")
        }
        
        if (pumNum.text! as NSString).isEqual(to: "0") {
            pumImage.image = UIImage(named: "emptyPum")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
