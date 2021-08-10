//
//  OntoPayViewController.swift
//  ONTO
//
//  Created by Apple on 2018/12/10.
//  Copyright © 2018 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
class OntoPayViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @objc var walletArr: NSMutableArray!
    @objc var payInfo: NSDictionary!
    var tableView:UITableView?
    var arrowBtn:UIButton!
    var nameLB:UILabel!
    var addressLB:UILabel!
    var sendConfirmV:SendConfirmView!
    var defaultDic:NSDictionary!
    var passwordString: String?
    var hub: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultDic = (walletArr[0] as! NSDictionary)
        createNav()
        createUI()
    }
    func createNav() {
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
    }
    func createUI() {
//        let infoDic = payInfo.value(forKey: "params") as! NSDictionary
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "RegisterONTOLogo")
        view.addSubview(logoImage)
        
        let thirdName = UILabel()
        thirdName.text =  LocalizeEx("dappLogin")// "\(infoDic.value(forKey: "dappName") ?? "")"
        thirdName.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        thirdName.changeSpace(0, wordSpace: 1*SCALE_W)
        thirdName.textAlignment = .center
        view.addSubview(thirdName)
        
        let requiredLB = UILabel()
        requiredLB.text = LocalizeEx("LoginReq")
        requiredLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        requiredLB.changeSpace(0, wordSpace: 1)
        requiredLB.textAlignment = .left
        view.addSubview(requiredLB)
        
