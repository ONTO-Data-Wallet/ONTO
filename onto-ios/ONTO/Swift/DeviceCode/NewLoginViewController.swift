//
//  NewLoginViewController.swift
//  ONTO
//
//  Created by Apple on 2018/9/10.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
private let  SSafeBottomHeight  = (LL_iPhoneX ? 34 : 0)
class NewLoginViewController: BaseViewController {
    var titleLB:UILabel!
    var ontLB:UILabel!
    var selfID:String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        createNav()
        createUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = false;
        self.tabBarController?.tabBar.isHidden = false
        let ontStr = UserDefaults.standard.value(forKey: ONT_ID) as! String
        let ontString = "\(ontStr)DeviceCode"
        let ontStatusStr = UserDefaults.standard.value(forKey: ontString) as! String
        if (ontStatusStr as NSString).isEqual(to: "1") {
            self.navigationController?.popViewController(animated: false)
            return
        }
        titleLB.text = UserDefaults.standard.value(forKey: IDENTITY_NAME) as? String
        selfID = UserDefaults.standard.value(forKey: IDENTITY_NAME) as? String
        ontLB.text = UserDefaults.standard.value(forKey: ONT_ID) as? String
    }
    func createNav() {
        self.setNavLeftImageIcon(UIImage.init(named:""), title: "")
        
        let titleSize = Common.attrSizeString( self.loacalkey(key: "ONTIDLOGIN"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = self.loacalkey(key: "ONTIDLOGIN")
        navTitle.textColor = UIColor.black
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 2)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
    }
    
    func createUI()  {
        let imageV = UIImageView.init()
        imageV.image = UIImage(named: "newMask")
        view.addSubview(imageV)
        
        titleLB = UILabel.init()
        titleLB.removeFromSuperview()
        
        titleLB.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLB.textAlignment = .center
        titleLB.changeSpace(0, wordSpace: 1)
        view.addSubview(titleLB)
        
        let ontIDLB = UILabel.init()
        ontIDLB.textAlignment = .left
        ontIDLB.text = loacalkey(key: "newLoginID")
        ontIDLB.textColor = UIColor(hexString: "#6E6F70")
        ontIDLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        ontIDLB.changeSpace(0, wordSpace: 1)
        view.addSubview(ontIDLB)
        
        let changeBtn = UIButton.init()
        changeBtn.setImage(UIImage(named: "changeBtn"), for: .normal)
        changeBtn.setEnlargeEdge(17)
        view.addSubview(changeBtn)
        
        ontLB = UILabel.init()
        ontLB.textAlignment = .left
        ontLB.numberOfLines = 0
        ontLB.removeFromSuperview()
        
        ontLB.changeSpace(2, wordSpace: 1)
        ontLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        view.addSubview(ontLB)
        
        let imageAlert = UIImageView.init()
        imageAlert.image = UIImage(named: "IDAlert")
        view.addSubview(imageAlert)
        
        let loginAlert = UILabel.init()
        loginAlert.numberOfLines = 0
        loginAlert.text = loacalkey(key: "loginAlert")
        loginAlert.textAlignment = .left
        loginAlert.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        loginAlert.changeSpace(2, wordSpace: 0)
        view.addSubview(loginAlert)
        
        let loginBtn = UIButton.init()
        loginBtn.backgroundColor = UIColor.black
        loginBtn.setTitle(loacalkey(key: "LOGIN"), for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.addSubview(loginBtn)
        
        let newOntBtn = UIButton.init()
        newOntBtn.setTitle(loacalkey(key: "CREATENEWONTID"), for: .normal)
        newOntBtn.setTitleColor(UIColor(hexString: "#196BD8"), for: .normal)
        newOntBtn.titleLabel?.changeSpace(0, wordSpace: 2)
        newOntBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        view.addSubview(newOntBtn)
        
        let str = Common.getEncryptedContent(APP_ACCOUNT) as String
        let jsDic = Common.dictionary(withJsonString: str) as NSDictionary
        let arr  = jsDic["identities"] as? NSArray
        if arr?.count == 1 {
            changeBtn.isHidden = true
        }
        imageV.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self.view)
            make?.height.width().equalTo()(70*SCALE_W)
            make?.top.equalTo()(self.view)?.offset()(35*SCALE_W)
        }
        titleLB.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self.view)
            make?.top.equalTo()(imageV.mas_bottom)?.offset()(13*SCALE_W)
        }
        ontIDLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)?.offset()(37.5*SCALE_W)
            make?.top.equalTo()(self.titleLB.mas_bottom)?.offset()(50*SCALE_W)
        }
        changeBtn.mas_makeConstraints { (make) in
            make?.right.equalTo()(self.view)?.offset()(-37.5*SCALE_W)
            make?.top.equalTo()(self.titleLB.mas_bottom)?.offset()(38*SCALE_W)
            make?.height.width().equalTo()(34*SCALE_W)
        }
        ontLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)?.offset()(37.5*SCALE_W)
            make?.right.equalTo()(self.view)?.offset()(-37.5*SCALE_W)
            make?.top.equalTo()(ontIDLB.mas_bottom)?.offset()(7*SCALE_W)
        }
        imageAlert.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)?.offset()(42*SCALE_W)
            make?.top.equalTo()(self.ontLB.mas_bottom)?.offset()(57*SCALE_W)
            make?.height.width().equalTo()(17*SCALE_W)
        }
        loginAlert.mas_makeConstraints { (make) in
            make?.left.equalTo()(imageAlert.mas_right)?.offset()(10*SCALE_W)
            make?.right.equalTo()(self.view)?.offset()(-37.5*SCALE_W)
            make?.centerY.equalTo()(imageAlert.mas_centerY)
        }
        loginBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(self.view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            if LL_iPhoneX {
                
                make?.bottom.equalTo()(self.view)?.offset()(-40*SCALE_W - 83 )
            }else{
                 make?.bottom.equalTo()(self.view)?.offset()(-40*SCALE_W - 49 )
            }
        }
        newOntBtn.mas_makeConstraints { (make) in
            make?.width.equalTo()(SYSWidth)
            make?.bottom.equalTo()(loginBtn.mas_top)?.offset()(-20*SCALE_W)
        }
        
        changeBtn.handleControlEvent(.touchUpInside) {
            let vc = SelectONTIDViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        newOntBtn.handleControlEvent(.touchUpInside) {
            self.tabBarController?.tabBar.isHidden = true
            let vc = CreateViewController()
            self.tabBarController?.tabBar.isHidden = true
            vc.isIdentity = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        loginBtn.handleControlEvent(.touchUpInside) {
            let vc = NewPasswordSheet.init(title: self.loacalkey(key: "NewPassword"),selectedDic:[:])
            vc?.isLogin = true 
            vc?.callback = { string  in
                self.navigationController?.popViewController(animated: true)
            }
            let window = UIApplication.shared.windows
            window[0].addSubview(vc!)
            window[0].makeKeyAndVisible()
        }
    }
    func checkLogin(Signature:String) {
        
    }
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        return bundle
        
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
