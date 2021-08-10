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
class BoxListDetailController: ZYSWController {
    
    @IBOutlet weak var airdropView:UIView!
    @IBOutlet weak var airdropLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var _collectionViewLeadingLayout: NSLayoutConstraint!
    @IBOutlet weak var airdropHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var airdropImage: UIImageView!
    public var _list:[BaseAdapterMappable]! = [BaseAdapterMappable]();
    public var _mod:BoxListModel!;
    public var _modDetail:BoxDetailModel?;
    public var bKycCert:Bool = false;
    var cacheSize = CGSize.zero;
    var _footerView:TextFooterView!;
    lazy var _footerViewEx:TextFooterView = {
        
        let name   = TextFooterView.classNameEx;
        let bottles:NSArray! =  Bundle.main.loadNibNamed(name, owner: self, options: nil)! as NSArray;
        let v:TextFooterView! = bottles.lastObject as! TextFooterView;
        return v
    } ()
    var header = MJRefreshNormalHeader()         //下拉刷新
    var footer = MJRefreshAutoNormalFooter()     //上拉加载
    var _timer:Timer!;
    static var _tickCount:Int! = 0;
    
    deinit {
        tickStop();
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //kyc认证成功，刷新一下页面
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(NotificationName.kKycOauthedSuccessed), object: nil, queue: OperationQueue.main) { (nc) in
            self.loadDataWithPage(page: 1, view: nil) {
                (bSuccess, callBacks) in
            }
        }
        
