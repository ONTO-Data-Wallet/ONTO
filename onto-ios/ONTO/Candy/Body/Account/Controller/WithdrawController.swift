//
//  WithdrawController.swift
//  ONTO
//
//  Created by zhan zhong yi on 2018/8/25.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class WithdrawController: ZYBlackTransParentController {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var myOkBtn:UIButton!
    var completionHandler:SFRequestCommonBlock?
    var _modBalance:ACBalanceItemModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.UISet()
        self.showAlert(title: "", message: "", cancelBtn: "", okBtn: LocalizeEx("candy_get_cert")) { (bSuccess, callBacks) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true;
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
        
        titleLabel.font = Const.font.DINProFontType(.bold, 15);
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        contentLabel.font = Const.font.DINProFontType(.bold, 15);
        contentLabel.textColor = Const.color.kAPPDefaultBlackColor;
        contentLabel.numberOfLines = 0
        
        myOkBtn.backgroundColor = Const.color.kAPPDefaultBlackColor;
        myOkBtn.titleLabel?.font = Const.font.DINProFontType(.bold, 18);
        myOkBtn.setTitleColor(Const.color.kAPPDefaultWhiteColor, for: UIControlState.normal)
        myOkBtn.setNeedsDisplay();
        
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
    }
    
    
     func showAlert(title:String!,message:String!,cancelBtn:String!,okBtn:String?, handler:SFRequestCommonBlock!) -> Void {
        
        let black = [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 18),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultBlackColor] as [NSAttributedStringKey : Any];
        let black93 = [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 15),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultBlackColor] as [NSAttributedStringKey : Any];
        let gray  =  [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 18),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultGrayColor] as [NSAttributedStringKey : Any];

        let attrTitle = NSMutableAttributedString.init(string: LocalizeEx("withdraw"), attributes: gray)
        let part =  NSMutableAttributedString.init(string: " \(_modBalance.title!) ", attributes: black)
        attrTitle.append(part)
        titleLabel.attributedText = attrTitle;
        
        let attrText = NSMutableAttributedString.init(string: LocalizeEx("cert_desc"), attributes: black93)
        contentLabel.attributedText = attrText;
        completionHandler = handler
        myOkBtn.setTitle(okBtn, for: UIControlState.normal)
    }
    
    //MARK: - clicked
    @IBAction func okBtnClicked(_ sender: Any) {
        self.dismiss(animated: false) {
            self.navigationController?.popToRootViewController(animated: true)
            CommonOCAdapter.share().setTabIndex(IDViewController.className())
        }
    }

}
