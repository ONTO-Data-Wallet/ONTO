//
//  BoxListCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class ACRecordCLCell: BaseSWCLCell {
    
    @IBOutlet weak var headImgView:UIImageView!;
    @IBOutlet weak var iconImgView:UIImageView!;
    @IBOutlet weak var timeLabel:UILabel!;
    @IBOutlet weak var titleLabel:UILabel!;
    @IBOutlet weak var currencyLabel:UILabel!;
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var lineImgViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var statusLB: UILabel!
    public weak var _delegate:CommonDelegate?;
    var _dict:Any?;
    var _mod:ACRecordModel?;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white

        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        currencyLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        currencyLabel.textColor = Const.color.kAPPDefaultBlackColor;
        
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        timeLabel.textColor = Const.color.kAPPDefaultGrayColor;
        
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
        lineImgViewHeightLayout.constant = 0.5
    }

    //MARK -- common
    public func fillCellWithMod(mod:ACRecordModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {

        _delegate = delegate;
        _mod = mod;

        let holder = #imageLiteral(resourceName: "ongblue");
        let url = mod.headImg ?? ""
        headImgView.sd_setImage(with: URL.init(string: url), placeholderImage:holder , options: SDWebImageOptions.retryFailed) { (image, error,  SDImageCacheTypeNone, url) in
            
        }
        
        statusLB.textColor = checkColor(mod)
        statusLB.text = checkStatusText(mod)
        titleLabel.text = mod.title;
        currencyLabel.text = mod.currency;
        timeLabel.text = mod.time;

        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    func checkColor(_ mod:ACRecordModel) -> UIColor {
        guard  let bCheck = mod.status else {
            return UIColor(hexString: "#1B6DFF")!;
        }
        if bCheck == 3 {
            return UIColor(hexString: "#1B6DFF")!;
        }else if bCheck == 1 {
            return UIColor(hexString: "#fa4c4e")!;
        }
        
        return UIColor(hexString: "#1B6DFF")!;
    }
    func checkStatusText(_ mod:ACRecordModel) -> String {
        guard  let bCheck = mod.status else {
            return LocalizeEx("WalletManageSuccess");
        }
        if bCheck == 3 {
            return LocalizeEx("WalletManageSuccess");
        }else if bCheck == 2 {
            return LocalizeEx("CreateFailed");
        }else if bCheck == 1 {
            return LocalizeEx("WaitingFor");
        }
        
        return LocalizeEx("WalletManageSuccess");
    }
    func checkName(_ mod:ACRecordModel) -> UIImage {
        
        guard  let bCheck = mod.status else {
            return #imageLiteral(resourceName: "candy_record_failed");
        }
        
        if bCheck == 3 {
            return #imageLiteral(resourceName: "candy_record_check")
        }else if bCheck == 1 {
            return #imageLiteral(resourceName: "candy_record_pending");
        }
        
        return #imageLiteral(resourceName: "candy_record_failed")
    }
    
    func setCheckedLabel(_ m:ACRecordModel?) {
        
        if m == nil {
            return;
        }
        
        let mod:ACRecordModel! = m;
        if mod.hot == "HOT" {
           
        }else if mod.hot == "Ongoing" {
         
        }else {
           
        }
    }

}
