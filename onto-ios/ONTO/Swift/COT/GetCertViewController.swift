//
//  GetCertViewController.swift
//  ONTO
//
//  Created by Apple on 2018/8/7.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class GetCertViewController: BaseViewController {

    @objc var certArray: NSArray = []
    @objc var resultDic: NSDictionary! 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        
        createUI()
    
    }
    func createUI(){
        let title = UILabel(frame: CGRect(x: 70*SCALE_W, y: 9*SCALE_W, width: SYSWidth - 70*SCALE_W, height: 16*SCALE_W))
        title.textColor = UIColor(hexString: "#9b9b9b")
        title.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        title.textAlignment = .left
        title.text = "\(self.loacalkey(key: "byCOT")) \(resultDic.value(forKey: "Name")!)"//  "\(NSLocalizedString("byCOT", comment: "default"))  \(resultDic.value(forKey: "Name")!)"
        title.changeSpace(lineSpace: 0, wordSpace: 2)
        view.addSubview(title)
        
        let AuthorizationLB = UILabel(frame: CGRect(x: 70*SCALE_W, y: 23*SCALE_W, width: SYSWidth - 70*SCALE_W, height: 28*SCALE_W))
        AuthorizationLB.textColor = UIColor.black
        AuthorizationLB.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        AuthorizationLB.textAlignment = .left
        AuthorizationLB.text = self.loacalkey(key: "AuthorizationList")// NSLocalizedString("AuthorizationList", comment: "default")
        AuthorizationLB.changeSpace(lineSpace: 0, wordSpace: 3)
        view.addSubview(AuthorizationLB)
        
        var cotStr = NSMutableAttributedString.init()
        cotStr = getAttrString(str: resultDic.value(forKey: "ReqDes") as! String, width: SYSWidth - 112*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 0)
//        if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
//            cotStr = getColorAttrString1(str: loacalkey(key: "COTNeed"), width: SYSWidth - 112*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 0, defaultColor: UIColor(hexString: "#9B9B9B")!, cColor: UIColor.black, cColorLocation: 15, cColorLength: 65)
//        }else{
//            cotStr = getColorAttrString1(str: loacalkey(key: "COTNeed"), width: SYSWidth - 112*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 0, defaultColor: UIColor(hexString: "#9B9B9B")!, cColor: UIColor.black, cColorLocation: 10, cColorLength: 16)
//        }
        
        let cotStrH = getHeight(str: loacalkey(key: "COTNeed"), width: SYSWidth - 112*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 0)
        let COTNeedLB = UILabel(frame: CGRect(x: 70*SCALE_W, y: 55*SCALE_W, width: SYSWidth - 112*SCALE_W, height: cotStrH))
        COTNeedLB.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        COTNeedLB.textColor = UIColor(hexString: "#9B9B9B")
        COTNeedLB.textAlignment = .left
        COTNeedLB.numberOfLines = 0
        COTNeedLB.attributedText = cotStr
        view.addSubview(COTNeedLB)
        
        let image = UIImageView(frame: CGRect(x: 57*SCALE_W, y: 126*SCALE_W, width: 16*SCALE_W, height: 16*SCALE_W))
        image.image = UIImage(named: "coticon-none")
        view.addSubview(image)
        
        let needAuthLB = UILabel(frame: CGRect(x: 86*SCALE_W, y: 120*SCALE_W, width: SYSWidth - 86*SCALE_W, height: 28*SCALE_W))
        needAuthLB.textColor = UIColor.black
        needAuthLB.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        needAuthLB.textAlignment = .left
        needAuthLB.text = self.loacalkey(key: "IMIdentityInformation")
        needAuthLB.changeSpace(lineSpace: 0, wordSpace: 3*SCALE_W)
        view.addSubview(needAuthLB)
        
        let strH = getHeight(str: self.loacalkey(key: "PassportInfo"), width: SYSWidth - 119*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 2)
        let strContent = getAttrString(str: self.loacalkey(key: "PassportInfo"), width: SYSWidth - 119*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 2)
        let COTNeedLB1 = UILabel(frame: CGRect(x: 86*SCALE_W, y: 148*SCALE_W, width: SYSWidth - 119*SCALE_W, height: strH))
        COTNeedLB1.textColor = UIColor(hexString: "#9b9b9b")
        COTNeedLB1.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        COTNeedLB1.textAlignment = .left
        COTNeedLB1.numberOfLines = 0
        COTNeedLB1.attributedText = strContent
        view.addSubview(COTNeedLB1)
        
        let image1 = UIImageView(frame: CGRect(x: SYSWidth/2 - 25.5*SCALE_W, y: 183*SCALE_W + strH, width: 51*SCALE_W, height: 51*SCALE_W))
        image1.image = UIImage(named: "cotinfo")
        view.addSubview(image1)
        
        let textMaxSize2 = CGSize(width: SYSWidth - 112*SCALE_W, height: CGFloat(MAXFLOAT))
        let textLabelSize2 = self.textSize(text:self.loacalkey(key: "COTFirst") , font: UIFont.systemFont(ofSize: 12, weight: .regular), maxSize: textMaxSize2)
        let LB = UILabel(frame: CGRect(x: 85*SCALE_W, y: 269*SCALE_W + strH, width: SYSWidth - 119*SCALE_W, height: textLabelSize2.height+2))
        LB.textColor = UIColor.black
        LB.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        LB.textAlignment = .left
        LB.numberOfLines = 0
        LB.text = self.loacalkey(key: "COTFirst")
        LB.changeSpace(lineSpace: 0, wordSpace: 2)
        view.addSubview(LB)
        
//        let alertBtn = UIButton(frame: CGRect(x: 0, y: 452*SCALE_W, width: SYSWidth, height: 17*SCALE_W))
//        alertBtn.setImage(UIImage(named: "cotlink"), for: .normal)
//        alertBtn.setTitle(self.loacalkey(key: "COTAlert"), for: .normal)
//        alertBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        alertBtn.setTitleColor(UIColor(hexString: "#216ed5"), for: .normal)
//        view.addSubview(alertBtn)
//
//        let getBtn = UIButton(frame: CGRect(x: 58*SCALE_W, y: 499*SCALE_W, width: SYSWidth - 116*SCALE_W, height: 60*SCALE_W))
////        getBtn.setTitle(NSLocalizedString("COTGET", comment: "default"), for: .normal)
//        getBtn.setTitle(self.loacalkey(key: "COTGET"), for: .normal)
//        getBtn.backgroundColor = UIColor.black
//        getBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        getBtn.setTitleColor(UIColor.white , for: .normal)
//        view.addSubview(getBtn)
//        getBtn.addTarget(self, action: #selector(toGetCert), for: .touchUpInside)
        let bottomV = UIView(frame: CGRect(x: 0, y: SYSHeight  - 160*SCALE_W - 64, width: SYSWidth, height: 160*SCALE_W))
        if UIDevice.current.isX() {
            bottomV.frame = CGRect(x: 0, y: SYSHeight - 88 - 160*SCALE_W, width: SYSWidth, height: 160*SCALE_W)
        }
        view.addSubview(bottomV)
        
        //        allButton = UIButton(frame: CGRect(x: 47*SCALE_W, y: 2.5*SCALE_W, width: 28.5*SCALE_W, height: 22*SCALE_W))
        //        allButton.setImage(UIImage(named: "cotIcon_Selected-big"), for: .normal)
        //        bottomV.addSubview(allButton)
        
        //        let allLB = UILabel(frame: CGRect(x: 85*SCALE_W, y: 0*SCALE_W, width: SYSWidth - 144*SCALE_W, height: 25*SCALE_W))
        //        allLB.textColor = UIColor.black
        //        allLB.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        //        allLB.textAlignment = .left
        //        allLB.text = NSLocalizedString("SelectAll", comment: "default")
        //        bottomV.addSubview(allLB)
        
        let alertBtn = UIButton(frame: CGRect(x: 0, y: 10*SCALE_W, width: SYSWidth, height: 17*SCALE_W))
        alertBtn.setImage(UIImage(named: "cotlink"), for: .normal)
        alertBtn.setTitle(loacalkey(key: "COTAlert"), for: .normal)
        alertBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        alertBtn.setTitleColor(UIColor(hexString: "#216ed5"), for: .normal)
        bottomV.addSubview(alertBtn)
        alertBtn.handleControlEvent(.touchUpInside) {
            let vc = WebIdentityViewController()
            if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
                vc.introduce = "https://info.onto.app/#/detail/65"
            }else{
                vc.introduce = "https://info.onto.app/#/detail/64"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let getBtn = UIButton(frame: CGRect(x: 55*SCALE_W, y: 57*SCALE_W, width: SYSWidth - 110*SCALE_W, height: 60*SCALE_W))
        getBtn.setTitle(loacalkey(key: "COTGET"), for: .normal)
        getBtn.backgroundColor = UIColor.black
        getBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        getBtn.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 2*SCALE_W)
        getBtn.setTitleColor(UIColor.white , for: .normal)
        bottomV.addSubview(getBtn)
        getBtn.addTarget(self, action: #selector(toGetCert), for: .touchUpInside)
        
    }
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        
        print("bundle=\(bundle)")
        return bundle
        
    }
    
    public func getAttrString(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat) -> NSMutableAttributedString {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttributes([kCTFontAttributeName as NSAttributedStringKey : font], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [kCTParagraphStyleAttributeName as NSAttributedStringKey : paragraphStyle], range: .init(location: 0, length: ((str as NSString).length)))
        return attributedString
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
    public func getHeight(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat) -> CGFloat {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttributes([kCTFontAttributeName as NSAttributedStringKey : font], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [kCTParagraphStyleAttributeName as NSAttributedStringKey : paragraphStyle], range: .init(location: 0, length: ((str as NSString).length)))
        
        let attSize = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue))), context: nil).size  //NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
        return attSize.height
    }
    @objc func toGetCert() {
        
        self.navigationController?.popToRootViewController(animated: true)
//        let arr = UserDefaults.standard.value(forKey: APPAUCHARR) as! NSArray
//
//        //            self.appNativeArr = [IdentityModel mj_objectArrayWithKeyValuesArray:AppNativeListArr];
//        var array = NSArray.init()
//        array = [IdentityModel.mj_objectArray(withKeyValuesArray: arr)]
//
//        let vc = AuthInfoViewController()
//        vc.typeImage = "cotinnerlogo"
//        vc.modelArr = array[0] as! [Any]
//        vc.typeString = loacalkey(key: "IM_Introduce")
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [ kCTFontAttributeName as NSAttributedStringKey : font ], context: nil).size
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
        
        
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
