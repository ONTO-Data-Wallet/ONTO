//
//  AuthStatusViewController.swift
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
class AuthStatusViewController: BaseViewController {

    @objc var stauts:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        createNav()
        createUI()
        
    }
    
    func createUI() {
        
        let titleLB = UILabel.init()
        if stauts {
            titleLB.text = LocalizeEx("AUTHORIZATIONSUCCESS")
        }else{
            titleLB.text = LocalizeEx("AUTHORIZATIONFAILED")
        }
        titleLB.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLB.changeSpace(0, wordSpace: 1)
        titleLB.textAlignment = .center
        view.addSubview(titleLB)
        
        let statusImage = UIImageView.init()
        if stauts {
            statusImage.image = UIImage(named: "AuthSuccess")
        }else{
            statusImage.image = UIImage(named: "AuthFail")
        }
        view.addSubview(statusImage)
        
        let infoLB = UILabel.init()
        infoLB.text = LocalizeEx("AuthInfo")
        infoLB.numberOfLines = 0
        infoLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        infoLB.changeSpace(2, wordSpace: 1)
        infoLB.textAlignment = .left
        view.addSubview(infoLB)
        
        let btn = UIButton.init()
        if stauts {
            btn.setTitle(LocalizeEx("OK"), for: .normal)
        }else{
            btn.setTitle(LocalizeEx("TRYAGAIN"), for: .normal)
        }
        btn.backgroundColor = UIColor.black
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.titleLabel?.changeSpace(0, wordSpace: 3)
        btn.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(btn)
        
        titleLB.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
            make?.top.equalTo()(view)?.offset()(15*SCALE_W)
        }
        
        statusImage.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(view)
            make?.width.height()?.equalTo()(200*SCALE_W)
            make?.top.equalTo()(titleLB.mas_bottom)?.offset()(30*SCALE_W)
        }
        
        infoLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(38*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-38*SCALE_W)
            make?.top.equalTo()(statusImage.mas_bottom)?.offset()(40*SCALE_W)
        }
        
        btn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            if UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W - 34)
            }else{
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W )
            }
        }
    }
    func createNav() {
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        
        let buttonSize = getSize(str:LocalizeEx("RECORD"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 12, weight: .bold), lineSpace: 0, wordSpace: 0)
        let navbutton = UIButton(frame: CGRect(x: 0, y: LL_StatusBarHeight + 15, width: Int(buttonSize.width)+2, height: 28))
        navbutton.setTitle(LocalizeEx("RECORD"), for: .normal)
        navbutton.setTitleColor(UIColor.black, for: .normal)
        navbutton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        let rightItem = UIBarButtonItem.init(customView: navbutton)
        //UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:navbutton];
        self.navigationItem.rightBarButtonItem = rightItem;
        navbutton.handleControlEvent(.touchUpInside) {
            let vc = COTAuthListViewController()
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
}