        //telegram 成功后刷新一下页面
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: OperationQueue.main) { (nc) in
            self.loadDataWithPage(page: 1, view: nil) {
                (bSuccess, callBacks) in
            }
        }
        
        self.UISet();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tickStart();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tickStop();
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - common extern
    class func containBoxListDetail(_ nav:UINavigationController!) -> BoxListDetailController?{
        
        let arr = nav.viewControllers
        for cv in arr {
            if cv is BoxListDetailController {
                return (cv as! BoxListDetailController);
            }
        }
        
        return nil;
    }
    
    class func containCOTMListViewController(_ nav:UINavigationController!) -> COTMListViewController?{
        
        let arr = nav.viewControllers
        for cv in arr {
            if cv is COTMListViewController {
                return (cv as! COTMListViewController);
            }
        }
        
        return nil;
    }
    
    //COTMListViewController
    
    //MARK: - common
    func UISet() {
    
        self.title = "Candy Box";
        self.title = "";
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
        
        self.airdropView.backgroundColor = Const.color.kAPPDefaultBlueColor
        airdropLabel.font = Const.font.DINProFontType(.medium, 14)
        airdropLabel.textColor = Const.color.kAPPDefaultWhiteColor
        
        timeLabel.font = UIFont.init(name: "Helvetica Neue", size: 13)
        timeLabel.textColor = Const.color.kAPPDefaultWhiteColor

        let arr = [
            ["headImg":"candy_eth_icon",
             "title":"Enthereum network",
             "selector":"giftClicked",
             "content":"A new generation of distributed application games have arrived on Ethereum — raising questions about the network's capacity to cope after December's CryptoKittie congestion ",
             "hot":"HOT",
             "currency":"ERC20",
             "webSite":"WebSite",
             "url":"http://ont.io",
             "webContent":"A new generation of distributed application games have arrived on Ethereum — raising questions about the network's capacity to cope after December's CryptoKittie congestion ",
             "Socials":[["headImg":"candy_mission_wihtepaper","bOk":"1","title":"White paper","url":""],["headImg":"candy_mission_twitter","bOk":"1","title":"Twitter","url":""],["headImg":"candy_mission_telegram","bOk":"0","title":"Telegram","url":"https://t.me/luckyboxofficialbot?start=NRUJ5CYIS1QQ"]]],
            ["headImg":"ongblue",
             "title":"Enthereum network",
             "selector":"giftClicked",
             "content":"A new generation of distributed application games have arrived on Ethereum — raising questions about the network's capacity to cope after December's CryptoKittie congestion ",
             "hot":"Ongoning",
             "currency":"ERC20",
             "arr":[["headImg":"candy_mission_icon","bOk":"1"],["headImg":"candy_mission_icon","bOk":"1"],["headImg":"candy_mission_icon","bOk":"0"]]]
        ];
        let top = Mapper<BoxDetailModel>().map(JSONString: arr[0].json);
        let bottom = Mapper<BoxListDetailMissionModel>().map(JSONString: arr[1].json);
        _list = [top!,bottom!];
        self.setupCollectionView();
        self.setUpHeaderLoadMore()
        self._collectionView.mj_header.beginRefreshing()
        updateUI();
    }
    
    func updateUI(){
        
        let count = self.timeCount(_modDetail)
        if (bLess24Hours(count) && count > 0) == false {
            airdropHeightLayout.constant = 0;
            airdropView.isHidden = true;
        }else if _modDetail?.bExpired() == true {
            airdropHeightLayout.constant = 0;
            airdropView.isHidden = true;
        }else {
            airdropHeightLayout.constant = 39;
            airdropView.isHidden = false;
        }
//        airdropHeightLayout.constant = 39;
//        airdropView.isHidden = false;
        
        airdropLabel.text = LocalizeEx("airdrop");
        timeLabel.text = timeText(_modDetail);
        airdropImage.sd_setImage(with: URL.init(string: _modDetail?.logo1 ?? ""), placeholderImage:UIImage.init() , options: SDWebImageOptions.retryFailed) { (image, error,  SDImageCacheTypeNone, url) in
            
        }
        self.view.setNeedsUpdateConstraints();
        self.view.layoutIfNeeded();
    }
    
    func timeCount(_ mod:BoxDetailModel?) -> Int {
        
        if mod == nil {
            return 0;
        }
        
        let timestamp = NSDate().timeIntervalSince1970
        let inter = Int(timestamp);
        let d = mod!.endDate! - inter;
        if d > 0 {
            return d;
        }

        return 0;
    }
    
    func timeText(_ mod:BoxDetailModel?) -> String {
        
        if mod == nil {
            return "";
        }
        
        if mod!.bExpired() == true {
            return "00:00:00"
        }
        
       let timestamp = NSDate().timeIntervalSince1970
        let inter = Int(timestamp);
        let d = mod!.endDate! - inter;
        let str = "\(d)"
        let last = ZYUtilsSW.timeByTimeStamp(str, "dd HH:mm:ss")
        return last;
    }
    
    
    func updateMode(mod:BoxDetailModel!,params:Dictionary<String,Any>!){
        
        _modDetail = mod;
        updateUI();
        
        _list[0] = mod;
        let m = _list[1] as! BoxListDetailMissionModel;
        m.items = mod.items
        _list[1] = m;
        
        self.page = page;
        let b:Bool = (Int(mod.hasMore?.stringValue ?? "0")) != 0
        self._collectionView.mj_footer.isHidden = !b
        self.reloadData();
        if _modDetail != nil && _modDetail!.bExpired() == true {
            return;
        }
        self.tickStart();
    }
    
    
    func params(page:String?) -> Dictionary<String,String> {
        
        
        var params:Dictionary<String, String> = [:]
        params["projectId"] = _mod.itemId;
//        var bKycVerfied = "0";
//        if (CommonOCAdapter.share().bKycVerfied() == true) {
//            bKycVerfied = "1";
//        }
//        params["kycCertified"] = bKycVerfied;
//        params["ontCount"] = "\(CommonOCAdapter.share().getOntAmout()!)";
        params["address"] = CommonOCAdapter.getWalletAddress();
    
        return params;
    }
    
    func loadDataWithPage(page:NSInteger,view:UIView?,handler:@escaping(SFRequestCommonBlock)) -> Void {
        
        let action = "project/getProjectDetail";
        let pageStr = String.init(format: "%d", page);
        let params = self.params(page:pageStr);
        AlamofireModel().loadModelEx(path: action, type: HTTPMethod.post, parameters: params) { (bSuccess, response: DataResponse<BoxDetailModel>) in
            
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
    
    //加入项目
    func joinProject(handler:@escaping(SFRequestCommonBlock)) {
        joinProject(view: nil, handler: handler)
    }
    
    func joinProject(view:UIView?,handler:@escaping(SFRequestCommonBlock)) {
        
        let action = "project/getCandy";
        var params = [String:String]()
        params["projectId"] = _mod.itemId;
//        var bKycVerfied = "0";
//        if (CommonOCAdapter.share().bKycVerfied() == true) {
//            bKycVerfied = "1";
//        }
//        params["kycCertified"] = bKycVerfied;
//        params["ontCount"] = "\(CommonOCAdapter.share().getOntAmout()!)";
        params["address"] = CommonOCAdapter.getWalletAddress();
        AlamofireModel().loadModelEx(path: action, type: HTTPMethod.post, parameters: params,inView:view) { (bSuccess, response: DataResponse<BaseAdapterMappable>) in
            
            let mappedObject = response.result.value
            if mappedObject == nil {
                let mod = BaseAdapterMappable();
                mod.msg = Const.msg.kServerStateErrorEx;
                handler(false,mod);
                return;
            }
            
//            self.updateMode(mod: mappedObject, params: params)
            handler(true,mappedObject);
        }
    }
    
    //提交任务判定
    func uploadMission(handler:@escaping(SFRequestCommonBlock)) {
        
        let action = "mission/ruledMission";
        var params = [String:String]()
        params["ontCount"] = "ontCount";
        params["kycCertified"] = "0"; // 0或1
        AlamofireModel().loadModelEx(path: action, type: HTTPMethod.post, parameters: params) { (bSuccess, response: DataResponse<BoxDetailModel>) in
            
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
    
    
    //MARK:common - tick
    func tickStart(){
        
        let count = self.timeCount(_modDetail)
        if count == 0 {
            return;
        }
        
        tickStop();
        BoxListDetailController._tickCount = count;
        updateTimeLabel(BoxListDetailController._tickCount)
        _timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tickUpddate(dt:)), userInfo: nil, repeats: true)
        RunLoop.current.add(_timer, forMode: .commonModes)
    }
    

    @objc func tickUpddate(dt:TimeInterval) {
        
//        print("tick:%d",BoxListDetailController._tickCount);
        BoxListDetailController._tickCount = BoxListDetailController._tickCount - 1;
        updateTimeLabel(BoxListDetailController._tickCount);
        if(BoxListDetailController._tickCount == 0){
            tickStop();
            _modDetail?.status = 3;
            self.reloadData();
        }
    }
    
    func bLess24Hours(_ count:Int?) -> Bool {
        
        guard let secs = count else{
            return false;
        }
        
        if secs < 24*60*60 {
            return true;
        }
        
        return false;
    }
    
    func updateTimeLabel(_ count:Int){
        
        let last = leftTime(count)
        timeLabel.text = last;
//        timeLabel.isHidden = !(self.bLess24Hours(count) && count > 0);
    }
    
    func leftTime(_ timeout:Int) -> String {
        
//        int days = (int)(timeout/(3600*24));
//        if (days==0) {
//            self.dayLabel.text = @"";
//        }
//        int hours = (int)((timeout-days*24*3600)/3600);
//        int minute = (int)(timeout-days*24*3600-hours*3600)/60;
//        int second = timeout-days*24*3600-hours*3600-minute*60;
        
        let days = timeout/(3600*24)
        var last = ""
        if days > 0 {
            last = last + "\(days)"
        }
        
        let hours = (timeout - days*3600*24)/3600
        let minute = (timeout - days*3600*24 - hours*3600)/60
        let second = timeout - days*3600*24 - hours*3600 - minute*60
        if hours > 0 {
            last = last.appendingFormat(" %02d", hours)
        }
        
        if minute > 0 {
            if last.count > 0 {
                last = last.appendingFormat(":%02d", minute)
            }else {
                last = last.appendingFormat("%02d", minute)
            }
        }
        
        if second > 0 {
            if last.count > 0 {
               last = last.appendingFormat(":%02d", second)
            }else {
               last = last.appendingFormat("%02d", second)
            }
        }
        
        return last;
    }
    
    func tickStop(){
        
        if( _timer != nil && _timer.isValid == true){
            _timer.invalidate();
            _timer = nil;
        }
    }
    
    func timeIsTicking() -> Bool {
        if( _timer != nil && _timer.isValid == true){
            return true;
        }
        
        return false;
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
        
        if _footerView != nil {
            let section = 0;
            _footerView.fillCellWithMod(mod: _modDetail, row: section, delegate: self,type:TextFooterView.FooterType.btn);
        }
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
        ourCollectionView.register(BoxListDetailCLCell.nib(), forCellWithReuseIdentifier: BoxListDetailCLCell.cellIdentifier())
        ourCollectionView.register(BoxListDetailMissionCLCell.nib(), forCellWithReuseIdentifier: BoxListDetailMissionCLCell.cellIdentifier())
        ourCollectionView.register(TextFooterView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: TextFooterView.cellIdentifier());
    }

}

extension BoxListDetailController:CommonDelegate {
    
    func itemClicked(_ sender: Any) {
        
        
    }
    
    func headTap(_ sender: Any) {
        
        let mod = sender as! BoxListDetailItemModel
        let url = mod.url;
        let _ = ZYUtilsSW.openUrl(url);
        
    }
    
    func itemExClicked(_ sender: Any) {
        
        let mod = sender as! BoxListDetailMissionItemModel;
        if(mod.bOk == "1"){
            return;
        }
        
        //去到认证页面
        if mod.missionCode == "kyc_certification" {
       
//            CommonOCAdapter.share().setTabIndex(IDViewController.className())
//            let d = mod.toJSON();
//            CommonOCAdapter.share().refInfoDic = NSMutableDictionary(dictionary: d) as! [AnyHashable : Any];
            //根据refInfo去到对应的位置
            guard let refInfo = mod.refInfo else {
                return;
            }
        
            CommonOCAdapter.share().createCOT(refInfo, inCv: self) { (bSuccess, callBacks) in
                
            }
            return;
        }
        
        //当前用户的ont余额
        if mod.missionCode == "ontcount_op" {
            Common.showToast(LocalizeEx("OntAlert"))
            return;
        }
        
        //goto url
        var ur = mod.url
        if UIApplication.shared.canOpenURL(URL(string: "tg://")!) {
            ur = mod.url_scheme;
        }
        //ur = "tg://resolve?domain=haoge_bot&start=QUdyaml1U1BoTVM2d1BzUEZib1lqQjVhUkVXUXdMb2dWcyAxIDc5";
        let _ = ZYUtilsSW.openUrl(ur);
    }
    
    
    //join group
    func cdBottomBtnClicked(_ sender: Any) {
        joinProject { (bSuccess, callBacks) in
            
            let mod = callBacks as! BaseAdapterMappable
            if bSuccess == false {
                let msg = mod.message ?? mod.msg;
                self.showHint(msg)
                return;
            }
            
            if mod.code != 0 {
                let msg = mod.message;
                self.showHint(msg, in: self.view)
                return;
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName.kObtainCoinsSuccessed), object: self._modDetail)
            self._modDetail?.dispStatus = 4;
            self.reloadData();
            
            let attributesBlack = [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 14),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultWhiteColor] as [NSAttributedStringKey : Any];
            let attributesRed  =  [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 15),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultWhiteColor] as [NSAttributedStringKey : Any];
            let attributesGray  =  [NSAttributedStringKey.font: Const.font.DINProFontType(.medium, 14),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultWhiteColor] as [NSAttributedStringKey : Any];
            let attributesRed18  =  [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 18),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultWhiteColor] as [NSAttributedStringKey : Any];
            
            let attrTitle = NSMutableAttributedString(string:LocalizeEx("candy_congratulations") + "!", attributes: attributesBlack)
            
            var attrText = NSMutableAttributedString();
            if bLocalizeZh() == true {
                attrText = NSMutableAttributedString(string:LocalizeEx("candy_got_title"), attributes: attributesGray)
                var part = NSMutableAttributedString(string:(self._modDetail!.title ?? "") + LocalizeEx("candy_project")  + LocalizeEx("candy_get") + "了 ", attributes: attributesGray)
                attrText.append(part)
                part = NSMutableAttributedString(string:self._modDetail!.onceAmount!, attributes: attributesRed18)
                attrText.append(part)
                part = NSMutableAttributedString(string:" " + (self._modDetail!.tokenName ?? ""), attributes: attributesRed)
                attrText.append(part);
            }else {
                attrText = NSMutableAttributedString(string:LocalizeEx("candy_got_title"), attributes: attributesGray)
                var part = NSMutableAttributedString(string:self._modDetail!.onceAmount!, attributes: attributesRed18)
                attrText.append(part)
                part = NSMutableAttributedString(string:" " + (self._modDetail!.tokenName ?? ""), attributes: attributesRed)
                attrText.append(part);
                part = NSMutableAttributedString(string:" \(LocalizeEx("candy_from")) " + (self._modDetail!.title ?? ""), attributes: attributesGray)
                attrText.append(part);
            }
            if Common.isStringEmpty(self._modDetail?.logo2) {
                let cv = CongratulationViewController()
                cv.alertString = attrText
                cv.moneyNum = ""
                self.navigationController?.pushViewController(cv, animated: true)
            }else{
                let cv = CongratulationViewController()
                cv.alertString = attrText
                cv.imageString = self._modDetail?.logo2
                cv.moneyNum = self._modDetail!.onceAmount!
                self.navigationController?.pushViewController(cv, animated: true)
            }
            
