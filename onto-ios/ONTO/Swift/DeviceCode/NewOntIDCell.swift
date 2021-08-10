//
//  NewOntIDCell.swift
//  ONTO
//
//  Created by Apple on 2018/9/10.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class NewOntIDCell: UITableViewCell {

    var topLB:UILabel!
    var bottomLB:UILabel!
    var rightBtn:UIButton!
    var line:UIView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        topLB = UILabel.init()
        topLB.textColor = UIColor.black
        topLB.text = "JOHNPAPAINFD"
        topLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        topLB.textAlignment = .left
        addSubview(topLB)
        
        bottomLB = UILabel.init()
        bottomLB.textColor = UIColor.black
        bottomLB.text = "did:ont:AceMx7N1anTnNho6sGZk4kpv8ZZy2vvDBv"
        bottomLB.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        bottomLB.textAlignment = .left
        addSubview(bottomLB)
        
        rightBtn = UIButton.init()
        rightBtn.setImage(UIImage(named: "cotIcon_Selected-big"), for: .normal)
        rightBtn.isHidden = true
        addSubview(rightBtn)
        
        line = UIView.init()
        line.backgroundColor = UIColor(hexString: "#DDDDDD")
        addSubview(line)
        
        topLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.top.equalTo()(self)?.offset()(25*SCALE_W)
        }
        rightBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.topLB.mas_right)?.offset()(10*SCALE_W)
            make?.centerY.equalTo()(self.topLB.mas_centerY)
            make?.height.width().equalTo()(24*SCALE_W)
        }
        bottomLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.top.equalTo()(self.topLB.mas_bottom)?.offset()(7*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
        }
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.top.equalTo()(self.mas_bottom)?.offset()(-1)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.height.equalTo()(1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
