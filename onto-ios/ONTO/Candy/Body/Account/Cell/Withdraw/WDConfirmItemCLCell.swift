//
//  WDConfirmItemCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/24.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class WDConfirmItemCLCell: BaseSWCLCell {
    
    @IBOutlet weak var imgView:UIImageView!;
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var lineImgViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var imgViewLeadingLayout: NSLayoutConstraint!
    public weak var _delegate:CommonDelegate?;
    var _mod:WDConfirmModel?;
    var itemSize:CGSize! = CGSize.zero;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        
        imgView.backgroundColor = Const.color.kAPPDefaultBlackColor;
        imgView.layer.cornerRadius = imgView.frame.size.height/2;
        imgView.layer.masksToBounds = true;
        imgView.isHidden = true;
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor
    }

    //MARK: - common
    public func fillCellWithMod(mod:WDConfirmModel!,row:NSInteger,delegate:CommonDelegate?,size:CGSize) -> Void {
        
        _delegate = delegate;
        _mod = mod;
        
        itemSize = size;
        //        let name = "candy_mission_icon";
        //        let image:UIImage = UIImage.init(named: name)!;
        //        imgView.image = image;
        self.updateUI(mod)
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
    func updateUI(_ mod:WDConfirmModel) {
        
        if let pwd = mod.pwd  {
            if pwd.isEmpty == true {
                imgView.isHidden = true;
            }else {
                imgView.isHidden = false;
            }
        }else {
            imgView.isHidden = true;
        }
    }
    
    
}
