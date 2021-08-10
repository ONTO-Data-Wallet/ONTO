//
//  NewOntImportViewController.swift
//  ONTO
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
class NewOntImportViewController: BaseViewController,UITextFieldDelegate,UITextViewDelegate {
    
//    @objc var isIdentity:Bool = false
    var mytextView: UITextView!
    var passwordF:  UITextField!
    var comfirmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        createNav()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent  = false
        
        //输入框输入内容返回内容被清空-bug
//        let str = UserDefaults.standard.value(forKey: "box") ?? ""
//        print("boxStr\(str)")
//        mytextView.text = str as? String
    }
    func createNav() {
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        self.setNavTitle(loacalkey(key: "ONTIDIMPORT"))
        self.navigationController?.navigationBar.titleTextAttributes = {[NSAttributedStringKey.foregroundColor : UIColor.black,
                                                                         NSAttributedStringKey.font : UIFont.systemFont(ofSize: 21, weight: .bold),
                                                                         NSAttributedStringKey.kern: 2]}()
    }
    
    func createUI() {
        let topLabel = UILabel.init()
        topLabel.text = loacalkey(key: "keystoreImport")
        topLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        topLabel.changeSpace(0, wordSpace: 1)
        topLabel.textAlignment = .left
        view.addSubview(topLabel)
        
        mytextView = UITextView.init()
        mytextView.backgroundColor = UIColor(hexString: "#F6F8F9")
        mytextView.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        mytextView.placeholderLabel.text = loacalkey(key: "Enterkeystore")
        view.addSubview(mytextView)
        
        let whatBtn = UIButton.init()
        whatBtn.setImage(UIImage(named: "cotlink"), for: .normal)
        whatBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        whatBtn.setTitleColor(UIColor(hexString: "#216ed5"), for: .normal)
        whatBtn.setTitle("  \(loacalkey(key: "Whatkeystore"))", for: .normal)
        view.addSubview(whatBtn)
        
        whatBtn.handleControlEvent(.touchUpInside) {
            let vc = WebIdentityViewController()
            if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
                vc.introduce = "https://info.onto.app/#/detail/18"
            }else{
                vc.introduce =  "https://info.onto.app/#/detail/3"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let passwordLB = UILabel.init()
        passwordLB.text = loacalkey(key: "passwordLB")
        passwordLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        passwordLB.changeSpace(0, wordSpace: 1)
        view.addSubview(passwordLB)
        
        passwordF = UITextField.init()
        passwordF.placeholder = loacalkey(key:  "passwordLBText")
        passwordF.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        passwordF.isSecureTextEntry = true
        passwordF.keyboardType = .numberPad
        passwordF.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        view.addSubview(passwordF)
        
        
        let line = UIView.init()
        line.backgroundColor = UIColor(hexString: "#E9EDEF")
        view.addSubview(line)
        
        let checkBox = UIButton.init()
        checkBox.setEnlargeEdge(20)
        checkBox.setImage(UIImage(named: "cotbigunselect"), for: .normal)
        checkBox.setImage(UIImage(named: "cotIcon_Selected-big"), for: .selected)
        view.addSubview(checkBox)
        
        let attributedString = NSMutableAttributedString.init(string: loacalkey(key: "LoginService"))
        if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
            attributedString.addAttribute(NSAttributedStringKey.link, value: "zhifubao://", range:NSMakeRange(13, 16) )
            attributedString.addAttribute(NSAttributedStringKey.link, value: "weixin://", range: NSMakeRange(34, 14))
        }else{
            attributedString.addAttribute(NSAttributedStringKey.link, value: "zhifubao://", range:NSMakeRange(7, 4) )
            attributedString.addAttribute(NSAttributedStringKey.link, value: "weixin://", range: NSMakeRange(12, 4))
        }
        
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12, weight: .medium), range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedStringKey.kern, value: 1, range: NSMakeRange(0, attributedString.length))
        
        let textview = UITextView.init()
        textview.delegate = self
        textview.attributedText = attributedString
        textview.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue :UIColor(hexString: "#216ed5") as Any,
                                       NSAttributedStringKey.underlineColor.rawValue: UIColor(hexString: "#216ed5") as Any,
                                       NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.patternSolid.rawValue]
        
        textview.isEditable = false
        textview.isScrollEnabled = false
        view.addSubview(textview)
        
        
        let importBtn = UIButton.init()
        importBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        importBtn.setTitle(loacalkey(key: "IMPORTFROMDROPBOX"), for: .normal)
        importBtn.titleLabel?.changeSpace(0, wordSpace: 3*SCALE_W)
        importBtn.setTitleColor(UIColor(hexString: "#216ed5"), for: .normal) // 9b9b9b   216ed5
        view.addSubview(importBtn)
        
        comfirmBtn = UIButton.init()
        comfirmBtn.isUserInteractionEnabled = false
        comfirmBtn.backgroundColor = UIColor(hexString: "#9b9b9b")
        comfirmBtn.setTitleColor(UIColor.white, for: .normal)
        comfirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        comfirmBtn.setTitle(loacalkey(key: "BoxIMPORT"), for: .normal)
        comfirmBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        comfirmBtn.addTarget(self, action: #selector(comfirmClick), for: .touchUpInside)
        view.addSubview(comfirmBtn)
        
        topLabel.mas_makeConstraints { (make) in
            make?.left.top().equalTo()(view)?.offset()(20*SCALE_W)
        }
        
        mytextView.mas_makeConstraints { (make) in
            make?.left?.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(topLabel.mas_bottom)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.height.equalTo()(160*SCALE_W)
        }
        
        whatBtn.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
            make?.top.equalTo()(mytextView.mas_bottom)?.offset()(20*SCALE_W)
            make?.height.equalTo()(20*SCALE_W)
        }
        
        passwordLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(whatBtn.mas_bottom)?.offset()(30*SCALE_W)
        }
        
        passwordF.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(passwordLB.mas_bottom)?.offset()(5*SCALE_W)
            make?.height.equalTo()(30*SCALE_W)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(passwordF.mas_bottom)?.offset()(5*SCALE_W)
            make?.height.equalTo()(1)
        }
        
        checkBox.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(line.mas_bottom)?.offset()(22*SCALE_W)
            make?.width.equalTo()(28.5*SCALE_W)
            make?.height.equalTo()(22*SCALE_W)
        }
        
        textview.mas_makeConstraints { (make) in
            make?.left.equalTo()(checkBox.mas_right)?.offset()(10*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(line.mas_bottom)?.offset()(15*SCALE_W)
        }
        
        comfirmBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            if UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W - 34)
            }else{
               make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W)
            }
        }
        
        importBtn.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
            make?.bottom.equalTo()(comfirmBtn.mas_top)?.offset()(-25*SCALE_W)
        }
        
        checkBox.handleControlEvent(.touchUpInside) {
            
            checkBox.isSelected = !checkBox.isSelected;
            if (checkBox.isSelected) {
                self.comfirmBtn.isUserInteractionEnabled = true;
                self.comfirmBtn.backgroundColor = UIColor.black

            } else {
                self.comfirmBtn.isUserInteractionEnabled = false;
                self.comfirmBtn.backgroundColor = UIColor(hexString: "#9b9b9b")

            }
        }
        importBtn.handleControlEvent(.touchUpInside) {
            UserDefaults.standard.set("", forKey: "box")
            let vc = BoxLoginViewController()
            vc.type = "output"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @objc private func comfirmClick(){
        let str = self.mytextView.text! as NSString
        if str.length <= 0 {
            let pop = MGPopController.init(title: loacalkey(key: "SelectAlertPassWord1"), message: nil, image: nil)
            let action = MGPopAction.init(title:  self.loacalkey(key: "OK")) {
            }
            action?.titleColor = UIColor(hexString:"#32A4BE")
            pop?.add(action)
            pop?.showCloseButton = false
            pop?.show()
            return;
        }
        if  (passwordF.text! as NSString).length < 6 {
            let pop = MGPopController.init(title: loacalkey(key: "SelectAlertPassWord1"), message: nil, image: nil)
            let action = MGPopAction.init(title:  self.loacalkey(key: "OK")) {
            }
            action?.titleColor = UIColor(hexString:"#32A4BE")
            pop?.add(action)
            pop?.showCloseButton = false
            pop?.show()
            return;
        }
        
        loadJS()
    }
    func loadJS()  {
        let v = WebJsView.init(idetity: true, textViewText: mytextView.text, pwd: passwordF.text)
        v?.callback = { string  in
            self.importSuccess()
        }
        view.addSubview(v!)
    }
    func importSuccess() {
        let successV = COTAlertV(title: self.loacalkey(key: "Importsuccessfully"), imageString: "boxImportS", buttonString: self.loacalkey(key: "OK"))
        successV?.callback = { (backMsg) in
            let vc = ImportSuccessViewController.init(nibName: "ImportSuccessViewController", bundle: nil)
            vc.isWallect = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        successV?.show()
    }
    @objc private func textFieldDidChange(textField:UITextField)  {
        if (textField.text! as NSString).length > 6 {
            textField.text = (textField.text! as NSString).substring(to: 6)
        }
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if (URL.scheme?.hasPrefix("zhifubao"))! {
            let vc = WebIdentityViewController()
            vc.introduce = APPTERMS
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }else if (URL.scheme?.hasPrefix("weixin"))!{
            
            let vc = WebIdentityViewController()
            vc.introduce = APPPRIVACY
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        return true
        
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
    }
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        return bundle
        
    }


}
