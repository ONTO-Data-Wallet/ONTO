//
//  SelectONTIDViewController.swift
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
private let  LL_TabBarHeight   =   (LL_iPhoneX ? 34 : 0)
class SelectONTIDViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {
    var tableView:UITableView?
    var dataArray:NSArray? = []
    var selectIndex:IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        createNav()
        createUI()
        getData()
    }
    func getData() {
        let str = Common.getEncryptedContent(APP_ACCOUNT) as String
        let jsDic = Common.dictionary(withJsonString: str) as NSDictionary
        dataArray = jsDic["identities"] as? NSArray
        print("arr = \(String(describing: dataArray))")
        tableView?.reloadData()
    }
    func createNav() {
        let titleSize = Common.attrSizeString( self.loacalkey(key: "ONTIDLOGIN"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = self.loacalkey(key: "ONTIDLOGIN")
        navTitle.textColor = UIColor.black
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 2)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
    }
    func createUI() {
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
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view?.addSubview(tableView!)
        
        let bottomV = UIView.init()
        bottomV.backgroundColor = UIColor(hexString: "#F85957")
        view.addSubview(bottomV)
        
        let switchBtn = UIButton.init()
        switchBtn.backgroundColor = UIColor.black
        switchBtn.setTitle(loacalkey(key: "SWITCH"), for: .normal)
        switchBtn.setTitleColor(UIColor.white, for: .normal)
        switchBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        switchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        bottomV.addSubview(switchBtn)
        
        let newOntBtn = UIButton.init()
        newOntBtn.setTitle(loacalkey(key: "CREATENEWONTID"), for: .normal)
        newOntBtn.setTitleColor(UIColor(hexString: "#196BD8"), for: .normal)
        newOntBtn.titleLabel?.changeSpace(0, wordSpace: 2)
        newOntBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        bottomV.addSubview(newOntBtn)
        
        bottomV.mas_makeConstraints { (make) in
            make?.width.equalTo()(SYSWidth)
            
            if LL_iPhoneX {
                make?.height.equalTo()(160*SCALE_W + 34)
            }else{
                make?.height.equalTo()(160*SCALE_W )
            }
            make?.top.equalTo()(self.tableView?.mas_bottom)
        }
        switchBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(self.view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            make?.top.equalTo()(newOntBtn.mas_bottom)?.offset()(15*SCALE_W)
        }
        newOntBtn.mas_makeConstraints { (make) in
            make?.width.equalTo()(SYSWidth)
            make?.top.equalTo()(bottomV.mas_top)?.offset()(15*SCALE_W)
        }
        
        switchBtn.handleControlEvent(.touchUpInside) {
            print(self.selectIndex)
            UserModel.shareInstance().isCheckCode = false
            let dic = self.dataArray![self.selectIndex.row] as! NSDictionary
            
            let vc = NewPasswordSheet.init(title: self.loacalkey(key: "NewPassword"),selectedDic:dic as! [AnyHashable : Any])
            if (dic["ontid"] as! NSString).isEqual(to: UserDefaults.standard.value(forKey: ONT_ID) as! String){
                vc?.isDefault = true
            }else{
                vc?.isDefault = false
            }
            vc?.isLogin = false
            vc?.callback = { string  in
                UserModel.shareInstance().isCheckCode = true
                let arr = dic["controls"] as! NSArray
                let conDic = arr[0]  as! NSDictionary
                UserDefaults.standard.set(dic["ontid"], forKey: ONT_ID)
                UserDefaults.standard.set(dic["label"], forKey: IDENTITY_NAME)
                UserDefaults.standard.set(conDic["key"], forKey: ENCRYPTED_PRIVATEKEY)
                UserDefaults.standard.set("\(self.selectIndex.row)", forKey: SELECTINDEX)
                UserDefaults.standard.set(UserDefaults.standard.value(forKey: DEVICE_CODE), forKey: DEVICE_CODE)
                UserDefaults.standard.synchronize()
                
                self.navigationController?.popToRootViewController(animated: true)
            }
            let window = UIApplication.shared.windows
            window[0].addSubview(vc!)
            window[0].makeKeyAndVisible()
        }
        newOntBtn.handleControlEvent(.touchUpInside) {
            let vc = CreateViewController()
            vc.isIdentity = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (dataArray?.count)!
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80*SCALE_W
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:NewOntIDCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? NewOntIDCell
        if cell == nil {
            cell = NewOntIDCell(style: .default, reuseIdentifier: "cellID")
            cell.selectionStyle = .none
        }
        let dic = dataArray![indexPath.row] as! NSDictionary
        
        cell.topLB.text = dic["label"] as? String
        cell.bottomLB.text = dic["ontid"] as? String
        
        let defaultStr = UserDefaults.standard.value(forKey: IDENTITY_NAME) as? String
        if (cell.topLB.text! as NSString).isEqual(to: defaultStr!){
            cell.topLB.textColor = UIColor(hexString: "#196BD8")
            cell.bottomLB.textColor = UIColor(hexString: "#196BD8")
            cell.rightBtn.isHidden = false
            selectIndex = indexPath
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellArr = tableView.indexPathsForVisibleRows! as NSArray
        
        for index in cellArr{
            let cell = tableView.cellForRow(at: (index as! NSIndexPath) as IndexPath) as! NewOntIDCell
            cell.topLB.textColor = UIColor.black
            cell.bottomLB.textColor = UIColor.black
            cell.rightBtn.isHidden  = true
        }
        let cell = tableView.cellForRow(at: indexPath) as! NewOntIDCell
        selectIndex = indexPath
        cell.topLB.textColor = UIColor(hexString: "#196BD8")
        cell.bottomLB.textColor = UIColor(hexString: "#196BD8")
        cell.rightBtn.isHidden  = false
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true;
        self.tabBarController?.tabBar.isHidden = true
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
