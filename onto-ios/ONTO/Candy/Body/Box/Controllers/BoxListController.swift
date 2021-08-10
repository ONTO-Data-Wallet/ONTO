//
//  BoxListController.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
private let  LL_iPhoneX  = (SYSWidth == 375 && SYSHeight == 812 ? true : false)
private let  LL_StatusBarHeight   =   (LL_iPhoneX ? 44 : 20)
class BoxListController: ZYSWController {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    public var _list:[BoxListModel]! = [BoxListModel]();
    var header = MJRefreshNormalHeader()         //下拉刷新
    var footer = MJRefreshAutoNormalFooter()     //上拉加载
    var confirmView:SendConfirmView!
    
//    enum ProjectStatus:Int {
//        case hot
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(NotificationName.kLoginSuccessed), object: nil, queue: OperationQueue.main) { (nc) in
            self._collectionView.mj_header.beginRefreshing()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(NotificationName.kObtainCoinsSuccessed), object: nil, queue: OperationQueue.main) { (nc) in
            let ob = nc.object
            guard let mod = ob as?  BoxDetailModel else {
                debugPrint("error! mod is not BoxDetailModel");
                return;
            }
            
            for i in 0..<self._list.count {
                if self._list[i].itemId == mod.itemId {
                    self._list[i].status = 2; //2 obtained
                    self.reloadData();
                    return;
                }
            }
            
            debugPrint("error! can't find mod by itemid:\(mod.itemId!)")
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(NotificationName.kLoginbBackAction), object: nil, queue: OperationQueue.main) { (nc) in
            if self.navigationController?.viewControllers.last == self {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
        
        // Do any additional setup after loading the view.
        self.UISet();
//        self.test();
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
        self.title = LocalizeEx("candy_box")
//        let image = UIImage(named:"candy_money_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//        let item:UIBarButtonItem! =  UIBarButtonItem.init(image: image, style: UIBarButtonItemStyle.plain, target: self, action:  #selector(self.rightBarItemClicked(sender:)));
//        self.navigationItem.rightBarButtonItem = item;
        let buttonSize = getSize(str: LocalizeEx("ACCOUNT"), width: SYSWidth - 108, font: UIFont.systemFont(ofSize: 12, weight: .bold), lineSpace: 0, wordSpace: 0)
        let navbutton = UIButton(frame: CGRect(x: 0, y: LL_StatusBarHeight + 15, width: Int(buttonSize.width)+2, height: 28))
        navbutton.setTitle(LocalizeEx("ACCOUNT"), for: .normal)
        navbutton.setTitleColor(UIColor.black, for: .normal)
        navbutton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        navbutton.addTarget(self, action: #selector(self.rightBarItemClicked(sender:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: navbutton)
        self.navigationItem.rightBarButtonItem = rightItem;
        

        let arr = [[String:String]]();
        let list =  Mapper<BoxListModel>().mapArray(JSONArray: arr)
        _list = list;
        self.setupCollectionView();
        self.setUpHeaderLoadMore();

        if LoginCenter.shared().bNeedLogin() == false {
            self._collectionView.mj_header.beginRefreshing();
            return;
        }
        
        LoginCenter.shared().showLogin(baseController: self) { (bSuccess, callBacks) in
            if bSuccess == false {
//                guard let d = callBacks as? [String:String] else {
//                    return;
//                }
//                if d["bBack"] != nil {
//                    self.navigationController?.popViewController(animated: false)
//                }
                return;
            }
            
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    func  isLegalAddress(_ address:String,_ mod:ACBalanceItemModel) -> Bool {
        
        guard let title = mod.title else {
            debugPrint("error! 提现 tokenname 为空!")
            self.showHint(LocalizeEx("candy_withdraw_noaddress"), yOffset: -180)
            return false;
        }
        
        if title ==  "ONT" || title == "NEO" {
            if address.validatedByRex("A[0-9a-zA-Z]{33}$") == false {
                
                self.showHint(LocalizeEx("candy_withdraw_noaddress"), yOffset: -180)
                return false;
            }
            
            return true;
        }
        
        if title ==  "ETH" {
            if address.validatedByRex("^(0x|0X)?[0-9a-fA-F]{40}$") == false {
                
                self.showHint(LocalizeEx("candy_withdraw_noaddress"), yOffset: -180)
                return false;
            }
            
            return true;
        }
        
        return true;
    }

     func test() {
        
        var text = "";
        
        //        ONT、NEO：AVRKWDig5TorzjCS5xphjgMnmdsT7KgsGD，ATfjyFnafWU1GZ1U6wDHU2cTaBaXzJYpBW
        //        ETH：0x06012c8cf97BEaD5deAe237070F9587f8E7A266d，0x898546137aE2e091Ae5032EEb4cf16306d9FD713
        
        var _modBalance = Mapper<ACBalanceItemModel>().map(JSON: ["title":""])!
        _modBalance.title = "ETH";
        text = "0x06012c8cf97BEaD5deAe237070F9587f8E7A266d";
        //判断地址格式是否合法
        if isLegalAddress(text, _modBalance) == false {
            return;
        }
    }
    
    func updateMode(mod:BoxListGroupModel!,params:Dictionary<String,Any>!){
        
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
        let b:Bool = mod.hasMore(page)
        self._collectionView.mj_footer.isHidden = !b
        self.reloadData();
    }
    
    //是否有更多页
    func hasMore(_ page:Int,_ mod:BoxListGroupModel) -> Bool {
        
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
        params["pageSize"] = "\(Const.value.kPageSize5)"
        if let mod = _list.last {
            if  let last_id =  mod.itemId {
                params["last_id"] = last_id;
            }
        }
        
        return params;
    }
    
    func loadDataWithPage(page:NSInteger,view:UIView?,handler:@escaping(SFRequestCommonBlock)) -> Void {
        
        let action = "project/getProjectList";
        let pageStr = String.init(format: "%d", page);
        let params = self.params(page:pageStr);
        AlamofireModel().loadModelEx(path: action, type: HTTPMethod.get, parameters: params) { (bSuccess, response: DataResponse<BoxListGroupModel>) in
            
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
        ourCollectionView.register(BoxListCLCell.nib(), forCellWithReuseIdentifier: BoxListCLCell.cellIdentifier())
    }

}

extension BoxListController:CommonDelegate {
    
    func itemClicked(_ sender: Any) {
        
    }
}

extension BoxListController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return _list.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Const.SCREEN_WIDTH;
        let s = collectionView.ar_sizeForCell(withIdentifier: BoxListCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: { (c) in
            
            let cell:BoxListCLCell = c as! BoxListCLCell;
            let row = indexPath.row;
            let mod = self._list[row]
            cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        })
        debugPrint("\(s)");
        return s;
//        return CGSize.init(width: width, height: 137.5);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:BoxListCLCell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxListCLCell.cellIdentifier(), for: indexPath as IndexPath) as! BoxListCLCell;
        
        let row = indexPath.row;
        let mod = _list[row]
        cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        
        return cell;
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row  = indexPath.row;
        let mod:BoxListModel = _list[row];
        
        if mod.bExpired() == true {
            return;
        }
        
        let cv = BoxListDetailController()
        cv.bShowBack = true;
        cv._mod = mod;
        self.navigationController?.pushViewController(cv, animated: true);
    }
    public func getSize(str: String,width: CGFloat,font: UIFont,lineSpace:CGFloat,wordSpace:CGFloat) -> CGSize {
        let attributedString =  NSMutableAttributedString.init(string: str, attributes: [ kCTKernAttributeName as NSAttributedStringKey : wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttributes([kCTFontAttributeName as NSAttributedStringKey : font], range: .init(location: 0, length: ((str as NSString).length)))
        attributedString.addAttributes( [kCTParagraphStyleAttributeName as NSAttributedStringKey : paragraphStyle], range: .init(location: 0, length: ((str as NSString).length)))
        
        let attSize = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue))), context: nil).size  //NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
        return attSize
    }
}
