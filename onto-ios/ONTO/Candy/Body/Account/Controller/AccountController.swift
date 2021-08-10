//
//  AccountController.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class AccountController: ZYSWController {
    
    enum noItem:Int {
        case balance
        case record
        case address
    }
    
    @IBOutlet weak var _collectionView: UICollectionView!
    var _headerView:TitleCommonCLHeaderView!;
    let headerHeight:CGFloat = 56.0;
    var _headerDicts:Array<Dictionary<String,String>>!
    public var _list:[[BaseAdapterMappable]]! = [[BaseAdapterMappable]]();
    var header = MJRefreshNormalHeader()         //下拉刷新
    var footer = MJRefreshAutoNormalFooter()     //上拉加载
    var modAccount:AccountModel?;
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.UISet();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - common
    func UISet() {
        
        self.title = LocalizeEx("candy_account");
        //        let item:UIBarButtonItem! =  UIBarButtonItem.init(image: UIImage(named:"Me_A-b"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(self.rightBarItemClicked(sender:)));
        //        self.navigationItem.rightBarButtonItem = item;
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(NotificationName.kWithdrawSuccessed), object: nil, queue: OperationQueue.main) { (nc) in
            self.loadDataWithPage(page: 1, view: nil) {
                (bSuccess, callBacks) in
            }
        }
        
        self.updateList(modAccount);
        self.setupCollectionView();
        self.setupRefresh();
        self._collectionView.mj_header.beginRefreshing();
    }
    
    func updateList(_ mod:AccountModel?) {
        
        //头部
        _headerDicts = [["title":"","bMore":"0"],["title":LocalizeEx("candy_balance_title"),"bMore":"0"],["title":LocalizeEx("candy_record_title"),"bMore":""],["title":LocalizeEx("candy_address_title"),"bMore":""]]
        
        //清空_list
        _list.removeAll();
        //name
        let arr = [
            ["title":ZYUtilsSW.getOntName(),"content":""]
        ];
        let list =  Mapper<ACNameModel>().mapArray(JSONArray: arr)
        _list.append(list)
        
        //Balance
        if bNoBalance(modAccount) {
            let arr = self.getblankList(AccountController.noItem.balance)
            _list.append(arr);
        }else {
            
            let m =  Mapper<ACBalanceListModel>().map(JSON: ["title":""])!
            m.items  = mod?.balanceModels;
            _list.append([m]);
        }
        
        //Record
        if bNoRecord(modAccount) {
            let arr = self.getblankList(AccountController.noItem.record)
            _list.append(arr);
            _headerDicts[2]["bMore"] = "0";
        }else {
            
            let arr  = mod?.recordModels;
            _list.append(arr!);
            _headerDicts[2]["bMore"] = "1";
        }
        
        //Address
        if bNoAddress(modAccount) {
            let arr = self.getblankList(AccountController.noItem.address)
            _list.append(arr);
            _headerDicts[3]["bMore"] = "0";
        }else {
            
            let arr  = mod?.addressModels;
            _list.append(arr!);
            _headerDicts[3]["bMore"] = "1";
        }
    }
    
    func getblankList(_ type:AccountController.noItem) -> [BlankModel] {
        
        //Balance
        if type ==  noItem.balance {
            
            let arr1 = [
                ["headImg":"blank_balance",
                 "title":LocalizeEx("no_balance"),
                 "selector":"giftClicked",
                 "bBlank":"1"
                ]
            ];
            let list1 =  Mapper<BlankModel>().mapArray(JSONArray: arr1)
            return list1;
        }
        
        //Record
        if type == noItem.record {
            
            let arr2 = [
                ["headImg":"blank_record",
                 "title":LocalizeEx("no_record"),
                 "selector":"giftClicked",
                 "bBlank":"1"
                ]
            ];
            let list2 =  Mapper<BlankModel>().mapArray(JSONArray: arr2)
            return list2;
        }
        
        //Address
        if type == noItem.address {
            let arr3 = [
                ["headImg":"blank_address",
                 "title":LocalizeEx("no_address"),
                 "selector":"giftClicked",
                 "bBlank":"1"
                ]
            ];
            let list3 =  Mapper<BlankModel>().mapArray(JSONArray: arr3)
            return list3;
        }
        
        assert(true, "error! noItem  type is not found!")
        return [BlankModel]();
    }
    
    
    func bNoBalance(_ ob:AccountModel?) -> Bool {
        
        guard let mod = ob else {
            return true;
        }
        
        guard let arr =  mod.balanceModels  else {
            return true;
        }
        
        if arr.count > 0 {
            return false;
        }
        
        return true;
    }
    
    
    func bNoRecord(_ ob:AccountModel?) -> Bool {
        
        guard let mod = ob else {
            return true;
        }
        
        guard let arr =  mod.recordModels  else {
            return true;
        }
        
        if arr.count > 0 {
            return false;
        }
        
        return true;
    }
    
    func bNoAddress(_ ob:AccountModel?) -> Bool {
        
        guard let mod = ob else {
            return true;
        }
        
        guard let arr =  mod.addressModels  else {
            return true;
        }
        
        if arr.count > 0 {
            return false;
        }
        
        return true;
    }
    
    func updateMode(mod:AccountModel!,params:Dictionary<String,Any>!){
        
        modAccount = mod;
        self.updateList(modAccount);
        self.page = page;
        self.reloadData();
    }
    
    func params(page:String?) -> Dictionary<String,String> {
        
        var params:Dictionary<String, String> = [:]
        params["page"] = page;
        params["pageSize"] = "\(Const.value.kPageSize5)"
        
        return params;
    }
    
    func loadDataWithPage(page:NSInteger,view:UIView?,handler:@escaping(SFRequestCommonBlock)) -> Void {
        
        let action = "income/getIncomeBrief";
        let params = [String:String]()
        AlamofireModel().loadModelEx(path: action, type: HTTPMethod.get, parameters: params) { (bSuccess, response: DataResponse<AccountModel>) in
            
            let mappedObject = response.result.value
            if mappedObject == nil {
                let mod = BaseAdapterMappable();
                mod.msg = Const.msg.kServerStateErrorEx;
                handler(false,mod);
                return;
            }
            
            //            for item in mappedObject!.items! {
            //                print("\(item.title!)");
            //            }
            self.updateMode(mod: mappedObject, params: params);
            handler(true,mappedObject);
        }
        
    }
    
    //MARK: - clicked
    @objc func rightBarItemClicked(sender:Any) -> Void {
        
        
        //        "Balance" : [
        //        {
        //        "TokenName" : "OneToken",
        //        "TotalAmount" : "10.000000000000000000",
        //        "Logo" : "http:\/\/47.100.77.82:7001\/public\/images\/project\/1.png",
        //        "ProjectId" : 1
        //        }
        //        ],
        let mod =  Mapper<ACBalanceItemModel>().map(JSON: ["TokenName":"OneToken","TotalAmount":"10","ProjectId":"1"])!
        
        let cv = WithdrawOkController()
        cv._modBalance = mod;
        let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
        let nav = UINavigationController.init(rootViewController: cv)
        nav.navigationBar.isHidden = true;
        nav.view.backgroundColor = UIColor.clear;
        nav.view.isOpaque = true;
        nav.providesPresentationContextTransitionStyle = true;
        nav.definesPresentationContext = true;
        nav.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        nav.modalTransitionStyle = modalStyle
        self.navigationController?.present(nav, animated: false, completion: nil)
        cv.completionHandler = {(bSuccess,callBacks) in
            if bSuccess == false {
                return;
            }
            
            cv.dismiss(animated: false, completion: {
            })
        }
        return;
    }
    
    // MARK: - refresh & loadmore
    func setUpHeaderLoadMore() -> Void {
        
        self.setupRefresh();
        self.setupLoadMore();
        self._collectionView.mj_footer.isHidden = true;
    }
    
    func setupRefresh() -> Void {
        
        //设置普通下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        //隐藏最后一次更新时间
        header.lastUpdatedTimeLabel.isHidden = true
        //自定义各种状态下的文字
        //        header.setTitle("下拉刷新数据", for: .idle)
        //        header.setTitle("松开刷新数据", for: .pulling)
        //        header.setTitle("正在刷新数据", for: .refreshing)
        self._collectionView.mj_header = header
    }
    
    func setupLoadMore() -> Void {
        
        //设置普通上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        //自定义各种状态下的文字
        //        footer.setTitle("点击或上拉加载更多", for: .idle)
        //        footer.setTitle("松开加载数据", for: .pulling)
        //        footer.setTitle("正在加载数据", for: .refreshing)
        //        footer.setTitle("已全部加载完！", for: .noMoreData)
        self._collectionView.mj_footer = footer
    }
    
    //下拉更新操作
    @objc func headerRefresh() {
        self.loadDataWithPage(page: 1, view: nil) {
            [weak self] (bSuccess, callBacks) in
            self?._collectionView.mj_header.endRefreshing()
        }
        
    }
    //点击或上拉加载操作
    @objc func footerRefresh() {
        self.loadDataWithPage(page: self.page + 1, view: nil) {
            [weak self] (bSuccess, callBacks) in
            self?._collectionView.mj_footer.endRefreshing()
        }
    }
    
    // MARK: - collection
    func reloadData() ->Void{
        _collectionView.reloadData();
    }
    
    func setupCollectionView() ->Void{
        
        //  设置 layOut
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
//        layout.headerReferenceSize = CGSize(width:0,height:  0)   //头部间隔
//        layout.footerReferenceSize = CGSize(width:0,height:  0)   //底部间隔
        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0)            //section四周的缩进
