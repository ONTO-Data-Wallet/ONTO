//
//  BoxListDetailMissionItemCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/24.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class ACBalanceItemCLCell: BaseSWCLCell {
    
    @IBOutlet weak var imgView:UIImageView!;
    @IBOutlet weak var iconImgView:UIImageView!;
    @IBOutlet weak var titleLabel:UILabel!;
    @IBOutlet weak var contentLabel:UILabel!;
    public weak var _delegate:CommonDelegate?;
    var _mod:ACBalanceItemModel?;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.font = Const.font.DINProFontType(.medium, 14);
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        contentLabel.font = Const.font.DINProFontType(.medium, 20);
        contentLabel.textColor = Const.color.kAPPDefaultBlackColor;
    }

    //MARK: - common
    public func fillCellWithMod(mod:ACBalanceItemModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {
        
        _delegate = delegate;
        _mod = mod;
    
        let holder = #imageLiteral(resourceName: "ongblue");
        let url = mod.headImg ?? ""
        imgView.sd_setImage(with: URL.init(string: url), placeholderImage:holder , options: SDWebImageOptions.retryFailed) { (image, error,  SDImageCacheTypeNone, url) in
            
        }
        
        titleLabel.text = mod.title
        contentLabel.text = mod.content
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
}
