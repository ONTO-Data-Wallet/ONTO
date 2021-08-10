//
//  OntoPayDetailViewController.swift
//  ONTO
//
//  Created by Apple on 2018/12/10.
//  Copyright © 2018 Zeus. All rights reserved.
//



import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class OntoPayDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @objc var dataArray: NSMutableArray!
    @objc var toAddress: String!
    @objc var gas: String!
    @objc var payerAddress: String!
    @objc var payMoney: String!
    @objc var callback: String!
    @objc var payInfo: NSDictionary!
    @objc var payDetailDic:NSDictionary!
    @objc var isONT : Bool = false
    var nameLB:UILabel!
    var addressLB:UILabel!
    var arrowBtn:UIButton!
    @objc var defaultDic:NSDictionary!
    var tableView:UITableView?
    var sendConfirmV:SendConfirmView!
    var browserView:BrowserView!
    var passwordString: String?
    @objc var hashString: String?
    var hub: MBProgressHUD!
    
    var doucumentType: String!
    var idNumber:String!
    var photo1: UIImage!
    var photo2: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(LocalizeEx("PAYMENT"))
        self.setNavLeftImageIcon(UIImage.init(named: "cotback"), title: "Back")
//        defaultDic = (dataArray[0] as! NSDictionary)
        if toAddress == nil {
            createNoBuyUI()
            return;
        }
        createUI()
    }
    
    func createNoBuyUI() {
        
        let fromLB = UILabel()
        fromLB.text = LocalizeEx("ShuftiFrom")
        fromLB.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        fromLB.changeSpace(0, wordSpace: 1)
        fromLB.textAlignment = .left
        view.addSubview(fromLB)
        
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
        
        let paramsDic = payDetailDic["params"] as! NSDictionary
        print(payDetailDic)
        let invokeConfigDic = paramsDic["invokeConfig"] as! NSDictionary
        print("invokeConfigDic=\(invokeConfigDic)")
        let fee1 = "\(Common.getRealFee("500", gasLimit: "\(gas ?? "20000")") ?? "")"
        let feeLB1 = UILabel()
        feeLB1.text = "\(LocalizeEx("Fee")) \(fee1) ONG"
        feeLB1.textColor = UIColor(hexString: "#000000")
        feeLB1.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        feeLB1.changeSpace(0, wordSpace: 0.5*SCALE_W)
        feeLB1.textAlignment = .left
        view.addSubview(feeLB1)
        
        let confirmBtn = UIButton()
        confirmBtn.backgroundColor = UIColor.black
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.setTitle(LocalizeEx("NEWCONFIRM"), for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        confirmBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        view.addSubview(confirmBtn)
        
        browserView = BrowserView.init(frame: .zero)
        browserView.callbackPrompt = { (promptString) in
            self.handlePrompt(prompt: promptString ?? "")
        }
        browserView.callbackJSFinish = { () in
            //            self.loadJS()
        }
        view.addSubview(browserView)
        
        fromLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(view)?.offset()(78*SCALE_W)
        }
        
        nameLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(fromLB)
            make?.top.equalTo()(fromLB.mas_bottom)?.offset()(12*SCALE_W)
        }
        addressLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(fromLB)
            make?.top.equalTo()(nameLB.mas_bottom)?.offset()(6*SCALE_W)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(addressLB.mas_bottom)?.offset()(18*SCALE_W)
            make?.height.equalTo()(1)
        }
        
        feeLB1.mas_makeConstraints { (make) in
            make?.left.equalTo()(addressLB)
            make?.top.equalTo()(line.mas_bottom)?.offset()(18*SCALE_W)
        }
        
        confirmBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            if  UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W - 34)
            }else{
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W)
            }
        }
        
        confirmBtn.handleControlEvent(.touchUpInside) {
            //            self.checkMoney()
            self.confirmTrade(tx: "", txHash: "")
        }
    }
    func createUI() {
        let feeLB = UILabel()
        feeLB.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        feeLB.attributedText = getFeeString()
//        let pDic = payInfo.value(forKey: "params") as! NSDictionary
//        feeLB.text = pDic.value(forKey: "message") as? String
        feeLB.changeSpace(0, wordSpace: 1)
        feeLB.numberOfLines = 0
        feeLB.textAlignment = .center
        view.addSubview(feeLB)
        
        let fromLB = UILabel()
        fromLB.text = LocalizeEx("ShuftiFrom")
        fromLB.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        fromLB.changeSpace(0, wordSpace: 1)
        fromLB.textAlignment = .left
        view.addSubview(fromLB)
        
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
        
        let toLB = UILabel()
        toLB.text = LocalizeEx("ShuftiTo")
        toLB.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        toLB.changeSpace(0, wordSpace: 1)
        toLB.textAlignment = .left
        view.addSubview(toLB)
        
        let toAddressLB = UILabel()
        toAddressLB.text = toAddress
        toAddressLB.textColor = UIColor(hexString: "#000000")
        toAddressLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        //        toAddressLB.changeSpace(0, wordSpace: 0.5*SCALE_W)
        toAddressLB.textAlignment = .left
        view.addSubview(toAddressLB)
        
        let line1 = UIView()
        line1.backgroundColor = UIColor(hexString: "#DDDDDD")
        view.addSubview(line1)
        
        let paramsDic = payDetailDic["params"] as! NSDictionary
        print(payDetailDic)
        let invokeConfigDic = paramsDic["invokeConfig"] as! NSDictionary
        print("invokeConfigDic=\(invokeConfigDic)")
        let fee1 = "\(Common.getRealFee("500", gasLimit: "\(gas ?? "20000")") ?? "")"
        let feeLB1 = UILabel()
        feeLB1.text = "\(LocalizeEx("Fee")) \(fee1) ONG"
        feeLB1.textColor = UIColor(hexString: "#000000")
        feeLB1.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        feeLB1.changeSpace(0, wordSpace: 0.5*SCALE_W)
        feeLB1.textAlignment = .left
        view.addSubview(feeLB1)
        
        let supportBtn = UIButton()
        supportBtn.setImage(UIImage(named: "sSupport"), for: .normal)
        supportBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        supportBtn.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
        supportBtn.setTitle("  \(LocalizeEx("NotSupport"))", for: .normal)
        view.addSubview(supportBtn)
        
        let confirmBtn = UIButton()
        confirmBtn.backgroundColor = UIColor.black
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.setTitle(LocalizeEx("NEWCONFIRM"), for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        confirmBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        view.addSubview(confirmBtn)
        
        tableView = UITableView.init()
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.isHidden = true
        tableView?.dataSource = self
        tableView?.backgroundColor = UIColor.white
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID1")
//        view?.addSubview(tableView!)
        
        arrowBtn = UIButton()
        arrowBtn.setEnlargeEdge(20)
        arrowBtn.isSelected = true
        arrowBtn.setImage(UIImage(named: "sDown"), for: .normal)
        if dataArray.count == 0 {
            arrowBtn.isHidden = true
        }
//        view.addSubview(arrowBtn)
        
        sendConfirmV = SendConfirmView.init(frame: CGRect(x: 0, y: self.view.height, width: SYSWidth, height: SYSHeight))
        sendConfirmV.callback = { (token,from,to,value,password) in
            self.passwordString = password
            self.loadJS()
        }
        view.addSubview(sendConfirmV)
        
        browserView = BrowserView.init(frame: .zero)
        browserView.callbackPrompt = { (promptString) in
            self.handlePrompt(prompt: promptString ?? "")
        }
        browserView.callbackJSFinish = { () in
//            self.loadJS()
        }
        view.addSubview(browserView)
        
        feeLB.mas_makeConstraints { (make) in
//            make?.left.right()?.equalTo()(view)!.offset()(20*SCALE_W)
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(view)?.offset()(30*SCALE_W)
        }
        
        fromLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(feeLB.mas_bottom)?.offset()(48*SCALE_W)
        }
        
        nameLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(fromLB)
            make?.top.equalTo()(fromLB.mas_bottom)?.offset()(12*SCALE_W)
        }
        