//        layout.estimatedItemSize = CGSize(width: 320, height: 64)
        
        // 设置CollectionView
        let ourCollectionView:UICollectionView!  = _collectionView;
        ourCollectionView.collectionViewLayout = layout;
        ourCollectionView.delegate = self
        ourCollectionView.dataSource = self
        ourCollectionView.delaysContentTouches = false
        ourCollectionView.backgroundColor = UIColor.white;
        ourCollectionView.register(ACTopCLCell.nib(), forCellWithReuseIdentifier: ACTopCLCell.cellIdentifier())
        ourCollectionView.register(ACBalanceCLCell.nib(), forCellWithReuseIdentifier: ACBalanceCLCell.cellIdentifier())
        ourCollectionView.register(ACRecordCLCell.nib(), forCellWithReuseIdentifier: ACRecordCLCell.cellIdentifier())
        ourCollectionView.register(ACAdressCLCell.nib(), forCellWithReuseIdentifier: ACAdressCLCell.cellIdentifier())
        ourCollectionView.register(BlankCLCell.nib(), forCellWithReuseIdentifier: BlankCLCell.cellIdentifier())
        ourCollectionView.register(NewBalanceItemCell.self, forCellWithReuseIdentifier: NewBalanceItemCell.cellIdentifier() )
        ourCollectionView.register(TitleCommonCLHeaderView.nib(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: TitleCommonCLHeaderView.cellIdentifier())
        
    }
    
}

