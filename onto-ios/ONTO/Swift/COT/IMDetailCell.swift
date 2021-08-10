//
//  IMDetailCell.swift
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
class IMDetailCell: UITableViewCell {

    var topLB:UILabel!
    var bottomLB:UILabel!
    var rightBtn:UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        topLB = UILabel(frame: CGRect(x: 32*SCALE_W, y: 17*SCALE_W, width: SYSWidth - 48*SCALE_W, height: 16*SCALE_W))
        topLB.textColor = UIColor(hexString: "#6A797C")
        topLB.font = UIFont.systemFont(ofSize: 14)
        topLB.textAlignment = .left
        addSubview(topLB)
        
        bottomLB = UILabel(frame: CGRect(x: 32*SCALE_W, y: 40*SCALE_W*SCALE_W, width: SYSWidth - 48*SCALE_W, height: 34*SCALE_W))
        bottomLB.textColor = UIColor(hexString: "#2B4040")
        bottomLB.font = UIFont.systemFont(ofSize: 14)
        bottomLB.textAlignment = .left
        bottomLB.numberOfLines = 0
        addSubview(bottomLB)
        
        rightBtn = UIButton(frame: CGRect(x: SYSWidth - 32*SCALE_W, y: 17*SCALE_W, width: 16*SCALE_W, height: 16*SCALE_W))
        rightBtn.setImage(UIImage(named: "IdRight"), for: .normal)
        rightBtn.isHidden = true
        addSubview(rightBtn)
        
        let line = UIView(frame: CGRect(x: 32*SCALE_W, y: 80*SCALE_W - 1, width: SYSWidth - 32*SCALE_W, height: 1))
        line.backgroundColor = UIColor(hexString: "#E2EAF2")
        addSubview(line)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
