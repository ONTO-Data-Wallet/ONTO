//
//  BlankCLCell.swift
//  ONTO
//
//  Created by zhan zhong yi on 2018/8/26.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class BlankCLCell: BaseSWCLCell {
    
    @IBOutlet weak var headImgView:UIImageView!;
    @IBOutlet weak var titleLabel:UILabel!;
    public weak var _delegate:CommonDelegate?;
    var _mod:BlankModel?;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        
        titleLabel.font = Const.font.kAPPFont30;
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
    }
    
    //MARK -- common
    public func fillCellWithMod(mod:BlankModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {
        
        _delegate = delegate;
        _mod = mod;
        
        let image:UIImage = UIImage.init(named: mod.headImg ?? "ongblue")!;
        headImgView.image = image;

        titleLabel.text = mod.title;
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }

}
