//
//  COTMListViewController.swift
//  ONTO
//
//  Created by Apple on 2018/8/29.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)

class COTMListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView?
    var dataArray:NSMutableArray? = []
    var showDic:NSMutableDictionary!
    var getBtn:UIButton!
    var allButton:UIButton!
    var sectionButton:UIButton!
    
    @objc var model : ClaimModel?
    @objc var resultDic : NSDictionary!
    @objc var resultArr : NSArray!
    @objc var resultOArr : NSArray!
    @objc var certArray: NSArray = []
    @objc var oMaxNum: Int = 0
    @objc var oMinNum: Int = 0
    fileprivate lazy var headView = UIView()
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        getdata()
        createUI()
        // Do any additional setup after loading the view.
    }
    
    func getdata() {
        var isFirst: Bool = true
        for (index , str) in resultArr.enumerated() {// str as! String  //"claim:idm_dl_authentication"
            let claimArray = [DataBase.shared().getCalimWithClaimContext((str as! NSDictionary).value(forKey: "ClaimContext") as! String , andOwnerOntId: UserDefaults.standard.value(forKey: ONT_ID) as! String)] as NSArray
            let claimModel = claimArray[0] as! ClaimModel
            if Common.isBlankString(claimModel.ownerOntId) {
                let dic = NSMutableDictionary.init()
                dic["selected"] = "0";
                dic["list"] = [];
                //                self.dataArray?.add([])
                self.dataArray?.add(dic)
            }else{
                let dic = Common.dictionary(withJsonString: claimModel.content) as NSDictionary
                let dic1 = Common.claimdencode(dic.value(forKey: "EncryptedOrigData") as! String) as NSDictionary
                let claimDic = dic1.value(forKey: "claim") as! NSDictionary
                let contentDic = claimDic.value(forKey: "clm") as! NSDictionary
                
                let valueArr = contentDic.allValues
                let keyArr = contentDic.allKeys
                print("valueArr=\(valueArr)")
                print("keyArr=\(keyArr)")
                let listDic = NSMutableDictionary.init()
                listDic["claimContext"] = str
                if isFirst == true{
                    listDic["selected"] = "1"
                    self.showDic = NSMutableDictionary.init()
                    self.showDic.setValue(index, forKey: "select")
                }else{
                    listDic["selected"] = "1"
                }
                
                let listArr :NSMutableArray = []
                for (index , str) in valueArr.enumerated() {
                    let detailDic = NSMutableDictionary.init()
                    if isFirst == true{
                        detailDic["selected"] = "1"
                    }else{
                        detailDic["selected"] = "1"
                    }
                    if (keyArr[index] as! NSString) .isEqual(to: "IssuerName"){
                        
                    }else{
                        
                        detailDic["key"] = "\(str)"
                        listArr.add(detailDic)
                    }
                }
                if isFirst == true{
                    isFirst = false
                }
                listDic["list"] = listArr
                self.dataArray?.add(listDic)
                
                
            }
            
        }
         tableView?.reloadData()
    }
    func createUI() {
        
        let dic = resultArr[0] as! NSDictionary
        print("dic = \(dic["Des"] ?? "")")
        var cotStr = NSMutableAttributedString.init()

        
        cotStr = getAttrString(str: resultDic.value(forKey: "ReqDes") as! String, width: SYSWidth - 112*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 0)
        let cotStrH = getHeight(str: resultDic.value(forKey: "ReqDes") as! String, width: SYSWidth - 112*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 0)
        headView.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: 75*SCALE_W + cotStrH)
        
        let title = UILabel(frame: CGRect(x: 70*SCALE_W, y: 9*SCALE_W, width: SYSWidth - 70*SCALE_W, height: 16*SCALE_W))
        title.textColor = UIColor(hexString: "#9b9b9b")
        title.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        title.textAlignment = .left
        title.text = "\(loacalkey(key: "byCOT")) \(resultDic.value(forKey: "Name")!)"
        title.changeSpace(lineSpace: 0, wordSpace: 2)
        headView.addSubview(title)
        
        let AuthorizationLB = UILabel(frame: CGRect(x: 70*SCALE_W, y: 23*SCALE_W, width: SYSWidth - 70*SCALE_W, height: 28*SCALE_W))
        AuthorizationLB.textColor = UIColor.black
        AuthorizationLB.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        AuthorizationLB.textAlignment = .left
        AuthorizationLB.text = loacalkey(key: "AuthorizationList")
        AuthorizationLB.changeSpace(lineSpace: 2, wordSpace: 3*SCALE_W)
        headView.addSubview(AuthorizationLB)
        
        //        let textMaxSize = CGSize(width: SYSWidth - 112*SCALE_W, height: CGFloat(MAXFLOAT))
        //        let textLabelSize = self.textSize(text:loacalkey(key: "COTNeed") , font: UIFont.systemFont(ofSize: 12, weight: .regular), maxSize: textMaxSize)
        let COTNeedLB = UILabel(frame: CGRect(x: 70*SCALE_W, y: 55*SCALE_W, width: SYSWidth - 112*SCALE_W, height: cotStrH))
        COTNeedLB.textColor = UIColor(hexString: "#9b9b9b")
        COTNeedLB.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        COTNeedLB.textAlignment = .left
        COTNeedLB.numberOfLines = 0
        COTNeedLB.attributedText = cotStr
        headView.addSubview(COTNeedLB)
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight  - 64 - 160*SCALE_W), style: .grouped)
        if UIDevice.current.isX() {
            tableView?.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 34 - 88 - 160*SCALE_W)
        }
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.tableHeaderView = headView
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view?.addSubview(tableView!)
        
        let bottomV = UIView(frame: CGRect(x: 0, y: SYSHeight - 64 - 160*SCALE_W, width: SYSWidth, height: 160*SCALE_W))
        if UIDevice.current.isX() {
            bottomV.frame = CGRect(x: 0, y: SYSHeight - 88 - 160*SCALE_W, width: SYSWidth, height: 160*SCALE_W)
        }
        view.addSubview(bottomV)
        
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
        
        getBtn = UIButton(frame: CGRect(x: 55*SCALE_W, y: 57*SCALE_W, width: SYSWidth - 110*SCALE_W, height: 60*SCALE_W))
        getBtn.setTitle(loacalkey(key: "mobileNext"), for: .normal)
