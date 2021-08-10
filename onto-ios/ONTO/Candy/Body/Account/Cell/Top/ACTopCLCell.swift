//
//  BoxListCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class ACTopCLCell: BaseSWCLCell {
    
    @IBOutlet weak var titleLabel:UILabel!;
    @IBOutlet weak var contentLabel:UILabel!;
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var lineImgViewHeightLayout: NSLayoutConstraint!
    public weak var _delegate:CommonDelegate?;
    var _dict:Any?;
    var _mod:ACNameModel?;
    var _mLock:NSLock!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white

        titleLabel.font = Const.font.DINProFont("PingFangSC-Medium", 14);
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        contentLabel.font = Const.font.DINProFontType(.medium, 14);
        contentLabel.textColor = Const.color.kAPPDefaultGrayColor;
        
        _mLock = NSLock.init();
//        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
//        lineImgViewHeightLayout.constant = 1.0;
    }

    //MARK -- common
    public func fillCellWithMod(mod:ACNameModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {

        _mLock.lock();
        _delegate = delegate;
        _mod = mod;

        titleLabel.text = mod.title;
        contentLabel.attributedText = self.ontIdContent(); //mod.content?.replaceOnt(40, 10);  //hiddenString(40, offset: 10)

        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
        _mLock.unlock();
    }
    
    func ontIdContent() -> NSMutableAttributedString {
        
        var  num = 30;
        if Const.SCREEN_WIDTH < 375 {
            num = 26;
        }
        
        let title = LocalizeEx("related_ont_id") + " ";
        var content = ZYUtilsSW.getOntId();
        content = content.replaceOnt(num, 4);
        
        let black = [NSAttributedStringKey.font: Const.font.DINProFontType(.medium, 14),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultBlackColor] as [NSAttributedStringKey : Any];
        let gray  =  [NSAttributedStringKey.font: Const.font.DINProFontType(.medium, 14),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultGrayColor] as [NSAttributedStringKey : Any];
        let attrTitle = NSMutableAttributedString.init(string: title, attributes: gray)
        let part =  NSMutableAttributedString.init(string:content, attributes: black)
        attrTitle.append(part)
        return attrTitle;
    }

}
