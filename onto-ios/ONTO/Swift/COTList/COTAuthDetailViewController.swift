//
//  COTAuthDetailViewController.swift
//  ONTO
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
class COTAuthDetailViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    var tableView:UITableView?
    var authDic:NSDictionary!
    var dataArray:NSArray? = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        createNav()
        createUI()
    }
    func createNav() {
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
    }
    func createUI() {
        print("authDic=\(authDic)")
        dataArray = [LocalizeEx("authStatus"),LocalizeEx("ThirdPartyName"),LocalizeEx("AuthorizationNumber"),LocalizeEx("AuthorizationContent"),LocalizeEx("AuthONTID"),LocalizeEx("AuthorizationTime")]
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 64  ), style: .grouped)
        if UIDevice.current.isX() {
            tableView?.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 34 - 88 )
        }
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = UIColor.white
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view?.addSubview(tableView!)
        
        let ThirdParty = authDic["ThirdParty"] as! NSDictionary
        
        let headerV = UIView.init(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 113*SCALE_W))
        tableView?.tableHeaderView = headerV

        let tImage = UIImageView.init()
//        tImage.image = UIImage(named: "COTAUTH")
        tImage.sd_setImage(with: URL.init(string: ThirdParty.value(forKey: "Logo") as! String)) { (_, _, _, _) in
        }
        headerV.addSubview(tImage)

        let tLB = UILabel.init()
        tLB.text = (ThirdParty["Name"] as! String)
        tLB.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        tLB.changeSpace(0, wordSpace: 1)
        tLB.textAlignment = .center
        headerV.addSubview(tLB)
        
//        headerV.mas_makeConstraints { (make) in
//            //            make?.left.right()?.equalTo()(view)
//            make?.width.equalTo()(SYSWidth)
//            make?.height.equalTo()(113*SCALE_W)
//        }

        tImage.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(headerV)
            make?.top.equalTo()(headerV)
            make?.width.height()?.equalTo()(60*SCALE_W)
        }

        tLB.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(headerV)
            make?.top.equalTo()(tImage.mas_bottom)?.offset()(15*SCALE_W)
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            let authArr = self.authDic["Claims"] as! NSArray
            return authArr.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let HV = UIView.init()
        HV.backgroundColor = UIColor.white
        
        let LB = UILabel.init()
        LB.text =  (self.dataArray![section] as! String)
        LB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        LB.textColor = UIColor(hexString: "#6E6F70")
        LB.changeSpace(0, wordSpace: 1)
        LB.textAlignment = .left
        HV.addSubview(LB)
        
        LB.mas_makeConstraints { (make) in
            make?.left.equalTo()(HV)?.offset()(20*SCALE_W)
            make?.top.equalTo()(HV)?.offset()(19*SCALE_W)
        }
        return HV
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40*SCALE_W
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let FV = UIView.init()
        FV.backgroundColor = UIColor.white
        
        let line = UIView.init()
        line.backgroundColor = Const.color.kAPPDefaultLineColor
        FV.addSubview(line)
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(FV)?.offset()(20*SCALE_W)
            make?.right.equalTo()(FV)?.offset()(-20*SCALE_W)
            make?.bottom.equalTo()(FV)
            make?.height.equalTo()(1)
        }
        return FV
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 14*SCALE_W
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28*SCALE_W
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:AuthDetailCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? AuthDetailCell
        if cell == nil {
            cell = AuthDetailCell(style: .default, reuseIdentifier: "cellID")
            cell.selectionStyle = .none
        }
        cell.reloadCellByDic(dic: self.authDic, index: indexPath)
        return cell
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
        
        
    }

}
