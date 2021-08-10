//
//  NewMobileViewController.swift
//  ONTO
//
//  Created by Apple on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
class NewMobileViewController: BaseViewController,UITextFieldDelegate {
    
    var getBtn:UIButton!
    var codeLB:UILabel!
    var myphoneBtn = UIButton(type: .custom)
    var myphoneNumF = UITextField.init()
    var codeStr:NSString! = ""
    var reginStr:NSString! = ""
    @objc var claimContext:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("0", forKey: "mobile")
        createNav()
        createUI()
        // Do any additional setup after loading the view.
    }
    func createNav() {
        
        let titleSize = getSize(str: self.loacalkey(key: "NewMobile"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = self.loacalkey(key: "NewMobile")
        navTitle.textColor = UIColor.black
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 2)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
    }
    func createUI() {
        let imageV = UIImageView(frame: CGRect(x: SYSWidth/2 - 31*SCALE_W, y: 44*SCALE_W, width: 62*SCALE_W, height: 62*SCALE_W))
        imageV.image = UIImage(named: "newGroup")
        view.addSubview(imageV)
         //
        let mobileSize = getSize(str: self.loacalkey(key: "mobileInfo"), width: SYSWidth - 90*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
        let mobileStr = getAttrString(str: self.loacalkey(key: "mobileInfo"), width: SYSWidth - 90*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
        print(mobileSize)
        let mobileInfo = UILabel(frame: CGRect(x: 45*SCALE_W, y: 120*SCALE_W, width: SYSWidth - 90*SCALE_W, height: mobileSize.height))
        mobileInfo.textAlignment = .left
        mobileInfo.numberOfLines = 0
        mobileInfo.attributedText = mobileStr
        mobileInfo.textColor = UIColor.black
        view.addSubview(mobileInfo)
        
        codeLB = UILabel(frame: CGRect(x: 45*SCALE_W, y: 231*SCALE_W, width: 95*SCALE_W, height: 18*SCALE_W))
        view.addSubview(codeLB)
        codeLB.text = self.loacalkey(key: "newZoneCode")
        codeLB.textColor = UIColor(hexString:"#6E6F70")
        codeLB.font = UIFont.systemFont(ofSize: 12)
        codeLB.changeSpace(lineSpace: 0, wordSpace: 1*SCALE_W)
        codeLB.textAlignment = .left
        
        let phoneBtn = UIButton(frame: CGRect(x: 45*SCALE_W, y: 231*SCALE_W, width: 90*SCALE_W, height: 18*SCALE_W))
        self.view.addSubview(phoneBtn)
        phoneBtn.setEnlargeEdge(10)
        phoneBtn.addTarget(self, action: #selector(phoneNumClickAction), for: UIControlEvents.touchUpInside)
//        phoneBtn.setTitle(self.loacalkey(key: "newZoneCode"), for: .normal)
//        phoneBtn.titleLabel?.textAlignment = .left
//        phoneBtn.setTitleColor(UIColor(hexString:"#6E6F70"), for: .normal)
        self.myphoneBtn = phoneBtn
//        phoneBtn.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 1)
//        phoneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        let line = UIView(frame: CGRect(x: 45*SCALE_W, y: 254*SCALE_W, width: 105*SCALE_W, height: 0.5))
        line.backgroundColor = UIColor(hexString: "#DDDDDD")
        view.addSubview(line)
        
        let attributedString =  NSMutableAttributedString.init(string: self.loacalkey(key: "newPhone"), attributes: [ kCTKernAttributeName as NSAttributedStringKey : 1 , NSAttributedStringKey.foregroundColor : UIColor(hexString: "#6E6F70") as Any])
        let phoneNumberF = UITextField(frame: CGRect(x: 180*SCALE_W, y: 231*SCALE_W, width: SYSWidth - 210*SCALE_W, height: 18*SCALE_W))
        self.view.addSubview(phoneNumberF)
        phoneNumberF.attributedPlaceholder = attributedString
        phoneNumberF.keyboardType = .numberPad
        phoneNumberF.delegate = self
        phoneNumberF.font = UIFont.systemFont(ofSize: 12)
        self.myphoneNumF = phoneNumberF
        
        let line1 = UIView(frame: CGRect(x: 180*SCALE_W, y: 254*SCALE_W, width: SYSWidth - 210*SCALE_W, height: 0.5))
        line1.backgroundColor = UIColor(hexString: "#DDDDDD")
        view.addSubview(line1)
        
        let phoneimage = UIImageView.init()
        phoneimage.image = UIImage.init(named:"newRectangle")
        self.view.addSubview(phoneimage)
        phoneimage.mas_makeConstraints {(make) in
            make?.width.height().equalTo()(17*SCALE_W)
            make?.centerY.equalTo()(phoneBtn)?.offset()(0)
            make?.left.equalTo()(phoneBtn.mas_right)?.offset()(5*SCALE_W)
            
        }
        
        let whatBtn = UIButton(frame: CGRect(x: 0, y: 265*SCALE_W, width: SYSWidth, height: 17*SCALE_W))
        whatBtn.setEnlargeEdge(8)
        view.addSubview(whatBtn)
        whatBtn.setImage(UIImage(named: "IdHelp"), for: .normal)
        whatBtn.setTitle(self.loacalkey(key: "mobileSupport"), for: .normal)
        whatBtn.setTitleColor(UIColor(hexString: "#29A6FF"), for: .normal)
        whatBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        whatBtn.handleControlEvent(.touchUpInside) {
            let vc = WebIdentityViewController()
            if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
                vc.introduce = "https://info.onto.app/#/detail/71"
            }else{
                vc.introduce = "https://info.onto.app/#/detail/72"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        getBtn = UIButton(frame: CGRect(x: 58*SCALE_W, y: SYSHeight - 49 - 20  - 100*SCALE_W, width: SYSWidth - 116*SCALE_W, height: 60*SCALE_W))
        if UIDevice.current.isX() {
            getBtn.frame = CGRect(x: 58*SCALE_W, y: SYSHeight - 49 - 44  - 100*SCALE_W, width: SYSWidth - 116*SCALE_W, height: 60*SCALE_W)
        }
        getBtn.setTitle(loacalkey(key: "mobileNext"), for: .normal)
        getBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
        getBtn.isUserInteractionEnabled = false
        getBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        getBtn.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 3*SCALE_W)
        getBtn.setTitleColor(UIColor.white , for: .normal)
        view.addSubview(getBtn)
        getBtn.addTarget(self, action: #selector(toGetCert), for: .touchUpInside)
    }
    @objc func toGetCert() {

        
        if Common.checkPhone( self.myphoneNumF.text , regin: self.reginStr as String?){
            print("***")
            UserDefaults.standard.set("1", forKey: "mobile")
            let vc = MobileCodeViewController()
            vc.statusType = "mobile"
            vc.contentStr = self.myphoneNumF.text
            vc.contentStrLeft = self.codeStr as String?
            vc.nationStr = Common.getJsLocaleWithcode(self.codeStr as String?)
            vc.claimContext = self.claimContext
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print("---")
//            ToastUtil.shortToast(self.view, value:self.loacalkey(key: "mobileError") )
            Common.showToast(self.loacalkey(key: "mobileError"))
//
        }
    }
    @objc func phoneNumClickAction(button:UIButton) {
        
        
        let vc =  NewCountryCodeViewController()
        vc.returnCountryCodeReginBlock = { countryString , reginString in
            print("+++ \(String(describing: reginString))")
            self.codeStr = self.getIntFromString(str: countryString!) as NSString
            self.reginStr = reginString! as NSString
//            self.myphoneBtn.setTitle("+"+self.getIntFromString(str: countryString!), for: UIControlState.normal)
//            self.myphoneBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.codeLB.text = "+"+self.getIntFromString(str: countryString!)
            self.codeLB.changeSpace(lineSpace: 0, wordSpace: 1)
            self.codeLB.textColor = UIColor.black
            
            if (self.myphoneNumF.text! as NSString).length>0 {
                self.getBtn.backgroundColor = UIColor.black
                self.getBtn.isUserInteractionEnabled = true
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else{
                return true
            }
            let textLength = text.count + string.count - range.length
            if Common.validateNumber(string) == false{
                return false
            }
            return textLength<=20
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text! as NSString).length > 0 && codeStr.length > 0 {
            print("22222")
            getBtn.backgroundColor = UIColor.black
            getBtn.isUserInteractionEnabled = true
        }else{
            getBtn.isUserInteractionEnabled = false
            getBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
        }
    }
    // 从字符串中提取数字
    func getIntFromString(str:String) -> String {
        let scanner = Scanner(string: str)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number :Int = 0
        
        scanner.scanInt(&number)
        print(number)
        return String(number)
        
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
