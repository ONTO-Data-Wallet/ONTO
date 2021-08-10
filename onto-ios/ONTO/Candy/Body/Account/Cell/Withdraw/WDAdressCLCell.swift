//
//  BoxListCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class WDAdressCLCell: BaseSWCLCell {
    
    @IBOutlet weak var titleLabel:UILabel!;
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var lineImgViewHeightLayout: NSLayoutConstraint!
    public weak var _delegate:CommonDelegate?;
    var _mod:ACAdressModel?;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        self.highlightView?.layer.backgroundColor = Const.color.kAPPDefaultBlueColor.cgColor

        titleLabel.font = Const.font.kAPPFont30;
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
        lineImgViewHeightLayout.constant = 0.5;
    }

    //MARK -- common
    public func fillCellWithMod(mod:ACAdressModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {

        _delegate = delegate;
        _mod = mod;

        titleLabel.text = mod.content;

        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
}