//        tableView?.mas_makeConstraints({ (make) in
//            make?.left.right()?.equalTo()(view)
//            make?.top.equalTo()(fromLB.mas_bottom)
//            make?.height.equalTo()(240*SCALE_W)
//        })
//        arrowBtn.mas_makeConstraints { (make) in
//            make?.centerY.equalTo()(nameLB)
//            make?.width.height()?.equalTo()(20*SCALE_W)
//            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
//        }
        addressLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(fromLB)
            make?.top.equalTo()(nameLB.mas_bottom)?.offset()(6*SCALE_W)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(addressLB.mas_bottom)?.offset()(18*SCALE_W)
            make?.height.equalTo()(1)
        }
        
        toLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(fromLB)
            make?.top.equalTo()(line.mas_bottom)?.offset()(28*SCALE_W)
        }
        
        toAddressLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(fromLB)
            make?.top.equalTo()(toLB.mas_bottom)?.offset()(12*SCALE_W)
        }
        
        line1.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(toAddressLB.mas_bottom)?.offset()(18*SCALE_W)
            make?.height.equalTo()(1)
        }
        
        feeLB1.mas_makeConstraints { (make) in
            make?.left.equalTo()(addressLB)
            make?.top.equalTo()(line1.mas_bottom)?.offset()(18*SCALE_W)
        }
        
        confirmBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            if  UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W - 34)
            }else{
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W)
            }
        }
        
        supportBtn.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
            make?.bottom.equalTo()(confirmBtn.mas_top)?.offset()(-31*SCALE_W)
            make?.height.equalTo()(25*SCALE_W)
        }
        
