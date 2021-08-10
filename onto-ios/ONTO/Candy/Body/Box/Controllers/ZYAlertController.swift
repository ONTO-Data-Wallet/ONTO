//
//  ZYAlertController.swift
//  ONTO
//
//  Created by zhan zhong yi on 2018/8/25.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class ZYAlertController: ZYBlackTransParentController {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var myOkBtn:UIButton!
    var completionHandler:SFRequestCommonBlock?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.UISet()
        self.showAlert(title: "Congratulations", message: "", cancelBtn: "", okBtn: "OK") { (bSuccess, callBacks) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - common
    func UISet() {
        
        titleLabel.font = Const.font.DINProFontType(.bold, 14);
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        contentLabel.font = Const.font.DINProFontType(.medium, 14);
        contentLabel.textColor = Const.color.kAPPDefaultGrayColor;
        contentLabel.numberOfLines = 0
        
        myOkBtn.titleLabel?.font = Const.font.DINProFontType(.bold, 18);
        myOkBtn.setTitleColor(Const.color.kAPPDefaultBlackColor, for: UIControlState.normal)
        myOkBtn.setNeedsDisplay()
        
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
    }
    

     func showAlert(title:String!,message:String!,cancelBtn:String!,okBtn:String?, handler:SFRequestCommonBlock!) -> Void {
        
        let attributesBlack = [NSAttributedStringKey.font: Const.font.DINProFontType(.medium, 14),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultBlackColor] as [NSAttributedStringKey : Any];
        let attributesRed  =  [NSAttributedStringKey.font: Const.font.kAPPFont30,NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultRedColor];
        let attributesGray  =  [NSAttributedStringKey.font: Const.font.DINProFontType(.medium, 14),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultGrayColor] as [NSAttributedStringKey : Any];

        let attrTitle = NSMutableAttributedString(string:LocalizeEx("candy_congratulations") + "!", attributes: attributesBlack)
        let attrText = NSMutableAttributedString(string:LocalizeEx("candy_got_title"), attributes: attributesGray)
        var part = NSMutableAttributedString(string:"500 NEO", attributes: attributesRed)
        attrText.append(part);
        part = NSMutableAttributedString(string:" from XXX project", attributes: attributesGray)
        attrText.append(part);

        titleLabel.attributedText = attrTitle;
        contentLabel.attributedText = attrText;
        completionHandler = handler
        myOkBtn.setTitle(okBtn, for: UIControlState.normal)
    }
    
    func showAlert(titleAttr:NSMutableAttributedString!,messageAttr:NSMutableAttributedString!,cancelBtn:String?,okBtn:String?,handler:SFRequestCommonBlock!) -> Void {
        
        titleLabel.attributedText = titleAttr;
        contentLabel.attributedText = messageAttr;
        completionHandler = handler
        myOkBtn.setTitle(okBtn, for: UIControlState.normal)
    }
    
    //MARK: - clicked
    @IBAction func okBtnClicked(_ sender: Any) {
        self.dismiss(animated: false) {
            if self.completionHandler != nil {
                self.completionHandler!(true,nil)
            }
        }
    }

}
