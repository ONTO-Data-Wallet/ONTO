//
//  WithdrawController.swift
//  ONTO
//
//  Created by zhan zhong yi on 2018/8/25.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class WithdrawOkController: ZYBlackTransParentController {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var myTextView:UITextView!;
    @IBOutlet weak var myPlaceHolder:UILabel!
    @IBOutlet weak var dropListBtn:UIButton!
    @IBOutlet weak var scanBtn:UIButton!
    @IBOutlet weak var balanceLabel:UILabel!
    @IBOutlet weak var amoutLabel:UILabel!;
    @IBOutlet weak var amoutNumsLabel:UILabel!;
     @IBOutlet weak var lineTopImgView:UIImageView!
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var myOkBtn:UIButton!
    @IBOutlet weak var dropListBtnWidthLayout: NSLayoutConstraint!
    @IBOutlet weak var dropListBtnTralingLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var boardView:UIView!
    @IBOutlet weak var boardAddressView:UIView!
    @IBOutlet weak var boardAddressTitle:UILabel!
    public var _list:[ACAdressModel]! = [ACAdressModel]();
    var completionHandler:SFRequestCommonBlock?
    public var _mod:ACAdressModel! =  Mapper<ACAdressModel>().map(JSON: ["":""])!
    var _modBalance:ACBalanceItemModel!
    var _accountModel:AccountModel?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.UISet()
        self.showAlert(title: "", message: "", cancelBtn: "", okBtn: LocalizeEx("withdraw_next")) { (bSuccess, callBacks) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        titleLabel.font = Const.font.DINProFontType(.bold, 18);
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        boardAddressTitle.font = Const.font.DINProFontType(.bold, 18);
        boardAddressTitle.textColor = Const.color.kAPPDefaultBlackColor
        
//        amoutLabel.font = Const.font.DINProFontType(.medium, 15);
        amoutLabel.textColor = Const.color.kAPPDefaultGrayColor
        
        amoutNumsLabel.font = Const.font.DINProFontType(.bold, 18);
        amoutNumsLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        myOkBtn.backgroundColor = Const.color.kAPPDefaultBlackColor;
        myOkBtn.titleLabel?.font = Const.font.DINProFontType(.bold, 18);
        myOkBtn.setTitleColor(Const.color.kAPPDefaultWhiteColor, for: UIControlState.normal)
        myOkBtn.setNeedsDisplay()
        
        myTextView.font = Const.font.DINProFontType(.bold, 15)
        myTextView.isScrollEnabled = false;
        myTextView.setContentOffset(CGPoint.zero, animated: false)
        myTextView.textContainer.maximumNumberOfLines = 2
        myTextView.textContainer.lineBreakMode = .byTruncatingTail
        myPlaceHolder.font = Const.font.DINProFontType(.medium, 15);
        myPlaceHolder.textColor = Const.color.kAPPDefaultGrayColor;
        
        lineTopImgView.backgroundColor = Const.color.kAPPDefaultGrayColor;
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
        
        let arr = [[String:Any]]();
        let list =  Mapper<ACAdressModel>().mapArray(JSONArray: arr)
        _list = list;
        setupCollectionView();
        self.updateUI();
        self.loadDataWithPage(page: 0, view: nil) { (bSuccess, callBacks) in
            
        }
    }
    

     func showAlert(title:String!,message:String!,cancelBtn:String!,okBtn:String?, handler:SFRequestCommonBlock!) -> Void {
        
        let black = [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 18),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultBlackColor] as [NSAttributedStringKey : Any];
        let gray  =  [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 18),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultGrayColor] as [NSAttributedStringKey : Any];
        
        let attrTitle = NSMutableAttributedString.init(string: LocalizeEx("withdraw"), attributes: gray)
        let part =  NSMutableAttributedString.init(string: " \(_modBalance.title!) ", attributes: black)
        attrTitle.append(part)

        titleLabel.attributedText = attrTitle;
        completionHandler = handler
        myOkBtn.setTitle(okBtn, for: UIControlState.normal)
    }
    
    func updateMyTextView() {
        
        
    }
    
    func updateUI() {
        
        if bMoreAddress() == true {
            dropListBtnWidthLayout.constant = 30;
            dropListBtnTralingLayout.constant = 13;
            dropListBtn.isHidden = false;
        }else {
            dropListBtnWidthLayout.constant = 0;
            dropListBtnTralingLayout.constant = 0;
            dropListBtn.isHidden = true;
        }
        
        myPlaceHolder.text = "\(LocalizeEx("candy_input")) \(_modBalance.title!) \(LocalizeEx("candy_address_title"))";
        self.updateText();
        
        let black = [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 15),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultBlackColor] as [NSAttributedStringKey : Any];
        let gray  =  [NSAttributedStringKey.font: Const.font.DINProFontType(.medium, 15),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultGrayColor] as [NSAttributedStringKey : Any];
        
        let amout = _modBalance.content ?? ""
        let attrTitle = NSMutableAttributedString(string:LocalizeEx("withdraw_balance"), attributes: gray)
        var part = NSMutableAttributedString(string:"   ", attributes: gray)
        attrTitle.append(part)
        part = NSMutableAttributedString(string:amout, attributes: black)
        attrTitle.append(part)
        balanceLabel.attributedText = attrTitle
        
        amoutLabel.text = LocalizeEx("withdraw_amount")
        amoutNumsLabel.text = amout
        
        //提币地址
        let black18 = [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 18),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultBlackColor] as [NSAttributedStringKey : Any];
        let gray18  =  [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 18),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultGrayColor] as [NSAttributedStringKey : Any];
        let adTittle =  NSMutableAttributedString.init(string: "\(_modBalance.title!) ", attributes: black18)
        let address = NSMutableAttributedString.init(string: LocalizeEx("addressLB"), attributes: gray18)
        adTittle.append(address)
        boardAddressTitle.attributedText = adTittle
        
        view.setNeedsUpdateConstraints();
        view.updateConstraints()
        view.layoutIfNeeded();
    }
    
    func bMoreAddress() -> Bool {
        
        if _accountModel != nil && _list.count > 0 {
            return true;
        }
        
        return false;
    }
    
    
    func updateMode(mod:AccountModel!,params:Dictionary<String,Any>!){
        
        _accountModel = mod;
        guard  let arr = mod.addressWithdrawModels else {
            return;
        }
        
        let s:String! = params["page"] as! String;
        let page:Int! = Int(s);
        if page <= 1 {
            _list.removeAll();
        }
        _list.append(contentsOf: arr)
        
        self.reloadData();
        self.updateUI();
    }
    
    func params(page:String?) -> Dictionary<String,String> {
        
        var params:Dictionary<String, String> = [:]
        params["page"] = page;
        params["pageSize"] = "\(Const.value.kPageSize5)"
        params["projectId"] = _modBalance.itemId;
        
        return params;
    }
    
    //验证提币地址
    func loadConfirm(_ address:String,view:UIView?,handler:@escaping(SFRequestCommonBlock)) -> Void {
        
        let action = "income/isAddress";
        var params = [String:String]()
        params["projectId"] = _modBalance.itemId
        params["address"] = address
        
        AlamofireModel().loadModelEx(path: action, type: HTTPMethod.post, parameters: params,inView:view) { (bSuccess, response: DataResponse<AccountModel>) in
            
            let mappedObject = response.result.value
            if mappedObject == nil {
                let mod = BaseAdapterMappable();
                mod.msg = Const.msg.kServerStateErrorEx;
                handler(false,mod);
                return;
            }
            
            if mappedObject?.code != 0 {
                let mod = BaseAdapterMappable();
                mod.msg = mappedObject?.message
                handler(false,mod);
                return;
            }
            
            handler(true,mappedObject);
        }
        
    }
    
    func loadDataWithPage(page:NSInteger,view:UIView?,handler:@escaping(SFRequestCommonBlock)) -> Void {
        
        let action = "income/getWithdrawAddressList";
        let params = self.params(page: String.init(format: "%d", page))
        AlamofireModel().loadModelEx(path: action, type: HTTPMethod.get, parameters: params) { (bSuccess, response: DataResponse<AccountModel>) in
            
            let mappedObject = response.result.value
            if mappedObject == nil {
                let mod = BaseAdapterMappable();
                mod.msg = Const.msg.kServerStateErrorEx;
                handler(false,mod);
                return;
            }
            
            self.updateMode(mod: mappedObject, params: params);
            handler(true,mappedObject);
        }
        
    }
    
    //提币
    func loadDataWithdraw(params:[String:String],view:UIView?,handler:@escaping(SFRequestCommonBlock)) -> Void {
        
        let action = "income/saveWithdraw";
        AlamofireModel().loadModelEx(path: action, type: HTTPMethod.post, parameters: params,inView:view) { (bSuccess, response: DataResponse<BaseAdapterMappable>) in
            
            let mappedObject = response.result.value
            if mappedObject == nil {
                let mod = BaseAdapterMappable();
                mod.msg = Const.msg.kServerStateErrorEx;
                handler(false,mod);
                return;
            }
            
            if mappedObject?.code  != 0 {
                let mod = BaseAdapterMappable();
                mod.msg = mappedObject?.message;
                handler(false,mod);
                return;
            }
            
            handler(true,mappedObject);
        }
        
    }
    
    
    func updateText() {
        
        let myText = self.myTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if myText.count > 0 {
            myPlaceHolder.isHidden = true;
        }else {
            myPlaceHolder.isHidden = false;
        }
    }
    
    func  getChainCode(_ text:String) -> String {
        var chainCode = ""
//        if _mod != nil {
//            if text == _mod.content {
//                chainCode = _mod.blockChainName!;
//            }
//        }
        if chainCode.count == 0 {
            chainCode = _modBalance.blockChainName ?? "";
        }
        
        return chainCode;
    }

    //本地验证提币地址是否合法
    func  isLegalAddress(_ address:String,_ chainCode:String) -> Bool {
        
        if chainCode.count == 0 {
            debugPrint("error! 提现 tokenname 为空!")
            self.showHint(LocalizeEx("candy_withdraw_noaddress"), yOffset: -180)
            return false;
        }
        
        if chainCode ==  "ONT" || chainCode == "NEO" {
            if address.validatedByRex("A[0-9a-zA-Z]{33}$") == false {
                
                self.showHint(LocalizeEx("candy_withdraw_wrongaddress"), yOffset: -180)
                return false;
            }
            
            return true;
        }
        
        if chainCode ==  "ETH" {
            if address.validatedByRex("^(0x|0X)?[0-9a-fA-F]{40}$") == false {

                self.showHint(LocalizeEx("candy_withdraw_wrongaddress"), yOffset: -180)
                return false;
            }

            return true;
        }
        
//        if address.validatedByRex("[0-9a-fA-F]$") == false {
//
//            self.showHint(LocalizeEx("candy_withdraw_wrongaddress"), yOffset: -180)
//            return false;
//        }
        
        return true;
    }
    
    //MARK: - clicked
    @IBAction func okBtnClicked(_ sender: Any) {
        
        let text = myTextView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
        if text == nil || text!.isEmpty == true {
            self.showHint(LocalizeEx("candy_withdraw_noaddress"), yOffset: -180)
            return;
        }
        
        //本地验证是否合法
////        ONT、NEO：AVRKWDig5TorzjCS5xphjgMnmdsT7KgsGD，ATfjyFnafWU1GZ1U6wDHU2cTaBaXzJYpBW
////        ETH：0x06012c8cf97BEaD5deAe237070F9587f8E7A266d，0x898546137aE2e091Ae5032EEb4cf16306d9FD713
////        _modBalance.title = "ONT";
////        text = "AVRKWDig5TorzjCS5xphjgMnmdsT7KgsGD";
//        //判断地址格式是否合法
//        let chainCode = getChainCode(text!);
//        if isLegalAddress(text!, chainCode) == false {
//            return;
//        }
        
        let amout = _modBalance.content ?? "0"
        if Double(amout)! <= 0.0 {
            self.showHint("Coins is not enough!", yOffset: -180)
            return;
        }
        
        //在线验证提币地址是否合法
        self.loadConfirm(text!, view: self.view) { (bOk, result) in
            
            if bOk == false {
                self.showHint(LocalizeEx("candy_withdraw_wrongaddress"), yOffset: -180)
                return;
            }
            
            self.boardView.isHidden = true;
            var params =  [String:String]()
            params["projectId"] = self._modBalance.itemId;
            params["address"] = text;
            let cv  = WithdrawPwdController();
            cv.type = WithdrawPwdController.PwdType.withDraw
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
            cv.modalTransitionStyle = modalStyle
            cv.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
            self.present(cv, animated: false, completion: nil)
            cv.completionHandler = { [weak self] (bSuccess,callBacks) in
                
                if bSuccess == false {
                    if let d = callBacks as? [String:String] {
                        if d["bBackGroudTap"]  == "1" {
                            self?.boardView.isHidden = false;
                        }
                    }
                    return;
                }
                
                self?.loadDataWithdraw(params: params, view: self?.view, handler: { (bOk, callBacks) in
                    
                    if bOk == false {
                        self?.boardView.isHidden = false;
                        cv.dismiss(animated: false, completion: {
                        })
                        let mod  = callBacks as! BaseAdapterMappable
                        let msg = mod.msg;
                        self?.showHint(msg, yOffset: -180)
                        return;
                    }
                    
                    self?.presentingViewController?.dismiss(animated: false, completion: {
                        
                    })
                    
//                    let msg = LocalizeEx("withdraw_success");
//                    ZYUtilsSW.topController().showHint(msg, yOffset: -180)
                    let pop = MGPopController.init(title: LocalizeEx("withdraw_success"), message: LocalizeEx("tokenAlert"), image: nil)
                    let action = MGPopAction.init(title:  LocalizeEx("OK")) {
                    }
                    action?.titleColor = UIColor(hexString:"#32A4BE")
                    pop?.add(action)
                    pop?.showCloseButton = false
                    pop?.show()
                    return;
                    NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName.kWithdrawSuccessed), object: nil)
                })
            }
        }
    }
    
    @IBAction func dropListClicked(_ sender:Any) {
        
        self.myTextView.resignFirstResponder();
        guard  let mod = _accountModel else {
            let msg = "Address are loading!"
            self.showHint(msg)
            boardAddressView.isHidden = true;
            return;
        }
        
        if mod.addressWithdrawModels == nil || mod.addressWithdrawModels?.count == 0 {
            let msg = LocalizeEx("no_address")
            self.showHint(msg)
            boardAddressView.isHidden = true;
            return;
        }
        
        boardAddressView.isHidden = !boardAddressView.isHidden
    }
    
    @IBAction func scanClicked(_ sender:Any) {
        
        CommonOCAdapter.share().showQrScan(self) { (bSuccess, callBacks) in
            debugPrint("callbacks:%@",callBacks!)
            if(bSuccess == false){
                return;
            }
            
            guard let d = callBacks as? [String:Any] else {
                return;
            }
            
            self.myTextView.text = d["value"] as? String;
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
        ourCollectionView.backgroundColor = UIColor.clear;
        ourCollectionView.register(WDAdressCLCell.nib(), forCellWithReuseIdentifier: WDAdressCLCell.cellIdentifier())
    }
    
}


