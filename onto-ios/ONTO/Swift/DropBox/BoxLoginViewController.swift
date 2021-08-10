//
//  BoxLoginViewController.swift
//  ONTO
//
//  Created by Apple on 2018/10/9.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth / 375)
private let LL_iPhoneX = (SYSWidth == 375 && SYSHeight == 812 ? true : false)

class BoxLoginViewController: BaseViewController {

    @objc var jsonStr: String!
    @objc var type: String!
    var hub: MBProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavLeftImageIcon(UIImage.init(named: "cotback"), title: "Back")

        let boxV = UIImageView.init()
        boxV.image = UIImage(named: "dropbox")
        view.addSubview(boxV)

        let boxLB = UILabel.init()
        boxLB.numberOfLines = 0
        boxLB.text = loacalkey(key: "boxInfo")
        boxLB.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        boxLB.changeSpace(2, wordSpace: 1)
        boxLB.textAlignment = .left
        view.addSubview(boxLB)

        let boxLogin = UIButton.init()
        boxLogin.backgroundColor = UIColor.black
        boxLogin.setTitle(loacalkey(key: "LOGINDROPBOX"), for: .normal)
        boxLogin.setTitleColor(UIColor.white, for: .normal)
        boxLogin.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        boxLogin.titleLabel?.changeSpace(0, wordSpace: 3)
        view.addSubview(boxLogin)

        boxV.mas_makeConstraints { (make) in
            make?.top.equalTo()(view)?.offset()(20)
            make?.centerX.equalTo()(view.mas_centerX)
            make?.width.height()?.equalTo()(110 * SCALE_W)
        }

        boxLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(40 * SCALE_W)
            make?.right.equalTo()(view)?.offset()(-40 * SCALE_W)
            make?.top.equalTo()(boxV.mas_bottom)?.offset()(10 * SCALE_W)
        }

        boxLogin.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58 * SCALE_W)
            make?.right.equalTo()(view)?.offset()(-58 * SCALE_W)
            make?.height.equalTo()(60 * SCALE_W)
            if UIDevice.current.isX() {
                make?.bottom.equalTo()(view)?.offset()(-40 * SCALE_W - 34)
            } else {
                make?.bottom.equalTo()(view)?.offset()(-40 * SCALE_W)
            }
        }

        boxLogin.handleControlEvent(.touchUpInside) {
            let exception = tryBlock {
                let dropbox = CRDropbox.init(clientId: "b4uhh5qp4ig3jbg", clientSecret: "ei7nilpkww843hg", redirectUri: "https://www.cloudrailauth.com/com.ontology.foundation.onto", state: "Development")
                dropbox?.login()

                let successV = COTAlertV(title: self.loacalkey(key: "boxLoginS"), imageString: "dropLoginS", buttonString: self.loacalkey(key: "OK"))
                successV?.callback = { (backMsg) in
                    let vc = BoxFolderViewController()
                    vc.dropbox = dropbox
                    vc.jsonStr = self.jsonStr
                    vc.type = self.type
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                successV?.show()
            }
            if exception != nil {
                self.navigationController?.popViewController(animated: true)
            }
        }

    }

    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)


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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
