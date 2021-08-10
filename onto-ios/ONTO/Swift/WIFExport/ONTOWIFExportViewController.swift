//
//  ONTOWIFExportViewController.swift
//  ONTO
//
//  Created by Apple on 2019/5/8.
//  Copyright © 2019 Zeus. All rights reserved.
//

import UIKit

class ONTOWIFExportViewController: BaseViewController {

    @objc var defaultDic:NSDictionary!
    @objc var passwordString: String?
    var hub: MBProgressHUD!
    
    var WIFLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavLeftImageIcon(UIImage(named: "cotback"), title: "")
        self.createUI()
        decryptPwd()
    }
    
    private func createUI() {
        view.backgroundColor = UIColor.white
        
        let alertLB = UILabel()
        alertLB.text = LocalizeEx("WIFBackup")
        alertLB.font = UIFont.systemFont(ofSize: 14)
        alertLB.numberOfLines = 0
        view.addSubview(alertLB)
        
        let bgView = UIView()
        bgView.layer.cornerRadius = 5
        bgView.backgroundColor = UIColor(hexString: "#FAFAFA")
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor(hexString: "#E6E6E6")?.cgColor
        view.addSubview(bgView)
        
        WIFLB = UILabel()
        WIFLB.numberOfLines = 0
        WIFLB.alpha = 0.6
        WIFLB.font = UIFont.systemFont(ofSize: 13)
        bgView.addSubview(WIFLB)
        
        let copyBtn = UIButton()
        copyBtn.setTitle(LocalizeEx("WIFCopy"), for: .normal)
        copyBtn.setTitleColor(UIColor.white, for: .normal)
        copyBtn.backgroundColor = UIColor.black
        copyBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        copyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.addSubview(copyBtn)
        
        copyBtn.handleControlEvent(.touchUpInside) {
            let pasteboard = UIPasteboard.general
            pasteboard.string = self.WIFLB.text
            
            let copyV = COTAlertV.init(title: LocalizeEx("WIFCopySuccess"), imageString: "dropCopy", buttonString: LocalizeEx("OK"))
            copyV?.show()
        }
        
        alertLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20)
            make?.right.equalTo()(view)?.offset()(-20)
            make?.top.equalTo()(view)?.offset()(35)
        }
        bgView.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20)
            make?.right.equalTo()(view)?.offset()(-20)
            make?.top.equalTo()(alertLB.mas_bottom)?.offset()(25)
        }
        
        WIFLB.mas_makeConstraints { (make) in
            make?.top.equalTo()(bgView)?.offset()(20)
            make?.left.equalTo()(bgView)?.offset()(15)
            make?.right.equalTo()(bgView)?.offset()(-15)
            make?.bottom.equalTo()(bgView.mas_bottom)?.offset()(-20)
        }
        
        copyBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58)
            make?.right.equalTo()(view)?.offset()(-58)
            make?.height.offset()(60)
            make?.bottom.equalTo()(view)?.offset()(-40)
        }
    }
    
    func decryptPwd() {
        if self.passwordString?.count == 0 {
            return
        }
        
        hub = ToastUtil.showMessage("", to: nil)
        let str = "Ont.SDK.decryptEncryptedPrivateKey('\(defaultDic["key"]!)','\(Common.transferredMeaning(passwordString!) ?? "")','\(defaultDic["address"]!)','\(defaultDic["salt"]!)','decryptEncryptedPrivateKey')"
        print("\(str)")
        let Delagate =  UIApplication.shared.delegate as! AppDelegate
        Delagate.browserView.wkWebView.evaluateJavaScript(str, completionHandler: nil)
        Delagate.browserView.callbackPrompt = { ( prompt ) in
            self.handlePrompt(prompt: prompt!)
        }
    }

    private func handlePrompt(prompt: String) {
        let promptArray = prompt.components(separatedBy: "params=") as NSArray
        let resultStr = promptArray[1] as! NSString
        let data:NSData = resultStr.data(using: String.Encoding.utf8.rawValue)! as NSData
        let obj = try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))
        
        if (prompt as NSString).hasPrefix("decryptEncryptedPrivateKey") {
            let errorNum = (obj as! NSDictionary).value(forKey: "error") as! Int
            if errorNum == 0 {
                exportWifJs()
            }else if errorNum == 53000 {
                hub.hide(animated: true)
                Common.showToast(LocalizeEx("PASSWORDERROR"))
            }else {
                hub.hide(animated: true)
                Common.showToast("\(LocalizeEx("Systemerror")):\((obj as! NSDictionary).value(forKey: "error")!)")

            }
        }else if (prompt as NSString).hasPrefix("exportWifPrivakeKey") {
            print("obj=\(obj)")
            hub.hide(animated: true)
            let errorNum = (obj as! NSDictionary).value(forKey: "error") as! Int
            if errorNum == 0 {
                let result = (obj as! NSDictionary).value(forKey: "result") as! NSDictionary
                WIFLB.text = "\(result["wif"] ?? "")"
            }else {
                Common.showToast("\(LocalizeEx("Systemerror")):\((obj as! NSDictionary).value(forKey: "error")!)")

            }
        }
    }
    
    private func exportWifJs() {
        let str = "Ont.SDK.exportWifPrivakeKey('\(defaultDic["key"]!)','\(Common.transferredMeaning(passwordString!) ?? "")','\(defaultDic["address"]!)','\(defaultDic["salt"]!)','exportWifPrivakeKey')"
        print("\(str)")
        let Delagate =  UIApplication.shared.delegate as! AppDelegate
        Delagate.browserView.wkWebView.evaluateJavaScript(str, completionHandler: nil)
        Delagate.browserView.callbackPrompt = { ( prompt ) in
            self.handlePrompt(prompt: prompt!)
        }
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
    }
}
