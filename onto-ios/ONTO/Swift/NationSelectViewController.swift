//
//  NationSelectViewController.swift
//  ONTO
//
//  Created by 赵伟 on 2018/8/8.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth / 375)

class NationSelectViewController: BaseViewController {

    @objc var modelArr: NSArray!
    @objc var typeString:String!
    var countryBtn1 = UIButton(type: .custom)
    var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configUI()

    }

    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (typeString as NSString).isEqual(to: "Shufti"){
            self.navigationController?.navigationBar.titleTextAttributes = {[NSAttributedStringKey.foregroundColor : UIColor.black,
                                                                         NSAttributedStringKey.font : UIFont.systemFont(ofSize: 21, weight: .bold),
                                                                         NSAttributedStringKey.kern: 2]}()
        }
    }
    func configUI() {
        self.setNavTitle(self.loacalkey(key: "IM_Nationality"))
        
        if (typeString as NSString).isEqual(to: "Shufti"){
            self.setNavLeftImageIcon(UIImage.init(named: "cotback"), title: "Back")
        }else{
            self.setNavLeftImageIcon(UIImage.init(named: "nav_back"), title: "Back")
        }
        //标题
        let titleLabel = UILabel.init()
        titleLabel.text = self.loacalkey(key: "IM_Connect")
        titleLabel.text = self.loacalkey(key: "IM_Connect")
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        titleLabel.textColor = UIColor(hexString: "#2B4045")
        self.view.addSubview(titleLabel)
        if (typeString as NSString).isEqual(to: "Shufti"){
            titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .bold)
            titleLabel.changeSpace(0, wordSpace: 2)
            titleLabel.textColor = UIColor.black
        }
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(self.view)
            make?.top.equalTo()(self.view.mas_top)?.offset()(60)
        }

        //副标题
        let subTitleL = UILabel.init()
        subTitleL.text = self.loacalkey(key: "IM_Legal")
        subTitleL.font = UIFont.systemFont(ofSize: 14)
        subTitleL.textColor = UIColor(hexString: "#6A797C")
        subTitleL.numberOfLines = 0
        self.view.addSubview(subTitleL)
        if (typeString as NSString).isEqual(to: "Shufti"){
            subTitleL.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            subTitleL.changeSpace(0, wordSpace: 1)
            subTitleL.textColor = UIColor.black
        }
        subTitleL.textAlignment = .left
        Common.setLabelSpace(subTitleL, withValue: self.loacalkey(key: "IM_Legal"), with: UIFont.systemFont(ofSize: 14))
        subTitleL.mas_makeConstraints { (make) in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(20)
            make?.left.equalTo()(self.view)?.offset()(36)
            make?.right.equalTo()(self.view)?.offset()(-36)
        }

        let countryBtn = UIButton(type: .custom)
        self.view.addSubview(countryBtn)
        countryBtn.setTitle(self.loacalkey(key: "IM_Choose1"), for: UIControlState.normal)
        
        countryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        countryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        if (typeString as NSString).isEqual(to: "Shufti"){
            countryBtn.setTitleColor(UIColor(hexString: "#000000"), for: UIControlState.normal)
            countryBtn.titleLabel?.changeSpace(0, wordSpace: 1)
        }else{
            countryBtn.setTitleColor(UIColor(hexString: "#6A797C"), for: UIControlState.normal)
        }
        countryBtn.handleControlEvent(UIControlEvents.touchUpInside) {

            let vc = XWCountryCodeController()
            vc.returnCountryCodeBlock = { countryString in
                let mystring = countryString?.replacingOccurrences(of: "+" + self.getIntFromString(str: countryString!), with: "")
                let mystring1 = mystring?.replacingOccurrences(of: self.getIntFromString(str: mystring!), with: "")
                let cerStr = mystring1! as NSString
                let charstr = mystring1?.last
                let origalstr = "\(charstr!)"
                var surestr: String!
                if (origalstr as NSString).isEqual(to: " ") {
                    surestr = cerStr.substring(to: cerStr.length - 2)
                } else {
                    surestr = "\(cerStr)"
                }
                self.countryBtn1.setTitle(mystring, for: .normal)
                self.countryBtn1.setTitleColor(UIColor(hexString: "#2B4045"), for: .normal)
                if (self.typeString as NSString).isEqual(to: "IM"){
                    let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appdelegate.selectCountry = Common.getLocalWithcountryName(surestr!)
                }else{
                    self.nextBtn.backgroundColor = UIColor(hexString: "#000000")
                    let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appdelegate.selectCountry = Common.getLocalWithcountryName(surestr!)
                }
                

            }
            self.navigationController?.pushViewController(vc, animated: true)

        }

        countryBtn.mas_makeConstraints { (make) in

            make?.height.equalTo()(44)
            make?.top.equalTo()(subTitleL.mas_bottom)?.offset()(70)
            make?.left.equalTo()(self.view)?.offset()(25)
            make?.right.equalTo()(self.view)?.offset()(-25)
        }
        self.countryBtn1 = countryBtn


        let phoneimage = UIImageView.init()
        phoneimage.image = UIImage.init(named: "menudark")
        self.view.addSubview(phoneimage)
        phoneimage.mas_makeConstraints { (make) in
            make?.width.height().equalTo()(20)
            make?.centerY.equalTo()(countryBtn)?.offset()(0)
            make?.left.equalTo()(countryBtn.mas_right)?.offset()(-20)

        }


        let line1 = UIView.init()

        self.view.addSubview(line1)
        line1.backgroundColor = UIColor(hexString: "#E9EDEF")
        line1.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(countryBtn)
            make?.top.equalTo()(countryBtn.mas_bottom)?.offset()(0)
            make?.height.equalTo()(1)
        }

