//
//  BoxListDetailMissionItemCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/24.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class BoxListDetailMissionItemCLCell: BaseSWCLCell {
    
    @IBOutlet weak var imgView:UIImageView!;
    @IBOutlet weak var iconImgView:UIImageView!;
    @IBOutlet weak var titleLabel:UILabel!;
    public weak var _delegate:CommonDelegate?;
    var _mod:BoxListDetailMissionItemModel?;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = ZYUtilsSW.getColor(hexColor: "FAFAFC")
        
        titleLabel.font = Const.font.DINProFontType(.medium, 14);
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
    }

    //MARK: - common
    public func fillCellWithMod(mod:BoxListDetailMissionItemModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {
        
        _delegate = delegate;
        _mod = mod;
        
        var name = "";
        if mod.bOk == "1"{
            name = self.getImageByMission(mod)
            iconImgView.isHidden = false
            titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        }else {
            name = self.getImageByMission(mod)
            iconImgView.isHidden = true
            titleLabel.textColor = Const.color.kAPPDefaultGrayColor
        }
        let image:UIImage = UIImage.init(named: name)!;
        imgView.image = image;
        
        titleLabel.text = mod.title;
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
    func getImageByMission(_ mod:BoxListDetailMissionItemModel) -> String {
        
        if mod.missionCode == "ontcount_op" {
            return "candy_mission_icon_ont"
        }else if mod.missionCode == "kyc_certification" {
            return "candy_mission_icon_kyc"
        }else if mod.missionCode == "join_telegram" {
            
            return "candy_mission_icon_telegram"
        }else {
            
            //默认ont吧
            return "candy_mission_icon_ont"
        }
    }
}
