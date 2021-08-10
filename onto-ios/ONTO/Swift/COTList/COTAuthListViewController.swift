//
//  COTAuthListViewController.swift
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
class COTAuthListViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    

    var page:Int = 1
    var tableView:UITableView?
    var dataArray:NSMutableArray? = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNav()
        createUI()
        page = 1
        getData()
    }
    func getData() {
        var urlString:String
        if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
            urlString = "\(COTAuthList)EN"
        }else{
            urlString = "\(COTAuthList)CN"
        }
        let params:NSDictionary? = ["OwnerOntId":UserDefaults.standard.value(forKey: ONT_ID) as! String? ?? "" , "DeviceCode":UserDefaults.standard.value(forKey: DEVICE_CODE) as! String? ?? ""  , "PageNumber":page,"PageSize":10]
        CCRequest.shareInstance()?.request(withURLString: urlString, methodType: .POST, params: params, success: { (responseObject, responseOriginal) in
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
            print("AuthList =\(responseOriginal!)")
            let dic = (responseOriginal as! NSDictionary).value(forKey: "Result") as! NSDictionary
            let arr = dic["RecordList"] as! NSArray
            if self.page == 1{
                self.dataArray?.removeAllObjects()
                self.dataArray?.addObjects(from: arr as! [Any])
            }else{
                self.dataArray?.addObjects(from: arr as! [Any])
            }
            if self.dataArray?.count == 0{
                self.createEmptyV()
            }
            self.tableView?.reloadData()
            
        }, failure: { (error, errorDesc, responseOriginal) in
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
            if self.dataArray?.count == 0{
                self.createEmptyV()
            }
        })
        
    }
    func createEmptyV() {
        self.tableView?.isHidden = true
        
        let emptyImage = UIImageView.init()
        emptyImage.image = UIImage(named: "emptyCOT")
        view.addSubview(emptyImage)
        
        let emptyLB = UILabel.init()
        emptyLB.text = LocalizeEx("emptyAuth")
        emptyLB.numberOfLines = 0
        emptyLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        emptyLB.changeSpace(0, wordSpace: 1)
        emptyLB.textAlignment = .left
        view.addSubview(emptyLB)
        
        emptyImage.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(view)
            make?.top.equalTo()(view)?.offset()(125*SCALE_W)
            make?.width.height()?.equalTo()(80*SCALE_W)
        }
        
        emptyLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(38*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-38*SCALE_W)
            make?.top.equalTo()(emptyImage.mas_bottom)?.offset()(30*SCALE_W)
        }
    }
    func createNav() {
        
        let titleSize = getSize(str: LocalizeEx("AUTHORIZATIONS"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = LocalizeEx("AUTHORIZATIONS")
        navTitle.textColor = UIColor.black
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 2)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
    }
    func createUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 64  ), style: .plain)
        if UIDevice.current.isX() {
            tableView?.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 34 - 88 )
        }
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
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153*SCALE_W
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:AuthListCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? AuthListCell
        if cell == nil {
            cell = AuthListCell(style: .default, reuseIdentifier: "cellID")
            cell.selectionStyle = .none
        }
        let dic = self.dataArray![indexPath.row] as! NSDictionary
        cell.reloadCellByDic(dic: dic)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = COTAuthDetailViewController()
        let dic = self.dataArray![indexPath.row] as! NSDictionary
        vc.authDic = dic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func navLeftAction() {
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

}
