//
//  BottleView.swift
//  SNSBasePro
//
//  Created by zhan zhong yi on 2017/9/12.
//  Copyright © 2017年 zhan zhong yi. All rights reserved.
//

import UIKit

class TextFooterView: UICollectionReusableView {
    
    enum FooterType:String {
        case text = "0" //文字
        case btn = "1" //按钮
        
        static func initMy(str:String!) -> FooterType {
            return FooterType.init(rawValue: str)!
        }
    }
    
    var type:FooterType! {
        get {
            return FooterType.init(rawValue: self.typeStr);
        }
        set {
            self.typeStr = newValue.rawValue;
        }
    }
    
    var typeStr:String! = TextFooterView.FooterType.text.rawValue;
    @IBOutlet weak var _imageView:UIImageView!;
    @IBOutlet weak var _tileLabel:UILabel!;
    @IBOutlet weak var _titleLastLabel:UILabel!
    @IBOutlet weak var _timeLabel:UILabel!
    @IBOutlet weak var lineImgView:UIImageView!
    weak var _delegate:CommonDelegate?;
    var _dict:Any?;
    var _mod:BoxDetailModel!;
    @IBOutlet weak var titleLabelHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopLayout: NSLayoutConstraint!
    @IBOutlet weak var titleBtn:UIButton!;
    @IBOutlet weak var titleBtnTopLayout: NSLayoutConstraint!
    @IBOutlet weak var titleBtnBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var titleBtnWidthLayout: NSLayoutConstraint!
    @IBOutlet weak var titleBtnWidthAspect: NSLayoutConstraint!
    @IBOutlet weak var bageLabel:UILabel!;
    @IBOutlet weak var airdropRuleLabel:UILabel!;
    @IBOutlet weak var lineAirdropRuleImgView:UIImageView!;
    @IBOutlet weak var pumCap: UIImageView!
    
    static let grayColor:UIColor! = ZYUtilsSW.getColor(hexColor: "9b9b9b")
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        _tileLabel.font = Const.font.kAPPFont30;
        _tileLabel.textColor = Const.color.kAPPDefaultBlackColor;
        
        _titleLastLabel.font = Const.font.DINProFontType(.medium, 15);
        _titleLastLabel.textColor = Const.color.kAPPDefaultBlackColor;
        
        _timeLabel.font = Const.font.DINProFontType(.medium, 15);
        _timeLabel.textColor = Const.color.kAPPDefaultGrayColor;
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
        
        airdropRuleLabel.font = Const.font.DINProFontType(.medium, 15);
        airdropRuleLabel.textColor = Const.color.kAPPDefaultBlackColor;
        lineAirdropRuleImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
        
        titleBtn.backgroundColor = Const.color.kAPPDefaultBlackColor;
        titleBtn.setTitleColor(Const.color.kAPPDefaultWhiteColor, for: UIControlState.normal);
        titleBtn.titleLabel?.font = Const.font.DINProFontType(.bold, 18);
        
        _tileLabel.isHidden = true;
        titleBtn.isHidden = true;
        
        bageLabel.backgroundColor = Const.color.kAPPDefaultRedColor;
        bageLabel.layer.cornerRadius = bageLabel.frame.size.height/2;
        bageLabel.layer.borderWidth = 4.0;
        bageLabel.layer.borderColor = Const.color.kAPPDefaultWhiteColor.cgColor;
        bageLabel.text = "4";
        bageLabel.textColor = Const.color.kAPPDefaultWhiteColor;
        