extension WithdrawOkController:UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let myText = textView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
        
        if text == "\n" {
            return false;
        }
        
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            debugPrint("Backspace was pressed")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
                self.updateText();
            }
            return true;
        }
        
        if(text.count == 0){
            return false;
        }
        
        debugPrint("myText:%d",myText?.count ?? -1)
        debugPrint("frame:\(textView.frame.debugDescription)")
//        let count = myText.count;
//        if count > 20 {
//            return false;
//        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            self.updateText();
        }
        return true;
    }
}


extension WithdrawOkController:CommonDelegate {
    
    func itemClicked(_ sender: Any) {
        
    }
}


extension WithdrawOkController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return _list.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Const.SCREEN_WIDTH;
        return collectionView.ar_sizeForCell(withIdentifier: WDAdressCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: { (c) in
            
            let cell = c as! WDAdressCLCell;
            let row = indexPath.row;
            let mod = self._list[row]
            cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WDAdressCLCell.cellIdentifier(), for: indexPath as IndexPath) as! WDAdressCLCell;
        
        let row = indexPath.row;
        let mod = _list[row]
        cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        
        return cell;
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         boardAddressView.isHidden = true;
        
        let row  = indexPath.row;
        _mod = _list[row];
        
        myTextView.text = _mod.content;
        updateUI();
    }
    
    //MARK: CollectionView Cell highlighted
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! BaseSWCLCell;
        cell.highlightView?.isHidden = false;
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! BaseSWCLCell;
        cell.highlightView?.isHidden = true;
    }
    
}
