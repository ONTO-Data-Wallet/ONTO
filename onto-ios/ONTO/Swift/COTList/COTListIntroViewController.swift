//
//  COTListIntroViewController.swift
//  ONTO
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
class COTListIntroViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createNav()
        createUI()
    }
    func createNav() {
        
        let titleSize = getSize(str: UserDefaults.standard.value(forKey: IDENTITY_NAME) as! String, width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = (UserDefaults.standard.value(forKey: IDENTITY_NAME) as! String)
        navTitle.textColor = UIColor.black
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 2)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
    }
    func createUI() {
        
        let  bgV = UIView.init()
        bgV.backgroundColor = UIColor(hexString: "#eaf7ff")
        view.addSubview(bgV)
        
        let image = UIImageView.init()
        image.image = UIImage(named: "ListOval")
        view.addSubview(image)
        
        let name = UILabel.init()
        name.text = (UserDefaults.standard.value(forKey: IDENTITY_NAME) as! String)
        name.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        name.changeSpace(0, wordSpace: 1)
        name.textAlignment = .left
        view.addSubview(name)
        
        let ontidLB = UILabel.init()
        ontidLB.text = LocalizeEx("ListOnt")
        ontidLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        ontidLB.textColor = UIColor(red: 110/255.0, green: 111/255.0, blue: 112/255.0, alpha: 1)
        ontidLB.changeSpace(0, wordSpace: 1)
        ontidLB.textAlignment = .left
        view.addSubview(ontidLB)
        
        let ontidLBD = UILabel.init()
        ontidLBD.numberOfLines = 0
        ontidLBD.text = (UserDefaults.standard.value(forKey: ONT_ID) as! String)
        ontidLBD.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        ontidLBD.textColor = UIColor.black
        ontidLBD.changeSpace(2, wordSpace: 1)
        ontidLBD.textAlignment = .left
        view.addSubview(ontidLBD)
        
        let copyBtn = UIButton.init()
        copyBtn.setImage(UIImage(named: "ListRectangle 12"), for: .normal)
        view.addSubview(copyBtn)
        
        let image1 = UIImageView.init()
        image1.image = UIImage(named: "ListRectangle 7")
        view.addSubview(image1)
        
        let authLB = UILabel.init()
        authLB.text = LocalizeEx("AUTHORIZATIONS")
        authLB.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        authLB.changeSpace(0, wordSpace: 1)
        authLB.textAlignment = .left
        view.addSubview(authLB)
        
        let rightImage = UIImageView.init()
        rightImage.image = UIImage(named: "candy_right_arrow")
        view.addSubview(rightImage)
        
        let line = UIView.init()
        line.backgroundColor = Const.color.kAPPDefaultLineColor
        view.addSubview(line)
        
        let btn = UIButton.init()
        view.addSubview(btn)
        
        
        let image1_1 = UIImageView.init()
        image1_1.image = UIImage(named: "sfpInfo")
        view.addSubview(image1_1)
        
        let authLB_1 = UILabel.init()
        authLB_1.text = LocalizeEx("CERTIFICATIONS")
        authLB_1.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        authLB_1.changeSpace(0, wordSpace: 1)
        authLB_1.textAlignment = .left
        view.addSubview(authLB_1)
        
        let rightImage_1 = UIImageView.init()
        rightImage_1.image = UIImage(named: "candy_right_arrow")
        view.addSubview(rightImage_1)
        
        let line_1 = UIView.init()
        line_1.backgroundColor = Const.color.kAPPDefaultLineColor
        view.addSubview(line_1)
        
        let btn_1 = UIButton.init()
        view.addSubview(btn_1)
        
        bgV.mas_makeConstraints { (make) in
            make?.left.right()?.top()?.equalTo()(view)
            make?.height.equalTo()(130*SCALE_W)
        }
        
        image.mas_makeConstraints { (make) in
            make?.left.top()?.equalTo()(bgV)?.offset()(20*SCALE_W)
            make?.width.height()?.equalTo()(70*SCALE_W)
        }
        
        name.mas_makeConstraints { (make) in
            make?.left.equalTo()(image.mas_right)?.offset()(10*SCALE_W)
            make?.top.equalTo()(image)
        }
        
        ontidLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(name)
            make?.top.equalTo()(name.mas_bottom)?.offset()(15*SCALE_W)
        }
        
        ontidLBD.mas_makeConstraints { (make) in
            make?.left.equalTo()(name)
            make?.top.equalTo()(ontidLB.mas_bottom)?.offset()(2*SCALE_W)
            make?.right.equalTo()(bgV)?.offset()(-20*SCALE_W)
        }
        
        copyBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(bgV)?.offset()(35*SCALE_W)
            make?.right.equalTo()(bgV)?.offset()(-20*SCALE_W)
            make?.width.height()?.equalTo()(34*SCALE_W)
        }
        
        image1.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(bgV.mas_bottom)?.offset()(45*SCALE_W)
            make?.width.height()?.equalTo()(50*SCALE_W)
        }
        
        authLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(image1.mas_right)?.offset()(15*SCALE_W)
            make?.centerY.equalTo()(image1)
        }
        
        rightImage.mas_makeConstraints { (make) in
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.centerY.equalTo()(image1)
            make?.width.height()?.equalTo()(20*SCALE_W)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(image1.mas_bottom)?.offset()(10*SCALE_W)
            make?.height.equalTo()(0.5)
        }
        
        btn.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
            make?.top.equalTo()(bgV.mas_bottom)?.offset()(35*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
        }
        
        image1_1.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(line.mas_bottom)?.offset()(45*SCALE_W)
            make?.width.height()?.equalTo()(50*SCALE_W)
        }
        
        authLB_1.mas_makeConstraints { (make) in
            make?.left.equalTo()(image1_1.mas_right)?.offset()(15*SCALE_W)
            make?.centerY.equalTo()(image1_1)
        }
        
        rightImage_1.mas_makeConstraints { (make) in
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.centerY.equalTo()(image1_1)
            make?.width.height()?.equalTo()(20*SCALE_W)
        }
        
        line_1.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(image1_1.mas_bottom)?.offset()(10*SCALE_W)
            make?.height.equalTo()(0.5)
        }
        
        btn_1.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
            make?.top.equalTo()(line.mas_bottom)?.offset()(35*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
        }
        
        copyBtn.handleControlEvent(.touchUpInside) {
            let pasteboard = UIPasteboard.general
            pasteboard.string = ontidLBD.text
            Common.showToast(LocalizeEx("OntidCopySuccess"))
        }
        btn.handleControlEvent(.touchUpInside) {
            let vc = COTAuthListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        btn_1.handleControlEvent(.touchUpInside) {
            let vc = ONTOAuthListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
        
        
    }
    public func getSize(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat) -> CGSize {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttributes([kCTFontAttributeName as NSAttributedStringKey : font], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [kCTParagraphStyleAttributeName as NSAttributedStringKey : paragraphStyle], range: .init(location: 0, length: ((str as NSString).length)))
        
        let attSize = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue))), context: nil).size  //NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
        return attSize
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
