//
//  NewEmailViewController.swift
//  ONTO
//
//  Created by Apple on 2018/8/24.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
class NewEmailViewController: BaseViewController,UITextFieldDelegate {

    var getBtn:UIButton!
    var myphoneBtn = UIButton(type: .custom)
    var myphoneNumF = UITextField.init()
    @objc var claimContext:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("0", forKey: "mobile")
        createNav()
        createUI()
        // Do any additional setup after loading the view.
    }
    func createNav() {
        let titleSize = getSize(str: self.loacalkey(key: "newEMAIL"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = self.loacalkey(key: "newEMAIL")
        navTitle.textColor = UIColor.black
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 2)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
    }
    func createUI() {
        let imageV = UIImageView(frame: CGRect(x: SYSWidth/2 - 31*SCALE_W, y: 44*SCALE_W, width: 62*SCALE_W, height: 62*SCALE_W))
        imageV.image = UIImage(named: "newGroup 2")
        view.addSubview(imageV)
        //
        let mobileSize = getSize(str: self.loacalkey(key: "emailSendInfo"), width: SYSWidth - 90*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
        let mobileStr = getAttrString(str: self.loacalkey(key: "emailSendInfo"), width: SYSWidth - 90*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
        print(mobileSize)
        let mobileInfo = UILabel(frame: CGRect(x: 45*SCALE_W, y: 120*SCALE_W, width: SYSWidth - 90*SCALE_W, height: mobileSize.height))
        mobileInfo.textAlignment = .left
        mobileInfo.numberOfLines = 0
        mobileInfo.attributedText = mobileStr
        mobileInfo.textColor = UIColor.black
        view.addSubview(mobileInfo)
        
        let attributedString =  NSMutableAttributedString.init(string: self.loacalkey(key: "YourEmail"), attributes: [ kCTKernAttributeName as NSAttributedStringKey : 1 , NSAttributedStringKey.foregroundColor : UIColor(hexString: "#6E6F70") as Any])
        let phoneNumberF = UITextField(frame: CGRect(x: 45*SCALE_W, y: 231*SCALE_W, width: SYSWidth - 90*SCALE_W, height: 18*SCALE_W))
        self.view.addSubview(phoneNumberF)
        phoneNumberF.attributedPlaceholder = attributedString
        phoneNumberF.keyboardType = .emailAddress
        phoneNumberF.delegate = self
        phoneNumberF.font = UIFont.systemFont(ofSize: 14)
        self.myphoneNumF = phoneNumberF
        
        let line1 = UIView(frame: CGRect(x: 45*SCALE_W, y: 254*SCALE_W, width: SYSWidth - 90*SCALE_W, height: 0.5))
        line1.backgroundColor = UIColor(hexString: "#DDDDDD")
        view.addSubview(line1)
        
        getBtn = UIButton(frame: CGRect(x: 58*SCALE_W, y: SYSHeight - 49 - 20  - 100*SCALE_W, width: SYSWidth - 116*SCALE_W, height: 60*SCALE_W))
        if UIDevice.current.isX() {
            getBtn.frame = CGRect(x: 58*SCALE_W, y: SYSHeight - 49 - 44  - 100*SCALE_W, width: SYSWidth - 116*SCALE_W, height: 60*SCALE_W)
        }
        getBtn.setTitle(loacalkey(key: "mobileNext"), for: .normal)
        getBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
        getBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        getBtn.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 3*SCALE_W)
        getBtn.setTitleColor(UIColor.white , for: .normal)
        view.addSubview(getBtn)
        getBtn.addTarget(self, action: #selector(toGetCert), for: .touchUpInside)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text! as NSString).length > 0  {
            getBtn.backgroundColor = UIColor.black
            getBtn.isUserInteractionEnabled = true
        }else{
            getBtn.isUserInteractionEnabled = false
            getBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
        }
    }
    @objc func toGetCert() {
        if Common.isValidateEmail(self.myphoneNumF.text)==false {
//            ToastUtil.shortToast(self.view, value:self.loacalkey(key: "IM_EnterEmail"))
            Common.showToast(self.loacalkey(key: "IM_EnterEmail"))
            return
        }
        UserDefaults.standard.set("1", forKey: "mobile")
        let vc = MobileCodeViewController()
        vc.claimContext = self.claimContext
        vc.statusType = "email"
        vc.contentStr = self.myphoneNumF.text
        self.navigationController?.pushViewController(vc, animated: true)
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
    public func getColorAttrString1(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat,defaultColor: UIColor,cColor: UIColor,cColorLocation:Int,cColorLength:Int) -> NSMutableAttributedString {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: font, range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttribute( kCTParagraphStyleAttributeName as NSAttributedStringKey , value: paragraphStyle, range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [ NSAttributedStringKey.foregroundColor : defaultColor], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttribute( NSAttributedStringKey.foregroundColor , value: cColor, range: NSRange(location:cColorLocation,length:cColorLength))
        return attributedString
    }
    public func getAttrString(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat) -> NSMutableAttributedString {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttributes([kCTFontAttributeName as NSAttributedStringKey : font], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [kCTParagraphStyleAttributeName as NSAttributedStringKey : paragraphStyle], range: .init(location: 0, length: ((str as NSString).length)))
        return attributedString
    }
    func appendColorStrWithString(str:String,font:CGFloat,color:UIColor) -> NSMutableAttributedString {
        var attributedString : NSMutableAttributedString
        let attStr = NSMutableAttributedString.init(string: str, attributes: [kCTFontAttributeName as NSAttributedStringKey : UIFont.systemFont(ofSize: font),kCTForegroundColorAttributeName as NSAttributedStringKey:color])
        attributedString = NSMutableAttributedString.init(attributedString: attStr)
        return attributedString
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

}