//        getBtn.backgroundColor = UIColor.black
        getBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        getBtn.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 2*SCALE_W)
        getBtn.setTitleColor(UIColor.white , for: .normal)
        getBtn.addTarget(self, action: #selector(toGetCert), for: .touchUpInside)
        bottomV.addSubview(getBtn)
        var num:Int = 0
        for canDic in self.dataArray!{
            if ((canDic as! NSMutableDictionary).value(forKey: "selected") as! NSString) .isEqual(to: "1"){
                num += 1
            }
        }
        if num == resultArr.count {
            getBtn.backgroundColor = UIColor.black
            getBtn.isUserInteractionEnabled = true
        }else{
            getBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
            getBtn.isUserInteractionEnabled = false
        }
        tableView?.reloadData()
    }
    @objc func toGetCert() {
        
        let ClaimIdsArr = NSMutableArray.init()
        let ClaimContextsArr = NSMutableArray.init()
        let ClaimsArr = NSMutableArray.init()
        for sureDic in self.dataArray! {
            if ((sureDic as! NSMutableDictionary).value(forKey: "selected") as! NSString) .isEqual(to: "1"){
                let dic12 = (sureDic as! NSMutableDictionary).value(forKey: "claimContext") as! NSDictionary
                let claimArray = [DataBase.shared().getCalimWithClaimContext(dic12.value(forKey: "ClaimContext") as! String, andOwnerOntId: (UserDefaults.standard.value(forKey: ONT_ID) as! String))] as NSArray
                let claimModel = claimArray[0] as! ClaimModel
                let dic = Common.dictionary(withJsonString: claimModel.content) as NSDictionary
                let dic1_1 = Common.claimdencode((dic.value(forKey: "EncryptedOrigData") as! String)) as NSDictionary
                let dic1 = dic1_1.value(forKey: "claim") as! NSDictionary
                
                ClaimIdsArr.add(dic1["jti"] ?? "")
                
                ClaimContextsArr.add(dic1["context"] ?? "")
                
                ClaimsArr.add(dic["EncryptedOrigData"] ?? "")
                
            }
        }
        if resultOArr.count == 0 {
//            let cotVc = COTListViewController()
//            cotVc.resultDic = resultDic
//            cotVc.certArray = resultArr
//            cotVc.ClaimIdsArr1 = ClaimIdsArr
//            cotVc.ClaimContextsArr1 = ClaimContextsArr
//            cotVc.ClaimsArr1 = ClaimsArr
//            cotVc.oMaxNum =  1
//            cotVc.oMinNum = 1
//            self.navigationController?.pushViewController(cotVc, animated: true)
            
            let params:NSDictionary? = ["OntId":UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "" , "DeviceCode":UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? ""  , "AuthFlag":true , "ThirdPartyOntId":self.resultDic?.value(forKey: "OntId") ?? "did:ont:AZypQgpn7CT5DWA5vQZLcy7pu4Pd72wMp1","Claims":ClaimsArr,"ClaimContexts":ClaimContextsArr,"ClaimIds":ClaimIdsArr]
            CCRequest .shareInstance().request(withURLString: COTConfirm, methodType: .POST, params: params, success: { (responseObject, responseOriginal) in

                let vc = COTStatusViewController()
                vc.statusType = "0"
                self.navigationController?.pushViewController(vc, animated: true)
            }) { (error, errorDesc, responseOriginal) in
                let vc = COTStatusViewController()
                vc.statusType = "1"
                if responseOriginal != nil{
                    vc.errorMsg = (responseOriginal as! NSDictionary).value(forKey: "Desc") as? String

                }

                self.navigationController?.pushViewController(vc, animated: true)

            }
        }else{
            var num1:Int  = 0
            for (index , str) in resultOArr.enumerated() {// str as! String  //"claim:idm_dl_authentication"
                let claimArray = [DataBase.shared().getCalimWithClaimContext(((str as! NSDictionary).value(forKey: "ClaimContext") as! String) , andOwnerOntId: (UserDefaults.standard.value(forKey: ONT_ID) as! String))] as NSArray
                let claimModel = claimArray[0] as! ClaimModel
                if Common.isBlankString(claimModel.ownerOntId) {
                    num1 += 1
                    print(index)
                }
            }
            if num1 < resultOArr.count {
                let cotVc = COTListViewController()
                cotVc.resultDic = resultDic
                cotVc.certArray = resultOArr
                cotVc.ClaimIdsArr1 = ClaimIdsArr
                cotVc.ClaimContextsArr1 = ClaimContextsArr
                cotVc.ClaimsArr1 = ClaimsArr
                cotVc.oMaxNum =  oMaxNum
                cotVc.oMinNum = oMinNum
                self.navigationController?.pushViewController(cotVc, animated: true)
            }else{
                let vc = GetCertViewController()
                vc.certArray = resultOArr
                vc.resultDic = resultDic
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return resultArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dic = self.dataArray![section] as! NSDictionary
        let arr = dic["list"] as! NSArray
        return arr.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHead = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 98*SCALE_W))
        let AuthorizationLB = UILabel(frame: CGRect(x: 75*SCALE_W, y: 0*SCALE_W, width: SYSWidth - 107*SCALE_W, height: 25*SCALE_W))
        AuthorizationLB.textColor = UIColor.black
        AuthorizationLB.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        AuthorizationLB.textAlignment = .left
        sectionHead.addSubview(AuthorizationLB)
        
        sectionButton = COTButton(frame: CGRect(x: 40*SCALE_W, y: 2.5*SCALE_W, width: 28.5*SCALE_W, height: 22*SCALE_W))
        sectionButton.setImage(UIImage(named: "cotIcon_Selected-big"), for: .normal)
        sectionButton.setEnlargeEdge(20)
        (sectionButton as! COTButton).sectionTag = section
        sectionHead.addSubview(sectionButton)
        
        let dic = self.dataArray![section] as! NSMutableDictionary

       
        let dic1 = resultArr[section] as! NSDictionary
        AuthorizationLB.text =  dic1["Name"] as? String
        
           AuthorizationLB.changeSpace(lineSpace: 0, wordSpace: 1*SCALE_W)
        let nameH = getHeight(str: dic1["Name"] as! String, width: SYSWidth - 107*SCALE_W, font: UIFont.systemFont(ofSize: 18, weight: .bold), lineSpace: 1, wordSpace: 1*SCALE_W)
        AuthorizationLB.frame = CGRect(x: 75*SCALE_W, y: 0*SCALE_W, width: SYSWidth - 107*SCALE_W, height: nameH)
        
        let arr = dic["list"] as! NSArray
        if arr.count == 0 {
            sectionHead.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: 80*SCALE_W)
            sectionButton.setImage(UIImage(named: "coticon-none"), for: .normal)
            let sorryLB = UILabel(frame: CGRect(x: 75*SCALE_W, y: 30*SCALE_W, width: SYSWidth - 137*SCALE_W, height: 40*SCALE_W + 4))
            sorryLB.textColor = UIColor.black
            sorryLB.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            sorryLB.textAlignment = .left
            sorryLB.numberOfLines = 0
            sorryLB.text =  loacalkey(key: "COTFirst")
            sorryLB.changeSpace(lineSpace: 1.5, wordSpace: 2)
            sectionHead.addSubview(sorryLB)
        }else{
            if (dic["selected"] as! NSString) .isEqual(to: "1"){
                sectionButton.setImage(UIImage(named: "cotIcon_Selected-big"), for: .normal)
            }else{
                sectionButton.setImage(UIImage(named: "cotbigunselect"), for: .normal)
            }
        
        let str = getAttrString(str: dic1["Des"] as! String, width: SYSWidth - 137*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 2)
        let strH = getHeight(str: dic1["Des"] as! String, width: SYSWidth - 137*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 2)
            let AuthorizationLB1 = UILabel(frame: CGRect(x: 75*SCALE_W, y: 30*SCALE_W, width: SYSWidth - 137*SCALE_W, height: strH))
            AuthorizationLB1.textColor = UIColor(hexString: "#9B9B9B")
            AuthorizationLB1.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            AuthorizationLB1.textAlignment = .left
            AuthorizationLB1.numberOfLines = 0
            AuthorizationLB1.attributedText = str
//            AuthorizationLB1.changeSpace(lineSpace: 0, wordSpace: 1.67)
            sectionHead.addSubview(AuthorizationLB1)
        }
            
