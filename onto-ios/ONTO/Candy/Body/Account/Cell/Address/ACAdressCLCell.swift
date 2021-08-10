//
//  BoxListCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class ACAdressCLCell: BaseSWCLCell {
    
    @IBOutlet weak var headImgView:UIImageView!;
    @IBOutlet weak var titleLabel:UILabel!;
    @IBOutlet weak var contentLabel:UILabel!;
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var lineImgViewHeightLayout: NSLayoutConstraint!
    public weak var _delegate:CommonDelegate?;
    var _dict:Any?;
    var _mod:ACAdressModel?;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white

        titleLabel.font = Const.font.DINProFontType(.medium, 17)
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        contentLabel.font = Const.font.DINProFontType(.medium, 14);
        contentLabel.textColor = Const.color.kAPPDefaultBlackColor;
        
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
        lineImgViewHeightLayout.constant = 0.5;
    }

    //MARK -- common
    public func fillCellWithMod(mod:ACAdressModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {

        _delegate = delegate;
        _mod = mod;

        let holder = #imageLiteral(resourceName: "ongblue");
        let url = mod.headImg ?? ""
        headImgView.sd_setImage(with: URL.init(string: url), placeholderImage:holder , options: SDWebImageOptions.retryFailed) { (image, error,  SDImageCacheTypeNone, url) in
            
        }
        titleLabel.text = mod.blockChainName;
        contentLabel.text = mod.content;

        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
}
