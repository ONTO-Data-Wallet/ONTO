//
//  DragonDetailViewController.swift
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
class DragonDetailViewController: BaseViewController {
    var bottomBtn:UIButton!
    var dragonDic: NSDictionary!
    var walletAddress: String!
    var ongAmount: String!
    var walletDic: NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        createNav()
        createUI()
        getData()
    }
    func getData() {
    }
    func createNav() {
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        self.setNavRightImageIcon(UIImage(named: "coticon-none"), title: "")
    }
    func createUI() {
        
        let dragonImage = UIImageView()
        let svgImage = SVGKImage.init(contentsOf: URL.init(string: "\(dragonDic["src"]!)")) as SVGKImage
        dragonImage.image = svgImage.uiImage
        view.addSubview(dragonImage)
        
        let nameLB = UILabel()
        nameLB.text = (dragonDic["name"] as! String)
        nameLB.textAlignment = .left
        nameLB.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLB.changeSpace(0, wordSpace: 1)
        view.addSubview(nameLB)
        
        let generationLB = UILabel()
        if (UserDefaults.standard.value(forKey: HomeLanguage) as! NSString) .isEqual(to: "en"){
            generationLB.text = "\(LocalizeEx("gen")) \(dragonDic["gen"] ?? "0")"
        }else{
            generationLB.text = "\(dragonDic["gen"] ?? "0") \(LocalizeEx("gen"))"
        }
        
        generationLB.textAlignment = .left
        generationLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        generationLB.changeSpace(0, wordSpace: 1)
        view.addSubview(generationLB)
        
        let sex = UILabel()
        let sexString = "\(dragonDic["sex"] ?? "1")"
        if  (sexString as NSString).isEqual(to: "1") {
           sex.text = "\(LocalizeEx("sexLB"))\(LocalizeEx("sexMan"))"
        }else{
            sex.text = "\(LocalizeEx("sexLB"))\(LocalizeEx("sexGial"))"
        }
        sex.textAlignment = .left
        sex.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        sex.changeSpace(0, wordSpace: 1)
        view.addSubview(sex)
        

        let propLB1 = UILabel()
        let propLB1String = "\(dragonDic["element"] ?? "1")"
        
        if  (propLB1String as NSString).isEqual(to: "1") {
            propLB1.text = "\(LocalizeEx("propLB"))\(LocalizeEx("propwater"))"
        }else if  (propLB1String as NSString).isEqual(to: "2"){
            propLB1.text = "\(LocalizeEx("propLB"))\(LocalizeEx("propfire"))"
        }else if  (propLB1String as NSString).isEqual(to: "3"){
            propLB1.text = "\(LocalizeEx("propLB"))\(LocalizeEx("propwind"))"
        }else if  (propLB1String as NSString).isEqual(to: "4"){
            propLB1.text = "\(LocalizeEx("propLB"))\(LocalizeEx("propland"))"
        }
        propLB1.textAlignment = .left
        propLB1.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        propLB1.changeSpace(0, wordSpace: 1)
        view.addSubview(propLB1)
        
//        dragonlevel = "level: ";
//        dragonPower = "power: ";
        
        let propLB = UILabel()
        propLB.text = "\(LocalizeEx("dragonlevel"))\(dragonDic["level"] ?? "0") " //"\(dragonDic["lang_fightcd"] ?? "") | \(dragonDic["lang_gencd"] ?? "")"
        propLB.textAlignment = .left
        propLB.numberOfLines = 0
        propLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        propLB.changeSpace(0, wordSpace: 1)
        view.addSubview(propLB)
        
        let propLB2 = UILabel()
        propLB2.text = "\(LocalizeEx("dragonPower"))\(dragonDic["fight_power"] ?? "0") " //"\(dragonDic["lang_fightcd"] ?? "") | \(dragonDic["lang_gencd"] ?? "")"
        propLB2.textAlignment = .left
        propLB2.numberOfLines = 0
        propLB2.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        propLB2.changeSpace(0, wordSpace: 1)
        view.addSubview(propLB2)
        
        let skillLB = UILabel()
        let skillArr = dragonDic["lang_skill"] as! NSArray
        var skillString: String = ""
        for item in skillArr {
            let itemString = "\(item)"
            if (itemString as NSString).isEqual(to: "<null>"){
            }else{
                if skillString.count == 0 {
                    skillString += itemString
                }else{
                    skillString += " • \(itemString)"
                }
            }
        }
        print("skillString=\(skillString)")
        
        if skillString.count == 0 {
            skillLB.text = LocalizeEx("dragonNone")
        }else{
            skillLB.text = skillString
        }
        skillLB.textAlignment = .left
        skillLB.numberOfLines = 0
        skillLB.textColor = UIColor(hexString: "#6E6F70")
        skillLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        skillLB.changeSpace(0, wordSpace: 1)
//        view.addSubview(skillLB)
        
        dragonImage.mas_makeConstraints { (make) in
            make?.right.equalTo()(view)?.offset()(-15*SCALE_W)
            make?.top.equalTo()(view)?.offset()(10*SCALE_W)
            make?.width.height()?.equalTo()(125*SCALE_W)
        }
        
        nameLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(view)?.offset()(10*SCALE_W)
        }
        
        generationLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(nameLB)
            make?.top.equalTo()(nameLB.mas_bottom)?.offset()(6*SCALE_W)
        }
        
        sex.mas_makeConstraints { (make) in
            make?.left.equalTo()(generationLB.mas_right)?.offset()(20*SCALE_W);
            make?.top.equalTo()(nameLB.mas_bottom)?.offset()(6*SCALE_W)
        }
        
        propLB1.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W);
            make?.top.equalTo()(generationLB.mas_bottom)?.offset()(15*SCALE_W)
        }
        
        propLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(nameLB)
            make?.top.equalTo()(propLB1.mas_bottom)?.offset()(15*SCALE_W)
//            make?.right.equalTo()(dragonImage.mas_left)?.offset()(-10*SCALE_W)
        }
        
        propLB2.mas_makeConstraints { (make) in
            make?.left.equalTo()(propLB.mas_right)?.offset()(20*SCALE_W)
            make?.top.equalTo()(propLB1.mas_bottom)?.offset()(15*SCALE_W)
//            make?.right.equalTo()(dragonImage.mas_left)?.offset()(-10*SCALE_W)
        }
//        skillLB.mas_makeConstraints { (make) in
//            make?.left.equalTo()(nameLB)
//            make?.top.equalTo()(propLB2.mas_bottom)?.offset()(12*SCALE_W)
//            make?.right.equalTo()(dragonImage.mas_left)?.offset()(-10*SCALE_W)
//        }
        
        bottomBtn = UIButton.init()
        self.bottomBtn.backgroundColor = UIColor.black
        self.bottomBtn.isUserInteractionEnabled = true
        bottomBtn.setTitle(LocalizeEx("pumSend"), for: .normal)
        bottomBtn.setTitleColor(UIColor.white, for: .normal)
        bottomBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        bottomBtn.titleLabel?.changeSpace(0, wordSpace: 3)
        view.addSubview(bottomBtn)
        
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
            let vc = SendViewController()
            vc.amount = "1"
            vc.ongAmount = self.ongAmount
            vc.isDragon = true
            vc.walletAddr = self.walletAddress
            vc.pumType = LocalizeEx("dragon")
            vc.dragonId = "\(self.dragonDic["id"]!)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
    }
    override func navRightAction() {
        let getVc = GetViewController()
        self.navigationController?.pushViewController(getVc, animated: true)
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