//            if section != (self.showDic["select"] as! Int){
//                sectionHead.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: 25*SCALE_W)
//                AuthorizationLB1.isHidden = true
//            }
//        }
        
        //
        return sectionHead
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dic = self.dataArray![section] as! NSMutableDictionary
        let arr = dic["list"] as! NSArray
        if arr.count == 0 {
            return 90*SCALE_W
        }
        let authDic = dic["claimContext"] as! NSDictionary
        print(authDic)
        let nameH = getHeight(str: authDic["Name"] as! String, width: SYSWidth - 107*SCALE_W, font: UIFont.systemFont(ofSize: 18, weight: .bold), lineSpace: 1, wordSpace: 1*SCALE_W) //dic1["Name"] as? String
        let strH = getHeight(str:  authDic["Des"] as! String, width: SYSWidth - 137*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 2)
        print("dd \(37*SCALE_W + strH)")
        return 5*SCALE_W + strH + nameH
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dic = self.dataArray![indexPath.section] as! NSMutableDictionary
        let arr = dic["list"] as! NSArray
        let contentDic = arr[indexPath.row] as! NSDictionary
        
        let cellH = getHeight(str: contentDic.value(forKey: "key") as! String, width: SYSWidth - 164*SCALE_W, font: UIFont.systemFont(ofSize: 12), lineSpace: 1.5, wordSpace: 2*SCALE_W)
        return 23*SCALE_W + cellH
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:COTTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? COTTableViewCell
        if cell == nil {
            cell = COTTableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        let dic = self.dataArray![indexPath.section] as! NSMutableDictionary
        let arr = dic["list"] as! NSArray
        print("arr=\(arr)")
        let contentDic = arr[indexPath.row] as! NSDictionary
        if (contentDic["selected"] as! NSString) .isEqual(to: "1"){
            cell.selectedBtn?.setImage(UIImage(named: "cotIcon_Selected-big"), for: .normal)
        }else{
            cell.selectedBtn?.setImage(UIImage(named: "cotbigunselect"), for: .normal)
        }
        let cellStr = getAttrString(str: contentDic.value(forKey: "key") as! String, width: SYSWidth - 164*SCALE_W, font: UIFont.systemFont(ofSize: 12), lineSpace: 1.5, wordSpace: 2*SCALE_W)
        let cellH = getHeight(str: contentDic.value(forKey: "key") as! String, width: SYSWidth - 164*SCALE_W, font: UIFont.systemFont(ofSize: 12), lineSpace: 1.5, wordSpace: 2*SCALE_W)
        cell.titleLabel?.frame = CGRect(x: 106*SCALE_W, y: 9.5*SCALE_W, width: SYSWidth - 164*SCALE_W, height: cellH)
        cell.titleLabel?.attributedText = cellStr
        (cell.selectedBtn as! COTButton).sectionTag = indexPath.section
        (cell.selectedBtn as! COTButton).rowTag = indexPath.row
//        cell.selectedBtn?.addTarget(self, action: #selector(cellButtonClick(button:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionFoot = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 58*SCALE_W))
        
        let typeLB = UILabel(frame: CGRect(x: 0, y: 0, width: SYSWidth - 34*SCALE_W, height: 16*SCALE_W))
        typeLB.textAlignment = .right
        typeLB.changeSpace(lineSpace: 0, wordSpace: 1)
        typeLB.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        sectionFoot.addSubview(typeLB)
        let dic = self.dataArray![section] as! NSDictionary
        let arr = dic["list"] as! NSArray
        if arr.count == 0 {
            typeLB.textColor = UIColor(hexString: "#196BD8")
            typeLB.text =  loacalkey(key: "IMGetCert")
            let typeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: SYSWidth - 34*SCALE_W, height: 16*SCALE_W))
            typeBtn.handleControlEvent(.touchUpInside) {
                
                let socialArr = UserDefaults.standard.value(forKey: SOCIALAUCHARR) as! NSArray
                let authArr = UserDefaults.standard.value(forKey: IDAUTHARR) as! NSArray
                let mArr = [IdentityModel.mj_objectArray(withKeyValuesArray: authArr)] as! NSMutableArray
                
                let dic1 = self.resultArr[section] as! NSDictionary
                if (dic1["ClaimContext"] as! NSString).isEqual(to: "claim:mobile_authentication"){
                    let vc = NewMobileViewController()
                    vc.claimContext = dic1["ClaimContext"] as? String
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if (dic1["ClaimContext"] as! NSString).isEqual(to: "claim:email_authentication"){
                    let vc = NewEmailViewController()
                    vc.claimContext = dic1["ClaimContext"] as? String
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if (dic1["ClaimContext"] as! NSString).isEqual(to: "claim:cfca_authentication"){
                    let vc = AuthInfoViewController()
                    vc.typeImage = "logo-cfca"
                    vc.typeString = LocalizeEx("authInfoDetail")
                    
                    for subDic in authArr{
                        let ClaimContextStr =  (subDic as! NSDictionary).value(forKey: "ClaimContext") as! NSString
                        let claimImage = (subDic as! NSDictionary).value(forKey: "HeadLogo")
                        if ClaimContextStr.isEqual(to: "claim:cfca_authentication"){
                            vc.claimImage = (claimImage as! String)
                            for cModel in  mArr{
                                if ((cModel as! IdentityModel).claimContext as NSString) .isEqual(to: "claim:cfca_authentication"){
                                    vc.chargeModel = (cModel as! IdentityModel)
                                }
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                }else if (dic1["ClaimContext"] as! NSString).isEqual(to: "claim:sensetime_authentication"){
                    
                    let vc = AuthInfoViewController()
                    vc.typeImage = "shangtang"
                    vc.typeString = LocalizeEx("shangtangInfo")
                    for subDic in authArr{
                        let ClaimContextStr =  (subDic as! NSDictionary).value(forKey: "ClaimContext") as! NSString
                        let claimImage = (subDic as! NSDictionary).value(forKey: "HeadLogo")
                        if ClaimContextStr.isEqual(to: "claim:sensetime_authentication"){
                            vc.claimImage = (claimImage as! String)
                            for cModel in  mArr{
                                if ((cModel as! IdentityModel).claimContext as NSString) .isEqual(to: "claim:sensetime_authentication"){
                                    vc.chargeModel = (cModel as! IdentityModel)
                                }
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                }else if (dic1["ClaimContext"] as! NSString).isEqual(to: "claim:linkedin_authentication"){
                    let vc = WebIdentityViewController()
                    vc.identityType = IdentityType(rawValue: 1)
                    for subDic in socialArr{
                        let ClaimContextStr =  (subDic as! NSDictionary).value(forKey: "ClaimContext") as! NSString
                        let claimImage = (subDic as! NSDictionary).value(forKey: "HeadLogo")
                        let claimurl = (subDic as! NSDictionary).value(forKey: "H5ReqParam")
                        if ClaimContextStr.isEqual(to: "claim:linkedin_authentication"){
                            vc.claimImage = (claimImage as! String)
                            vc.claimurl = (claimurl as! String)
                           self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                }else if (dic1["ClaimContext"] as! NSString).isEqual(to: "claim:github_authentication"){
                    //2
                    let vc = WebIdentityViewController()
                    vc.identityType = IdentityType(rawValue: 2)
                    for subDic in socialArr{
                        let ClaimContextStr =  (subDic as! NSDictionary).value(forKey: "ClaimContext") as! NSString
                        let claimImage = (subDic as! NSDictionary).value(forKey: "HeadLogo")
                        let claimurl = (subDic as! NSDictionary).value(forKey: "H5ReqParam")
                        if ClaimContextStr.isEqual(to: "claim:github_authentication"){
                            vc.claimImage = (claimImage as! String)
                            vc.claimurl = (claimurl as! String)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }else if (dic1["ClaimContext"] as! NSString).isEqual(to: "claim:facebook_authentication"){
                    //3
                    let vc = WebIdentityViewController()
                    vc.identityType = IdentityType(rawValue: 3)
                    for subDic in socialArr{
                        let ClaimContextStr =  (subDic as! NSDictionary).value(forKey: "ClaimContext") as! NSString
                        let claimImage = (subDic as! NSDictionary).value(forKey: "HeadLogo")
                        let claimurl = (subDic as! NSDictionary).value(forKey: "H5ReqParam")
                        if ClaimContextStr.isEqual(to: "claim:facebook_authentication"){
                            vc.claimImage = (claimImage as! String)
                            vc.claimurl = (claimurl as! String)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }else if (dic1["ClaimContext"] as! NSString).isEqual(to: "claim:twitter_authentication"){
                    //0
                    let vc = WebIdentityViewController()
                    vc.identityType = IdentityType(rawValue: 0)
                    for subDic in socialArr{
                        let ClaimContextStr =  (subDic as! NSDictionary).value(forKey: "ClaimContext") as! NSString
                        let claimImage = (subDic as! NSDictionary).value(forKey: "HeadLogo")
                        let claimurl = (subDic as! NSDictionary).value(forKey: "H5ReqParam")
                        if ClaimContextStr.isEqual(to: "claim:twitter_authentication"){
                            vc.claimImage = (claimImage as! String)
                            vc.claimurl = (claimurl as! String)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }else if (dic1["ClaimContext"] as! NSString).contains("claim:sfp"){
                    let authArr = UserDefaults.standard.value(forKey: APPAUCHARR) as! NSArray
                    let vc = AuthInfoViewController()
                    vc.typeImage = "SHUFTIPRO";
                    vc.modelArr = [IdentityModel.mj_objectArray(withKeyValuesArray: authArr)]
                    vc.typeString =  LocalizeEx("Shufti_Introduce")
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let authArr = UserDefaults.standard.value(forKey: APPAUCHARR) as! NSArray
                    let vc = AuthInfoViewController()
                    vc.typeImage = "cotinnerlogo";
                    vc.modelArr = [IdentityModel.mj_objectArray(withKeyValuesArray: authArr)]
                    vc.typeString =  LocalizeEx("IM_Introduce")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            sectionFoot.addSubview(typeBtn)
        }
        let line = UIView(frame: CGRect(x: 76*SCALE_W, y: 20*SCALE_W, width: SYSWidth - 108*SCALE_W, height: 1))
        line.backgroundColor = UIColor(hexString: "#9B9B9B")
        sectionFoot.addSubview(line)
        
        return sectionFoot
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 58*SCALE_W
    }
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        
        return bundle
        
    }
    
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
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
    func appendColorStrWithString(str:String,font:CGFloat,color:UIColor) -> NSMutableAttributedString {
        var attributedString : NSMutableAttributedString
        let attStr = NSMutableAttributedString.init(string: str, attributes: [kCTFontAttributeName as NSAttributedStringKey : UIFont.systemFont(ofSize: font),NSAttributedStringKey.foregroundColor:color])
        attributedString = NSMutableAttributedString.init(attributedString: attStr)
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
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [ kCTFontAttributeName as NSAttributedStringKey : font ], context: nil).size
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
