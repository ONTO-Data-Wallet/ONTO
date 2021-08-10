//
//  NewBoxListViewController.swift
//  ONTO
//
//  Created by Apple on 2018/9/30.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
class NewBoxListViewController: ZYSWController {
    public var _list:[BoxListModel]! = [BoxListModel]();

    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UISet();
        // Do any additional setup after loading the view.
    }
    func UISet() {
        
        
        
        self.title = LocalizeEx("candy_box")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 21, weight: .bold),NSAttributedStringKey.kern:2]
        
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#000842")
        self.view.backgroundColor = UIColor(hexString: "#000842")
       
        let navbutton = UIButton.init()
        navbutton.setTitle(LocalizeEx("ACCOUNT"), for: .normal)
        navbutton.setTitleColor(UIColor.white, for: .normal)
        navbutton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        let rightItem = UIBarButtonItem.init(customView: navbutton)
        self.navigationItem.rightBarButtonItem = rightItem;
        navbutton.handleControlEvent(.touchUpInside) {
            
        }
        
//        let item:UIBarButtonItem! = UIBarButtonItem.init(title: "ACCOUNT", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(self.rightBarItemClicked(sender:)));
//        self.navigationItem.rightBarButtonItem = item;

    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    //MARK: - clicked
    @objc func rightBarItemClicked(sender:Any) -> Void {
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
