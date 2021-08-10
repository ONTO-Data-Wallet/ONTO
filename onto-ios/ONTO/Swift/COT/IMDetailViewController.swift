//
//  IMDetailViewController.swift
//  ONTO
//
//  Created by Apple on 2018/8/9.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class IMDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView:UITableView?
    var dataArray:NSMutableArray?
    var dataContentArray:NSMutableArray?
    var showDic:NSMutableDictionary!
    var arrowBtn:UIButton?
    var claimContext: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(NSLocalizedString("newClaimDetails", comment: "default"))
        self.setNavLeftImageIcon(UIImage.init(named:"nav_back"), title: "Back")
//        self.setNavRightImageIcon(UIImage.init(), title: NSLocalizedString("Update", comment: "default"))
        getdata()
        createUI()
    }
    func getdata()  {
        let claimArray = [DataBase.shared().getCalimWithClaimContext(self.claimContext, andOwnerOntId: UserDefaults.standard.value(forKey: ONT_ID) as! String)] as NSArray
        let claimModel = claimArray[0] as! ClaimModel
        if Common.isBlankString(claimModel.ownerOntId) {
            getInfo()
        }else{
            handleData(dic: Common.dictionary(withJsonString: claimModel.content)! as NSDictionary)
        }
    }
    func handleData(dic:NSDictionary)  {
        
        
        let claimData =  Common.claimdencode( dic.value(forKey: "EncryptedOrigData") as! String) as NSDictionary
        let claimDic = claimData.value(forKey: "claim") as! NSDictionary
        guard let proofDic = claimDic.value(forKey: "proof") ,
            let proofDic1 = (proofDic as AnyObject).value(forKey: "Proof")
        else {
//            let allKey = [ NSLocalizedString("authStatus", comment: "default"), NSLocalizedString("Created", comment: "default"),NSLocalizedString("ExpiresAt", comment: "default") ]
//            let allValue = [ NSLocalizedString("IMSuccess", comment: "default"),Common.getTimeFromTimestamp(String(claimDic.value(forKey: "iat")) ),Common.getTimeFromTimestamp(String(claimDic.value(forKey: "exp")))]
//            dataArray?.add(allKey)
//            dataContentArray?.add(allValue)
//            
//            print("data- \(String(describing: dataArray))")
            return
        }
        if Common.isBlankString((proofDic1 as AnyObject).value(forKey: "TxnHash") as! String) {
            let allKey = [ NSLocalizedString("authStatus", comment: "default"), NSLocalizedString("Created", comment: "default"),NSLocalizedString("ExpiresAt", comment: "default") ]
            let allValue = [ NSLocalizedString("IMSuccess", comment: "default"),Common.getTimeFromTimestamp(claimDic.value(forKey: "iat") as! String),Common.getTimeFromTimestamp(claimDic.value(forKey: "exp") as! String)]
            dataArray?.add(allKey)
            dataContentArray?.add(allValue)

        }else{
            let TxnHashStr = Common.isBlankString((proofDic1 as AnyObject).value(forKey: "TxnHash") as! String) ? "" : (proofDic1 as AnyObject).value(forKey: "TxnHash") as! String
            let allKey = [ NSLocalizedString("authStatus", comment: "default"), NSLocalizedString("Created", comment: "default"),NSLocalizedString("ExpiresAt", comment: "default"),NSLocalizedString("BlockchainTransaction", comment: "default")  ]
            let allValue = [ NSLocalizedString("IMSuccess", comment: "default"),Common.getTimeFromTimestamp(claimDic.value(forKey: "iat") as! String),Common.getTimeFromTimestamp(claimDic.value(forKey: "exp") as! String),TxnHashStr]
            dataArray?.add(allKey)
            dataContentArray?.add(allValue)
        }
        print("data= \(String(describing: dataArray))")
//        }
    }
    func getInfo() {
        
    }
    func createUI() {
        view.backgroundColor = UIColor.white
        showDic = NSMutableDictionary(dictionary: ["select": "1"])
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight  - 64), style: .grouped)
        if UIDevice.current.isX() {
            tableView?.frame = CGRect(x: 0, y: 0, width: SYSWidth, height: SYSHeight - 34 - 88 )
        }
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(IMInfoCell.self, forCellReuseIdentifier: "cellID")
        tableView?.register(IMDetailCell.self, forCellReuseIdentifier: "cellID1")
        view?.addSubview(tableView!)
        
