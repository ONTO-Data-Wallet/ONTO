//
//  IMInfoCell.swift
//  ONTO
//
//  Created by Apple on 2018/8/9.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class IMInfoCell: UITableViewCell {

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
        leftLB = UILabel(frame: CGRect(x: 34.5*SCALE_W, y: 15*SCALE_W, width: SYSWidth/2 - 34.5*SCALE_W, height: 16*SCALE_W))
        leftLB.textColor = UIColor(hexString: "#8C9AAB")
        leftLB.font = UIFont.systemFont(ofSize: 14)
        leftLB.textAlignment = .left
        leftLB.tag = 1000
        addSubview(leftLB)
        
        rightLB = UILabel(frame: CGRect(x: SYSWidth/2, y: 15*SCALE_W, width: SYSWidth/2 - 34.5*SCALE_W, height: 16*SCALE_W))
        rightLB.textColor = UIColor(hexString: "#3D5777")
        rightLB.font = UIFont.systemFont(ofSize: 14)
        rightLB.textAlignment = .right
        rightLB.tag = 10000
        addSubview(rightLB)
        
        let line = UIView(frame: CGRect(x: 34.5*SCALE_W, y: 39*SCALE_W - 1, width: SYSWidth - 69*SCALE_W, height: 1))
        line.backgroundColor = UIColor(hexString: "#E2EAF2")
        addSubview(line)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
