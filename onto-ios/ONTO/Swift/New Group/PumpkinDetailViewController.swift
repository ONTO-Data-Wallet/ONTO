//
//  PumpkinDetailViewController.swift
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
class PumpkinDetailViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    var tableView:UITableView?
    var bottomBtn:UIButton!
    var numLB:UILabel!
    var emptyBgV:UIView!
    var dataArray:NSMutableArray? = []
    var pumType:String!
    var page:Int = 1
    var walletAddress: String!
    var pumNumber: String!
    var ongAmount: String!
    var smstimer: Timer!
    var num:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        createNav()
        createUI()
//        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.toTimer()
//        self.perform(#selector(self.checkMobile), with: nil, afterDelay: 1)
        getData()
    }
    func getData() {
        
        let urlString: String = "\(CapitalURL)\(TradeList)/\(walletAddress!)/\(pumType!)/10/\(page)"
        CCRequest.shareInstance()?.request(withURLString: urlString, methodType: .GET, params: nil, success: { (responseObject, responseOriginal) in
            print("responseOriginal=\(responseOriginal!)")
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
            let dic = responseObject as! NSDictionary
            let arr = dic["TxnList"] as! NSArray
            if self.page == 1 {
                self.dataArray?.removeAllObjects()
                self.dataArray?.addObjects(from: arr as! [Any])
            }else{
                self.dataArray?.addObjects(from: arr as! [Any])
            }
            
            let  BalanceArr = dic["AssetBalance"] as! NSArray
            for dic1 in BalanceArr {
                let str = (dic1 as! NSDictionary).value(forKey: "AssetName") as! NSString
                let num = (dic1 as! NSDictionary).value(forKey: "Balance") as! NSString
                if str.isEqual(to: self.pumType){
                    self.pumNumber = num as String
                    self.numLB.text = num as String
                    if num.isEqual(to: "0"){
                        self.bottomBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
                        self.bottomBtn.isUserInteractionEnabled = false
                    }else{
                        self.bottomBtn.backgroundColor = UIColor.black
                        self.bottomBtn.isUserInteractionEnabled = true
                    }
                }
                
            }
//            self.toTimer()
            self.tableView?.reloadData()
            self.createEmptyV()
        }, failure: { (error, errorDesc, responseOriginal) in
//            self.toTimer()
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
            self.createEmptyV()
        })
    }
    func toTimer() {
        if ((self.smstimer != nil) && self.smstimer.isValid){
            self.smstimer.invalidate()
        }
        self.smstimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.checkMobile), userInfo: nil, repeats: true)
    }
    @objc func checkMobile() {
        self.page = 1
        self.getData()
        
    }
    func createNav() {
        var  titleStr: String!
        if pumType.isEqual("pumpkin01") {
            titleStr = LocalizeEx("PumpkinRed")
        }else if pumType.isEqual("pumpkin02"){
            titleStr = LocalizeEx("PumpkinOrange")
        }else if pumType.isEqual("pumpkin03"){
            titleStr = LocalizeEx("PumpkinYellow")
        }else if pumType.isEqual("pumpkin04"){
            titleStr = LocalizeEx("PumpkinGreen")
        }else if pumType.isEqual("pumpkin05"){
            titleStr = LocalizeEx("PumpkinIndigo")
        }else if pumType.isEqual("pumpkin06"){
            titleStr = LocalizeEx("PumpkinBlue")
        }else if pumType.isEqual("pumpkin07"){
            titleStr = LocalizeEx("PumpkinPurple")
        }else if pumType.isEqual("pumpkin08"){
            titleStr = LocalizeEx("PumpkinGolden")
        }
        let titleSize = getSize(str: titleStr, width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = titleStr
        navTitle.textColor = UIColor.black
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 2)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        self.setNavRightImageIcon(UIImage(named: "coticon-none"), title: "")
    }
    func createUI() {
        numLB = UILabel.init()
        numLB.text = pumNumber
        numLB.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        numLB.changeSpace(0, wordSpace: 2)
        numLB.textAlignment = .left
        view.addSubview(numLB)
        
        let bgImage = UIImageView.init()
        bgImage.image = UIImage(named: "bgPum")
        view.addSubview(bgImage)
        
        let LB = UILabel.init()
        LB.text = LocalizeEx("TransactionLog")
        LB.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        LB.changeSpace(0, wordSpace: 1)
        LB.textAlignment = .left
        view.addSubview(LB)
        
        let line = UIView.init()
        line.backgroundColor  = Const.color.kAPPDefaultLineColor
        view.addSubview(line)
        
        tableView = UITableView.init()
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view?.addSubview(tableView!)
        
        tableView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.getData()
        })
        
        tableView?.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.getData()
        })
        
        bottomBtn = UIButton.init()
