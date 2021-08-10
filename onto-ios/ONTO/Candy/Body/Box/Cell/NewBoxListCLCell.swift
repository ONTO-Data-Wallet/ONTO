//
//  NewBoxListCLCell.swift
//  ONTO
//
//  Created by Apple on 2018/9/30.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let CELLW = (SYSWidth - 55*SCALE_W)/2
private let CELLH = 210*CELLW/160
class NewBoxListCLCell: BaseSWCLCell {
    var bgImageView: UIImageView!
    var statusLB: UILabel!
    var moneyLB: UILabel!
    var moneyTypeImage: UIImageView!
    var coinImage: UIImageView!
    var coinTypeLB: UILabel!
    var bottomLB: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        bgImageView = UIImageView.init()
        bgImageView.layer.cornerRadius = 5
        self.addSubview(bgImageView)
        
        statusLB = UILabel.init()
        statusLB.textColor = UIColor.white
        statusLB.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLB.textAlignment = .right
        statusLB.changeSpace(0, wordSpace: 1)
        self.addSubview(bgImageView)
        
        moneyTypeImage = UIImageView.init()
        self.addSubview(moneyTypeImage)
        
        moneyLB = UILabel.init()
        moneyLB.textAlignment = .center
        moneyLB.textColor = UIColor.white
        moneyLB.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        moneyLB.changeSpace(0, wordSpace: 1)
        self.addSubview(moneyLB)
        
        coinImage = UIImageView.init()
        self.addSubview(coinImage)
        
        coinTypeLB = UILabel.init()
        coinTypeLB.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        coinTypeLB.textAlignment = .left
        coinTypeLB.textColor = UIColor.white
        self.addSubview(coinTypeLB)
        
        bottomLB = UILabel.init()
        bottomLB.textAlignment = .center
        bottomLB.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        bottomLB.changeSpace(0, wordSpace: 1)
        self.addSubview(bottomLB)
        
        layoutUI()
    }
    func layoutUI() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
