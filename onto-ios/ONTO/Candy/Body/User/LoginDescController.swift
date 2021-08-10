//
//  DescController.swift
//  ONTO
//
//  Created by zhan zhong yi on 2018/8/25.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class LoginDescController: ZYSWController {
    
    @IBOutlet weak var textView:UITextView!;
     @IBOutlet weak var myOkBtn:UIButton!
    @IBOutlet weak var headImgView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!;
    @IBOutlet weak var contentLabel:UILabel!;
    var completionHandler:SFRequestCommonBlock?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.UISet();
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
        self.title = ""
        textView.font = Const.font.DINProFontType(.medium, 15);
        textView.textColor = Const.color.kAPPDefaultBlackColor;
        textView.isEditable = false
        textView.backgroundColor = UIColor.clear
        textView.text = LocalizeEx("candy_login_desc")
        
        headImgView.image = #imageLiteral(resourceName: "candy_user_head")
        titleLabel.font = Const.font.DINProFontType(.medium, 15);
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        titleLabel.text = ZYUtilsSW.getOntName()
        
        contentLabel.font = Const.font.DINProFontType(.medium, 15);
        contentLabel.textColor = Const.color.kAPPDefaultGrayColor;

        let attributesBlack = [NSAttributedStringKey.font: Const.font.DINProFontType(.black, 15),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultBlackColor] as [NSAttributedStringKey : Any];
        let attributesGray  =  [NSAttributedStringKey.font: Const.font.DINProFontType(.medium, 15),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultGrayColor] as [NSAttributedStringKey : Any];
        
        let attrTitle = NSMutableAttributedString(string:LocalizeEx("related_ont_id") + " ", attributes: attributesGray)
        let name = ZYUtilsSW.getOntId()
        //name.hiddenString(28, offset: 2)
        var  num = 28;
        if Const.SCREEN_WIDTH < 375 {
            num = 24;
        }
        let part = NSMutableAttributedString(string:name.replaceOnt(num, 2), attributes: attributesBlack)
        attrTitle.append(part);
        contentLabel.attributedText = attrTitle;
        
        myOkBtn.backgroundColor = Const.color.kAPPDefaultBlackColor;
        myOkBtn.titleLabel?.font = Const.font.DINProFontType(.bold, 18);
        myOkBtn.setTitleColor(Const.color.kAPPDefaultWhiteColor, for: UIControlState.normal)
        myOkBtn.setTitle(LocalizeEx("enter"), for: UIControlState.normal)
        myOkBtn.setNeedsDisplay()
    }
    

    @IBAction func nextClicked() {
        
//        if LoginCenter.shared().bNeedLogin() == false {
//            let cv = AccountController()
//            cv.bShowBack = true;
//            self.navigationController?.pushViewController(cv, animated: true);
//            return;
//        }
        LoginCenter.shared().login(baseController: self) { (bSuccess, callBacks) in
            //self.presentingViewController?.dismiss(animated: false, completion: nil)
            self.completionHandler!(bSuccess,callBacks)
        }
    }
    
    override func backClicked(sender: Any) {
        let d = ["bBack":"1"]
        self.completionHandler!(false,d)
        self.dismiss(animated: true, completion: nil)
    }

}
