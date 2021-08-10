//
//  IMStep3ViewController.swift
//  ONTO
//
//  Created by Apple on 2018/8/1.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth / 375)

//private var KIsiPhoneX = ([UIScreen.instancesRespond(to: Selector())instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

class IMStep3ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var fullName:String!
    var lastName:String!
    var idNumber:String!


    var email: String!
    var phoneNum: String!
    var doucumentType: String!

    var photo1: UIImage!
    var photo2: UIImage!
//    @property(nonatomic,strong)MBProgressHUD            *hub;
    var hub: MBProgressHUD!
    var tableView: UITableView?
    var dataDic = NSMutableDictionary()
    var dataArray: NSMutableArray?
    var dataArray1: NSMutableArray? = ["Document Type:", "Passport", "Issued Country:"]
    var dataArray2: NSMutableArray?
    
    var shuftiModel:IdentityModel!
    var walletArray:NSMutableArray? = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        dataArray = [self.loacalkey(key: "IM_country"),self.loacalkey(key: "IM_DoucmentType"),self.loacalkey(key: "IM_Name"),"\(self.doucumentType!)\(self.loacalkey(key: "IMNumber"))"]

        dataArray2 = [Common.getcountryNameWithlocale(appdelegate.selectCountry),self.doucumentType,self.fullName+" "+self.lastName,self.idNumber];
        
        

        self.setNavTitle(self.loacalkey(key: "IM_GLOBAL"))
        self.setNavLeftImageIcon(UIImage.init(named: "nav_back"), title: "Back")
        dataDic.setValue(dataArray, forKey: "dic")
        dataDic.setValue(dataArray1, forKey: "dic1")
        dataDic.setValue(dataArray2, forKey: "dic2")
        setupTableView()

        // Do any additional setup after loading the view.
    }

    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
    }

    func setupTableView() {


        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 49 - 64), style: .grouped)
        if UIDevice.current.isX() {
            tableView?.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 83 - 88)
        }
        tableView?.backgroundColor = UIColor.red
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view?.addSubview(tableView!)

        let submitBtn = UIButton.init()

        submitBtn.setTitle(self.loacalkey(key: "IM_Submit1"), for: .normal)
        submitBtn.backgroundColor = UIColor(hexString: "#F0F7FC")
        submitBtn.setTitleColor(UIColor(hexString: "#29A6FF"), for: .normal)
        submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        submitBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        view.addSubview(submitBtn)
        submitBtn.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(self.view)
            make?.height.equalTo()(48)
            if #available(iOS 11, *) {
                make?.bottom.equalTo()(self.view.mas_safeAreaLayoutGuideBottom)
            } else {
                make?.bottom.equalTo()(self.view.mas_bottom)
            }
        }
    }

    var localeStr = ""

    @objc func submitClick(button: UIButton) {
        
        
        
        let isNeedPay = "\(shuftiModel.chargeInfo?.charge ?? "0")"
        if isNeedPay.isEqual("1"){
            // 查询钱包情况
            checkWallet()
        }else{
            submitIDMInfo()
        }
    }

    func checkWallet() {
        walletArray?.removeAllObjects()
        let arr = UserDefaults.standard.value(forKey: ALLASSET_ACCOUNT) as? NSArray
        if arr?.count == 0 || arr == nil {
            Common.showToast(LocalizeEx("NOWALLET"))
            return
        }
        for dic in arr! {
            let subDic = dic as! NSDictionary
            print("\(subDic)")
            if (subDic.value(forKey: "label") != nil){
                walletArray?.add(subDic)
            }
        }
        if walletArray?.count == 0 {
            Common.showToast(LocalizeEx("NOWALLET"))
        }else{
            let vc = IDMPaymentViewController()
            vc.shuftiModel = shuftiModel
            vc.dataArray = walletArray
            vc.photo1 = photo1
            vc.photo2 = photo2
            vc.doucumentType = doucumentType
            vc.idNumber = idNumber
            vc.fullName = fullName
            vc.lastName = lastName
            // 测试代码
            let ceshiDci = [:] as NSMutableDictionary
            ceshiDci.addEntries(from: payDic() as! [AnyHashable : Any])
            vc.payPreDic = ceshiDci
            vc.comFrom = "idm"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        print("arr = \(walletArray!)")
    }
    func payDic() -> NSDictionary {
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
            imageBase64String2 = "image/png;base64," + imageBase64String3
        }
        
        
        var mydoucumentType: String = ""
        
        if doucumentType == self.loacalkey(key: "IM_IDCard") {
            mydoucumentType = "ID"
        } else if doucumentType == self.loacalkey(key: "IM_Passort") {
            mydoucumentType = "PP"
        } else if doucumentType == self.loacalkey(key: "IM_DriverLicense") {
            mydoucumentType = "DL"
        }
        
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        var dict: NSDictionary
        if imageBase64String2.count == 0 {
            dict = ["ontId" :UserDefaults.standard.string(forKey:ONT_ID)!,"deviceCode":UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? "", "country": appdelegate.selectCountry,"firstName":self.fullName,"lastName":self.lastName,"docType":mydoucumentType,"frontDoc":"image/png;base64,"+imageBase64String!,"docNumber":self.idNumber]
        }else{
            dict = ["ontId" :UserDefaults.standard.string(forKey:ONT_ID)!,"deviceCode":UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? "", "country": appdelegate.selectCountry,"firstName":self.fullName,"lastName":self.lastName,"docType":mydoucumentType,"frontDoc":"image/png;base64,"+imageBase64String!, "backDoc":imageBase64String2,"docNumber":self.idNumber]
            
        }
        
        return dict
    }
    func submitIDMInfo() {
       
        let dict = payDic()
        
        hub = ToastUtil.showMessage("", to: self.view)
        CCRequest.shareInstance().request(withURLStringNoLoading: IdentityMind_API, methodType: MethodType.POST, params: dict, success: { (responseObject, responseOriginal) in
            
            self.hub.hide(animated: true)
            let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            UserDefaults.standard.set(appdelegate.selectCountry, forKey: UserDefaults.standard.string(forKey: ONT_ID)! + "c")
            
            let vc = IMStatusViewController()
            vc.statusType = "1"
            vc.calimFrom = "idm"
            vc.docType = self.doucumentType
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }) { (error, errorDesc, responseOriginal) in
            self.hub.hide(animated: true)
            
            let vc = IMStatusViewController()
            vc.statusType = "3"
            vc.calimFrom = "idm"
            vc.docType = self.doucumentType
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            let arr = dataDic["dic"] as! NSMutableArray
            return arr.count
        }
        return 0
//        let arr = dataDic["dic1"] as! NSMutableArray
//        return arr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 * SCALE_W
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 53 * SCALE_W));

            let image = UIImageView(frame: CGRect(x: 25 * SCALE_W, y: 17.5 * SCALE_W, width: 12 * SCALE_W, height: 12 * SCALE_W))
            image.image = UIImage(named: "dot")
