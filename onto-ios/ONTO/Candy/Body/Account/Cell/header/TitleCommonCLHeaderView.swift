//
//  BottleView.swift
//  SNSBasePro
//
//  Created by zhan zhong yi on 2017/9/12.
//  Copyright © 2017年 zhan zhong yi. All rights reserved.
//

import UIKit

class TitleCommonCLHeaderView: UICollectionReusableView {
    
    enum TitleCommonType:Int {
      case normal
      case right
    }
    
    weak var _delegate:CommonDelegate?;
    @IBOutlet weak var _titleLabel:UILabel!;
    @IBOutlet weak var _descLabel:UILabel!;
    @IBOutlet weak var _arrowBtn:UIButton!;
    @IBOutlet weak var _backBtn:UIButton!;
    var _mod:Dictionary<String,String>!;
    @IBOutlet weak var titleTopLayout: NSLayoutConstraint!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        _titleLabel.textColor = Const.color.kAPPDefaultBlackColor;
        _titleLabel.font = Const.font.DINProFontType(.bold, 18);
        
        _descLabel.textColor = Const.color.kAPPDefaultBlackColor;
        _descLabel.font = Const.font.kAPPFont24;
        
        
    }
    
    //MARK -- common
    public func fillCellWithMod(mod:Any!,type:TitleCommonCLHeaderView.TitleCommonType,row:NSInteger,delegate:CommonDelegate?) -> Void {
        self.fillCellWithMod(mod: mod, type: type, row: row, delegate: delegate, bLast: false)
    }
    
    public func fillCellWithMod(mod:Any!,type:TitleCommonCLHeaderView.TitleCommonType,row:NSInteger,delegate:CommonDelegate?,bLast:Bool) -> Void {
        
         let d = mod  as! Dictionary<String,String>;
        _delegate = delegate;
        _mod = d
        
        let bMore = d["bMore"];
        if bMore == "1" {
            _arrowBtn.isHidden = false;
        }else {
            _arrowBtn.isHidden = true;
        }
        _backBtn.isHidden = _arrowBtn.isHidden;
    
        if type == TitleCommonType.right {
            
            _titleLabel.isHidden = true;
            _descLabel.text = d["title"]
            
        }else {
            _titleLabel.isHidden = false;
            _titleLabel.text = d["title"]
        }
        
        if bLast == true {
            titleTopLayout.constant = 35;
        }else {
            titleTopLayout.constant = 15;
        }
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
    //MARK: - clicked
    @IBAction func cdRightArrowClicked(_ sender: Any) {
        _delegate?.cdRightArrowClicked?(_mod)
    }
}

