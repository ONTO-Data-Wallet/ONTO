//
//  PumpkinNumViewController.swift
//  ONTO
//
//  Created by Apple on 2018/10/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
class PumpkinNumViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var tableView:UITableView?
    var bottomBtn:UIButton!
    @objc var pumArr:NSArray!
    @objc var walletAddress: String!
    @objc var ongAmount: String!
    @objc var walletDic: NSDictionary!
    var dataArray:NSMutableArray? = []
    override func viewDidLoad() {
        super.viewDidLoad()
        createNav()
        createUI()
        resolveData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    func resolveData() {
        var pumStatus:Bool = true
        self.dataArray?.removeAllObjects()
        for dic in self.pumArr {
            let str = (dic as! NSDictionary).value(forKey: "AssetName") as! NSString
            let num =  "\((dic as! NSDictionary).value(forKey: "Balance") ?? 0)"  //(dic as! NSDictionary).value(forKey: "Balance") as! NSString
            if str.isEqual(to: "pumpkin01"){
                dataArray?.add(dic)
                if num.isEqual("0"){
                    pumStatus = false
                }
            }
            if str.isEqual(to: "pumpkin02"){
                dataArray?.add(dic)
                if num.isEqual("0"){
                    pumStatus = false
                }
            }
            if str.isEqual(to: "pumpkin03"){
                dataArray?.add(dic)
                if num.isEqual("0"){
                    pumStatus = false
                }
            }
            if str.isEqual(to: "pumpkin04"){
                dataArray?.add(dic)
                if num.isEqual("0"){
                    pumStatus = false
                }
            }
            if str.isEqual(to: "pumpkin05"){
                dataArray?.add(dic)
                if num.isEqual("0"){
                    pumStatus = false
                }
            }
            if str.isEqual(to: "pumpkin06"){
                dataArray?.add(dic)
                if num.isEqual("0"){
                    pumStatus = false
                }
            }
            if str.isEqual(to: "pumpkin07"){
                dataArray?.add(dic)
                if num.isEqual("0"){
                    pumStatus = false
                }
            }
            if str.isEqual(to: "ong"){
                ongAmount = Common.getPrecision9Str(num as String)
            }
            
            if str.isEqual(to: "pumpkin08") && !num.isEqual("0"){
                dataArray?.insert(dic, at: 0)
            }
//            Common getPrecision9Str
        }
        if pumStatus {
            bottomBtn.backgroundColor = UIColor.black
            bottomBtn.isUserInteractionEnabled = true
        }else{
            bottomBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
            bottomBtn.isUserInteractionEnabled = false
        }
        tableView?.reloadData()
    }
    @objc func getData() {
        let urlStr = "\(CapitalURL)/\(Get_Blance)/\(walletDic["address"]!)"//[NSString stringWithFormat:@"%@/%@", Get_Blance, dict[@"address"]];
        CCRequest.shareInstance()?.request(withURLString: urlStr, methodType: .GET, params: nil, success: { (responseObject, responseOriginal) in
            self.tableView?.mj_header.endRefreshing()
            let rArr = responseObject as! NSArray
            self.pumArr = rArr
            self.resolveData()
        }, failure: { (error, errorDesc, responseOriginal) in
            self.tableView?.mj_header.endRefreshing()
        })

    }
    func createNav() {
        
        let titleSize = getSize(str: LocalizeEx("PUMPKIN"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = LocalizeEx("PUMPKIN")
        navTitle.textColor = UIColor.black
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 2)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
    }
    func createUI() {
        tableView = UITableView.init()
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view?.addSubview(tableView!)
        
        tableView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.getData()
        })
        
        bottomBtn = UIButton.init()
        bottomBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
        bottomBtn.setTitle(LocalizeEx("SYNTHESIZ"), for: .normal)
        bottomBtn.setTitleColor(UIColor.white, for: .normal)
        bottomBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        bottomBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        view.addSubview(bottomBtn)
        
       
        let whatBtn = UIButton.init()
        whatBtn.setImage(UIImage(named: "cotlink"), for: .normal)
        whatBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        whatBtn.setTitleColor(UIColor(hexString: "#216ed5"), for: .normal)
        whatBtn.setTitle("  \(LocalizeEx("pumWhat"))", for: .normal)
        view.addSubview(whatBtn)
        
        tableView?.mas_makeConstraints({ (make) in
            make?.left.right()?.top()?.equalTo()(view)
            if UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-150*SCALE_W - 34)
            }else{
                make?.bottom.equalTo()(view)?.offset()(-150*SCALE_W )
            }
        })
        
        bottomBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            if UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W - 34)
            }else{
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W)
            }
        }
        
        whatBtn.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
            make?.bottom.equalTo()(bottomBtn.mas_top)?.offset()(-10*SCALE_W)
            make?.height.equalTo()(25*SCALE_W)
        }
        bottomBtn.handleControlEvent(.touchUpInside) {
//            NSString * gas_limit = [[NSUserDefaults standardUserDefaults] valueForKey:PUMPKINGASLIMIT];
//            NSString * gas_price = [[NSUserDefaults standardUserDefaults] valueForKey:PUMPKINGASPRICE];
            
            print("\(UserDefaults.standard.value(forKey: PUMPKINGASPRICE)  ?? "")")
            let price = "\(UserDefaults.standard.value(forKey: PUMPKINGASPRICE) ?? "")"
            let limit = "\(UserDefaults.standard.value(forKey: PUMPKINGASLIMIT) ?? "")"
            let fee = Common.getRealFee(price as String , gasLimit: limit as String)
            let isEnough = Common.isEnoughOng(self.ongAmount, fee: fee) as Bool
            if isEnough {
            }else{
                let pop = MGPopController.init(title: LocalizeEx("NotenoughONG"), message: "", image: nil)
                let action = MGPopAction.init(title:  LocalizeEx("OK")) {
                }
                action?.titleColor = UIColor(hexString:"#32A4BE")
                pop?.add(action)
                pop?.showCloseButton = false
                pop?.show()
                return;
            }
            let vc = WalletPasswordView.init(title: "", selectedDic: (self.walletDic as! [AnyHashable : Any]))
            vc?.callback =  { string  in
                self.showSuccess()
            }

        }
        
        whatBtn.handleControlEvent(.touchUpInside) {
            let vc = WebIdentityViewController()
            if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
                vc.introduce = "https://info.onto.app/#/detail/81"
            }else{
                vc.introduce =  "https://info.onto.app/#/detail/80"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    func showSuccess() {
        let successV = PumAlert.init(title: LocalizeEx("pumpkinCongratulations"), imageString: "goldenPum", numString: "1", buttonString: LocalizeEx("OK"))
        successV?.callback = { (backMsg) in

            self.perform(#selector(self.getData), with: nil, afterDelay: 1)
        }
        successV?.show()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80*SCALE_W
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:PumpkinCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? PumpkinCell
        if cell == nil {
            cell = PumpkinCell(style: .default, reuseIdentifier: "cellID")
            cell.selectionStyle = .none
        }
        let dic = dataArray![indexPath.row] as! NSDictionary
        cell.reloadCellByDic(dic: dic)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PumpkinDetailViewController()
        let dic = dataArray![indexPath.row] as! NSDictionary
        vc.pumType = (dic["AssetName"] as! String)
        vc.walletAddress = self.walletAddress
        vc.pumNumber = (dic["Balance"] as! String)
        vc.ongAmount = self.ongAmount
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func navLeftAction() {
        NotificationCenter.default.post(name: NSNotification.Name("Refresh_Home"), object: self, userInfo: nil)
        self.navigationController!.popViewController(animated: true)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