//            image.backgroundColor = UIColor(hexString: "#E1EFFF")
            bgView.addSubview(image)

            let titleLB = UILabel(frame: CGRect(x: 44 * SCALE_W, y: 14 * SCALE_W, width: SYSWidth - 44 * SCALE_W, height: 19 * SCALE_W))

            titleLB.text = self.loacalkey(key: "IM_Step2")
            titleLB.textColor = UIColor(hexString: "#6A797C")
            titleLB.font = UIFont.systemFont(ofSize: 16, weight: .medium)

            bgView.addSubview(titleLB)
            return bgView;
        }
        return nil

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 53 * SCALE_W;
        }
        return 0;

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        let titleLB = UILabel(frame: CGRect(x: 18 * SCALE_W, y: 14 * SCALE_W, width: SYSWidth / 2 - 40 * SCALE_W, height: 16 * SCALE_W))
        titleLB.tag = 1000;
        titleLB.textColor = UIColor(hexString: "#AAB3B4")
        titleLB.textAlignment = .left
        titleLB.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        cell.contentView.addSubview(titleLB)

        let contentLB = UILabel(frame: CGRect(x: SYSWidth / 2 - 40 * SCALE_W, y: 14 * SCALE_W, width: SYSWidth / 2 + 22 * SCALE_W, height: 16 * SCALE_W))
        contentLB.textColor = UIColor(hexString: "#2B4045")
        contentLB.textAlignment = .right
        contentLB.tag = 10000;
        contentLB.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        cell.contentView.addSubview(contentLB)

        let line = UIView(frame: CGRect(x: 18 * SCALE_W, y: 44 * SCALE_W - 1, width: SYSWidth - 18 * SCALE_W, height: 1))
        line.backgroundColor = UIColor(hexString: "#E9EDEF")
        cell.contentView.addSubview(line)

        let arr = dataDic["dic"] as! NSMutableArray
        let arr2 = dataDic["dic2"] as! NSMutableArray
        titleLB.text = arr[indexPath.row] as? String
        contentLB.text = arr2[indexPath.row] as? String

        return cell

    }

    func loacalkey(key: String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let bundle: String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        return bundle

    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 270 * SCALE_W));
        let image = UIImageView(frame: CGRect(x: 25 * SCALE_W, y: 30 * SCALE_W, width: SYSWidth - 50 * SCALE_W, height: 210 * SCALE_W))
        image.backgroundColor = UIColor(hexString: "#E1EFFF")
        image.image = self.photo1
        bgView.addSubview(image)

        if (self.photo2 != nil) {
            bgView.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: 550 * SCALE_W);
            let image2 = UIImageView(frame: CGRect(x: 25 * SCALE_W, y: 250 * SCALE_W, width: SYSWidth - 50 * SCALE_W, height: 210 * SCALE_W))
            image2.backgroundColor = UIColor(hexString: "#E1EFFF")
            image2.image = self.photo2
            bgView.addSubview(image2)
        }
        return bgView;
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 20*SCALE_W
//        }
        return 550
//        if (self.photo2 != nil) {
//            return 550*SCALE_W
//
//        }else{
//            return 270*SCALE_W
//
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}