        _titleLastLabel.text = LocalizeEx("candy_lasting_time");
        _timeLabel.font = Const.font.DINProFontType(.medium, 15);
        airdropRuleLabel.text = LocalizeEx("candy_airdrop_rule");
    }
    
    
    //MARK -- common
    public func fillCellWithMod(mod:Any?,row:NSInteger,delegate:CommonDelegate?) -> Void {
        
        self.fillCellWithMod(mod: mod, row: row, delegate: delegate, type: TextFooterView.FooterType.text);
    }
    
    public func fillCellWithMod(mod:Any?,row:NSInteger,delegate:CommonDelegate?,type:FooterType) -> Void {
        
        _delegate = delegate;
        self.type = type;
        
        guard let infoMod = mod as? BoxDetailModel else{
            print("error! 不是InfoModel");
            return;
        }
        
        _mod = infoMod;
        let str = infoMod.title;
        if(self.type == FooterType.btn){
            
            if _tileLabel == nil  {
                return;
            }
            
            _tileLabel.isHidden = true;
            titleBtn.isHidden = false;
            titleBtn.setTitle(str, for: UIControlState.normal);
            
            if infoMod.dispStatus == 1 {
                titleBtn.isHidden = false;
                titleBtn.backgroundColor = Const.color.kAPPDefaultBlackColor
                let title = btnTitle(infoMod)
                titleBtn.setTitle(title, for: UIControlState.normal)
                titleBtn.isUserInteractionEnabled = true;

            }else if infoMod.dispStatus == 2 {
                titleBtn.isHidden = false;
                titleBtn.backgroundColor = TextFooterView.grayColor
                let title = LocalizeEx("candy_coming_tomorrow")
                titleBtn.setTitle(title, for: UIControlState.normal)
                titleBtn.isUserInteractionEnabled = false;
                
            }else if infoMod.dispStatus == 3 {
                titleBtn.isHidden = false;
                titleBtn.backgroundColor = TextFooterView.grayColor
                let title = LocalizeEx("candy_event_over")
                titleBtn.setTitle(title, for: UIControlState.normal)
                titleBtn.isUserInteractionEnabled = false
                
            }else if infoMod.dispStatus == 4 {
                titleBtn.isHidden = false;
                titleBtn.backgroundColor = TextFooterView.grayColor
                let title = LocalizeEx("candy_event_obtained")
                titleBtn.setTitle(title, for: UIControlState.normal)
                titleBtn.isUserInteractionEnabled = false
            }else if infoMod.dispStatus == 5 {
                titleBtn.isHidden = false;
                titleBtn.backgroundColor = TextFooterView.grayColor
//                let image = ZYUtilsSW.imageFromColor(TextFooterView.grayColor)
//                titleBtn.setBackgroundImage(image, for: UIControlState.disabled)
                let title = btnTitle(infoMod)
                titleBtn.setTitle(title, for: UIControlState.normal)
                titleBtn.isUserInteractionEnabled = false;

            }else {
                titleBtn.isHidden = true
            }
            _timeLabel.text = self.lastTitle(infoMod)
            
            pumCap.sd_setImage(with: URL.init(string: infoMod.logo2 ?? ""), placeholderImage:UIImage.init() , options: SDWebImageOptions.retryFailed) { (image, error,  SDImageCacheTypeNone, url) in
                
            }
        }else {
            
            if titleBtn == nil {
                return;
            }
            
            _tileLabel.text = str;
            _tileLabel.isHidden = false;
            titleBtn.isHidden = true;
            titleBtn.removeFromSuperview();
            titleLabelTopLayout.constant = 6;
            titleLabelHeightLayout.constant = 30;
        }
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
    public func fillCellWithDict(dict:Any,row:NSInteger,delegate:CommonDelegate?) -> Void {
        
        _dict = dict;
        _delegate = delegate;
        
        guard  let d = dict as? Dictionary<String,String> else {
            print("error: %@ is nil",dict);
            return;
        }
        
        if(self.type == FooterType.btn){
            
            let  title = d["title"]
            titleBtn.setTitle(title, for: UIControlState.normal);
            
        }else {
            
            let  title = d["title"]
            _tileLabel.text = title;
            _tileLabel.sizeToFit();
        }

        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
//    //是否可用
//    public func bCanGetCoins(_ mod:BoxDetailModel) -> Bool {
//        return true;
//        if mod.status ==  1 && mod.obtain == 2 {
//            return true;
//        }
//
//        return false;
//    }
//
//    //今日是否obtain过
//    public func bObtained(_ mod:BoxDetailModel) -> Bool {
//
//        if mod.status! == 2 && mod.obtain! >= 3 {
//            return true;
//        }
//
//        return false;
//    }

    func btnTitle(_ mod:BoxDetailModel?) -> String {
        
        if mod == nil {
            return "";
        }
        if Common.isStringEmpty(mod?.logo2) {
            let str = LocalizeEx("candy_get");
            let name = mod!.tokenName ?? ""
            let amout = mod!.onceAmount ?? ""
            return str + " " + amout + " " + name;
        }else{
            
            let str = LocalizeEx("candy_get");
            let name = mod!.tokenName ?? ""
            return str + " " + name;
        }
        
    }
    
    func lastTitle(_ mod:BoxDetailModel) -> String {
        
        if mod.startDate == nil || mod.endDate == nil {
            return "";
        }
        
        let start = mod.startDate;
        let end = mod.endDate;
        let s = ZYUtilsSW.timeByTimeStampInter(TimeInterval(start!), "yyyy.MM.dd") + "-" + ZYUtilsSW.timeByTimeStampInter(TimeInterval(end!), "yyyy.MM.dd")
        return s;
    }
    
    //MARK: clicked
    @IBAction func btnClicked(sender:Any){
        
        self._delegate?.cdBottomBtnClicked?(sender)
    }
    
    @IBAction func rightArrowClicked(_ sender:UIButton) {
        _delegate?.cdRightArrowExClicked?(_mod!);
    }

}
