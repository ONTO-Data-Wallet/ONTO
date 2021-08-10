//
//  DragonListViewController.swift
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
class DragonListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView:UITableView?
    var bottomBtn:UIButton!
    
    @objc var walletAddress: String!
    @objc var ongAmount: String!
    @objc var walletDic: NSDictionary!
    var dataArray:NSMutableArray? = []
    var emptyBgV:UIView!
    var page:Int = 0
    
    var sendConfirmV:SendConfirmView!
    var hub: MBProgressHUD!
    var addressString:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        sendConfirmV = SendConfirmView.init(frame: CGRect(x: 0, y: self.view.height, width: SYSWidth, height: SYSHeight))
        sendConfirmV.callback = { (token,from,to,value,password) in
            self.loadJS()
        }
        view.addSubview(sendConfirmV)
        
        createNav()
        createUI()
//        getData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.perform(#selector(loadJS), with: nil, afterDelay: 0.5)
    }
    @objc func loadJS() {
        hub = ToastUtil.showMessage("", to: nil)
        let str = "OntCryptoAddress('\(walletAddress!)')"
        let Delagate =  UIApplication.shared.delegate as! AppDelegate
        Delagate.browserView.wkWebView.evaluateJavaScript(str, completionHandler: nil)
        Delagate.browserView.callbackPrompt = { ( prompt ) in
            self.handlePrompt(prompt: prompt!)
        }
    }
    func handlePrompt(prompt: String) {
        let promptArray = prompt.components(separatedBy: "params=") as NSArray
        let resultStr = promptArray[1] as! NSString
        let data:NSData = resultStr.data(using: String.Encoding.utf8.rawValue)! as NSData
        let obj = try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))
        addressString = (obj as! NSDictionary).value(forKey: "result") as? String
        print("obj=\(addressString!)")
        getData()
        
    }
    func getData() {
        
        var language:String
        if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
            language = "en"
        }else{
            language = "cn"
        }
        let urlString = "\(UserDefaults.standard.value(forKey: DRAGONLISTURL) ?? "")"
        let params:NSDictionary? = ["pageno":"\(page)","language":language,"owner":addressString as Any]
        CCRequest.shareInstance()?.request(withURLString: urlString, methodType: .GET, params: params, success: { (responseObject, responseOriginal) in
            if  self.hub != nil{
                 self.hub.hide(animated: true)
            }
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()

            self.tableView?.reloadData()
            self.createEmptyV()
        }, failure: { (error, errorDesc, responseOriginal) in
            if  self.hub != nil{
                self.hub.hide(animated: true)
            }
            
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
            if (responseOriginal == nil){
                self.tableView?.reloadData()
                self.createEmptyV()
                return
            }
            let dic = responseOriginal as! NSDictionary
            print("responseOriginal=\(dic)")
            let codeStr = "\(dic.value(forKey: "code") ?? "0")"
            if (codeStr as NSString).isEqual(to: "0"){
                let dataDic = dic["data"] as! NSDictionary
                let arr = dataDic["detail_data"] as! NSArray
                if self.page == 0 {
                    self.dataArray?.removeAllObjects()
                    self.dataArray?.addObjects(from: arr as! [Any])
                }else{
                    self.dataArray?.addObjects(from: arr as! [Any])
                }
            }
            if (self.dataArray?.count)! > 0{
                for item in self.dataArray!{
                    let itemDic = item as! NSDictionary
                    let idStr = "\(itemDic.value(forKey: "id")!)"
                    if (idStr as NSString).isEqual(to: "0"){
                        self.dataArray?.remove(item)
                    }
                }
            }
            
            self.tableView?.reloadData()
            self.createEmptyV()
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
    func createNav() {
        
        let titleSize = getSize(str: LocalizeEx("HYPERDRAGONS"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = LocalizeEx("HYPERDRAGONS")
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
            print("getData")
            self.page = 0
            self.getData()
        })
        tableView?.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.getData()
        })
        
        bottomBtn = UIButton.init()
        bottomBtn.setTitle(LocalizeEx("TransactionLog"), for: .normal)
        bottomBtn.setTitleColor(UIColor(hexString: "#196BD8"), for: .normal)
        bottomBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        bottomBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        view.addSubview(bottomBtn)
        
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
        
        bottomBtn.handleControlEvent(.touchUpInside) {
            let vc = DragonRecordViewController()
            vc.walletAddress = self.walletAddress    
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80*SCALE_W
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:DragonCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? DragonCell
        if cell == nil {
            cell = DragonCell(style: .default, reuseIdentifier: "cellID")
            cell.selectionStyle = .none
        }
        let dic = dataArray![indexPath.row] as! NSDictionary
        cell.reloadCellByDic(dic: dic)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DragonDetailViewController()
        let dic = dataArray![indexPath.row] as! NSDictionary
        vc.dragonDic = dic
        vc.ongAmount = ongAmount
        vc.walletAddress = walletAddress
        vc.walletDic = walletDic
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
