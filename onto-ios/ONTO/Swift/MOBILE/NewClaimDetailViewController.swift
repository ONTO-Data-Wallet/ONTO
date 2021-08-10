//
//  NewClaimDetailViewController.swift
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
class NewClaimDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @objc var statusType: String!
    @objc var contentStr: String!
    @objc var contentStrLeft: String!
    @objc var claimContext:String!
    var claimId:String?
    
    var tableView:UITableView?
    var dataArray:NSMutableArray? = []
    var dataContentArray:NSMutableArray? = []
    
    var getBtn:UIButton!
    var bottomV:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNav()
        createUI()
        getdata()
        // Do any additional setup after loading the view.
    }
    func getdata()  {
        let claimArray = [DataBase.shared().getCalimWithClaimContext(self.claimContext, andOwnerOntId: UserDefaults.standard.value(forKey: ONT_ID) as! String)] as NSArray
        let claimModel = claimArray[0] as! ClaimModel
        if Common.isBlankString(claimModel.ownerOntId) {
            getInfo()
        }else{
            handleData(dic: Common.dictionary(withJsonString: claimModel.content)! as NSDictionary)
        }
    }
    func handleData(dic:NSDictionary)  {
        
        
        let claimData =  Common.claimdencode( dic.value(forKey: "EncryptedOrigData") as! String) as NSDictionary
        let claimDic = claimData.value(forKey: "claim") as! NSDictionary
        let contentDic = claimDic["clm"] as! NSDictionary
        
        dataArray = NSMutableArray.init()
        dataContentArray = NSMutableArray.init()
        dataArray?.add(contentDic.allKeys)
        dataContentArray?.add(contentDic.allValues)
        
        let arr = NSMutableArray.init()//[NSMutableArray arrayWithArray:_dataArray[0]];
        arr.add(dataArray![0])
        
        if Common.isBlankString((dic as AnyObject).value(forKey: "TxnHash") as! String) {
            let allKey = [ loacalkey(key: "authStatus"), loacalkey(key: "COTCreated"),loacalkey(key: "COTExpireTime") ]
            let allValue = [ loacalkey(key: "IMStatusSuccess"),Common.getTimeFromTimestamp("\(String(describing: claimDic["iat"]!))"),Common.getTimeFromTimestamp("\(String(describing: claimDic["exp"]!))")]
            dataArray?.add(allKey)
            dataContentArray?.add(allValue)

        }else{
            let TxnHashStr = Common.isBlankString((dic as AnyObject).value(forKey: "TxnHash") as! String) ? "" : (dic as AnyObject).value(forKey: "TxnHash") as! String
            let allKey = [ loacalkey(key: "authStatus"), loacalkey(key: "COTCreated"),loacalkey(key: "COTExpireTime"),loacalkey(key: "newBlockchainRecord")  ]
            
            let allValue = [ loacalkey(key: "IMStatusSuccess"),Common.getTimeFromTimestamp("\(String(describing: claimDic["iat"]!))"),Common.getTimeFromTimestamp("\(String(describing: claimDic["exp"]!))"),TxnHashStr]
            dataArray?.add(allKey)
            dataContentArray?.add(allValue)
        }
        tableView?.reloadData()
        print("data= \(String(describing: dataArray))")
        //        }
    }
    
    func getInfo() {
        
        let params:NSDictionary? = ["OwnerOntId":UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "" ,"DeviceCode":UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? ""  ,"ClaimId": "" ,"ClaimContext":self.claimContext,"Status":"9"]
        CCRequest .shareInstance().request(withURLString: Claim_query, methodType: .POST, params: params, success: { (responseObject, responseOriginal) in
            print("dd = \(String(describing: responseObject))")
            let dic = responseObject as! NSDictionary
            if (dic["EncryptedOrigData"] as! NSString) .isEqual(to:""){
                return
            }
            
            let  model = ClaimModel()
            model.claimContext = self.claimContext
            model.ownerOntId = UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? ""
            model.status = "1"
            model.content = Common.dictionary(toJson: dic as! [AnyHashable : Any])
            DataBase.shared().addClaim(model, isSoket: false)
            
            self.handleData(dic: dic)
            
            let dic1 = Common.claimdencode(dic["EncryptedOrigData"] as! String)! as NSDictionary
            let dic2 = dic1["claim"] as! NSDictionary
            
            let params1:NSDictionary? = ["OwnerOntId":UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "" ,"DeviceCode":UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? ""  ,"ClaimId": dic2["jti"] ?? "" ];
            CCRequest .shareInstance().request(withURLString: LocalizationConfirm, methodType: .POST, params: params1, success: { (responseObject, responseOriginal) in
                
            }) { (error, errorDesc, responseOriginal) in
                print("444")
            }
        }) { (error, errorDesc, responseOriginal) in
            print("333")
            self.dataArray = NSMutableArray.init()
            self.dataContentArray = NSMutableArray.init()
            let allKey = [ NSLocalizedString("authStatus", comment: "default"), NSLocalizedString("IMReason", comment: "default") ]
            let allValue = [ NSLocalizedString("CreateFailed", comment: "default"), NSLocalizedString("failReason", comment: "default") ]
            self.dataArray?.add(allKey)
            self.dataContentArray?.add(allValue)
            self.bottomV.isHidden = false
            self.tableView?.frame =  CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight  - 20 - 49 - 100*SCALE_W)
            if UIDevice.current.isX() {
                self.tableView?.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 83 - 44 - 100*SCALE_W )
            }
            self.tableView?.tableFooterView = nil
            self.tableView?.reloadData()
        }
        
    }
    func createNav() {
        let titleSize = getSize(str: self.loacalkey(key: "newClaimDetails"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 1.5*SCALE_W)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2) - 5, y: LL_StatusBarHeight + 15, width: Int(titleSize.width)+2, height: 28))
        navTitle.text = self.loacalkey(key: "newClaimDetails")
        navTitle.textColor = UIColor.black
        
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 1.5*SCALE_W)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        
        let buttonSize = getSize(str: self.loacalkey(key: "NEWUPDATE"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 12, weight: .bold), lineSpace: 0, wordSpace: 0)
        let navbutton = UIButton(frame: CGRect(x: 0, y: LL_StatusBarHeight + 15, width: Int(buttonSize.width)+2, height: 28))
        navbutton.setTitle(self.loacalkey(key: "NEWUPDATE"), for: .normal)
        navbutton.setTitleColor(UIColor.black, for: .normal)
        navbutton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        let rightItem = UIBarButtonItem.init(customView: navbutton)
        //UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:navbutton];
        self.navigationItem.rightBarButtonItem = rightItem;
        navbutton.handleControlEvent(.touchUpInside) {
            if (self.statusType as NSString) .isEqual(to: "mobile"){
                let vc = NewMobileViewController()
                vc.claimContext = self.claimContext
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = NewEmailViewController()
                vc.claimContext = self.claimContext
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func createUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight  - 20 - 49), style: .grouped)
        if UIDevice.current.isX() {
            tableView?.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 83 - 44 )
        }
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view?.addSubview(tableView!)
        
        let logoV = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 96*SCALE_W))
        let logoImage = UIImageView(frame: CGRect(x: 70*SCALE_W, y: 30*SCALE_W, width: SYSWidth - 140*SCALE_W, height: 36*SCALE_W))
        logoImage.image = UIImage(named: "Ontoloogy Attested")
        logoV.addSubview(logoImage)
        
        tableView?.tableFooterView = logoV
        
        bottomV = UIView(frame: CGRect(x: 0, y: SYSHeight - 64 - 160*SCALE_W, width: SYSWidth, height: 160*SCALE_W))
        bottomV.isHidden = true
        if UIDevice.current.isX() {
            bottomV.frame = CGRect(x: 0, y: SYSHeight - 88 - 160*SCALE_W, width: SYSWidth, height: 160*SCALE_W)
        }
        view.addSubview(bottomV)
        
        getBtn = UIButton(frame: CGRect(x: 55*SCALE_W, y: 57*SCALE_W, width: SYSWidth - 110*SCALE_W, height: 60*SCALE_W))
        getBtn.setTitle(loacalkey(key: "cotRetry"), for: .normal)
        getBtn.backgroundColor = UIColor.black
        getBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        getBtn.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 2*SCALE_W)
        getBtn.setTitleColor(UIColor.white , for: .normal)
        bottomV.addSubview(getBtn)
        getBtn.addTarget(self, action: #selector(toGetCert), for: .touchUpInside)
    }
    @objc func toGetCert()  {
        if (self.statusType as NSString) .isEqual(to: "mobile"){
            let vc = NewMobileViewController()
            vc.claimContext = self.claimContext
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = NewEmailViewController()
            vc.claimContext = self.claimContext
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (dataArray?.count)! > 1 {
            if let arr = dataArray![1] as? NSArray {
                return arr.count
            }else {
                return 0
            }
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 145*SCALE_W))
        
        let bgV = UIImageView(frame: CGRect(x: 20*SCALE_W, y: 25*SCALE_W, width: SYSWidth - 40*SCALE_W, height: 100*SCALE_W))
        
        v.addSubview(bgV)
        
        if (self.statusType as NSString) .isEqual(to: "mobile"){
            bgV.image = UIImage(named: "NewGroupbg")
            let lb = UILabel(frame: CGRect(x: 120*SCALE_W, y: 23*SCALE_W, width: SYSWidth - 170*SCALE_W, height: 28*SCALE_W))
            lb.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            lb.textAlignment = .left
            lb.text = loacalkey(key: "myClaimD")
            lb.changeSpace(lineSpace: 0, wordSpace: 2)
            bgV.addSubview(lb)
            
            let lb1 = UILabel(frame: CGRect(x: 120*SCALE_W, y: 50*SCALE_W, width: SYSWidth - 165*SCALE_W, height: 28*SCALE_W))
            lb1.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            lb1.textAlignment = .left
            let mskContent = contentStr! as NSString
//            let nmskContent = "**\(mskContent.substring(with: NSRange.init(location: 2, length: mskContent.length - 4)))**"
//            let nmskContent = mskContent.replacingCharacters(in: NSRange.init(location: 2, length: mskContent.length - 4), with: "******")
            var mmm = ""
            for index in 0...mskContent.length {
                if index > 1 && index < mskContent.length - 2{
                    mmm += "*"
                }
            }
            let nmskContent = "\(mskContent.substring(with: NSRange.init(location: 0, length: 2)))\(mmm)\(mskContent.substring(with: NSRange.init(location: mskContent.length - 2, length: 2)))"
            lb1.text = "+\(contentStrLeft!) \(nmskContent)" //"+86 13333333333"
            lb1.changeSpace(lineSpace: 0, wordSpace: 1.5*SCALE_W)
            bgV.addSubview(lb1)
            
        }else{
            bgV.image = UIImage(named: "newGroup 6")
            let lb = UILabel(frame: CGRect(x: 15*SCALE_W, y: 29*SCALE_W, width: SYSWidth - 170*SCALE_W, height: 28*SCALE_W))
            lb.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            lb.textAlignment = .left
            lb.text = loacalkey(key: "MyEmail")
            lb.changeSpace(lineSpace: 0, wordSpace: 2)
            bgV.addSubview(lb)
            
            let contentString = contentStr! as NSString
            let arr = contentString.components(separatedBy: "@") as NSArray
            let str1 = "\(arr[0])" as NSString
            
            var mmm = ""
            for index in 0...str1.length {
                if index < str1.length - 2{
                    mmm += "*"
                }
            }
            
            let lb1 = UILabel(frame: CGRect(x: 15*SCALE_W, y: 56*SCALE_W, width: SYSWidth - 70*SCALE_W, height: 28*SCALE_W))
            lb1.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            lb1.textAlignment = .left
            lb1.text = "\(mmm)\(str1.substring(with: NSRange.init(location: str1.length - 2, length: 2)))@\(arr[1])"
            lb1.changeSpace(lineSpace: 0, wordSpace: 1*SCALE_W)
            bgV.addSubview(lb1)
        }
        
        
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 145*SCALE_W
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 3 {
            let arr1 = dataContentArray![1] as! NSArray
            let mobileSize = getSize(str: arr1[indexPath.row] as! String, width: SYSWidth - 40*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
            
            return 64*SCALE_W + mobileSize.height
//        }
//        return 80*SCALE_W
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:NewClaimDetailCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? NewClaimDetailCell
        if cell == nil {
            cell = NewClaimDetailCell(style: .default, reuseIdentifier: "cellID")
        }
        let arr = dataArray![1] as! NSArray
        let arr1 = dataContentArray![1] as! NSArray
        cell.topLB.text = arr[indexPath.row] as? String
        cell.topLB.changeSpace(lineSpace: 0, wordSpace: 1)
        cell.bottomLB.text = arr1[indexPath.row] as? String
        if indexPath.row == 0 {
            if self.bottomV.isHidden == true {
                cell.bottomLB.textColor = UIColor(hexString: "#196BD8")
            }else{
                cell.bottomLB.textColor = UIColor(hexString: "#FC9594")
            }
        }
        if indexPath.row == 3 {
//            cell.bottomLB.text = "sdfgsdjfgsjdfgsdhjfcgsdhfcgsdjhfgsdjhfsdjfsjfgsjdfgsdjgfjsfsfdfs"
            cell.rightBtn.isHidden = false
        }
        let mobileSize = getSize(str: cell.bottomLB.text!, width: SYSWidth - 40*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
        
        cell.bottomLB.frame = CGRect(x: 20*SCALE_W, y: 45*SCALE_W*SCALE_W, width: SYSWidth - 40*SCALE_W, height: mobileSize.height)
        cell.line.frame = CGRect(x: 20*SCALE_W, y: 64*SCALE_W + mobileSize.height - 1, width: SYSWidth - 20*SCALE_W, height: 1)
        cell.bottomLB.changeSpace(lineSpace: 1, wordSpace: 1)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let arr = dataContentArray![1] as! NSArray
            let vc = WebIdentityViewController()
            vc.transaction = arr[3] as! String;
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func navLeftAction() {
        
//        let cv = BoxListDetailController.containCOTMListViewController(self.navigationController);
//        if cv != nil {
//            self.navigationController?.popToViewController(cv!, animated: true)
//            return;
//        }
        self.navigationController?.popToRootViewController(animated: true)
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