extension AccountController:CommonDelegate {
    
    //Balance clicked
    func itemClicked(_ sender: Any) {
        debugPrint("Balance clicked");
        
        let mod = sender as! ACBalanceItemModel
        //如果已认证
        //        if CommonOCAdapter.share().bKycVerfied() == true {
        let cv = WithdrawOkController()
        cv._modBalance = mod;
        let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
        //            cv.modalTransitionStyle = modalStyle
        //            cv.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        let nav = UINavigationController.init(rootViewController: cv)
        nav.navigationBar.isHidden = true;
        nav.view.backgroundColor = UIColor.clear;
        nav.view.isOpaque = true;
        nav.providesPresentationContextTransitionStyle = true;
        nav.definesPresentationContext = true;
        nav.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        nav.modalTransitionStyle = modalStyle
        self.navigationController?.present(nav, animated: false, completion: nil)
        cv.completionHandler = {(bSuccess,callBacks) in
            if bSuccess == false {
                return;
            }
            
            cv.dismiss(animated: false, completion: {
            })
        }
        return;
        //        }
        
        //如果未认证
        //        let cv = WithdrawController()
        //        cv._modBalance = mod;
        //        let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
        //        cv.modalTransitionStyle = modalStyle
        //        cv.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        //        self.navigationController?.present(cv, animated: false, completion: nil)
        //        cv.completionHandler = {(bSuccess,callBacks) in
        //            if bSuccess == false {
        //                return;
        //            }
        //
        //            cv.dismiss(animated: false, completion: {
        //            })
        //        }
    }
    