//        arrowBtn.handleControlEvent(.touchUpInside) {
//            if self.arrowBtn.isSelected{
//                self.arrowBtn.setImage(UIImage(named: "sUp"), for: .normal)
//                self.tableView?.isHidden = false
//            }else{
//                self.tableView?.isHidden = true
//                self.arrowBtn.setImage(UIImage(named: "sDown"), for: .normal)
//            }
//            self.arrowBtn.isSelected = !self.arrowBtn.isSelected
//        }
        
        confirmBtn.handleControlEvent(.touchUpInside) {
//            self.checkMoney()
            self.confirmTrade(tx: "", txHash: "")
        }
    }
    func checkMoney() {
//        CCRequest.shareInstance()?.request(withURLString1: "\(Get_Blance)/\(defaultDic["address"]!)", methodType: .GET, params: nil, success: { (responseObject, responseOriginal) in
//            let  arr = responseObject as! NSArray
//            for dic in arr{
//                let subDic = dic as! NSDictionary
//                if (subDic["AssetName"] as! NSString).isEqual(to: "ong"){
//                    let isEnough = Common.isEnoughOng((subDic.value(forKey: "Balance") as! String), fee: Common.getAllFee(self.shuftiModel.chargeInfo.amount, gasPrice: self.shuftiModel.chargeInfo.gasPrice, gasLimit: self.shuftiModel.chargeInfo.gasLimit)) as Bool
//                    if  isEnough{
                        self.sendConfirmV.paybyStr = "";
                        self.sendConfirmV.amountStr = "";
                        self.sendConfirmV.isWalletBack = true;
                        self.sendConfirmV.show()
//                    }else{
//                        Common.showToast(LocalizeEx("NotenoughONG"))
//                    }
//                }
//            }
//        }, failure: { (error, errorDesc, responseOriginal) in
//            Common.showToast(LocalizeEx("NetworkAnomaly"))
//        })
        
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
//                signTrade()
                makeTrasaction(key: "\((obj as! NSDictionary).value(forKey: "result") ?? "")")
            }else{
                hub.hide(animated: true)
                self.sendConfirmV.dismiss()
                Common.addAlertTitle(LocalizeEx("PASSWORDERROR"), message: nil, buttonString: LocalizeEx("OK")) { (str) in
                    
                }
            }
        }else if (prompt as NSString).hasPrefix("addSign") {
            let errorNum = (obj as! NSDictionary).value(forKey: "error") as! Int
            if errorNum == 0 {
                confirmTrade(tx: (obj as! NSDictionary).value(forKey: "result") as! String, txHash: (obj as! NSDictionary).value(forKey: "txHash") as! String)
            }else{
                hub.hide(animated: true)
                self.sendConfirmV.dismiss()
                Common.showToast(LocalizeEx("Systemerror"))
            }
        }else if (prompt as NSString).hasPrefix("sendTransaction") {
            hub.hide(animated: true)
            if (obj as! NSDictionary).value(forKey: "error") == nil{
                return;
            }
            let errorNum = (obj as! NSDictionary).value(forKey: "error") as! Int
            if errorNum == 0 {
                Common.showToast(LocalizeEx("sendSuccess"))
                if callback.count > 0 {
                    sendHashToDragon(isSuccess: 0)
                }
            }else{
                if callback.count > 0{
                    sendHashToDragon(isSuccess: 1)
                }
                Common.showToast("\(LocalizeEx("Systemerror")):\((obj as! NSDictionary).value(forKey: "error") ?? "")")
            }
            hub.hide(animated: true)
            self.navigationController?.popToRootViewController(animated: true)

        }else if (prompt as NSString).hasPrefix("makeDappTransaction") {
            let errorNum = (obj as! NSDictionary).value(forKey: "error") as! Int
            if errorNum == 0 {
                confirmTrade(tx: (obj as! NSDictionary).value(forKey: "result") as! String, txHash: (obj as! NSDictionary).value(forKey: "txHash") as! String)
            }else{
                hub.hide(animated: true)
                self.sendConfirmV.dismiss()
                Common.showToast(LocalizeEx("Systemerror"))
            }
        }
    }
    func sendHashToDragon(isSuccess: Int) {
        let params : NSDictionary;
        if isSuccess == 0 {
            params = ["action":"invoke",
                      "error": 0,
                      "desc": "SUCCESS",
                      "result": "\(hashString!)",
                      "version":"\(self.payDetailDic["version"] ?? "")",
                      "id":"\(self.payDetailDic["id"] ?? "")"]
        }else{
            params = ["action": "invoke",
                      "error": 8001,
                      "desc": "SEND TX ERROR",
                      "result": 1,
                      "version":"\(self.payDetailDic["version"] ?? "")",
                      "id":"\(self.payDetailDic["id"] ?? "")"]
        }
        CCRequest.shareInstance()?.request(withURLString: callback, methodType: .POST, params: params, success: { (responseObject, responseOriginal) in
            
        }, failure: { (error, errorDesc, responseOriginal) in
            
        })
    }
    func makeTrasaction(key:String) {
        print("231")
        let jsonString = Common.convert(toJsonData: (payInfo as! [AnyHashable : Any]))
        print("jsonString=\(jsonString ?? "")")
        
        let str = "Ont.SDK.makeDappTransaction('\(jsonString!)','\(key)','makeDappTransaction')"
        print("\(str)")
        let Delagate =  UIApplication.shared.delegate as! AppDelegate
        Delagate.browserView.wkWebView.evaluateJavaScript(str, completionHandler: nil)
        Delagate.browserView.callbackPrompt = { ( prompt ) in
            self.handlePrompt(prompt: prompt!)
        }
//        NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.makeDappTransaction('%@','%@','makeDappTransaction')",str,obj[@"result"]];
//        [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
//        __weak typeof(self) weakSelf = self;
//        [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
//            [weakSelf handlePrompt:prompt];
//            }];
        
    }
    func signTrade() {
        // 加签
        let jsStr = "addSign('\(hashString!)','\(defaultDic["key"]!)')"
        print("\(jsStr)")
        let Delagate =  UIApplication.shared.delegate as! AppDelegate
        Delagate.browserView.wkWebView.evaluateJavaScript(jsStr, completionHandler: nil)
        Delagate.browserView.callbackPrompt = { ( prompt ) in
            self.handlePrompt(prompt: prompt!)
        }
    }
    func confirmTrade(tx:String,txHash:String) {
        hub = ToastUtil.showMessage("", to: nil)
        let str11 = "Ont.SDK.sendTransaction('\(hashString!)','sendTransaction')"
        print("\(str11)")

        let ss = "Ont.SDK.setServerNode('\(UserDefaults.standard.value(forKey: TESTNETADDR) ?? "")')"//TESTNETADDR
        browserView.wkWebView.evaluateJavaScript(ss, completionHandler: nil)
        browserView.wkWebView.evaluateJavaScript("Ont.SDK.setSocketPort('20335')", completionHandler: nil)
        browserView.wkWebView.evaluateJavaScript("Ont.SDK.setRestPort('20334')", completionHandler: nil)
        browserView.wkWebView.evaluateJavaScript(str11, completionHandler: nil)
        browserView.callbackPrompt = { ( prompt ) in
            self.handlePrompt(prompt: prompt!)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
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
        let dic = self.dataArray![indexPath.row] as! NSDictionary
        cell.reloadCellByDic(dic: dic,defaultDic: defaultDic)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaultDic = (self.dataArray![indexPath.row] as! NSDictionary)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = {[NSAttributedStringKey.foregroundColor : UIColor.black,
                                                                         NSAttributedStringKey.font : UIFont.systemFont(ofSize: 21, weight: .bold),
                                                                         NSAttributedStringKey.kern: 2]}()
    }
    func appendColorStrWithString(str:String,font:UIFont,color:UIColor) -> NSMutableAttributedString {
        
        
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : 0])
        attributedString.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: font, range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [ NSAttributedStringKey.foregroundColor : color], range: .init(location: 0, length: ((str as NSString).length)))
        return attributedString
    }
    func getFeeString() -> NSMutableAttributedString {
        
        let typeString:String;
        if isONT {
            typeString = "ONT"
        }else{
            typeString = "ONG"
        }
        let cotStr = NSMutableAttributedString.init()
        cotStr.append(appendColorStrWithString(str: "\(LocalizeEx("WillPay")) ", font: UIFont.systemFont(ofSize: 24, weight: .medium), color: UIColor(hexString: "#000000")!))
        cotStr.append(appendColorStrWithString(str: payMoney , font: UIFont.systemFont(ofSize: 24, weight: .medium), color: UIColor(hexString: "#196BD8")!))
        cotStr.append(appendColorStrWithString(str: " \(typeString)", font: UIFont.systemFont(ofSize: 24, weight: .medium), color: UIColor(hexString: "#000000")!))
        
        return cotStr
    }
    
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
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
