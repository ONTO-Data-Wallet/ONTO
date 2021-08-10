//
//  NewBalanceItemCell.swift
//  ONTO
//
//  Created by Apple on 2018/10/17.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class NewBalanceItemCell: BaseSWCLCell {
    var imgView:UIImageView!;
    var moneyLB:UILabel!
    var typeLB:UILabel!;
    var withdrawBtn:UILabel!
    var _delegate:CommonDelegate?;
    var _mod:ACBalanceItemModel?;
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setUpUI()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        imgView = UIImageView.init()
        addSubview(imgView)
        
        moneyLB = UILabel.init()
        moneyLB.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        moneyLB.changeSpace(0, wordSpace: 1)
        moneyLB.textAlignment = .left
        addSubview(moneyLB)
        
        typeLB = UILabel.init()
        typeLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        typeLB.changeSpace(0, wordSpace: 1)
        typeLB.textAlignment = .left
        addSubview(typeLB)
        
        withdrawBtn = UILabel.init()
        withdrawBtn.backgroundColor = UIColor.black
        withdrawBtn.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        withdrawBtn.changeSpace(0, wordSpace: 1)
        withdrawBtn.textAlignment = .center
        withdrawBtn.textColor = UIColor.white
        withdrawBtn.text = LocalizeEx("NewWITHDRAW")
//        withdrawBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        withdrawBtn.setTitleColor(UIColor.white, for: .normal)
//        withdrawBtn.setTitle(LocalizeEx("NewWITHDRAW"), for: .normal)
//        withdrawBtn.titleLabel?.changeSpace(0, wordSpace: 1)
//        withdrawBtn.isUserInteractionEnabled = true
        addSubview(withdrawBtn)
        
        let line = UIView.init()
        line.backgroundColor = Const.color.kAPPDefaultLineColor
        addSubview(line)
        
        imgView.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.width.height()?.equalTo()(50*SCALE_W)
            make?.top.equalTo()(self)?.offset()(10*SCALE_W)
            
        }
        
        moneyLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(imgView.mas_right)?.equalTo()(10*SCALE_W)
            make?.centerY.equalTo()(imgView.centerY)
        }
        
        withdrawBtn.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.height.equalTo()(34*SCALE_W)
            make?.width.equalTo()(100*SCALE_W)
            make?.centerY.equalTo()(imgView.centerY)
        }
        typeLB.mas_makeConstraints { (make) in
            make?.right.equalTo()(withdrawBtn.mas_left)?.offset()(-5*SCALE_W)
            make?.left.equalTo()(moneyLB.mas_right)?.offset()(5*SCALE_W)
            make?.centerY.equalTo()(imgView.centerY)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20*SCALE_W)
            make?.right.equalTo()(self)?.offset()(-20*SCALE_W)
            make?.height.equalTo()(0.5*SCALE_W)
            make?.bottom.equalTo()(self)?.offset()(-1)
        }
    }

    //MARK: - common
    public func fillCellWithMod(mod:ACBalanceItemModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {
        
        _delegate = delegate;
        _mod = mod;
        
        let holder = #imageLiteral(resourceName: "ongblue");
        let url = mod.headImg ?? ""
        imgView.sd_setImage(with: URL.init(string: url), placeholderImage:holder , options: SDWebImageOptions.retryFailed) { (image, error,  SDImageCacheTypeNone, url) in
            
        }
        
        typeLB.text = mod.title
        moneyLB.text = mod.content
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }

}