    func cdRightArrowClicked(_ sender: Any) {
        
        let mod = sender as! Dictionary<String,String>
        let index = _headerDicts.index(of: mod);
        debugPrint("index:\(String(describing: index))")
        
        //Balance
        if index == 1 {
            return;
        }
        
        //Record
        if index == 2 {
            
            let cv = RecordController();
            cv.bShowBack = true;
            self.navigationController?.pushViewController(cv, animated: true)
            return;
        }
        
        //Address
        if index == 3 {
            let cv = AddressController();
            cv.bShowBack = true;
            self.navigationController?.pushViewController(cv, animated: true)
            return;
        }
    }
}

extension AccountController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _list.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let arr = _list[section]
        return arr.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Const.SCREEN_WIDTH;
        let section = indexPath.section;
        //user name
        if section == 0 {
            
            return  collectionView.ar_sizeForCell(withIdentifier: ACTopCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: {[weak self] (c) in
                
                let cell = c as! ACTopCLCell;
                let row = indexPath.row;
                let section = indexPath.section;
                let arr = self?._list[section];
                let mod = arr?[row] as! ACNameModel
                cell.fillCellWithMod(mod: mod, row: row, delegate: self)
            })
        }
        
        //Balance
        if section == 1 {
            
            if bNoBalance(modAccount) == true {
                return  collectionView.ar_sizeForCell(withIdentifier: BlankCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: {[weak self] (c) in
                    
                    let cell = c as! BlankCLCell;
                    let row = indexPath.row;
                    let section = indexPath.section;
                    let arr = self?._list[section];
                    let mod = arr?[row] as! BlankModel
                    cell.fillCellWithMod(mod: mod, row: row, delegate: self)
                })
            }
            
            return  collectionView.ar_sizeForCell(withIdentifier: ACBalanceCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: {[weak self] (c) in
                
                let cell = c as! ACBalanceCLCell;
                let row = indexPath.row;
                let section = indexPath.section;
                let arr = self?._list[section];
                let mod = arr?[row] as! ACBalanceListModel
                cell.fillCellWithMod(mod: mod, row: row, delegate: self)
            })
        }
        
        //Record
        if section == 2 {
            
            if bNoRecord(modAccount) == true {
                return  collectionView.ar_sizeForCell(withIdentifier: BlankCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: {[weak self] (c) in
                    
                    let cell = c as! BlankCLCell;
                    let row = indexPath.row;
                    let section = indexPath.section;
                    let arr = self?._list[section];
                    let mod = arr?[row] as! BlankModel
                    cell.fillCellWithMod(mod: mod, row: row, delegate: self)
                })
            }
            
            return  collectionView.ar_sizeForCell(withIdentifier: ACRecordCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: {[weak self] (c) in
                
                let cell = c as! ACRecordCLCell;
                
                let row = indexPath.row;
                let section = indexPath.section;
                let arr = self?._list[section];
                let mod = arr?[row] as! ACRecordModel
                cell.fillCellWithMod(mod: mod, row: row, delegate: self)
            })
        }
        
        //Address
        if section == 3 {
            
            if bNoAddress(modAccount) == true {
                return  collectionView.ar_sizeForCell(withIdentifier: BlankCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: {[weak self] (c) in
                    
                    let cell = c as! BlankCLCell;
                    let row = indexPath.row;
                    let section = indexPath.section;
                    let arr = self?._list[section];
                    let mod = arr?[row] as! BlankModel
                    cell.fillCellWithMod(mod: mod, row: row, delegate: self)
                })
            }
            
            return  collectionView.ar_sizeForCell(withIdentifier: ACAdressCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: {[weak self] (c) in
                
                let cell = c as! ACAdressCLCell;
                let row = indexPath.row;
                let section = indexPath.section;
                let arr = self?._list[section];
                let mod = arr?[row] as! ACAdressModel
                cell.fillCellWithMod(mod: mod, row: row, delegate: self)
            })
        }
        
        return  CGSize.zero;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row;
        let section = indexPath.section;
        if section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACTopCLCell.cellIdentifier(), for: indexPath as IndexPath) as! ACTopCLCell;
            
            let arr = self._list[section];
            let mod = arr[row] as! ACNameModel
            cell.fillCellWithMod(mod: mod, row: row, delegate: self)
            return cell;
        }
        
        //balance
        if section == 1 {
            
            if bNoBalance(modAccount) == true {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlankCLCell.cellIdentifier(), for: indexPath as IndexPath) as! BlankCLCell;
                
                let arr = self._list[section];
                let mod = arr[row] as! BlankModel
                cell.fillCellWithMod(mod: mod, row: row, delegate: self)
                return cell;
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACBalanceCLCell.cellIdentifier(), for: indexPath as IndexPath) as! ACBalanceCLCell;
            
            let arr = self._list[section];
            let mod = arr[row] as! ACBalanceListModel
            cell.fillCellWithMod(mod: mod, row: row, delegate: self)
            return cell;
        }
        
        //Record
        if section == 2 {
            
            if bNoRecord(modAccount) == true {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlankCLCell.cellIdentifier(), for: indexPath as IndexPath) as! BlankCLCell;
                
                let arr = self._list[section];
                let mod = arr[row] as! BlankModel
                cell.fillCellWithMod(mod: mod, row: row, delegate: self)
                return cell;
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACRecordCLCell.cellIdentifier(), for: indexPath as IndexPath) as! ACRecordCLCell;
            
            let arr = self._list[section];
            let mod = arr[row] as! ACRecordModel
            cell.fillCellWithMod(mod: mod, row: row, delegate: self)
            return cell;
        }
        
        //Adress
        if section == 3 {
            
            if bNoAddress(modAccount) == true {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlankCLCell.cellIdentifier(), for: indexPath as IndexPath) as! BlankCLCell;
                
                let arr = self._list[section];
                let mod = arr[row] as! BlankModel
                cell.fillCellWithMod(mod: mod, row: row, delegate: self)
                return cell;
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACAdressCLCell.cellIdentifier(), for: indexPath as IndexPath) as! ACAdressCLCell;
            
            let arr = self._list[section];
            let mod = arr[row] as! ACAdressModel
            cell.fillCellWithMod(mod: mod, row: row, delegate: self)
            return cell;
        }
        
        let cell = UICollectionViewCell();
        return cell;
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row;
        let section = indexPath.section;
        if section == 0 {
            let arr = self._list[section];
            let mod = arr[row] as! ACNameModel
            return;
        }
        
        
        //balance
        if section == 1 {
            
            if bNoBalance(nil) == true {
                
                return;
            }
            
            return;
        }
        
        //Record
        if section == 2 {
            
            if bNoRecord(nil) == true {
                
                return;
            }
            
            return
        }
        
        //Adress
        if section == 3 {
            
            if bNoAddress(nil) == true {
                
                return;
            }
            
            return;
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section != _headerDicts.count - 1 {
            return UIEdgeInsets.zero;
        }
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0);
    }
    
    
    //MARK:UICollectionView Header-Footer
    //设置HeadView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize.zero;
        }
        
        //section height 不是很合理
        if section == _headerDicts.count - 1 {
            return CGSize(width: Const.SCREEN_WIDTH, height: headerHeight + 20)
        }
        
        return CGSize(width: Const.SCREEN_WIDTH, height: headerHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader{
            
            let v:TitleCommonCLHeaderView! = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleCommonCLHeaderView.cellIdentifier(), for: indexPath) as! TitleCommonCLHeaderView
            let d =  _headerDicts[indexPath.section]
            var bLast = false;
            print("\(section:indexPath.section,row:indexPath.row),count:\(_headerDicts.count)")
            if indexPath.section == _headerDicts.count - 1 {
                bLast = true;
            }
            v.fillCellWithMod(mod: d, type: TitleCommonCLHeaderView.TitleCommonType.normal, row: indexPath.section, delegate: self,bLast:bLast)
            _headerView = v;
            return v;
        }
        
        return UICollectionReusableView();
    }
    
    
}
