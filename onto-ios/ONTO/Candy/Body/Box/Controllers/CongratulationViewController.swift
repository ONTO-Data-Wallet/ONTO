//
//  CongratulationViewController.swift
//  ONTO
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class CongratulationViewController: BaseViewController {
    var alertString:NSMutableAttributedString!
    var imageString:String?
    var moneyNum:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
    func createUI() {
        let bgimage = UIImageView.init()
        if UIDevice.current.isX(){
            bgimage.image = UIImage(named: "boxbgx")
        }else{
            bgimage.image = UIImage(named: "candybg")
        }
        view.addSubview(bgimage)
        
        let backBtn = UIButton.init()
        backBtn.setImage(UIImage(named: "whiteback"), for: .normal)
        view.addSubview(backBtn)
        
        let titleLB = UILabel.init()
        titleLB.text = LocalizeEx("CONGRATULATION")
        titleLB.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLB.textColor = UIColor.white
        titleLB.changeSpace(0, wordSpace: 1)
        titleLB.textAlignment = .center
        view.addSubview(titleLB)
        
        let detailLB = UILabel.init()
        detailLB.attributedText = alertString
        detailLB.numberOfLines = 0
        detailLB.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        detailLB.textColor = UIColor.white
        detailLB.changeSpace(2, wordSpace: 0)
        detailLB.textAlignment = .center
        view.addSubview(detailLB)
        
        if Common.isStringEmpty(moneyNum) {
        }else{
            detailLB.isHidden = true
            
            let successVV = PumAlert.init(title: alertString, imageString: imageString, numString: moneyNum, buttonString: LocalizeEx("OK"), isCandy: true)
            successVV?.show()
        }
        let infoLB = UILabel.init()
        infoLB.text = LocalizeEx("candyWInfo")
        infoLB.numberOfLines = 0
        infoLB.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        infoLB.textColor = UIColor.white
        infoLB.changeSpace(2, wordSpace: 0)
        infoLB.textAlignment = .left
        view.addSubview(infoLB)
        
        let checkBtn = UIButton.init()
        checkBtn.backgroundColor = UIColor.black
        checkBtn.setTitle(LocalizeEx("CHECKMYACCOUNT"), for: .normal)
        checkBtn.setTitleColor(UIColor.white, for: .normal)
        checkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        checkBtn.titleLabel?.changeSpace(0, wordSpace: 3*SCALE_W)
        view.addSubview(checkBtn)
        
        
        bgimage.mas_makeConstraints { (make) in
            make?.left.right()?.top()?.bottom()?.equalTo()(view)
        }
        
        backBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(13*SCALE_W)
            if UIDevice.current.isX(){
                make?.top.equalTo()(view)?.offset()(35*SCALE_W + 24)
            }else{
                make?.top.equalTo()(view)?.offset()(35*SCALE_W)
            }
            make?.width.height()?.equalTo()(28*SCALE_W)
        }
        
        titleLB.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
            make?.top.equalTo()(backBtn.mas_bottom)?.offset()(15*SCALE_W)
        }
        
        detailLB.mas_makeConstraints { (make) in
            make?.top.equalTo()(titleLB.mas_bottom)?.offset()(15*SCALE_W)
            make?.width.equalTo()(180*SCALE_W)
            make?.centerX.equalTo()(view)
        }
        
        checkBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            if UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W - 34)
            }else{
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W)
            }
        }
        infoLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(38*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-38*SCALE_W)
//            make?.top.equalTo()(backBtn.mas_bottom)?.offset()(444*SCALE_W)
            make?.bottom.equalTo()(checkBtn.mas_top)?.offset()(-25*SCALE_W)
        }
        
        backBtn.handleControlEvent(.touchUpInside) {
            self.navigationController?.popViewController(animated:  true)
        }
        checkBtn.handleControlEvent(.touchUpInside) {
            if LoginCenter.shared().bNeedLogin() == false {
                let cv = AccountController()
                cv.bShowBack = true;
                self.navigationController?.pushViewController(cv, animated: true);
                return;
            }
            
            let cv = LoginDescController()
            cv.bShowBack = true;
            self.navigationController?.pushViewController(cv, animated: true);
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = .default
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
