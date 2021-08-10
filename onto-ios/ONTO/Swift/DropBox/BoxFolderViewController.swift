//
//  BoxFolderViewController.swift
//  ONTO
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class BoxFolderViewController: BaseViewController {
    var jsonStr: String!
    var type: String!
    var dropbox:CRDropbox!
    var hub:MBProgressHUD!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
        
        let boxV = UIImageView.init()
        boxV.image = UIImage(named: "dropbox")
        view.addSubview(boxV)
        
        let boxLB = UILabel.init()
        boxLB.numberOfLines = 0
        hub = ToastUtil.showMessage("", to: nil)
        let queue = DispatchQueue.init(label: "box")
        queue.async {
            let exitonto = self.dropbox.fileExists(atPath: "/onto")
            if exitonto {
            }else{
                self.dropbox.createFolder(withPath: "/onto")
            }
            dispatch_async_on_main_queue({
                boxLB.text = self.dropbox.userName()
                self.hub.hide(animated: true)
            })
            
        }
        boxLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        boxLB.changeSpace(2, wordSpace: 1)
        boxLB.textAlignment = .center
        view.addSubview(boxLB)
        
        boxV.mas_makeConstraints { (make) in
            make?.top.equalTo()(view)?.offset()(20)
            make?.centerX.equalTo()(view.mas_centerX)
            make?.width.height()?.equalTo()(110*SCALE_W)
        }
        
        boxLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(45*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-45*SCALE_W)
            make?.top.equalTo()(boxV.mas_bottom)?.offset()(10*SCALE_W)
        }
        
        
        let dropfolderV = UIImageView.init()
        dropfolderV.image = UIImage(named: "dropfolder")
        view.addSubview(dropfolderV)
        
        let dropfolderLB = UILabel.init()
        dropfolderLB.text = "ONTO"
        dropfolderLB.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        dropfolderLB.changeSpace(0, wordSpace: 1)
        dropfolderLB.textAlignment = .left
        view.addSubview(dropfolderLB)
        
        let rightV = UIImageView.init()
        rightV.image = UIImage(named: "newRectangle")
        view.addSubview(rightV)
        
        let line = UIView.init()
        line.backgroundColor = UIColor(hexString: "#E9EDEF")
        view.addSubview(line)
        
        let btn = UIButton.init()
        view.addSubview(btn)
        
        dropfolderV.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.top.equalTo()(boxLB.mas_bottom)?.offset()(47*SCALE_W)
            make?.width.height()?.equalTo()(20*SCALE_W)
        }
        
        dropfolderLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(dropfolderV.mas_right)?.offset()(10*SCALE_W)
            make?.centerY.equalTo()(dropfolderV.mas_centerY)?.offset()(0)
        }
        
        rightV.mas_makeConstraints { (make) in
            make?.width.height()?.equalTo()(20*SCALE_W)
            make?.centerY.equalTo()(dropfolderV.mas_centerY)?.offset()(0)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(20*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-20*SCALE_W)
            make?.height.equalTo()(1)
            make?.top.equalTo()(dropfolderV.mas_bottom)?.offset()(17*SCALE_W)
        }
        
        btn.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(view)
            make?.top.equalTo()(boxLB.mas_bottom)?.offset()(30*SCALE_W)
            make?.height.equalTo()(54*SCALE_W)
        }
        
        btn.handleControlEvent(.touchUpInside) {
            let vc = BoxFolderListViewController()
            vc.dropbox = self.dropbox
            vc.jsonStr = self.jsonStr
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
        
        
    }
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
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
