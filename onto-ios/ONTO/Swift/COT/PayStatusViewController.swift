//
//  PayStatusViewController.swift
//  ONTO
//
//  Created by Apple on 2018/11/22.
//  Copyright © 2018 Zeus. All rights reserved.
//



import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class PayStatusViewController: BaseViewController {
    var calimType: String!
    @objc var calimFrom: String!
    var docType: String!
    @objc var statusType: String!
    var ScrollView: UIScrollView!
    @objc var shuftiModel:IdentityModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavTitle(self.loacalkey(key: "newClaimDetails"))
        self.setNavLeftImageIcon(UIImage.init(named:"nav_back"), title: "Back")
        createUI()
        // Do any additional setup after loading the view.
    }
    func createUI() {
        var scrollFrame : CGRect
        var scrollSize: CGSize
        
        if UIDevice.current.isX() {
            scrollFrame = CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 48*SCALE_W - 88 - 34)
            scrollSize = CGSize(width: SYSWidth, height: SYSHeight - 48*SCALE_W - 88 - 34)
        }else{
            scrollSize = CGSize(width: SYSWidth, height: SYSHeight - 48*SCALE_W  - 64)
            scrollFrame = CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 48*SCALE_W  - 64)
        }
        ScrollView = UIScrollView(frame: scrollFrame)
        
        ScrollView.contentSize = scrollSize
        ScrollView.showsVerticalScrollIndicator = false
        view.addSubview(ScrollView)
        
        let typeImage = UIImageView(frame: CGRect(x: SYSWidth/2 - 52*SCALE_W, y: 30*SCALE_W, width: 104*SCALE_W, height: 104*250/450*SCALE_W))
        
        if (self.calimFrom as NSString).isEqual(to: "CFCA"){
            typeImage.frame = CGRect(x: SYSWidth/2 - 52*SCALE_W, y: 25*SCALE_W, width: 104*SCALE_W, height:104*94/360*SCALE_W)
            typeImage.image = UIImage(named: "logo-cfca")
        }else{
            typeImage.image = UIImage(named: "shangtang")
        }
        ScrollView.addSubview(typeImage)
        
        let statusImage = UIImageView(frame: CGRect(x: SYSWidth/2 - 37.5*SCALE_W, y: 76*SCALE_W, width: 75*SCALE_W, height: 75*SCALE_W))
        ScrollView.addSubview(statusImage)
        
        let statusLB = UILabel(frame: CGRect(x: 0, y: 177*SCALE_W, width: SYSWidth, height: 44*SCALE_W))
        statusLB.textAlignment = .center
        statusLB.numberOfLines = 0
        statusLB.font = UIFont.systemFont(ofSize: 14)
        statusLB.textColor = UIColor(hexString: "#2B4045")
        ScrollView.addSubview(statusLB)
        
        let statusLB1 = UILabel(frame: CGRect(x: 32*SCALE_W, y: 258*SCALE_W, width: 200*SCALE_W, height: 16*SCALE_W))
        statusLB1.textColor = UIColor(hexString: "#AAB3B4")
        statusLB1.font = UIFont.systemFont(ofSize: 14)
        statusLB1.textAlignment = .left
        statusLB1.text = self.loacalkey(key: "authStatus")
        ScrollView.addSubview(statusLB1)
        
        let statusLB2 = UILabel(frame: CGRect(x: 32*SCALE_W, y: 285*SCALE_W, width: 200*SCALE_W, height: 16*SCALE_W))
        statusLB2.textColor = UIColor(hexString: "#2B4045")
        statusLB2.font = UIFont.systemFont(ofSize: 14)
        statusLB2.textAlignment = .left
        ScrollView.addSubview(statusLB2)
        
        let line = UIView(frame: CGRect(x: 32*SCALE_W, y: 316*SCALE_W, width: SYSWidth - 32*SCALE_W, height: 1))
        line.backgroundColor = UIColor(hexString: "#F6F8F9")
        ScrollView.addSubview(line)
        
        let btn = UIButton(frame: CGRect(x: 0, y: SYSHeight - 48*SCALE_W - 64, width: SYSWidth, height: 48*SCALE_W))
        if UIDevice.current.isX() {
            btn.frame = CGRect(x: 0, y: SYSHeight - 48*SCALE_W - 88 - 34, width: SYSWidth, height: 48*SCALE_W)
        }
        btn.backgroundColor = UIColor(hexString: "#F0F7FC")
        btn.setTitleColor(UIColor(hexString: "#29A6FF"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.addSubview(btn)
        
        
        // review
        if (statusType! as NSString) .isEqual(to: "1") {
            statusImage.image = UIImage(named: "IMinreviewpic")
            statusLB.text = self.loacalkey(key: "Claimstatus1")
            statusLB.numberOfLines = 0;
            statusLB2.text =  self.loacalkey(key: "IMInReview")
            btn.isHidden = true
            
        }else if (statusType! as NSString) .isEqual(to: "2"){
            // success
            statusImage.image = UIImage(named: "IMsuccesspic")
            statusLB.text =  self.loacalkey(key: "Claimstatus3")
            statusLB2.isHidden = true
            statusLB1.isHidden = true
            line.isHidden = true
            
            btn.setTitle(self.loacalkey(key: "GettheVerificationClaim"), for: .normal)
            
            let whatBtn = UIButton(frame: CGRect(x: 0, y: 485*SCALE_W, width: SYSWidth, height: 17*SCALE_W))
            whatBtn.setImage(UIImage(named: "cotlink1"), for: .normal)
            whatBtn.setTitle(self.loacalkey(key: "WhatisVerificationClaim"), for: .normal)
            whatBtn.setTitleColor(UIColor(hexString: "#29A6FF"), for: .normal)
            whatBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            ScrollView.addSubview(whatBtn)
            whatBtn.handleControlEvent(.touchUpInside) {
                let vc = WebIdentityViewController()
                if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
                    vc.introduce = "https://info.onto.app/#/detail/61"
                }else{
                    vc.introduce = "https://info.onto.app/#/detail/60"
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            // 获取可信声明
            btn.handleControlEvent(.touchUpInside) {
                print("222")
                let vc = NewClaimViewController()
                vc.claimImage = self.shuftiModel.headLogo;
                vc.h5ReqParam = self.shuftiModel.h5ReqParam;
                if (self.calimFrom as NSString).isEqual(to: "CFCA"){
                    vc.claimContext = "claim:cfca_authentication";
                }else{
                    vc.claimContext = "claim:sensetime_authentication"
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                
            }
        }else{
            let params = ["OwnerOntId":UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "",
                          "DeviceCode": UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? "" ,//[[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_CODE],
                "ClaimId":"",
                "ClaimContext":calimType,
                "Status":"8"
            ];
            
            // failure
            statusImage.image = UIImage(named: "IMfailpic")
            statusLB.text = self.loacalkey(key: "Claimstatus2")
            statusLB2.text = self.loacalkey(key: "Claimstatus22")
            
            let reasonLB1 = UILabel(frame: CGRect(x: 32*SCALE_W, y: 339*SCALE_W, width: 200*SCALE_W, height: 16*SCALE_W))
            reasonLB1.textColor = UIColor(hexString: "#AAB3B4")
            reasonLB1.font = UIFont.systemFont(ofSize: 14)
            reasonLB1.textAlignment = .left
            reasonLB1.text = self.loacalkey(key: "IMReason")
            ScrollView.addSubview(reasonLB1)
            
            let reasonLB2 = UILabel(frame: CGRect(x: 32*SCALE_W, y: 365*SCALE_W, width: SYSWidth - 64*SCALE_W, height: 36*SCALE_W))
            reasonLB2.textColor = UIColor(hexString: "#2B4045")
            reasonLB2.numberOfLines = 0
            reasonLB2.font = UIFont.systemFont(ofSize: 14)
            
            reasonLB2.textAlignment = .left
            ScrollView.addSubview(reasonLB2)
            
            
            let line1 = UIView(frame: CGRect(x: 32*SCALE_W, y: 418*SCALE_W, width: SYSWidth - 32*SCALE_W, height: 1))
            line1.backgroundColor = UIColor(hexString: "#F6F8F9")
            ScrollView.addSubview(line1)
            
            
            btn.setTitle(self.loacalkey(key: "COTTryAgain"), for: .normal)
            btn.handleControlEvent(.touchUpInside) {
                print("111")
                let vc = RealNameViewController()
                vc.chargeModel = self.shuftiModel
                vc.claimImage = self.shuftiModel.headLogo
                if (self.calimFrom as NSString).isEqual(to: "CFCA"){
                    vc.isCFCA = true
                }else{
                    vc.isCFCA = false
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            
            CCRequest .shareInstance().request(withURLString: Claim_query, methodType: .POST, params: params, success: { (responseObject, responseOriginal) in
                print("认证失败=\(String(describing: responseObject))")
                let dic = (responseOriginal as! NSDictionary).value(forKey: "Result") as! NSDictionary
                let textSize = self.getSize(str: ((dic.value(forKey: "Description") as? String) ?? ""), width: SYSWidth - 64*SCALE_W, font: UIFont.systemFont(ofSize: 14), lineSpace: 0, wordSpace: 0)
                reasonLB2.frame = CGRect(x: 32*SCALE_W, y: 365*SCALE_W, width: SYSWidth - 64*SCALE_W, height: textSize.height)
                line1.frame = CGRect(x: 32*SCALE_W, y: 383*SCALE_W + textSize.height, width: SYSWidth - 32*SCALE_W, height: 1)
                self.ScrollView.contentSize = CGSize(width: SYSWidth, height: 383*SCALE_W + textSize.height+10)
                reasonLB2.text = dic.value(forKey: "Description") as? String
            }) { (error, errorDesc, responseOriginal) in
                
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func navLeftAction() {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        return bundle
        
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
