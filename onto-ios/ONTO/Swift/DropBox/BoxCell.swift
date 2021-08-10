//
//  BoxCell.swift
//  ONTO
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class BoxCell: UITableViewCell {

    var leftLB:UILabel!
    var rightLB:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        leftLB = UILabel.init()
        leftLB.textColor = UIColor(hexString: "#000000")
        leftLB.text = "johnpapayy11.keystore"
        leftLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        leftLB.textAlignment = .left
        leftLB.tag = 1000
        addSubview(leftLB)
        
        rightLB = UILabel.init()
        rightLB.textColor = UIColor(hexString: "#6E6F70")
        rightLB.text = "2018-08-13 12:10"
        rightLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        rightLB.textAlignment = .right
        rightLB.tag = 10000
        addSubview(rightLB)
        
        let line = UIView.init()
        line.backgroundColor = UIColor(hexString: "#E9EDEF")
        addSubview(line)
        
        leftLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.top.equalTo()(self)?.offset()(28*SCALE_W)
            make?.width.equalTo()(SYSWidth/2)
        }
        
        rightLB.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(self)?.offset()(28*SCALE_W)
        }
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.height.equalTo()(1)
            make?.bottom.equalTo()(self)?.offset()(-1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
