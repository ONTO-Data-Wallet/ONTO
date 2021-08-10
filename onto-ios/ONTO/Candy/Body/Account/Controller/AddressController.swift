//
//  AddressController.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper
import MJRefresh  //swift 中要用 oc 中的代码必须使用use_frameworks!
import Alamofire

class AddressController: ZYSWController {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    public var _list:[ACAdressModel]! = [ACAdressModel]();
    var header = MJRefreshNormalHeader()         //下拉刷新
    var footer = MJRefreshAutoNormalFooter()     //上拉加载

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
        
        self.title = LocalizeEx("candy_address_title");
//        let item:UIBarButtonItem! =  UIBarButtonItem.init(image: UIImage(named:"Me_A-b"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(self.crossClicked(sender:)));
//        self.navigationItem.rightBarButtonItem = item;

        let arr = [[String:String]]();
        let list =  Mapper<ACAdressModel>().mapArray(JSONArray: arr)
        _list = list;
        self.setupCollectionView();
        self.setUpHeaderLoadMore();
        self._collectionView?.mj_header.beginRefreshing();
        self.loadDataWithPage(page: 1, view: self.view) { (bSuccess, callBacks) in

        }
    }
    
    
    func updateMode(mod:ACAdressListModel!,params:Dictionary<String,Any>!){
        
        guard  let arr = mod.items else {
            return;
        }
        
        let s:String! = params["page"] as! String;
        let page:Int! = Int(s);
        if page <= 1 {
            _list.removeAll();
        }
        _list.append(contentsOf: arr)
        
        self.page = page;
        let b:Bool = hasMore(page, mod)  //(Int(mod.hasMore?.stringValue ?? "0")) != 0
        self._collectionView.mj_footer.isHidden = !b
        self.reloadData();
    }
    
    
//是否有更多页
func hasMore(_ page:Int,_ mod:ACAdressListModel) -> Bool {
    
    guard let p = mod.pageCount else {
        return false;
    }
    
    if page < p {
        return true;
    }
    
    return false;
}
    
    func params(page:String?) -> Dictionary<String,String> {
        
        var params:Dictionary<String, String> = [:]
        params["page"] = page;
        if let mod = _list.last {
            if  let last_id =  mod.itemId {
                params["last_id"] = last_id;
            }
        }
        
        return params;
    }
    
    func loadDataWithPage(page:NSInteger,view:UIView?,handler:@escaping(SFRequestCommonBlock)) -> Void {
        
        let action = "income/getAddressList";
        let pageStr = String.init(format: "%d", page);
        let params = self.params(page:pageStr);
        AlamofireModel().loadModelEx(path: action, type: HTTPMethod.get, parameters: params) { (bSuccess, response: DataResponse<ACAdressListModel>) in
            
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
    func rightBarItemClicked(sender:Any) -> Void {
        
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
            (bSuccess, callBacks) in
            //let mod:BaseModel? = callBacks as? BaseModel;
            self._collectionView.mj_header.endRefreshing()
        }
        
    }
    //点击或上拉加载操作
    @objc func footerRefresh() {
        self.loadDataWithPage(page: self.page + 1, view: nil) {
            (bSuccess, callBacks) in
            //let mod:BaseModel? = callBacks as? BaseModel;
            //            print("loadData success ",callBacks.debugDescription);
            self._collectionView.mj_footer.endRefreshing()
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
        layout.headerReferenceSize = CGSize(width:0,height:  0)   //头部间隔
        layout.footerReferenceSize = CGSize(width:0,height:  0)   //底部间隔
        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0)            //section四周的缩进
        
        // 设置CollectionView
        let ourCollectionView:UICollectionView!  = _collectionView;
        ourCollectionView.collectionViewLayout = layout;
        ourCollectionView.delegate = self
        ourCollectionView.dataSource = self
        ourCollectionView.delaysContentTouches = false
        ourCollectionView.backgroundColor = UIColor.white;
        ourCollectionView.register(ACAdressCLCell.nib(), forCellWithReuseIdentifier: ACAdressCLCell.cellIdentifier())
    }

}

extension AddressController:CommonDelegate {
    
    func itemClicked(_ sender: Any) {
        
    }
}

extension AddressController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return _list.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Const.SCREEN_WIDTH;
        return collectionView.ar_sizeForCell(withIdentifier: ACAdressCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: { (c) in
            
            let cell = c as! ACAdressCLCell;
            let row = indexPath.row;
            let mod = self._list[row]
            cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACAdressCLCell.cellIdentifier(), for: indexPath as IndexPath) as! ACAdressCLCell;
        
        let row = indexPath.row;
        let mod = _list[row]
        cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        
        return cell;
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row  = indexPath.row;
        let mod:ACAdressModel = _list[row];
        
//        let cv = BoxListDetailController()
//        cv.bShowBack = true;
//        cv._mod = mod;
//        self.navigationController?.pushViewController(cv, animated: true);
    }
    
}
