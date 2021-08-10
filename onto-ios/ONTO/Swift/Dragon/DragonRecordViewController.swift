//
//  DragonRecordViewController.swift
//  ONTO
//
//  Created by Apple on 2018/11/27.
//  Copyright © 2018 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
class DragonRecordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView:UITableView?
    var emptyBgV:UIView!
    var page:Int = 1
    var hub: MBProgressHUD!
    @objc var walletAddress: String!
    var nowTimeString: String!
    var dataArray:NSMutableArray? = []
    var isUp:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        createNav()
        createUI()
        nowTimeString = "\(Common.getNowTimeTimestamp()!)000"
        isUp = false
        hub = ToastUtil.showMessage("", to: nil)
        getData()
    }
    
    func getData() {
        let urlStr = "\(New_History_trade)?address=\(walletAddress!)&assetName=dragon&beforeTimeStamp=\(nowTimeString!)"

        CCRequest.shareInstance()?.request(withURLString1: urlStr, methodType: .GET, params: nil, success: { (responseObject, responseOriginal) in
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
            if  self.hub != nil{
                self.hub.hide(animated: true)
            }
            let resultDic = responseObject as! NSDictionary
            let TransfersArr = resultDic["Transfers"] as! NSArray
            if TransfersArr.count == 0 {
                return
            }else{
                let modelArr = NSMutableArray.init()
                for item in TransfersArr {
                    let traferDic = item as! NSDictionary
                    let model = TradeModel.model(with: traferDic as! [AnyHashable : Any])
                    model!.myaddress = self.walletAddress
                    modelArr.add(model as Any)
                }
                let lastDic = TransfersArr.lastObject as! NSDictionary
                self.nowTimeString = "\(lastDic.value(forKey: "createTimeLong")!)"
                
                if self.isUp == false {
                    self.dataArray = modelArr
                }else{
                    self.dataArray?.addObjects(from: modelArr as! [Any])
                }
                self.isUp = false
                self.tableView?.reloadData()
                self.createEmptyV()
            }
            
        }, failure: { (error, errorDesc, responseOriginal) in
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
            if  self.hub != nil{
                self.hub.hide(animated: true)
            }
            Common.showToast(LocalizeEx("Networkerrors"))
            self.createEmptyV()
        })
    }
    func createNav() {
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
            self.nowTimeString = "\(Common.getNowTimeTimestamp()!)000"
            self.isUp = false
            self.getData()
        })
        
        tableView?.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            self.isUp = true
            self.getData()
        })
        tableView?.mas_makeConstraints({ (make) in
            make?.left.right()?.top()?.equalTo()(view)
            if UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-34)
            }else{
                make?.bottom.equalTo()(view)?.offset()(0*SCALE_W )
            }
        })
    }
    func createEmptyV() {
        
        emptyBgV = UIView.init()
        if self.dataArray?.count == 0 {
            self.tableView?.tableHeaderView = self.emptyBgV
            let emptyImage = UIImageView.init()
            emptyImage.image = UIImage(named: "emptyRecord")
            emptyBgV.addSubview(emptyImage)
            
            let emptyLB = UILabel.init()
            emptyLB.text = LocalizeEx("ListNoRecord")
            emptyLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            emptyLB.changeSpace(0, wordSpace: 1)
            emptyLB.textAlignment = .center
            emptyBgV.addSubview(emptyLB)
            
            emptyBgV.mas_makeConstraints { (make) in
                make?.left.right()?.equalTo()(view)
                make?.top.equalTo()(view)?.offset()(178*SCALE_W)
                if UIDevice.current.isX(){
                    make?.bottom.equalTo()(view)?.offset()(-140*SCALE_W - 34)
                }else{
                    make?.bottom.equalTo()(view)?.offset()(-140*SCALE_W )
                }
            }
            
            emptyImage.mas_makeConstraints { (make) in
                make?.top.equalTo()(emptyBgV)?.offset()(35*SCALE_W)
                make?.centerX.equalTo()(emptyBgV)
                make?.width.height()?.equalTo()(80*SCALE_W)
            }
            
            emptyLB.mas_makeConstraints { (make) in
                make?.left.right()?.equalTo()(emptyBgV)
                make?.top.equalTo()(emptyImage.mas_bottom)?.offset()(10*SCALE_W)
            }
        }else{
            self.tableView?.tableHeaderView = nil
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:DealCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? DealCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("DealCell", owner: self, options: nil)?.last as? DealCell
            cell.selectionStyle = .none
        }
        cell.model = (self.dataArray![indexPath.row] as! TradeModel);
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WebIdentityViewController()
        let model = self.dataArray![indexPath.row] as! TradeModel
        vc.transaction = model.transferhash
        self.navigationController?.pushViewController(vc, animated: true)

    }
    override func navLeftAction() {
        let arr = self.navigationController!.viewControllers
        var isHave :Bool = false
        for cv in arr {
            if cv is DragonListViewController {
                isHave = true
                self.navigationController?.popToViewController(cv, animated: true)
                return
            }
        }
        
        if isHave == false {
            self.navigationController?.popViewController(animated: true)
        }
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
