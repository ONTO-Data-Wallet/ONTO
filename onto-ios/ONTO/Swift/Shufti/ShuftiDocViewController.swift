//
//  ShuftiDocViewController.swift
//  ONTO
//
//  Created by Apple on 2018/11/2.
//  Copyright © 2018 Zeus. All rights reserved.
//


import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)

class ShuftiDocViewController: BaseViewController {
    
    @objc var modelArr :NSArray!
    @objc var myStatus :NSString!
    @objc var typeString:String!
    
    var typeArr :NSMutableArray!
    var typeImageArr :NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        configUI()
        
        self.setNavTitle(self.loacalkey(key: "DOCUMENTTYPE"))
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = {[NSAttributedStringKey.foregroundColor : UIColor.black,
                                                                         NSAttributedStringKey.font : UIFont.systemFont(ofSize: 21, weight: .bold),
                                                                         NSAttributedStringKey.kern: 2]}()
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func configUI()  {
        
        self.typeArr = NSMutableArray.init(array: [self.loacalkey(key:"IM_IDCard"),self.loacalkey(key: "IM_Passort"),self.loacalkey(key: "IM_DriverLicense")])
        self.typeImageArr = NSMutableArray.init(array: ["blueid","bluepassport","bluedrive"])
        
        let statusArr = NSMutableArray.init(array: ["","",""])
        for model in self.modelArr {
            let model1:IdentityModel = model as! IdentityModel
            if model1.claimContext == "claim:sfp_idcard_authentication"{
                statusArr.replaceObject(at: 0, with: model1.issuedFlag)
            }else if model1.claimContext == "claim:sfp_passport_authentication"{
                statusArr.replaceObject(at: 1, with: model1.issuedFlag)
            }else if model1.claimContext == "claim:sfp_dl_authentication"{
                statusArr.replaceObject(at: 2, with: model1.issuedFlag)
            }
        }
        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let localeStr = appdelegate.selectCountry
        
        
        let path2 = Bundle.main.path(forResource: "newUnHave", ofType: "json")
        let url2 = URL(fileURLWithPath: path2!)
        var IMtypeArr = NSMutableArray.init()
        IMtypeArr = [1,1,1];
        // 带throws的方法需要抛异常
        do {
            
            let data2 = try Data(contentsOf: url2)
            let jsonData2:Any = try JSONSerialization.jsonObject(with: data2, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr2 = jsonData2 as! NSArray
            for dict in jsonArr2 {
                
                let mydic:NSDictionary = dict as! NSDictionary
                if mydic["country"]as? String ==  localeStr {
                    let arr = mydic["unSupport"]as?NSArray
                    
                    if (arr?.contains("M_ID"))!{
                        IMtypeArr.replaceObject(at: 0, with: 0)
                    }
                    if (arr?.contains("M_PP"))!{
                        IMtypeArr.replaceObject(at: 1, with: 0)
                    }
                    if (arr?.contains("M_DL"))!{
                        IMtypeArr.replaceObject(at: 2, with: 0)
                    }
                    
                    
                    
                }
            }
        } catch let _ as Error? {
        }
        
        for i in 0..<3{
            
            let card1 = IMCardView.init()
            card1.tag = i
            card1.frame = CGRect(x:25,y:20+i*200,width:240,height:160)
            
            if   UIScreen.main.bounds.width == 320{
                card1.frame = CGRect(x:25,y:i*170,width:240,height:160)
            }
            
            card1.centerX = UIScreen.main.bounds.width/2
            self.view.addSubview(card1)
            card1.settype(type: i,claim: true)
            card1.isNeedSuport = IMtypeArr[i] as! NSInteger
            //isuflag
            //            0 初始状态
            //            提交过来就处于审核中，flag是3
            //            审核成功：9
            //            审核失败：8
            //0成功 //1待审核 //2失败
            
            card1.setStauts(status: statusArr[i]as!NSInteger ,type: i)
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(showZoomImageView(tap:)))
            card1.addGestureRecognizer(tap)
            
        }
    }
    
