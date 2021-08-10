//
//  BoxListCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class BoxListCLCell: BaseSWCLCell {
    
    @IBOutlet weak var headImgView:UIImageView!;
    @IBOutlet weak var iconImgView:UIImageView!;
    @IBOutlet weak var hotLabel:UILabel!;
    @IBOutlet weak var titleLabel:UILabel!;
    @IBOutlet weak var contentLabel:UILabel!;
    @IBOutlet weak var currencyLabel:UILabel!;
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var coverImgView:UIImageView!;
    @IBOutlet weak var arrowImgView:UIImageView!
    public weak var _delegate:CommonDelegate?;
    var _dict:Any?;
    var _mod:BoxListModel?;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white

        
        titleLabel.font =  Const.font.DINProFontType(.bold, 18)
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        hotLabel.font = Const.font.DINProFontType(.bold, 15)
        hotLabel.textColor = Const.color.kAPPDefaultBlackColor;

        contentLabel.font = Const.font.DINProFontType(.medium, 15)
        contentLabel.textColor = Const.color.kAPPDefaultGrayColor;
        
        currencyLabel.font = Const.font.kAPPFont24;
        currencyLabel.textColor = Const.color.kAPPDefaultBlackColor;
        
        coverImgView.backgroundColor = ZYUtilsSW.getColor(hex: "ffffff", alpha: 0.5)
        
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
    }

    //MARK -- common
    public func fillCellWithMod(mod:BoxListModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {

        _delegate = delegate;
        _mod = mod;


        let holder = #imageLiteral(resourceName: "ongblue");
        var url = mod.headImg ?? ""
        headImgView.sd_setImage(with: URL.init(string: url), placeholderImage:holder , options: SDWebImageOptions.retryFailed) { (image, error,  SDImageCacheTypeNone, url) in
            
            if error != nil {
                debugPrint("\(String(describing: error?.localizedDescription))")
                return;
            }
        }
        
        url = mod.iconImg ?? ""
        iconImgView.sd_setImage(with: URL.init(string: url), placeholderImage:holder , options: SDWebImageOptions.retryFailed) { (image, error,  SDImageCacheTypeNone, url) in
            
        }
        
        titleLabel.text = mod.title;
        contentLabel.text = mod.content;
        currencyLabel.text = mod.currency;
        updateUI(mod);

        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
    public func fillCellWithDict(dict:Any!,row:NSInteger,delegate:CommonDelegate?) -> Void {
        
        fillCellWithDict(dict: dict, row: row, delegate: delegate, bLast: false)
    }
    
    public func fillCellWithDict(dict:Any!,row:NSInteger,delegate:CommonDelegate?,bLast:Bool) -> Void {
        
        _dict = dict;
        _delegate = delegate;
        
        let d = dict as! Dictionary<String,String>;
        
        let  title = d["title"]
        titleLabel.text = title;
        
        let icon = d["icon"];
        headImgView.image = UIImage.init(named:icon!);
        
        lineImgView.isHidden = bLast;
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
    
//    空投目录getProjectList：字段状态解释：
//    IsTop：是否置顶
//    IsHot：显示IsHot
//    Status：1:init, 3:on going, 6:stop，默认都是on going
//    EndDate：小于当前时间显示Expired
//    ObtainStatus：0未完成,1:完成但不可领取,2:完成可领取,3:Obtained,4:,5:,6:withdrawing,7:,8:failure,9:completed
    func updateUI(_ m:BoxListModel?) {
        
        if m == nil {
            return;
        }
        
        let mod:BoxListModel! = m;
        if mod.bExpired() == true {
            
            hotLabel.textColor = Const.color.kAPPDefaultGrayColor;
            coverImgView.isHidden = false;
            hotLabel.text =  mod.statusText();
            arrowImgView.isHidden = true;
            
        }else if mod.isHotValue() == true {
            
            hotLabel.textColor = Const.color.kAPPDefaultRedColor;
            coverImgView.isHidden = true;
            hotLabel.text = mod.hotText();
            arrowImgView.isHidden = false;
            
        }else if mod.isOngoing() == true {
            
            hotLabel.textColor = ZYUtilsSW.getColor(hexColor: "196BD8");
            coverImgView.isHidden = true;
            hotLabel.text = mod.statusText();
            arrowImgView.isHidden = false;
            
        }else if mod.isObtained() == true {
            
            hotLabel.textColor = Const.color.kAPPDefaultBlackColor;
            coverImgView.isHidden = true;
            hotLabel.text = mod.statusText();
            arrowImgView.isHidden = false;
        }else{
            hotLabel.textColor = Const.color.kAPPDefaultBlackColor;
            coverImgView.isHidden = true;
            hotLabel.text = mod.statusText();
            arrowImgView.isHidden = false;
        }
    }

}
