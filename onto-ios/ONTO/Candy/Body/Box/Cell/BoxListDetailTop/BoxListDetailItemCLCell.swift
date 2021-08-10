//
//  BoxListDetailMissionItemCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/24.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class BoxListDetailItemCLCell: BaseSWCLCell {
    
    @IBOutlet weak var titleLabel:UILabel!;
    @IBOutlet weak var imgView:UIImageView!;
    @IBOutlet weak var iconImgView:UIImageView!;
    public weak var _delegate:CommonDelegate?;
    var _mod:BoxListDetailItemModel?;
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear;
        
        titleLabel.font = Const.font.kAPPFont24;
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
    }

    //MARK: - common
    public func fillCellWithMod(mod:BoxListDetailItemModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {
        
        _delegate = delegate;
        _mod = mod;
        
        titleLabel.text = mod.title;
        let holder = #imageLiteral(resourceName: "ongblue");
        let url = mod.headImg ?? ""
        imgView.sd_setImage(with: URL.init(string: url), placeholderImage:holder , options: SDWebImageOptions.retryFailed) { (image, error,  SDImageCacheTypeNone, url) in
            
        }
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
}
