//
//  NewClaimFailViewController.swift
//  ONTO
//
//  Created by Apple on 2018/8/27.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
class NewClaimFailViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    @objc var statusType: String!
    @objc var contentStr: String!
    @objc var contentStrLeft: String!
    @objc var claimContext:String!
    var claimId:String?
    
    var tableView:UITableView?
    var dataArray:NSMutableArray? = []
    var dataContentArray:NSMutableArray? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNav()
        createUI()
        // Do any additional setup after loading the view.
    }
    func createNav() {
        let titleSize = getSize(str: self.loacalkey(key: "newClaimDetail"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 21, weight: .bold), lineSpace: 0, wordSpace: 2)
        let navTitle = UILabel(frame: CGRect(x: Int(SYSWidth/2 - titleSize.width/2), y: LL_StatusBarHeight + 15, width: Int(titleSize.width), height: 28))
        navTitle.text = self.loacalkey(key: "newClaimDetail")
        navTitle.textColor = UIColor.black
        navTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        navTitle.changeSpace(lineSpace: 0, wordSpace: 2)
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        
        let buttonSize = getSize(str: self.loacalkey(key: "NEWUPDATE"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 12, weight: .bold), lineSpace: 0, wordSpace: 0)
        let navbutton = UIButton(frame: CGRect(x: 0, y: LL_StatusBarHeight + 15, width: Int(buttonSize.width), height: 28))
        navbutton.setTitle(self.loacalkey(key: "NEWUPDATE"), for: .normal)
        navbutton.setTitleColor(UIColor.black, for: .normal)
        navbutton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        let rightItem = UIBarButtonItem.init(customView: navbutton)
        //UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:navbutton];
        self.navigationItem.rightBarButtonItem = rightItem;
        //        self.navigationItem.titleView = navbutton
    }
    func createUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight  - 20 - 49 - 100*SCALE_W), style: .grouped)
        if UIDevice.current.isX() {
            tableView?.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 83 - 44 - 100*SCALE_W )
        }
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view?.addSubview(tableView!)
        
