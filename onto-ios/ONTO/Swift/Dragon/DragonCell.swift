//
//  DragonCell.swift
//  ONTO
//
//  Created by Apple on 2018/11/27.
//  Copyright © 2018 Zeus. All rights reserved.
//

import UIKit

//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class DragonCell: UITableViewCell {

    var dragonLogo:UIImageView!
    var dragonNumber:UILabel!
    var dragonProperty:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        dragonLogo = UIImageView.init()
        dragonLogo.image = UIImage(named: "dragonSmall")
//        dragonLogo.sd_setImage(with: URL.init(string: "http://hd-ont-res-test.alfakingdom.com/normal/2.svg")) { (_, _, _, _) in
//
//        }
        addSubview(dragonLogo)
        
        dragonNumber = UILabel.init()
        dragonNumber.text = "Gragon #21136"
        dragonNumber.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        dragonNumber.changeSpace(0, wordSpace: 1)
        dragonNumber.textAlignment = .left
        addSubview(dragonNumber)
        
        dragonProperty = UILabel.init()
        dragonProperty.text = "Gen 85"
        dragonProperty.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        dragonProperty.changeSpace(0, wordSpace: 1)
        dragonProperty.textAlignment = .right
        addSubview(dragonProperty)
        
        let rightImage = UIImageView.init()
        rightImage.image = UIImage(named: "candy_right_arrow")
        addSubview(rightImage)
        
        let line = UIView.init()
        line.backgroundColor = Const.color.kAPPDefaultLineColor
        addSubview(line)
        
        dragonLogo.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.centerY.equalTo()(self)
            make?.width.height()?.equalTo()(50*SCALE_W)
        }
        
        dragonNumber.mas_makeConstraints { (make) in
            make?.left.equalTo()(dragonLogo.mas_right)?.offset()(30*SCALE_W)
            make?.centerY.equalTo()(self)
        }
        
        dragonProperty.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.right.equalTo()(self)?.offset()(-70*SCALE_W)
            make?.left.equalTo()(dragonNumber.mas_right)?.offset()(10*SCALE_W)
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
        dragonNumber.text = (dic["name"] as! String)
        dragonProperty.text = "\(LocalizeEx("fight_power")) \(dic["fight_power"] ?? "0")" //"\(dic["gen"] ?? "0") \(LocalizeEx("gen"))" //fight_power
        let svgImage = SVGKImage.init(contentsOf: URL.init(string: "\(dic["src"]!)")) as SVGKImage
        dragonLogo.image = svgImage.uiImage 
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