//        UIImageView * image =[[UIImageView alloc]initWithFrame:CGRectMake(62*SCALE_W, 31*SCALE_W, SYSWidth-140*SCALE_W, 36*SCALE_W)];
//        [bgV addSubview:image];
//        image.image =[UIImage imageNamed:@"Ontoloogy Attested"];
        
        let logoV = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 96*SCALE_W))
        let logoImage = UIImageView(frame: CGRect(x: 70*SCALE_W, y: 30*SCALE_W, width: SYSWidth - 140*SCALE_W, height: 36*SCALE_W))
        logoImage.image = UIImage(named: "Ontoloogy Attested")
        logoV.addSubview(logoImage)
        tableView?.tableFooterView = logoV
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 4
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let v1 = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 220*SCALE_W))
            
            let image = UIImageView(frame: CGRect(x: 17.5*SCALE_W, y: 0, width: SYSWidth - 35*SCALE_W, height: 210*SCALE_W))
            image.image = UIImage(named: "IMcard")
            image.isUserInteractionEnabled = true
            v1.addSubview(image)
            
            let name = UILabel(frame: CGRect(x: 17*SCALE_W, y: 75*SCALE_W, width: 200*SCALE_W, height: 24*SCALE_W))
            name.textAlignment = .left
            name.textColor = UIColor.white
            name.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            name.text = "Zhao Wang"
            image.addSubview(name)
            
            let typeimage = UIImageView(frame: CGRect(x: 17*SCALE_W, y: 152*SCALE_W, width: 24*SCALE_W, height: 24*SCALE_W))
            typeimage.image = UIImage(named: "IMbluepassport")
            image.addSubview(typeimage)
            
            let type = UILabel(frame: CGRect(x: 51*SCALE_W, y: 148*SCALE_W, width: 200*SCALE_W, height: 16*SCALE_W))
            type.textColor = UIColor.white
            type.textAlignment = .left
            type.text = "Passport ";
            type.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            image.addSubview(type)
            
            let typeCert = UILabel(frame: CGRect(x: 51*SCALE_W, y: 164*SCALE_W, width: 200*SCALE_W, height: 16*SCALE_W))
            typeCert.textColor = UIColor.white
            typeCert.textAlignment = .left
            typeCert.text = "Certification"
            typeCert.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            image.addSubview(typeCert)
            
            arrowBtn = UIButton(frame: CGRect(x: (SYSWidth - 35*SCALE_W)/2 - 8*SCALE_W, y: 186*SCALE_W, width: 16*SCALE_W, height: 16*SCALE_W))
            arrowBtn?.setEnlargeEdge(20)
            arrowBtn?.setImage(UIImage(named: "IMdropdown"), for: .normal)
            image.addSubview(arrowBtn!)
            if (self.showDic.value(forKey: "select") as! NSString) .isEqual(to: "1"){
                self.arrowBtn?.setImage(UIImage(named: "IMdropdown"), for: .normal)
            }else{
                self.arrowBtn?.setImage(UIImage(named: "IMdropup"), for: .normal)
            }
            arrowBtn?.handleControlEvent(.touchDown, with: {
                if (self.showDic.value(forKey: "select") as! NSString) .isEqual(to: "1"){
                    self.showDic.setValue("0", forKey: "select")
                    self.arrowBtn?.setImage(UIImage(named: "IMdropup"), for: .normal)
                }else{
                    self.showDic.setValue("1", forKey: "select")
                    self.arrowBtn?.setImage(UIImage(named: "IMdropdown"), for: .normal)
                }
                self.tableView?.reloadData()
            })
            return v1
        }else{
            let v2 = UIView(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 40*SCALE_W))
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: SYSWidth, height: 40*SCALE_W))
            btn.setImage(UIImage(named: "cotlink"), for: .normal)
            btn.setTitle(NSLocalizedString("IdentityMindCertification", comment: "default"), for: .normal)
            btn.setTitleColor(UIColor(hexString: "#29A6FF"), for: .normal)
            v2.addSubview(btn)
            return v2
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 220*SCALE_W
        }
        return 40*SCALE_W
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if (self.showDic.value(forKey: "select") as! NSString) .isEqual(to: "1"){
                return 0
            }else{
                return 39*SCALE_W
            }
        }
        return 80*SCALE_W
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.section == 0 {
            var cell:IMInfoCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? IMInfoCell
            if cell == nil {
                cell = IMInfoCell(style: .default, reuseIdentifier: "cellID")
                cell.selectionStyle = .none
            }
            
            if (self.showDic.value(forKey: "select") as! NSString) .isEqual(to: "1"){
                cell.isHidden = true
            }else{
                cell.isHidden = false
            }
            cell.leftLB.text = "Name"
            cell.rightLB.text = "China"
            return cell
        }else{
            var cell:IMDetailCell! = tableView.dequeueReusableCell(withIdentifier: "cellID1") as? IMDetailCell
            if cell == nil {
                cell = IMDetailCell(style: .default, reuseIdentifier: "cellID1")
                cell.selectionStyle = .none
            }
            cell.isHidden = false
            cell.topLB.text = "Status"
            cell.bottomLB.text = "cec3fa95b3c79147aab748e5ca55d2c4b02791046a99a05fcc485c0cec080159"
            return cell
        }
        
        
        
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
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