//        let whatBtn = UIButton(frame: CGRect(x: 0, y: 348, width: SYSWidth, height: 17 * SCALE_W))
//        if UIScreen.main.bounds.width == 320 {
//            whatBtn.frame = CGRect(x: 0, y: 373, width: SYSWidth, height: 17 * SCALE_W)
//        }
        let whatBtn = UIButton()
        view.addSubview(whatBtn)
        whatBtn.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
            make?.top.equalTo()(line1.mas_bottom)?.offset()(10)
            make?.height.equalTo()(17*SCALE_W)
        }
        if (typeString as NSString).isEqual(to: "Shufti"){
            whatBtn.setTitle(self.loacalkey(key: "SFPSL"), for: .normal)
        }else{
            whatBtn.setTitle(self.loacalkey(key: "newAlert"), for: .normal)
        }
//        whatBtn.mas_makeConstraints { (make) in
////            make?.left.right().equalTo()(self.view)
//            make?.top.equalTo()(line1.mas_bottom)?.offset()(24*SCALE_W)
//            make?.height.equalTo()(1)
//            make?.width.equalTo()(SYSWidth)
//        }
        whatBtn.setImage(UIImage(named: "IdHelp"), for: .normal)
        
        whatBtn.setTitleColor(UIColor(hexString: "#29A6FF"), for: .normal)
        whatBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        whatBtn.handleControlEvent(.touchUpInside) {
            let vc = WebIdentityViewController()
            if (self.typeString as NSString).isEqual(to: "Shufti"){
                vc.introduce = "https://info.onto.app/#/detail/84"
            }else{
                vc.introduce = "https://info.onto.app/#/detail/70"
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }

        self.nextBtnConfig()
    }

    func nextBtnConfig() {

        nextBtn = UIButton(type: .custom)
        nextBtn.setTitle(self.loacalkey(key: "IM_Submit"), for: UIControlState.normal)
        self.view.addSubview(nextBtn)
        
        if (typeString as NSString).isEqual(to: "Shufti"){
            nextBtn.backgroundColor = UIColor(hexString: "#9B9B9B")
            nextBtn.setTitleColor(UIColor.white, for: .normal)
            nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            nextBtn.titleLabel?.changeSpace(0, wordSpace: 3)
            nextBtn.mas_makeConstraints { (make) in
                make?.left.equalTo()(self.view)?.offset()(58*SCALE_W)
                make?.right.equalTo()(view)?.offset()(-58*SCALE_W)
                make?.height.equalTo()(60*SCALE_W)
                if UIDevice.current.isX() {
                    make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W - 34)
                }else{
                    make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W)
                }
            }
        }else{
            nextBtn.backgroundColor = UIColor(hexString: "#F0F7FC")
            nextBtn.setTitleColor(UIColor(hexString: "#29A6FF"), for: UIControlState.normal)
            nextBtn.mas_makeConstraints { (make) in
                make?.left.right().equalTo()(self.view)
                make?.height.equalTo()(48)
                if #available(iOS 11, *) {
                    make?.bottom.equalTo()(self.view.mas_safeAreaLayoutGuideBottom)
                } else {
                    make?.bottom.equalTo()(self.view.mas_bottom)
                }
            }
            nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        nextBtn.handleControlEvent(UIControlEvents.touchUpInside) {

            if self.countryBtn1.titleLabel?.text == self.loacalkey(key: "IM_Choose1") {

//                ToastUtil.shortToast(self.view, value: self.loacalkey(key: "IM_Choose1"))
                Common.showToast(self.loacalkey(key: "IM_Choose1"))

            } else {
                if  (self.typeString as NSString).isEqual(to: "Shufti"){
                    let vc = ShuftiDocViewController()
                    vc.modelArr = self.modelArr
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = DocTypeViewController()
                    vc.modelArr = self.modelArr
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }


        }

    }

    // 从字符串中提取数字
    func getIntFromString(str: String) -> String {
        let scanner = Scanner(string: str)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number: Int = 0

        scanner.scanInt(&number)

        print(number)
        return String(number)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func loacalkey(key: String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let bundle: String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        return bundle

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