//        #6E6F70
        let dotImage1 = UIImageView()
        dotImage1.layer.cornerRadius = 3.5*SCALE_W
        dotImage1.backgroundColor = UIColor(hexString: "#6E6F70")
        view.addSubview(dotImage1)
        
        let dotImage2 = UIImageView()
        dotImage2.layer.cornerRadius = 3.5*SCALE_W
        dotImage2.backgroundColor = UIColor(hexString: "#6E6F70")
        view.addSubview(dotImage2)
        
        let requiredLB1 = UILabel()
        requiredLB1.text = LocalizeEx("payVerify")
        requiredLB1.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        requiredLB1.changeSpace(0, wordSpace: 1)
        requiredLB1.textAlignment = .left
        view.addSubview(requiredLB1)
        
        let requiredLB2 = UILabel()
        requiredLB2.text = LocalizeEx("payLoginNeed")
        requiredLB2.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        requiredLB2.changeSpace(0, wordSpace: 1)
        requiredLB2.textAlignment = .left
        view.addSubview(requiredLB2)
        
        let FromLB = UILabel()
        FromLB.text = LocalizeEx("payLoginName")
        FromLB.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        FromLB.changeSpace(0, wordSpace: 1)
        FromLB.textAlignment = .left
        view.addSubview(FromLB)
        
        let btn = UIButton()
        btn.backgroundColor = UIColor.black
        btn.setTitle(LocalizeEx("NEWCONFIRM"), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.titleLabel?.changeSpace(0, wordSpace: 3*SCALE_W)
        view.addSubview(btn)
        
        nameLB = UILabel()
        nameLB.text = (defaultDic.value(forKey: "label") as! String)
        nameLB.textColor = UIColor(hexString: "#6E6F70")
        nameLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLB.changeSpace(0, wordSpace: 1)
        nameLB.textAlignment = .left
        view.addSubview(nameLB)
        
        addressLB = UILabel()
        addressLB.text = (defaultDic.value(forKey: "address") as! String)
        addressLB.textColor = UIColor(hexString: "#000000")
        addressLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        //        addressLB.changeSpace(0, wordSpace: 0.5*SCALE_W)
        addressLB.textAlignment = .left
        view.addSubview(addressLB)
        
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#DDDDDD")
        view.addSubview(line)
        
        tableView = UITableView.init()
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.isHidden = true
        tableView?.dataSource = self
        tableView?.backgroundColor = UIColor.white
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID1")
        view?.addSubview(tableView!)
        
        arrowBtn = UIButton()
        arrowBtn.setEnlargeEdge(20)
        arrowBtn.isSelected = true
        arrowBtn.setImage(UIImage(named: "sDown"), for: .normal)
        if walletArr.count == 0 {
            arrowBtn.isHidden = true
        }
        view.addSubview(arrowBtn)
        
        sendConfirmV = SendConfirmView.init(frame: CGRect(x: 0, y: self.view.height, width: SYSWidth, height: SYSHeight))
        sendConfirmV.callback = { (token,from,to,value,password) in
            self.passwordString = password
            self.loadJS()
        }
        view.addSubview(sendConfirmV)
        
        logoImage.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(view)
            make?.top.equalTo()(view)?.offset()(15*SCALE_W)
            make?.width.height()?.equalTo()(60*SCALE_W)
        }
        
        thirdName.mas_makeConstraints { (make) in
            make?.top.equalTo()(logoImage.mas_bottom)?.offset()(15*SCALE_W)
            make?.centerX.equalTo()(view)
        }
        
        requiredLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(thirdName.mas_bottom)?.offset()(30*SCALE_W)
        }
        
        dotImage1.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.width.height()?.equalTo()(7*SCALE_W)
            make?.top.equalTo()(requiredLB.mas_bottom)?.offset()(19*SCALE_W)
        }
        
        dotImage2.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.width.height()?.equalTo()(7*SCALE_W)
            make?.top.equalTo()(requiredLB.mas_bottom)?.offset()(41*SCALE_W)
        }
        
        requiredLB1.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(35*SCALE_W)
            make?.top.equalTo()(requiredLB.mas_bottom)?.offset()(15*SCALE_W)
        }
        
        requiredLB2.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(35*SCALE_W)
            make?.top.equalTo()(requiredLB1.mas_bottom)?.offset()(5*SCALE_W)
        }
        
        FromLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(requiredLB2.mas_bottom)?.offset()(18*SCALE_W)
        }
        nameLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(FromLB)
            make?.top.equalTo()(FromLB.mas_bottom)?.offset()(12*SCALE_W)
        }
        
        tableView?.mas_makeConstraints({ (make) in
            make?.left.right()?.equalTo()(view)
            make?.top.equalTo()(FromLB.mas_bottom)
            make?.height.equalTo()(240*SCALE_W)
        })
        arrowBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(nameLB)
            make?.width.height()?.equalTo()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
        }
        addressLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(FromLB)
            make?.top.equalTo()(nameLB.mas_bottom)?.offset()(6*SCALE_W)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(addressLB.mas_bottom)?.offset()(18*SCALE_W)
            make?.height.equalTo()(1)
        }
        
        btn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            if  UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W - 34)
            }else{
                 make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W )
            }
        }
        
        arrowBtn.handleControlEvent(.touchUpInside) {
            if self.arrowBtn.isSelected{
                self.arrowBtn.setImage(UIImage(named: "sUp"), for: .normal)
                self.tableView?.isHidden = false
            }else{
                self.tableView?.isHidden = true
                self.arrowBtn.setImage(UIImage(named: "sDown"), for: .normal)
            }
            self.arrowBtn.isSelected = !self.arrowBtn.isSelected
        }
        
        btn.handleControlEvent(.touchUpInside) {
            self.sendConfirmV.paybyStr = "";
            self.sendConfirmV.amountStr = "";
            self.sendConfirmV.isWalletBack = true;
            self.sendConfirmV.show()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.walletArr?.count)!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80*SCALE_W
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:ShuftiCell! = tableView.dequeueReusableCell(withIdentifier: "cellID1") as? ShuftiCell
        if cell == nil {
            cell = ShuftiCell(style: .default, reuseIdentifier: "cellID1")
            cell.selectionStyle = .none
        }
        let dic = self.walletArr![indexPath.row] as! NSDictionary
        cell.reloadCellByDic(dic: dic,defaultDic: defaultDic)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaultDic = (self.walletArr![indexPath.row] as! NSDictionary)
        addressLB.text = (defaultDic.value(forKey: "address") as! String)
        nameLB.text = (defaultDic.value(forKey: "label") as! String)
        tableView.reloadData()
        self.perform(#selector(hiddenTable), afterDelay: 0.5)
    }
    @objc func hiddenTable()  {
        tableView?.isHidden = true
        arrowBtn.isSelected = true
        arrowBtn.setImage(UIImage(named: "sDown"), for: .normal)
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
    }
    func loadJS() {
        if passwordString?.count == 0 {
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
    func handlePrompt(prompt: String) {
        let promptArray = prompt.components(separatedBy: "params=") as NSArray
        let resultStr = promptArray[1] as! NSString
        let data:NSData = resultStr.data(using: String.Encoding.utf8.rawValue)! as NSData
        let obj = try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))
        print("obj=\(obj)")
        if (prompt as NSString).hasPrefix("decryptEncryptedPrivateKey") {
            let errorNum = (obj as! NSDictionary).value(forKey: "error") as! Int
            if errorNum == 0 {
                loginDragon()
                
            }else{
                hub.hide(animated: true)
                self.sendConfirmV.dismiss()
                Common.addAlertTitle(LocalizeEx("PASSWORDERROR"), message: nil, buttonString: LocalizeEx("OK")) { (str) in
                    
                }
            }
        }else if (prompt as NSString).hasPrefix("newsignDataStr") {
           
            togiveDragon(ValueString: (obj as! NSDictionary).value(forKey: "result") as! String)
        }
    }
    func loginDragon() {
        let dic = payInfo["params"] as! NSDictionary
        let signStr = Common.hexString(from: "\(dic["message"] ?? "")")
        
        let str = "Ont.SDK.signDataHex('\(signStr!)','\(defaultDic["key"]!)','\(Common.base64Encode(passwordString!) ?? "")','\(defaultDic["address"]!)','\(defaultDic["salt"]!)','newsignDataStr')"
        let Delagate =  UIApplication.shared.delegate as! AppDelegate
        Delagate.browserView.wkWebView.evaluateJavaScript(str, completionHandler: nil)
        Delagate.browserView.callbackPrompt = { ( prompt ) in
            self.handlePrompt(prompt: prompt!)
        }
    }
    func togiveDragon(ValueString: String) {
        
        print(defaultDic)
        let dic = payInfo["params"] as! NSDictionary
        let params:NSDictionary? = ["user":"\(defaultDic["address"]!)",
                                    "message":"\(dic["message"]!)",
                                    "publickey":"\(defaultDic["publicKey"]!)",
                                    "signature":ValueString,
                                    "type":"account"
                                    ]
        
        let submitDic :NSDictionary? = ["action":"login","version":"v1.0.0","id":"\(payInfo["id"] ?? "")","params":params as Any]
        CCRequest.shareInstance()?.request(withURLString: "\(dic["callback"] ?? "")", methodType: .POST, params: submitDic!, success: { (responseObject, responseOriginal) in
            if  self.hub != nil{
                self.hub.hide(animated: true)
            }
            self.sendConfirmV.dismiss()
            self.navigationController?.popToRootViewController(animated: true)
        }, failure: { (error, errorDesc, responseOriginal) in
            if  self.hub != nil{
                self.hub.hide(animated: true)
            }
            self.sendConfirmV.dismiss()
        })
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