//            let cv =  ZYAlertController()
//            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
//            cv.modalTransitionStyle = modalStyle
//            cv.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
//            cv.view.layoutIfNeeded();
//            cv.showAlert(titleAttr: attrTitle, messageAttr: attrText, cancelBtn: nil, okBtn:LocalizeEx("OK"), handler: { (bSuccess, callbacks) in
//
//                //self.navigationController?.popViewController(animated: true)
//            })
//            self.navigationController?.present(cv, animated: false, completion: nil)

        }
        
    }

    
    //向右的箭头点击
    func cdRightArrowClicked(_ sender: Any) {
        
        let mod =  sender as! BoxDetailModel
        let cv = DescController();
        cv.bShowBack = true;
        cv._mod = mod;
        self.navigationController?.pushViewController(cv, animated: true);
    }
    
    //向右的url点击
    func cdUrlClicked(_ sender: Any) {
        
        let mod =  sender as! BoxDetailModel
        
        let ur = mod.url
        let url = URL.init(string: ur!)
        UIApplication.shared.open(url!, options: [ : ]) { (bSuccess) in
            
        }
    }
    
     //向右的箭头点击 airdroprule
    func cdRightArrowExClicked(_ sender: Any) {
        
        let mod =  sender as! BoxDetailModel
        let cv = DescAirdropController();
        cv.bShowBack = true;
        cv._mod = mod;
        self.navigationController?.pushViewController(cv, animated: true);
    }
}

