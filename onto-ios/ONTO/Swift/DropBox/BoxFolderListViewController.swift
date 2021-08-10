//
//  BoxFolderListViewController.swift
//  ONTO
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth / 375)
private let LL_iPhoneX = (SYSWidth == 375 && SYSHeight == 812 ? true : false)

class BoxFolderListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var jsonStr: String!
    var type: String!
    var dropbox: CRDropbox!
    var tableView: UITableView?
    var dataArray: NSMutableArray? = []
    var getBtn: UIButton!
    var isSelect: Bool = false
    var selecRow: Int = -1
    var hub: MBProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavLeftImageIcon(UIImage.init(named: "cotback"), title: "Back")
        createUI()
        getData()
    }

    func getData() {
        hub = ToastUtil.showMessage("", to: nil)
        let queue = DispatchQueue.init(label: "box")
        queue.async {
            let arr = self.dropbox.childrenOfFolder(withPath: "/onto")
//            self.hub.hide(animated: true)
            self.dataArray?.removeAllObjects()
            self.dataArray = arr
            dispatch_async_on_main_queue({
                if (self.type as NSString).isEqual(to: "output") {
                    if self.dataArray?.count == 0 {
                        self.getBtn.isHidden = true
                    }
                }
                self.hub.hide(animated: true)
                self.tableView?.reloadData()
            })

        }

        self.tableView?.reloadData()
    }

    func createUI() {
        tableView = UITableView.init()
        //设置数据源&代理 -> 目的： 子类直接实现数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(BoxCell.self, forCellReuseIdentifier: "cellID")
        view?.addSubview(tableView!)

        getBtn = UIButton.init()
        if (self.type as NSString).isEqual(to: "output") {
            getBtn.setTitle(loacalkey(key: "RESTORE"), for: .normal)
        } else {
            getBtn.setTitle(loacalkey(key: "BACKUP"), for: .normal)
        }
        getBtn.backgroundColor = UIColor.black
        getBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        getBtn.titleLabel?.changeSpace(lineSpace: 0, wordSpace: 2 * SCALE_W)
        getBtn.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(getBtn)

        tableView?.mas_makeConstraints({ (make) in
            make?.left.top()?.right()?.equalTo()(view)
            if UIDevice.current.isX() {
                make?.bottom.equalTo()(view)?.offset()(-120 * SCALE_W - 34)
            } else {
                make?.bottom.equalTo()(view)?.offset()(-120 * SCALE_W)
            }
        })

        getBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58 * SCALE_W)
            make?.right.equalTo()(view)?.offset()(-58 * SCALE_W)
            make?.height.equalTo()(60 * SCALE_W)
            if UIDevice.current.isX() {
                make?.bottom.equalTo()(view)?.offset()(-40 * SCALE_W - 34)
            } else {
                make?.bottom.equalTo()(view)?.offset()(-40 * SCALE_W)
            }

        }

        getBtn.handleControlEvent(.touchUpInside) {
            if (self.type as NSString).isEqual(to: "output") {
                if self.isSelect == true {
                    self.downLoadFile()
                } else {
                    Common.showToast(LocalizeEx("dropAlert"))
                }
            } else {
                self.hub = ToastUtil.showMessage("", to: nil)
                self.hub.hide(animated: true, afterDelay: 30)
                let queue = DispatchQueue.init(label: "boxupdate")
                queue.async {
                    let nameStr = UserDefaults.standard.value(forKey: IDENTITY_NAME)
                    let OntStr = UserDefaults.standard.value(forKey: ONT_ID) as! NSString
                    let ontID = OntStr.substring(from: OntStr.length - 5)
                    let path = "/onto/\(nameStr ?? "")-\(ontID).keystore"
                    let strem = InputStream.init(data: self.jsonStr.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                    self.dropbox.uploadFileWithContentModifiedDate(toPath: path, with: strem, size: 1024, overwrite: true, contentModifiedDate: Common.getboxTimestamp())

                    dispatch_async_on_main_queue({
                        self.hub.hide(animated: false)
                        let successV = COTAlertV(title: self.loacalkey(key: "BackupS"), imageString: "dropCopy", buttonString: self.loacalkey(key: "OK"))
                        successV?.callback = { (backMsg) in
                            self.getData()
                        }
                        successV?.show()
                    })


                }
            }
        }
    }

    func downLoadFile() {

        let CRCloudData = self.dataArray?[self.selecRow] as! CRCloudMetaData
        let path = CRCloudData.path
        let data = Common.downloadFile(path, dropbox: dropbox)
        for VC in (self.navigationController?.viewControllers)! {
            if (VC.className() as NSString).isEqual(to: "ONTO.NewOntImportViewController") { // AccountSafetyCtl  是你要返回的控制器（页面）
                UserDefaults.standard.set(data, forKey: "box")
                UserDefaults.standard.synchronize()
                self.navigationController?.popToViewController(VC, animated: true)
            }
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 * SCALE_W
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: BoxCell! = tableView.dequeueReusableCell(withIdentifier: "cellID") as? BoxCell
        if cell == nil {
            cell = BoxCell(style: .default, reuseIdentifier: "cellID")
        }
        let CRCloudData = self.dataArray?[indexPath.row] as! CRCloudMetaData
        cell.leftLB.text = CRCloudData.name
        let timeStr: NSString = CRCloudData.contentModifiedAt != nil ? CRCloudData.contentModifiedAt.stringValue as NSString : "1571484372000";
        let time = timeStr.substring(to: timeStr.length - 3)
        cell.rightLB.text = Common.getTimeFromTimestamp(time)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isSelect = true
        selecRow = indexPath.row
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

}
