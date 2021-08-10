//
//  COTStatusViewController.swift
//  ONTO
//
//  Created by Apple on 2018/9/25.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
class COTStatusViewController: BaseViewController {
    @objc var statusType: String!
    @objc var errorMsg: String!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        createUI()
        // Do any additional setup after loading the view.
    }
    func createUI() {
        let statusLB = UILabel.init()
        statusLB.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        statusLB.textAlignment = .center
        view.addSubview(statusLB)
        
        let statusImage = UIImageView.init()
        view.addSubview(statusImage)
        
        let statusInfo = UILabel.init()
        statusInfo.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        statusInfo.textAlignment = .left
        statusInfo.numberOfLines = 0
        view.addSubview(statusInfo)
        
        let statusBtn = UIButton.init()
        statusBtn.backgroundColor = UIColor.black
        statusBtn.setTitleColor(UIColor.white, for: .normal)
        statusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.addSubview(statusBtn)
        
        if (statusType as NSString).isEqual(to: "0"){
            statusLB.text = loacalkey(key: "AUTHORIZATIONSUCCESS")
            statusImage.image = UIImage(named: "authSuccess")
            statusInfo.text = loacalkey(key: "AUTHORIZATIONSUCCESSInfo")
            statusBtn.setTitle(loacalkey(key: "OK"), for: .normal)
        }else{
            statusLB.text = loacalkey(key: "AUTHORIZATIONFAILED")
            statusImage.image = UIImage(named: "authFail")
            if errorMsg == nil {
                statusInfo.text = loacalkey(key: "AUTHORIZATIONFAILEDInfo")
                
            }else{
                
                statusInfo.text = errorMsg
            }
            statusBtn.setTitle(loacalkey(key: "TRYAGAIN"), for: .normal)
        }
        statusInfo.changeSpace(2, wordSpace: 1)
        statusBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        statusBtn.handleControlEvent(.touchUpInside) {
            let cv = BoxListDetailController.containBoxListDetail(self.navigationController);
            if cv != nil {
                NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName.kKycOauthedSuccessed), object: nil);
                self.navigationController?.popToViewController(cv!, animated: true)
                return;
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        statusLB.mas_makeConstraints { (make) in
            make?.width.equalTo()(SYSWidth)
            make?.top.equalTo()(self.view)?.offset()(0)
        }
        statusImage.mas_makeConstraints { (make) in
            make?.top.equalTo()(statusLB.mas_bottom)?.offset()(30*SCALE_W)
            make?.width.height().equalTo()(200*SCALE_W)
            make?.centerX.equalTo()(self.view)
        }
        statusInfo.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)?.offset()(38*SCALE_W)
            make?.right.equalTo()(self.view)?.offset()(-38*SCALE_W)
            make?.top.equalTo()(statusImage.mas_bottom)?.offset()(39*SCALE_W)
        }
        
        statusBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(self.view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            if UIDevice.current.isX() {
                make?.bottom.equalTo()(self.view.mas_bottom)?.offset()(-40*SCALE_W - 34)
            }else{
                make?.bottom.equalTo()(self.view.mas_bottom)?.offset()(-40*SCALE_W)
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