//        bottomBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
        if pumNumber.isEqual("0"){
            self.bottomBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
            self.bottomBtn.isUserInteractionEnabled = false
        }else{
            self.bottomBtn.backgroundColor = UIColor.black
            self.bottomBtn.isUserInteractionEnabled = true
        }
        bottomBtn.setTitle(LocalizeEx("pumSend"), for: .normal)
        bottomBtn.setTitleColor(UIColor.white, for: .normal)
        bottomBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        bottomBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        view.addSubview(bottomBtn)
        
        numLB.mas_makeConstraints { (make) in
            make?.left.top()?.equalTo()(view)?.offset()(20*SCALE_W)
        }
        
        bgImage.mas_makeConstraints { (make) in
            make?.right.equalTo()(view)
            make?.top.equalTo()(view)?.offset()(10*SCALE_W)
            make?.width.height()?.equalTo()(125*SCALE_W)
        }
        
        LB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(view)?.offset()(150*SCALE_W)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.top.equalTo()(view)?.offset()(177*SCALE_W)
            make?.height.equalTo()(1)
        }
        
        tableView?.mas_makeConstraints({ (make) in
            make?.left.right()?.equalTo()(view)
            make?.top.equalTo()(view)?.offset()(178*SCALE_W)
            if UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-140*SCALE_W - 34)
            }else{
                make?.bottom.equalTo()(view)?.offset()(-140*SCALE_W )
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
        bottomBtn.handleControlEvent(.touchUpInside) {
            if ((self.smstimer != nil) && self.smstimer.isValid){
                self.smstimer.invalidate()
            }
            let vc = SendViewController()
            vc.amount = self.pumNumber
            vc.ongAmount = self.ongAmount
            vc.isPum = true
            vc.walletAddr = self.walletAddress
            vc.pumType = self.pumType
            self.navigationController?.pushViewController(vc, animated: true)
        }
        createEmptyV()
    }
    func createEmptyV() {
//        tableView?.isHidden = true
        
        emptyBgV = UIView.init()
//        view.addSubview(emptyBgV)
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
        return 80*SCALE_W
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:PumDetailCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? PumDetailCell
        if cell == nil {
            cell = PumDetailCell(style: .default, reuseIdentifier: "cellID")
            cell.selectionStyle = .none
        }
        let dic = dataArray![indexPath.row] as! NSDictionary
        cell.reloadCellByDic(dic: dic, address: walletAddress! as NSString)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = dataArray![indexPath.row] as! NSDictionary
        let vc = WebIdentityViewController()
        vc.transaction = (dic["TxnHash"] as! String)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func navLeftAction() {
        if ((self.smstimer != nil) && self.smstimer.isValid){
            self.smstimer.invalidate()
        }
        self.navigationController!.popViewController(animated: true)
    }
    override func navRightAction() {
        if ((self.smstimer != nil) && self.smstimer.isValid){
            self.smstimer.invalidate()
        }
        let getVc = GetViewController()
        self.navigationController?.pushViewController(getVc, animated: true)
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
