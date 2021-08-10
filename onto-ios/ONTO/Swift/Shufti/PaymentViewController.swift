//
//  PaymentViewController.swift
//  ONTO
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class PaymentViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var shuftiModel:IdentityModel!
    var dataArray: NSMutableArray!
    var nameLB:UILabel!
    var addressLB:UILabel!
    var arrowBtn:UIButton!
    var defaultDic:NSDictionary!
    var tableView:UITableView?
    var sendConfirmV:SendConfirmView!
    var passwordString: String?
    var hub: MBProgressHUD!
    
    var doucumentType: String!
    var idNumber:String!
    var photo1: UIImage!
    var photo2: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(LocalizeEx("PAYMENT"))
        self.setNavLeftImageIcon(UIImage.init(named: "cotback"), title: "Back")
        defaultDic = (dataArray[0] as! NSDictionary)
        createUI()
    }
    
    func createUI() {
        let feeLB = UILabel()
        feeLB.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        feeLB.changeSpace(0, wordSpace: 1)
        feeLB.attributedText = getFeeString()
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
        toAddressLB.text = shuftiModel.chargeInfo.toAddress!
        toAddressLB.textColor = UIColor(hexString: "#000000")
        toAddressLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        toAddressLB.changeSpace(0, wordSpace: 0.5*SCALE_W)
        toAddressLB.textAlignment = .left
        view.addSubview(toAddressLB)
        
        let line1 = UIView()
        line1.backgroundColor = UIColor(hexString: "#DDDDDD")
        view.addSubview(line1)
        
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
        view?.addSubview(tableView!)
        
        arrowBtn = UIButton()
        arrowBtn.setEnlargeEdge(20)
        arrowBtn.isSelected = true
        arrowBtn.setImage(UIImage(named: "sDown"), for: .normal)
        if dataArray.count == 0 {
            arrowBtn.isHidden = true
        }
        view.addSubview(arrowBtn)
        
        sendConfirmV = SendConfirmView.init(frame: CGRect(x: 0, y: self.view.height, width: SYSWidth, height: SYSHeight))
        sendConfirmV.callback = { (token,from,to,value,password) in
            self.passwordString = password
            self.loadJS()
        }
        view.addSubview(sendConfirmV)
        feeLB.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
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
        
        tableView?.mas_makeConstraints({ (make) in
            make?.left.right()?.equalTo()(view)
            make?.top.equalTo()(fromLB.mas_bottom)
            make?.height.equalTo()(240*SCALE_W)
        })
        arrowBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(nameLB)
            make?.width.height()?.equalTo()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
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
        
        confirmBtn.handleControlEvent(.touchUpInside) {
            self.checkMoney()
        }
    }
    func checkMoney() {
        CCRequest.shareInstance()?.request(withURLString1: "\(Get_Blance)/\(defaultDic["address"]!)", methodType: .GET, params: nil, success: { (responseObject, responseOriginal) in
            let  arr = responseObject as! NSArray
            for dic in arr{
                let subDic = dic as! NSDictionary
                if (subDic["AssetName"] as! NSString).isEqual(to: "ong"){
//                    let isEnough = Common.isEnoughOng((subDic.value(forKey: "Balance") as! String), fee: Common.getshuftiStr(self.shuftiModel.chargeInfo.amount)) as Bool
                    let isEnough = Common.isEnoughOng((subDic.value(forKey: "Balance") as! String), fee: Common.getAllFee(self.shuftiModel.chargeInfo.amount, gasPrice: self.shuftiModel.chargeInfo.gasPrice, gasLimit: self.shuftiModel.chargeInfo.gasLimit)) as Bool
                    if  isEnough{
                        self.sendConfirmV.paybyStr = "";
                        self.sendConfirmV.amountStr = "";
                        self.sendConfirmV.isWalletBack = true;
                        self.sendConfirmV.show()
                    }else{
                        Common.showToast(LocalizeEx("NotenoughONG"))
                    }
                }
            }
        }, failure: { (error, errorDesc, responseOriginal) in
            Common.showToast(LocalizeEx("NetworkAnomaly"))
        })
        
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
                signTrade()
            }else{
                hub.hide(animated: true)

                Common.addAlertTitle(LocalizeEx("PASSWORDERROR"), message: nil, buttonString: LocalizeEx("OK")) { (str) in
                    
                }
            }
        }else if (prompt as NSString).hasPrefix("transferAssets") {
            let errorNum = (obj as! NSDictionary).value(forKey: "error") as! Int
            if errorNum == 0 {
                let dic = obj as! NSDictionary
                confirmTrade(tx: dic.value(forKey: "tx") as! String, txHash: dic.value(forKey: "txHash") as! String)
            }else{
                hub.hide(animated: true)
                Common.showToast("\(LocalizeEx("Systemerror")):\((obj as! NSDictionary).value(forKey: "error")!)")
                return;
            }
        }
    }
    func signTrade() {
//        let str = "Ont.SDK.transferAssets('ONG','\(defaultDic["address"]!)','\(shuftiModel.chargeInfo.toAddress!)','\(shuftiModel.chargeInfo.amount!)','\(defaultDic["key"]!)','\(Common.transferredMeaning(passwordString!) ?? "")','\(defaultDic["salt"]!)','\(UserDefaults.standard.value(forKey: ASSETGASPRICE) ?? "")','\(UserDefaults.standard.value(forKey: ASSETGASLIMIT) ?? "")','\(defaultDic["address"]!)','transferAssets')"
        let str = "Ont.SDK.transferAssets('ONG','\(defaultDic["address"]!)','\(shuftiModel.chargeInfo.toAddress!)','\(shuftiModel.chargeInfo.amount!)','\(defaultDic["key"]!)','\(Common.transferredMeaning(passwordString!) ?? "")','\(defaultDic["salt"]!)','\(shuftiModel.chargeInfo.gasPrice!)','\(shuftiModel.chargeInfo.gasLimit!)','\(defaultDic["address"]!)','transferAssets')"
        print("\(str)")
        let Delagate =  UIApplication.shared.delegate as! AppDelegate
        Delagate.browserView.wkWebView.evaluateJavaScript(str, completionHandler: nil)
        Delagate.browserView.callbackPrompt = { ( prompt ) in
            self.handlePrompt(prompt: prompt!)
        }
    }
    func confirmTrade(tx:String,txHash:String) {
        var localeStr = ""
        let path = Bundle.main.path(forResource: "code", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
            /*
             * try 和 try! 的区别
             * try 发生异常会跳到catch代码中
             * try! 发生异常程序会直接crash
             */
            let data = try Data(contentsOf: url)
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! NSArray
            
            let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            var country = appdelegate.selectCountry
            country = country?.replacingOccurrences(of: " ", with: "")
            
            for dict in jsonArr {
                
                let mydic: NSDictionary = dict as! NSDictionary
                
                if mydic["en"] as? String == country {
                    
                    localeStr = (dict as AnyObject)["locale"] as! String
                    break
                    
                } else {
                    localeStr = (dict as AnyObject)["locale"] as! String
                    break
                }
            }
        } catch let error as Error? {
            //            print("读取本地数据出现错误!",error)
        }
        
        let imageData = UIImageJPEGRepresentation(Common.scaleToIMImage(from: self.photo1!), 0.6)
        let imageBase64String = imageData?.base64EncodedString()
        var imageBase64String2: String = ""
        
        if (self.photo2 != nil) {
            let imageData2 = UIImageJPEGRepresentation(Common.scaleToIMImage(from: self.photo2!), 0.6)
            let imageBase64String3 = (imageData2?.base64EncodedString())!
            imageBase64String2 = "data:image/jpeg;base64," + imageBase64String3
        }
        
        
        var mydoucumentType: String = ""
        
        if doucumentType == LocalizeEx("IM_IDCard") {
            mydoucumentType = "id_card"
        } else if doucumentType == LocalizeEx("IM_Passort") {
            mydoucumentType = "passport"
        } else if doucumentType == LocalizeEx("IM_DriverLicense") {
            mydoucumentType = "driving_license"
        }
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        var dict: NSDictionary
        let payDiv:NSDictionary = ["txnBody":tx,"txnHash":txHash,"fromAddress":defaultDic["address"]!,"toAddress":shuftiModel.chargeInfo.toAddress!,"amount":shuftiModel.chargeInfo.amount!,"assetName":shuftiModel.chargeInfo.assetName!]
        if imageBase64String2.count == 0 {
            dict = ["ontId" :UserDefaults.standard.string(forKey:ONT_ID)!,"deviceCode":UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? "", "country": appdelegate.selectCountry,"docType":mydoucumentType,"frontDoc":"data:image/jpeg;base64,"+imageBase64String!,"docNumber":self.idNumber,"txnInfo":payDiv,"backDoc":""]
        }else{
            dict = ["ontId" :UserDefaults.standard.string(forKey:ONT_ID)!,"deviceCode":UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? "", "country": appdelegate.selectCountry,"docType":mydoucumentType,"frontDoc":"data:image/jpeg;base64,"+imageBase64String!, "backDoc":imageBase64String2,"docNumber":self.idNumber,"txnInfo":payDiv]
            
        }
        CCRequest.shareInstance().request(withURLStringNoLoading: ShuftiPro, methodType: MethodType.POST, params: dict, success: { (responseObject, responseOriginal) in
            
            self.hub.hide(animated: true)
            self.sendConfirmV.dismiss()
            let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            UserDefaults.standard.set(appdelegate.selectCountry, forKey: UserDefaults.standard.string(forKey: ONT_ID)! + "c")
            
            let vc = IMStatusViewController()
            vc.statusType = "1"
            vc.calimFrom = "shufti"
            vc.docType = self.doucumentType
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }) { (error, errorDesc, responseOriginal) in
            self.hub.hide(animated: true)
            self.sendConfirmV.dismiss()
            let dic = responseOriginal as! NSDictionary
            if (dic["Error"] as! NSString).isEqual(to: "62007"){
                Common.showToast("\(dic["Desc"]!)")
                return
            }
            let vc = IMStatusViewController()
            vc.statusType = "3"
            vc.shuftiModel = self.shuftiModel
            vc.calimFrom = "shufti"
            vc.docType = self.doucumentType
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func getFeeString() -> NSMutableAttributedString {
        let cotStr = NSMutableAttributedString.init()
        cotStr.append(appendColorStrWithString(str: "\(LocalizeEx("Fee")) ", font: UIFont.systemFont(ofSize: 24, weight: .medium), color: UIColor(hexString: "#000000")!))
        cotStr.append(appendColorStrWithString(str: Common.getAllFee(shuftiModel.chargeInfo.amount, gasPrice: shuftiModel.chargeInfo.gasPrice, gasLimit: shuftiModel.chargeInfo.gasLimit) , font: UIFont.systemFont(ofSize: 24, weight: .medium), color: UIColor(hexString: "#196BD8")!))
        cotStr.append(appendColorStrWithString(str: " ONG", font: UIFont.systemFont(ofSize: 24, weight: .medium), color: UIColor(hexString: "#000000")!))
        
        return cotStr
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