    @objc func showZoomImageView( tap : UITapGestureRecognizer) {
        
        let tapView:IMCardView  = tap.view as! IMCardView
        if tapView.isNeedSuport==0 {
            
            let pop = MGPopController.init(title:self.loacalkey(key: "IMYourcountry"), message: "", image:UIImage.init(named: ""))
            let action = MGPopAction.init(title:  self.loacalkey(key: "OK")) {
            }
            action?.titleColor = UIColor(hexString:"#32A4BE")
            pop?.add(action)
            pop?.showCloseButton = false
            pop?.show()
            return;
            
        }
        
        //            0 初始状态
        //            提交过来就处于审核中，flag是3
        //            审核成功：9
        //            审核失败：8
        //成功
        if tapView.cardStatus1 == 9 {
            
            let vc = IMStatusViewController()
            vc.statusType = "2"
            vc.calimFrom = "shufti"
            vc.calimType = tapView.claimContext
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
            
            //        else if tapView.cardStatus1 == 10 {
            //            let claimArray = [DataBase.shared().getCalimWithClaimContext(tapView.claimContext, andOwnerOntId: UserDefaults.standard.value(forKey: ONT_ID) as! String)] as NSArray
            //            let claimModel = claimArray[0] as! ClaimModel
            //            if Common.isBlankString(claimModel.ownerOntId){
            //                let vc = IMStatusViewController()
            //                vc.statusType = "2"
            //                vc.calimType = tapView.claimContext
            //                self.navigationController?.pushViewController(vc, animated: true)
            //            }else{
            //                let IMDetail = IMNewDetailViewController()
            //                IMDetail.claimContext = tapView.claimContext;
            //                self.navigationController?.pushViewController(IMDetail, animated: true)
            //            }
            //        }
        else if tapView.cardStatus1 == 10 {
            let IMDetail = ShuftiProDetailViewController()
            IMDetail.claimContext = tapView.claimContext;
            self.navigationController?.pushViewController(IMDetail, animated: true)
        }
            
        else if tapView.cardStatus1 == 3{
            //审核中
            let vc = IMStatusViewController()
            vc.statusType = "1"
            vc.calimFrom = "shufti"
            vc.docType = self.typeArr[(tap.view?.tag)!] as? String
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if tapView.cardStatus1 == 0{
            
            let vc = ShuftiSurePreViewController()
            vc.docType = self.typeArr[(tap.view?.tag)!] as? String
            if tap.view?.tag == 0 {
                for model in self.modelArr {
                    let model1:IdentityModel = model as! IdentityModel
                    if model1.claimContext == "claim:sfp_idcard_authentication"{
                        vc.shuftiModel = model1
                    }
                }
            }else if tap.view?.tag == 1{
                for model in self.modelArr {
                    let model1:IdentityModel = model as! IdentityModel
                    if model1.claimContext == "claim:sfp_passport_authentication"{
                        vc.shuftiModel = model1
                    }
                }
            }else if tap.view?.tag == 2{
                for model in self.modelArr {
                    let model1:IdentityModel = model as! IdentityModel
                    if model1.claimContext == "claim:sfp_dl_authentication"{
                        vc.shuftiModel = model1
                    }
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else {
            
            //审核中
            let vc = IMStatusViewController()
            vc.statusType = "3"
            vc.calimFrom = "shufti"
            for model in self.modelArr {
                let model1:IdentityModel = model as! IdentityModel
                if model1.claimContext == "claim:sfp_passport_authentication"{
                    vc.shuftiModel = model1
                }else if model1.claimContext == "claim:sfp_dl_authentication"{
                    vc.shuftiModel = model1
                }else if model1.claimContext == "claim:sfp_idcard_authentication"{
                    vc.shuftiModel = model1
                }
            }
            vc.docType = self.typeArr[(tap.view?.tag)!] as? String
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        return bundle
        
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