//        let logoV = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 96*SCALE_W))
//        let logoImage = UIImageView(frame: CGRect(x: 70*SCALE_W, y: 30*SCALE_W, width: SYSWidth - 140*SCALE_W, height: 36*SCALE_W))
//        logoImage.image = UIImage(named: "Ontoloogy Attested")
//        logoV.addSubview(logoImage)
//
//        tableView?.tableFooterView = logoV
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 145*SCALE_W))
        
        let bgV = UIImageView(frame: CGRect(x: 20*SCALE_W, y: 25*SCALE_W, width: SYSWidth - 40*SCALE_W, height: 100*SCALE_W))
        
        v.addSubview(bgV)
        
        if (self.statusType as NSString) .isEqual(to: "mobile"){
            bgV.image = UIImage(named: "NewGroupbg")
            let lb = UILabel(frame: CGRect(x: 120*SCALE_W, y: 23*SCALE_W, width: SYSWidth - 170*SCALE_W, height: 28*SCALE_W))
            lb.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            lb.textAlignment = .left
            lb.text = loacalkey(key: "myClaimD")
            lb.changeSpace(lineSpace: 0, wordSpace: 2)
            bgV.addSubview(lb)
            
            let lb1 = UILabel(frame: CGRect(x: 120*SCALE_W, y: 50*SCALE_W, width: SYSWidth - 170*SCALE_W, height: 28*SCALE_W))
            lb1.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            lb1.textAlignment = .left
            lb1.text = "+\(contentStrLeft ?? "") \(contentStr ?? "")" //"+86 13333333333"
            lb1.changeSpace(lineSpace: 0, wordSpace: 2*SCALE_W)
            bgV.addSubview(lb1)
            
        }else{
            bgV.image = UIImage(named: "newGroup 6")
            let lb = UILabel(frame: CGRect(x: 15*SCALE_W, y: 29*SCALE_W, width: SYSWidth - 170*SCALE_W, height: 28*SCALE_W))
            lb.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            lb.textAlignment = .left
            lb.text = loacalkey(key: "myClaimD")
            lb.changeSpace(lineSpace: 0, wordSpace: 2)
            bgV.addSubview(lb)
            
            let lb1 = UILabel(frame: CGRect(x: 15*SCALE_W, y: 56*SCALE_W, width: SYSWidth - 70*SCALE_W, height: 28*SCALE_W))
            lb1.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            lb1.textAlignment = .left
            lb1.text = contentStr!
            lb1.changeSpace(lineSpace: 0, wordSpace: 1*SCALE_W)
            bgV.addSubview(lb1)
        }
        
        
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 145*SCALE_W
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            let mobileSize = getSize(str: "sdfgsdjfgsjdfgsdhjfcgsdhfcgsdjhfgsdjhfsdjfsjfgsjdfgsdjgfjsfsfdfs", width: SYSWidth - 40*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
            
            return 64*SCALE_W + mobileSize.height
        }
        return 80*SCALE_W
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:NewClaimDetailCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? NewClaimDetailCell
        if cell == nil {
            cell = NewClaimDetailCell(style: .default, reuseIdentifier: "cellID")
        }
        let arr = dataArray![1] as! NSArray
        let arr1 = dataContentArray![1] as! NSArray
        cell.topLB.text = arr[indexPath.row] as? String
        cell.topLB.changeSpace(lineSpace: 0, wordSpace: 1)
        cell.bottomLB.text = arr1[indexPath.row] as? String
        if indexPath.row == 3 {
            //            cell.bottomLB.text = "sdfgsdjfgsjdfgsdhjfcgsdhfcgsdjhfgsdjhfsdjfsjfgsjdfgsdjgfjsfsfdfs"
            cell.rightBtn.isHidden = false
        }
        let mobileSize = getSize(str: cell.bottomLB.text!, width: SYSWidth - 40*SCALE_W, font: UIFont.systemFont(ofSize: 14, weight: .medium), lineSpace: 1, wordSpace: 1)
        
        cell.bottomLB.frame = CGRect(x: 20*SCALE_W, y: 45*SCALE_W*SCALE_W, width: SYSWidth - 40*SCALE_W, height: mobileSize.height)
        cell.line.frame = CGRect(x: 20*SCALE_W, y: 64*SCALE_W + mobileSize.height - 1, width: SYSWidth - 20*SCALE_W, height: 1)
        cell.bottomLB.changeSpace(lineSpace: 1, wordSpace: 1)
        return cell
        
    }
    override func navLeftAction() {
        self.navigationController!.popToRootViewController(animated: true)
    }
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        return bundle
        
    }
    public func getColorAttrString1(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat,defaultColor: UIColor,cColor: UIColor,cColorLocation:Int,cColorLength:Int) -> NSMutableAttributedString {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: font, range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttribute( kCTParagraphStyleAttributeName as NSAttributedStringKey , value: paragraphStyle, range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [ NSAttributedStringKey.foregroundColor : defaultColor], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttribute( NSAttributedStringKey.foregroundColor , value: cColor, range: NSRange(location:cColorLocation,length:cColorLength))
        return attributedString
    }
    public func getAttrString(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat) -> NSMutableAttributedString {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttributes([kCTFontAttributeName as NSAttributedStringKey : font], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [kCTParagraphStyleAttributeName as NSAttributedStringKey : paragraphStyle], range: .init(location: 0, length: ((str as NSString).length)))
        return attributedString
    }
    func appendColorStrWithString(str:String,font:CGFloat,color:UIColor) -> NSMutableAttributedString {
        var attributedString : NSMutableAttributedString
        let attStr = NSMutableAttributedString.init(string: str, attributes: [kCTFontAttributeName as NSAttributedStringKey : UIFont.systemFont(ofSize: font),kCTForegroundColorAttributeName as NSAttributedStringKey:color])
        attributedString = NSMutableAttributedString.init(attributedString: attStr)
        return attributedString
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
