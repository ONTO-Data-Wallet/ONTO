//
//  MobileCodeViewController.swift
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
class MobileCodeViewController: BaseViewController {
    
    var statusType: String!
    var contentStr: String!
    var contentStrLeft: String!
    var nationStr: String!
    var isTrue: Bool = false
    
     @objc var claimContext:String!
    
    var codeButton:UIButton!
    var smstimer: Timer!
    var smstimer11: Timer!
    var num:Int = 0
    
    var textField:LKLPayCodeTextField!
    var lodingV:CheckView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.statusType as NSString) .isEqual(to: "mobile"){
            toSendMobileCode()
        }else{
            toSendEmailCode()
        }
        createNav()
        createUI()
        // Do any additional setup after loading the view.
    }
    func createNav() {
        let str:String
        if (self.statusType as NSString) .isEqual(to: "mobile"){
            str = self.loacalkey(key: "NewMobile")
        }else{
            str = self.loacalkey(key: "newEMAIL")
        }
        let titleSize = getSize(str: str, width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = str
        navTitle.textColor = UIColor.black
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 2)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
    }
    func createUI() {
        let lb1 = UILabel(frame: CGRect(x: 0, y: 23*SCALE_W, width: SYSWidth, height: 28))
        lb1.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        view.addSubview(lb1)
        
        let btn = UIButton(frame: CGRect(x: 0, y: 63*SCALE_W, width: SYSWidth, height: 22*SCALE_W))
        btn.setImage(UIImage(named: "Rectangle 9"), for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.addSubview(btn)
        
        var mobileSize : CGSize
        var mobileStr = NSMutableAttributedString.init()
        if (self.statusType as NSString) .isEqual(to: "mobile"){
            lb1.text = loacalkey(key: "VERIFYMOBILE")
            btn.setTitle("   +\(contentStrLeft ?? "") \(contentStr ?? "")", for: .normal)
            mobileSize = getSize(str: self.loacalkey(key: "mobileSendCode"), width: SYSWidth - 90*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
            mobileStr = getAttrString(str: self.loacalkey(key: "mobileSendCode"), width: SYSWidth - 90*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
        }else{
            lb1.text = loacalkey(key: "VERIFYEMAIL")
//
            btn.setImage(UIImage(named: "newRectangle9"), for: .normal)
            btn.setTitle("     \(contentStr!)", for: .normal)
            mobileSize = getSize(str: self.loacalkey(key: "emailSendCode"), width: SYSWidth - 90*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
            mobileStr = getAttrString(str: self.loacalkey(key: "emailSendCode"), width: SYSWidth - 90*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
        }
        lb1.changeSpace(lineSpace: 0, wordSpace: 3)
        lb1.textAlignment = .center
        btn.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 1.5*SCALE_W)

        let mobileInfo = UILabel(frame: CGRect(x: 45*SCALE_W, y: 103*SCALE_W, width: SYSWidth - 90*SCALE_W, height: mobileSize.height))
        mobileInfo.textAlignment = .left
        mobileInfo.numberOfLines = 0
        mobileInfo.attributedText = mobileStr
        mobileInfo.textColor = UIColor.black
        view.addSubview(mobileInfo)
        
        
        
        textField = LKLPayCodeTextField(frame: CGRect(x: 20*SCALE_W, y: 167*SCALE_W, width: SYSWidth - 40*SCALE_W, height: 40*SCALE_W))
        view.addSubview(textField)
        self.textField.isShowTrueCode = true
        self.textField.currentBlock = { (currentPayCodeString , currentInputString) in
        }
        
        self.textField.finishedBlock = { (payCodeString) in
            print("code \(String(describing: payCodeString))")
//            if (self.statusType as NSString) .isEqual(to: "mobile"){
                self.checkMobileCode(code: payCodeString!)
//            }else{
//
//            }
        }
        
        codeButton = UIButton(frame: CGRect(x: SYSWidth - 110*SCALE_W, y: 228*SCALE_W, width: 90*SCALE_W, height: 34*SCALE_W))
        codeButton.setTitle("60 \(loacalkey(key: "newSec"))", for: .normal)
        codeButton.setTitleColor(UIColor.white, for: .normal)
        codeButton.backgroundColor = UIColor(hexString: "#9B9B9B")
        codeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        codeButton.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 2*SCALE_W)
        codeButton.handleControlEvent(.touchUpInside) {
            self.textField.clearKeyCode()
            self.codeButton.backgroundColor = UIColor(hexString: "#9B9B9B")
            if (self.statusType as NSString) .isEqual(to: "mobile"){
                self.toSendMobileCode()
            }else{
                self.toSendEmailCode()
            }
            
        }
        view.addSubview(codeButton)
        
        let alertBtn = UIButton(frame: CGRect(x: 0, y: 277*SCALE_W, width: SYSWidth, height: 17*SCALE_W))
        alertBtn.setEnlargeEdge(17)
        alertBtn.setImage(UIImage(named: "cotlink"), for: .normal)
        alertBtn.setTitle(loacalkey(key: "verificationcode"), for: .normal)
        alertBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        alertBtn.setTitleColor(UIColor(hexString: "#216ed5"), for: .normal)
        view.addSubview(alertBtn)
        alertBtn.handleControlEvent(.touchUpInside) {
            let vc = WebIdentityViewController()
            if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
                vc.introduce = "https://info.onto.app/#/detail/69"
            }else{
                vc.introduce = "https://info.onto.app/#/detail/68"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func toSendMobileCode() {
        var NationStr: String
//        if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
//            NationStr = "EN"
//        }else{
//            NationStr = "CN"
//        }
        if (contentStrLeft as NSString).isEqual(to: "86"){
            NationStr = "CN"
        }else{
            NationStr = "EN"
        }
        let params = ["OwnerOntId":UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "",
                      "DeviceCode": UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? "" ,
            "PhoneNumber":"\(contentStrLeft!)*\(contentStr!)",
            "Nation":NationStr
        ];
        CCRequest .shareInstance().request(withURLString: MobileCodeSend, methodType: .POST, params: params, success: { (responseObject, responseOriginal) in
            
            if ((self.smstimer != nil) && self.smstimer.isValid){
                self.smstimer.invalidate()
            }
            self.num = 0
            self.smstimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkMobile), userInfo: nil, repeats: true)
            
        }) { (error, errorDesc, responseOriginal) in
            print("111")
//            self.codeButonStr()
            if ((self.smstimer != nil) && self.smstimer.isValid){
                self.smstimer.invalidate()
            }
            self.num = 0
            self.smstimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkMobile), userInfo: nil, repeats: true)
            
        }
    }
    @objc func checkMobile() {
        num += 1
        if num < 60 {
            codeButton.isUserInteractionEnabled = false
            codeButton.setTitle("\(60 - num) \(loacalkey(key: "newSec"))", for: .normal)
            codeButton.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 2*SCALE_W)
        }else{
            codeButonStr()
        }
        
    }
    func codeButonStr() {
        codeButton.isUserInteractionEnabled = true
        codeButton.setTitle(loacalkey(key: "newResend"), for: .normal)
        codeButton.backgroundColor = UIColor.black
        codeButton.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 2*SCALE_W)
        if ((self.smstimer != nil) && self.smstimer.isValid){
            self.smstimer.invalidate()
        }
        num = 0
    }
    func checkMobileCode(code:String) {
        var  str : String
        if (self.statusType as NSString) .isEqual(to: "mobile") {
            str = "\(MobileCodeCheck)?phonenumber=\(contentStrLeft!)*\(contentStr!)&code=\(code)"
        }else{
            str = "\(EmailCodeCheck)?email=\(contentStr!)&code=\(code)"
        }
        CCRequest.shareInstance().request(withURLString: str, methodType: .GET, params: nil, success: { (responseObject, responseOriginal) in
            print("\(String(describing: responseOriginal))")
            
            self.lodingV = CheckView(title: "", imageString: "", buttonString: "") //COTAlertV(title: self.loacalkey(key: "COTSucceed"), imageString: "cotsuccess", buttonString: self.loacalkey(key: "OK"))
            
            self.lodingV?.show()
            
            if ((self.smstimer11 != nil) && self.smstimer11.isValid){
                self.smstimer11.invalidate()
            }
            self.isTrue = false
            self.smstimer11 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkDetail), userInfo: nil, repeats: true)
            


        }) { (error, errorDesc, responseOriginal) in
//            self.codeButonStr()
            let pop = MGPopController.init(title:self.loacalkey(key: "codeError"), message: "", image:UIImage.init(named: ""))
            let action = MGPopAction.init(title:  self.loacalkey(key: "OK")) {
            }
            action?.titleColor = UIColor(hexString:"#32A4BE")
            pop?.add(action)
            pop?.showCloseButton = false
            pop?.show()
            return;
            
        }
    }
    @objc func checkDetail() {
        if self.isTrue == true {
            return
        }
        let params:NSDictionary? = ["OwnerOntId":UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "" ,
                                    "DeviceCode":UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? ""  ,
                                    "ClaimId": "" ,
                                    "ClaimContext":self.claimContext,
                                    "Status":"9"]
        
        CCRequest.shareInstance().request(withURLStringNoLoading: Claim_query, methodType: .POST, params: params,  success: { (responseObject, responseOriginal) in
            
//            [[DataBase sharedDataBase]
//                deleteCalim:[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID] andClaimContext:_claimContext];
            
            DataBase.shared().deleteCalim(UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "" , andClaimContext: self.claimContext)
            
            self.lodingV.dismiss()
            self.isTrue = true
            
            self.smstimer11.invalidate()
            let vc = NewClaimDetailViewController()
            vc.claimContext = self.claimContext
            vc.statusType = self.statusType
            vc.contentStr = self.contentStr
            if (self.statusType as NSString) .isEqual(to: "mobile"){
                vc.contentStrLeft = self.contentStrLeft
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
             //NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName.kKycOauthedOneSuccessed), object: nil);
            
        }) { (error, errorDesc, responseOriginal) in
            print("333")
        }
    }
    func toSendEmailCode() {
        var NationStr: String
        if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
            NationStr = "EN"
        }else{
            NationStr = "CN"
        }
        let params = ["OwnerOntId":UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "",
                      "DeviceCode": UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? "" ,
                      "Email":contentStr!,
                      "Nation":NationStr
        ];
        CCRequest .shareInstance().request(withURLString: EmailCodeSend, methodType: .POST, params: params, success: { (responseObject, responseOriginal) in
            
            if ((self.smstimer != nil) && self.smstimer.isValid){
                self.smstimer.invalidate()
            }
            self.num = 0
            self.smstimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkMobile), userInfo: nil, repeats: true)
            
        }) { (error, errorDesc, responseOriginal) in
            print("111")
//            self.codeButonStr()
            if ((self.smstimer != nil) && self.smstimer.isValid){
                self.smstimer.invalidate()
            }
            self.num = 0
            self.smstimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkMobile), userInfo: nil, repeats: true)
            
        }
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
