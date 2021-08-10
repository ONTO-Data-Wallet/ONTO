//
//  COTOListViewController.swift
//  ONTO
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018 Zeus. All rights reserved.
//



import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)

class COTOListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView?
    var dataArray:NSMutableArray? = []
    var showDic:NSMutableDictionary!
    var getBtn:UIButton!
    var allButton:UIButton!
    var sectionButton:UIButton!
    
    @objc var model : ClaimModel?
    @objc var resultDic : NSDictionary!
    @objc var certArray: NSArray = []
    @objc var ClaimIdsArr1: NSArray = []
    @objc var ClaimContextsArr1: NSArray = []
    @objc var ClaimsArr1: NSArray = []
    @objc var oMaxNum: Int = 0
    @objc var oMinNum: Int = 0
    
    fileprivate lazy var headView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        var isFirst: Bool = true
        for (index , str) in certArray.enumerated() {// str as! String  //"claim:idm_dl_authentication"
            let claimArray = [DataBase.shared().getCalimWithClaimContext((str as! NSDictionary).value(forKey: "ClaimContext") as? String , andOwnerOntId: UserDefaults.standard.value(forKey: ONT_ID) as? String)] as NSArray
            let claimModel = claimArray[0] as! ClaimModel
            if Common.isBlankString(claimModel.ownerOntId) {
                let dic = NSMutableDictionary.init()
                dic["selected"] = "0";
                dic["allSelected"] = "0"
                dic["list"] = [];
                self.dataArray?.add(dic)
            }else{
                let dic = Common.dictionary(withJsonString: claimModel.content) as NSDictionary
                let dic1 = Common.claimdencode(dic.value(forKey: "EncryptedOrigData") as? String) as NSDictionary
                let claimDic = dic1.value(forKey: "claim") as! NSDictionary
                let contentDic = claimDic.value(forKey: "clm") as! NSDictionary
                
                let valueArr = contentDic.allValues
                let keyArr = contentDic.allKeys
                let listDic = NSMutableDictionary.init()
                listDic["claimContext"] = str
                if isFirst == true{
                    listDic["selected"] = "0"
                    //                    self.showDic = NSMutableDictionary.init()
                    //                    self.showDic.setValue(index, forKey: "select")
                }else{
                    listDic["selected"] = "0"
                }
                listDic["allSelected"] = "0"
                let listArr :NSMutableArray = []
                for (index , str) in valueArr.enumerated() {
                    let detailDic = NSMutableDictionary.init()
                    if isFirst == true{
                        detailDic["selected"] = "0"
                    }else{
                        detailDic["selected"] = "0"
                    }
                    if (keyArr[index] as! NSString) .isEqual(to: "IssuerName"){
                        
                    }else{
                        
                        detailDic["key"] = str as? String
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
        createUI()
    }
    func createUI() {
        
        //        let
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
        
        getBtn.setTitle(loacalkey(key: "COTCONFIRMAUTHORIZE"), for: .normal)
        
        
        getBtn.backgroundColor = UIColor.black
        getBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        getBtn.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 2*SCALE_W)
        getBtn.setTitleColor(UIColor.white , for: .normal)
        bottomV.addSubview(getBtn)
        getBtn.addTarget(self, action: #selector(toGetCert), for: .touchUpInside)
    }
    @objc func toGetCert() {
        
        let ClaimIdsArr = NSMutableArray.init()
        let ClaimContextsArr = NSMutableArray.init()
        let ClaimsArr = NSMutableArray.init()
        var sureNum : Int = 0
        for sureDic in self.dataArray! {
            if ((sureDic as! NSMutableDictionary).value(forKey: "selected") as! NSString) .isEqual(to: "1"){
                let dic12 = (sureDic as! NSMutableDictionary).value(forKey: "claimContext") as! NSDictionary
                let claimArray = [DataBase.shared().getCalimWithClaimContext(dic12.value(forKey: "ClaimContext") as? String, andOwnerOntId: UserDefaults.standard.value(forKey: ONT_ID) as? String)] as NSArray
                let claimModel = claimArray[0] as! ClaimModel
                let dic = Common.dictionary(withJsonString: claimModel.content) as NSDictionary
                let dic1_1 = Common.claimdencode(dic.value(forKey: "EncryptedOrigData") as? String) as NSDictionary
                let dic1 = dic1_1.value(forKey: "claim") as! NSDictionary
                
                ClaimIdsArr.add(dic1["jti"] ?? "")
                ClaimContextsArr.add(dic1["context"] ?? "")
                ClaimsArr.add(dic["EncryptedOrigData"] ?? "")
                sureNum += 1
            }
        }
        if sureNum < oMinNum {
            let alertString = Common.authMoreLeftString(loacalkey(key: "authShao"), numString: "\(oMinNum)")
            Common.showToast(alertString)
            return
        }
        ClaimIdsArr.addObjects(from: ClaimIdsArr1 as! [Any])
        ClaimsArr.addObjects(from: ClaimsArr1 as! [Any])
        ClaimContextsArr.addObjects(from: ClaimContextsArr1 as! [Any])
        let params:NSDictionary? = ["OntId":UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "" , "DeviceCode":UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? ""  , "AuthFlag":true , "ThirdPartyOntId":self.resultDic?.value(forKey: "OntId") ?? "did:ont:AZypQgpn7CT5DWA5vQZLcy7pu4Pd72wMp1","Claims":ClaimsArr,"ClaimContexts":ClaimContextsArr,"ClaimIds":ClaimIdsArr]
        print("params=\(params!)")
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
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return certArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dic = self.dataArray![section] as! NSDictionary
        let arr = dic["list"] as! NSArray
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if indexPath.section != (self.showDic["select"] as! Int){
        //            return 0.01
        //        }
        
        
        let dic = self.dataArray![indexPath.section] as! NSMutableDictionary
        
        let arr = dic["list"] as! NSArray
        let contentDic = arr[indexPath.row] as! NSDictionary
        
        if (dic.value(forKey: "selected" ) as! NSString).isEqual(to: "1") {
        }else{
            var isListSelected :Bool = false
            for cellDic in arr {
                if ((cellDic as! NSMutableDictionary).value(forKey: "selected" ) as! NSString).isEqual(to: "1"){
                    isListSelected = true
                }
            }
            if  !isListSelected {
                
                return 0.01
            }
        }
        let cellH = getHeight(str: contentDic.value(forKey: "key") as! String, width: SYSWidth - 164*SCALE_W, font: UIFont.systemFont(ofSize: 12), lineSpace: 1.5, wordSpace: 2*SCALE_W)
        return 23*SCALE_W + cellH
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHead = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 98*SCALE_W))
        let AuthorizationLB = UILabel(frame: CGRect(x: 75*SCALE_W, y: 0*SCALE_W, width: SYSWidth - 107*SCALE_W, height: 25*SCALE_W))
        AuthorizationLB.textColor = UIColor.black
        AuthorizationLB.numberOfLines = 0
        AuthorizationLB.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        AuthorizationLB.textAlignment = .left
        sectionHead.addSubview(AuthorizationLB)
        
        sectionButton = COTButton(frame: CGRect(x: 40*SCALE_W, y: 2.5*SCALE_W, width: 28.5*SCALE_W, height: 22*SCALE_W))
        sectionButton.setImage(UIImage(named: "cotIcon_Selected-big"), for: .normal)
        sectionButton.setEnlargeEdge(20)
        sectionButton.isUserInteractionEnabled = true
        (sectionButton as! COTButton).sectionTag = section
        sectionButton.addTarget(self, action: #selector(sectionButtonClick(button:)), for: .touchUpInside)
        sectionHead.addSubview(sectionButton)
        
        let dic1 = certArray[section] as! NSDictionary
        AuthorizationLB.text =  dic1["Name"] as? String
        let nameH = getHeight(str: dic1["Name"] as! String, width: SYSWidth - 107*SCALE_W, font: UIFont.systemFont(ofSize: 18, weight: .bold), lineSpace: 1, wordSpace: 2)
        AuthorizationLB.frame = CGRect(x: 75*SCALE_W, y: 0*SCALE_W, width: SYSWidth - 107*SCALE_W, height: nameH)
        //        if section == 0 {
        //             AuthorizationLB.text =  loacalkey(key: "IM_Passport")
        //        }else if section == 1{
        //             AuthorizationLB.text =  loacalkey(key: "IM_IDCard")
        //        }else{
        //             AuthorizationLB.text =  loacalkey(key: "IM_DriverLicense")
        //        }
        AuthorizationLB.changeSpace(lineSpace: 0, wordSpace: 1*SCALE_W)
        
        
        let dic = self.dataArray![section] as! NSMutableDictionary
        let arr = dic["list"] as! NSArray
        if arr.count == 0 {
            sectionHead.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: 80*SCALE_W)
            sectionButton.setImage(UIImage(named: "coticon-none"), for: .normal)
            sectionButton.isUserInteractionEnabled = false
            let sorryLB = UILabel(frame: CGRect(x: 75*SCALE_W, y: nameH + 5*SCALE_W, width: SYSWidth - 137*SCALE_W, height: 40*SCALE_W + 4))
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
            
            let str = getAttrString(str:  dic1["Des"] as! String, width: SYSWidth - 137*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 2)
            let strH = getHeight(str:  dic1["Des"] as! String, width: SYSWidth - 137*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 2)
            let AuthorizationLB1 = UILabel(frame: CGRect(x: 75*SCALE_W, y: nameH + 5*SCALE_W, width: SYSWidth - 137*SCALE_W, height: strH))
            AuthorizationLB1.textColor = UIColor(hexString: "#9B9B9B")
            AuthorizationLB1.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            AuthorizationLB1.textAlignment = .left
            AuthorizationLB1.numberOfLines = 0
            AuthorizationLB1.attributedText = str
            AuthorizationLB1.changeSpace(lineSpace: 0, wordSpace: 1.67)
            sectionHead.addSubview(AuthorizationLB1)
            
            //            if section != (self.showDic["select"] as! Int){
            //                sectionHead.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: 25*SCALE_W)
            //                AuthorizationLB1.isHidden = true
            //            }
            if (dic.value(forKey: "selected" ) as! NSString).isEqual(to: "1") {
            }else{
                var isListSelected :Bool = false
                for cellDic in arr {
                    if ((cellDic as! NSMutableDictionary).value(forKey: "selected" ) as! NSString).isEqual(to: "1"){
                        isListSelected = true
                    }
                }
                if !isListSelected{
                    
                    sectionHead.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: 25*SCALE_W)
                    AuthorizationLB1.isHidden = true
                }
            }
        }
        
        //
        return sectionHead
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dic = self.dataArray![section] as! NSMutableDictionary
        let arr = dic["list"] as! NSArray
        if arr.count == 0 {
            return 90*SCALE_W
        }
        //        if section != (self.showDic["select"] as! Int){
        //            return 35*SCALE_W
        //        }
        if (dic.value(forKey: "selected" ) as! NSString).isEqual(to: "1") {
        }else{
            var isListSelected :Bool = false
            for cellDic in arr {
                if ((cellDic as! NSMutableDictionary).value(forKey: "selected" ) as! NSString).isEqual(to: "1"){
                    isListSelected = true
                }
            }
            if !isListSelected{
                return 35*SCALE_W
            }
        }
        let authDic = dic["claimContext"] as! NSDictionary
        let nameH = getHeight(str: authDic["Name"] as! String, width: SYSWidth - 107*SCALE_W, font: UIFont.systemFont(ofSize: 18, weight: .bold), lineSpace: 1, wordSpace: 2)
        let strH = getHeight(str: loacalkey(key: "COTPassword"), width: SYSWidth - 137*SCALE_W, font: UIFont.systemFont(ofSize: 12, weight: .regular), lineSpace: 1.5, wordSpace: 2)
        return 5*SCALE_W + strH + nameH
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
            typeBtn.tag = section
            //            typeBtn.addTarget(self, action: #selector(getCert), for: .touchUpInside)
            typeBtn.addTarget(self, action: #selector(getCert(button:)), for: .touchUpInside)
            sectionFoot.addSubview(typeBtn)
        }else{
            let dic11 = certArray[section] as! NSDictionary
            if (dic11.value(forKey: "ClaimContext") as! NSString).isEqual(to: "claim:cfca_authentication"){
                typeLB.text =  loacalkey(key: "IMCFCA")
                //IMSenseTime
            }else if (dic11.value(forKey: "ClaimContext") as! NSString).isEqual(to: "claim:sensetime_authentication"){
                typeLB.text =  loacalkey(key: "IMSenseTime")
            }
            else{
                typeLB.text =  loacalkey(key: "IMById")
            }
            typeLB.textColor = UIColor.black
            
        }
        let line = UIView(frame: CGRect(x: 76*SCALE_W, y: 20*SCALE_W, width: SYSWidth - 108*SCALE_W, height: 1))
        line.backgroundColor = UIColor(hexString: "#9B9B9B")
        sectionFoot.addSubview(line)
        
        return sectionFoot
    }
    @objc func getCert(button:UIButton) {
        let dic11 = certArray[button.tag] as! NSDictionary
        if (dic11.value(forKey: "ClaimContext") as! NSString).isEqual(to: "claim:cfca_authentication"){
            let arr = UserDefaults.standard.value(forKey: IDAUTHARR) as! NSArray
            let modelArr = [IdentityModel.mj_objectArray(withKeyValuesArray: arr)] as NSArray
            let arr12 = modelArr[0] as! NSArray
            for cModel in  arr12{
                print((cModel as! IdentityModel).claimContext)
                if ((cModel as! IdentityModel).claimContext as NSString) .isEqual(to: "claim:cfca_authentication"){
                    let vc = AuthInfoViewController()
                    vc.typeImage = "logo-cfca"
                    vc.claimImage = ((cModel as! IdentityModel).headLogo as NSString) as String?
                    vc.typeString = loacalkey(key: "authInfoDetail")
                    vc.chargeModel = (cModel as! IdentityModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return
        }else if (dic11.value(forKey: "ClaimContext") as! NSString).isEqual(to: "claim:sensetime_authentication"){
            let arr = UserDefaults.standard.value(forKey: IDAUTHARR) as! NSArray
            let modelArr = [IdentityModel.mj_objectArray(withKeyValuesArray: arr)] as NSArray
            let arr12 = modelArr[0] as! NSArray
            for cModel in  arr12{
                print((cModel as! IdentityModel).claimContext)
                if ((cModel as! IdentityModel).claimContext as NSString) .isEqual(to: "claim:sensetime_authentication"){
                    let vc = AuthInfoViewController()
                    vc.typeImage = "shangtang"
                    vc.claimImage = ((cModel as! IdentityModel).headLogo as NSString) as String?
                    vc.typeString = LocalizeEx("shangtangInfo")
                    vc.chargeModel = (cModel as! IdentityModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return
        }else if (dic11["ClaimContext"] as! NSString).contains("claim:sfp"){
            //    是否认证过
            let str = UserDefaults.standard.value(forKey: ONT_ID) as! String
            if (UserDefaults.standard.value(forKey: "\(str)c") != nil) {
                print("111")
                let arr = UserDefaults.standard.value(forKey: APPAUCHARR) as! NSArray
                
                //            self.appNativeArr = [IdentityModel mj_objectArrayWithKeyValuesArray:AppNativeListArr];
                var array = NSArray.init()
                array = [IdentityModel.mj_objectArray(withKeyValuesArray: arr)]
                
                
                let vc = ShuftiDocViewController()
                vc.myStatus = "1"
                
                vc.modelArr = array[0] as? NSArray
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.selectCountry = UserDefaults.standard.value(forKey: "\(str)c") as? String
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                print("222")
                let authArr = UserDefaults.standard.value(forKey: APPAUCHARR) as! NSArray
                let vc = AuthInfoViewController()
                vc.typeImage = "SHUFTIPRO";
                vc.modelArr = [IdentityModel.mj_objectArray(withKeyValuesArray: authArr)]
                vc.typeString =  LocalizeEx("Shufti_Introduce")
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        else{
            //    是否认证过
            let str = UserDefaults.standard.value(forKey: ONT_ID) as! String
            if (UserDefaults.standard.value(forKey: "\(str)c") != nil) {
                let arr = UserDefaults.standard.value(forKey: APPAUCHARR) as! NSArray
                
                var array = NSArray.init()
                array = [IdentityModel.mj_objectArray(withKeyValuesArray: arr)]
                
                let vc = DocTypeViewController()
                vc.myStatus = "1"
                vc.modelArr = array[0] as? NSArray
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.selectCountry = UserDefaults.standard.value(forKey: "\(str)c") as? String
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
        
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 58*SCALE_W
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:COTTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? COTTableViewCell
        if cell == nil {
            cell = COTTableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        let dic = self.dataArray![indexPath.section] as! NSMutableDictionary
        let arr = dic["list"] as! NSArray
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
        cell.selectedBtn?.addTarget(self, action: #selector(cellButtonClick(button:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        var isCan:Bool = false
        for canDic in self.dataArray!{
            if ((canDic as! NSMutableDictionary).value(forKey: "selected") as! NSString) .isEqual(to: "1"){
                isCan = true
            }
        }
        if isCan == true {
            getBtn.backgroundColor = UIColor.black
            getBtn.isUserInteractionEnabled = true
        }else{
            getBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
            getBtn.isUserInteractionEnabled = false
        }
        //        if indexPath.section != (self.showDic["select"] as! Int){
        //            cell.isHidden = true
        //        }
        if (dic.value(forKey: "selected" ) as! NSString).isEqual(to: "1") {
        }else{
            var isListSelected :Bool = false
            for cellDic in arr {
                if ((cellDic as! NSMutableDictionary).value(forKey: "selected" ) as! NSString).isEqual(to: "1"){
                    isListSelected = true
                }
            }
            if !isListSelected {
                cell.isHidden = true
            }
        }
        return cell
        
    }
    @objc func sectionButtonClick(button:COTButton) {
        let dic = self.dataArray![button.sectionTag!] as! NSMutableDictionary
        var sectionSelected: Bool = true
        let arr = dic["list"] as! NSArray
        if (dic["selected"] as! NSString) .isEqual(to: "1") {
            sectionSelected = false
            dic.setValue("0", forKey: "selected")
        }else{
            
            
            // 判断是否超限
            var selectNum : Int = 0
            for sureDic in self.dataArray! {
                if ((sureDic as! NSMutableDictionary).value(forKey: "selected") as! NSString) .isEqual(to: "1"){
                    selectNum += 1
                }
            }
            
            
            if selectNum >= oMaxNum {
                sectionSelected = false
                let alertString = Common.authMoreLeftString(loacalkey(key: "authMore"), numString: "\(oMaxNum)")
                Common.showToast(alertString)
                return;
            }
            sectionSelected = true
            dic.setValue("1", forKey: "selected")
        }
        
        for cellDic in arr {
            if sectionSelected == true{
                (cellDic as! NSMutableDictionary).setValue("1", forKey: "selected")
            }else{
                (cellDic as! NSMutableDictionary).setValue("0", forKey: "selected")
            }
        }
        for (index , item) in self.dataArray!.enumerated()
        {
            //            print("下标\(index) 值为\(item)")
            //            if index != button.sectionTag {
            //                (item as! NSMutableDictionary).setValue("0", forKey: "selected")
            //                let allArr = (item as! NSMutableDictionary)["list"] as! NSArray
            //                for allDic in allArr{
            //                    (allDic as! NSMutableDictionary).setValue("0", forKey: "selected")
            //                }
            //            }
            if ((item as! NSMutableDictionary)["selected"] as! NSString) .isEqual(to: "0") {
                let allArr = (item as! NSMutableDictionary)["list"] as! NSArray
                for allDic in allArr{
                    (allDic as! NSMutableDictionary).setValue("0", forKey: "selected")
                }
            }
        }
        //        self.showDic.setValue(button.sectionTag, forKey: "select")
        self.tableView?.reloadData()
    }
    @objc func cellButtonClick(button: COTButton) {
        let dic = self.dataArray![button.sectionTag!] as! NSMutableDictionary
        let arr = dic["list"] as! NSArray
        let cellDic = arr[button.rowTag!] as! NSMutableDictionary
        
        if (cellDic["selected"] as! NSString) .isEqual(to: "1"){
            cellDic .setValue("0", forKey: "selected")
        }else{
            cellDic .setValue("1", forKey: "selected")
        }
        var sectionSelected: Bool = true
        
        for cellArray in arr {
            
            var selectedCell:Bool
            if ((cellArray as! NSDictionary)["selected"] as! NSString) .isEqual(to: "1"){
                selectedCell = true
            }else{
                selectedCell = false
            }
            sectionSelected = sectionSelected && selectedCell
        }
        if sectionSelected == true {
            dic.setValue("1", forKey: "selected")
        }else{
            dic.setValue("0", forKey: "selected")
        }
        self.tableView?.reloadData()
        print(dic)
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
        let attStr = NSMutableAttributedString.init(string: str, attributes: [kCTFontAttributeName as NSAttributedStringKey : UIFont.systemFont(ofSize: font),kCTForegroundColorAttributeName as NSAttributedStringKey:color])
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
    
    
}
