//
//  COTTableViewCell.swift
//  ONTO
//
//  Created by Apple on 2018/8/7.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class COTTableViewCell: UITableViewCell {

    var titleLabel:UILabel?
    var selectedBtn:UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    func setUpUI() {
        selectedBtn = COTButton(frame: CGRect(x: 75*SCALE_W, y: 9.5*SCALE_W, width: 22*SCALE_W, height: 17*SCALE_W))
        selectedBtn?.setImage(UIImage(named: "cotIcon_Selected-big"), for: .normal)
        selectedBtn?.setEnlargeEdge(20)
        addSubview(selectedBtn!)
        
        titleLabel = UILabel(frame: CGRect(x: 106*SCALE_W, y: 9.5*SCALE_W, width: SYSWidth - 164*SCALE_W, height: 17*SCALE_W))
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
        titleLabel?.textColor = UIColor(hexString: "#2B4045")
        titleLabel?.text = "hahahahhahahha"
        titleLabel?.textAlignment = .left
        titleLabel?.numberOfLines = 0
        addSubview(titleLabel!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