extension BoxListDetailController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return _list.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Const.SCREEN_WIDTH;
        let row = indexPath.row;
        if row == 0 {
            return collectionView.ar_sizeForCell(withIdentifier: BoxListDetailCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: { (c) in
                
                let cell:BoxListDetailCLCell = c as! BoxListDetailCLCell;
                let mod = self._list[row] as! BoxDetailModel
                cell.fillCellWithMod(mod: mod, row: row, delegate: self)
            })
        }
        
        return collectionView.ar_sizeForCell(withIdentifier: BoxListDetailMissionCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: { (c) in
            
            let cell:BoxListDetailMissionCLCell = c as! BoxListDetailMissionCLCell;
            let mod = self._list[row] as! BoxListDetailMissionModel
            cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row;
        if row == 0 {
            let cell:BoxListDetailCLCell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxListDetailCLCell.cellIdentifier(), for: indexPath as IndexPath) as! BoxListDetailCLCell;
            let mod = _list[row] as! BoxDetailModel
            cell.fillCellWithMod(mod: mod, row: row, delegate: self)
            return cell;
        }
        
        let cell:BoxListDetailMissionCLCell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxListDetailMissionCLCell.cellIdentifier(), for: indexPath as IndexPath) as! BoxListDetailMissionCLCell;
        let mod = _list[row] as! BoxListDetailMissionModel
        cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        return cell;
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row;
        if row == 0 {
            return;
        }
    }
    
    //MARK:UICollectionViewHeader-Footer
    //设置HeadView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if cacheSize != CGSize.zero {
            return cacheSize;
        }
        
        _footerViewEx.fillCellWithMod(mod: _modDetail, row: section, delegate: self,type:TextFooterView.FooterType.btn);
        let s = CGSize(width: Const.SCREEN_WIDTH, height:_footerViewEx.frame.size.height);
        print("size:%d,%d",s.width,s.height);
        cacheSize = s;
        return s;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if( kind == UICollectionElementKindSectionFooter){
            
            let section = indexPath.section;
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TextFooterView.cellIdentifier(), for: indexPath) as! TextFooterView;
            v.fillCellWithMod(mod: _modDetail, row: section, delegate: self,type:TextFooterView.FooterType.btn);
            _footerView = v;
            return v;
        }
        
        return UICollectionReusableView();
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
