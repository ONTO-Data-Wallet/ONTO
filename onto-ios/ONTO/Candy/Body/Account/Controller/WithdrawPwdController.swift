//
//  WithdrawPwdController.swift
//  ONTO
//
//  Created by zhan zhong yi on 2018/8/25.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import ObjectMapper
import Masonry

extension WithdrawPwdController:HYKeyboardDelegate {
    
    func inputOver(with textField: UITextField!, inputArrayText arrayText: [Any]!) {
        
        if self.inputText.count < 6 {
            return;
        }
        
        self.finished();
    }
    
    func inputOver(with textField: UITextField!, inputText text: String!) {
        
    }
    
    func inputOver(withChange textField: UITextField!, changeText text: String!) {
        
        self.updateByText(text)
        if (text.count == 6) {
            self.finished();
        }
    }
}


//if([string isEqualToString:@"\n"]) {
//    //按回车关闭键盘
//    [textField resignFirstResponder];
//    return NO;
//} else if(string.length == 0) {
//    //判断是不是删除键
//    return YES;
//}
//else if(textField.text.length >= kDotCount) {
//    //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
//    DebugLog(@"输入的字符个数大于6，忽略输入");
//    return NO;
//} else {
//    return YES;
//}

extension WithdrawPwdController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            return false;
        }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            debugPrint("Backspace was pressed")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
                self.updateText();
            }
            return true;
        }
        
        if(string.count == 0){
            return false;
        }
        
        let text  = textField.text;
        if (text?.count)! >= 6 {
            return false;
        }
    
        //判断一下textField的位数
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            self.updateText();
        }
        
        return true;
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true;
    }

}

class WithdrawPwdController: ZYBlackTransParentController {
    
    enum PwdType:Int {
        case login
        case withDraw
    }
    
    @IBOutlet weak var boardView:BoardExView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var myOkBtn:UIButton!
    @IBOutlet weak var _collectionView:UICollectionView!;
    @IBOutlet weak var _collectionViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionViewLeadingLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionViewTopLayout: NSLayoutConstraint!
    @IBOutlet weak var textField:UITextField!;
    public weak var _delegate:CommonDelegate?;
    public var type:PwdType! = PwdType.login
    var completionHandler:SFRequestCommonBlock?
    var originHeight:CGFloat! = 0;
    var rows  = 1; //maybe not work
    let cols = 6;
    var _list = [WDConfirmModel]();
    static var bShowKeyBoard:Bool! = false
    var inputText:String! = ""
    lazy var pwdKeyBoard:HYKeyboard = {
        
        let v = HYKeyboard.init(nibName:"BangcleSafeKeyBoard.bundle/resources/HYKeyboard", bundle: nil)
        v.hostViewController = self
        v.btnrRandomChange = true
        v.shouldTextAnimation = true
        v.keyboardDelegate = self
        v.hostTextField = nil;
        v.secure = true;
        v.contentText = inputText
        v.synthesize = true
        v.shouldClear = true
        v.stringPlaceholder = ""
        v.intMaxLength  = 15
        v.keyboardType = HYKeyboardTypeNone
        v.shouldRefresh(HYKeyboardTypeNone)
        return v;
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.UISet()
        self.showAlert(title: "", message: "", cancelBtn: "", okBtn: LocalizeEx("candy_confirm_withdraw")) { (bSuccess, callBacks) in
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //print(tileContainer.frame.size); // This is actual size you are looking for
//        if WithdrawPwdController.bShowKeyBoard == false {
//            WithdrawPwdController.bShowKeyBoard = true
//            self.showKeyBoard()
//        }
        
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
        
        navigationController?.navigationBar.isTranslucent = false;
        titleLabel.font = Const.font.DINProFontType(.bold, 18);
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        myOkBtn.backgroundColor = Const.color.kAPPDefaultBlackColor;
        myOkBtn.titleLabel?.font = Const.font.DINProFontType(.bold, 18);
        myOkBtn.setTitleColor(Const.color.kAPPDefaultWhiteColor, for: UIControlState.normal)
        myOkBtn.setNeedsDisplay()
        textField.isSecureTextEntry = true;
        
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
        
        let arr = [
            ["headImg":"ongblue","title":"","pwd":""],
            ["headImg":"ongblue","title":"","pwd":""],
            ["headImg":"ongblue","title":"","pwd":""],
            ["headImg":"ongblue","title":"","pwd":""],
            ["headImg":"ongblue","title":"","pwd":""],
            ["headImg":"ongblue","title":"","pwd":""]
        ];
        
        let list =  Mapper<WDConfirmModel>().mapArray(JSONArray: arr)
        _list = list;
        self.setupCollectionView();
    }
    
    
     func showAlert(title:String!,message:String!,cancelBtn:String!,okBtn:String?, handler:SFRequestCommonBlock!) -> Void {
        
        let black = [NSAttributedStringKey.font: Const.font.DINProFontType(.bold, 18),NSAttributedStringKey.foregroundColor:Const.color.kAPPDefaultBlackColor] as [NSAttributedStringKey : Any];
        let attrTitle = NSMutableAttributedString(string:"", attributes: black)
        if type == PwdType.withDraw {
            let part = NSMutableAttributedString(string:LocalizeEx("withdraw_title"), attributes: black)
            attrTitle.append(part)
            titleLabel.attributedText = attrTitle
            myOkBtn.setTitle(LocalizeEx("candy_confirm_withdraw"), for: UIControlState.normal)
        }else {
            let part = NSMutableAttributedString(string:LocalizeEx("withdraw_title"), attributes: black)
            attrTitle.append(part)
            titleLabel.attributedText = attrTitle
            myOkBtn.setTitle(LocalizeEx("candy_confirm"), for: UIControlState.normal)
        }
        completionHandler = handler
    }
    
    
    func showKeyBoard() {

        textField.becomeFirstResponder();
//        var rect = self.pwdKeyBoard.view.frame;
//        //        let fied = self.pwdKeyBoard.hostTextField;
//        //        fied?.text = "123";
//        rect.size.width = self.view.frame.size.width;
//        print("self.view.frame:\(self.view.frame.debugDescription) rect:\(rect.debugDescription)")
//        rect.origin.y = self.view.frame.size.height + 10;
//        self.pwdKeyBoard.view.frame = rect;
//        self.view.addSubview(self.pwdKeyBoard.view)
//        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
//
//            self.pwdKeyBoard.view.origin.y = self.view.frame.size.height - self.pwdKeyBoard.view.frame.size.height;
//
//        }) { (bSuccess) in
//
//        }
    }
    
    func hiddenKeyBoard() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            self.pwdKeyBoard.view.origin.y = self.view.frame.size.height - self.pwdKeyBoard.view.frame.size.height;
            
        }) { (bSuccess) in
            
            self.pwdKeyBoard.view.origin.y = self.view.frame.size.height;
        }
        
    }
    
    func updateByText(_ text:String){
        
        inputText=text;
        debugPrint(" text:%@",text)
        if inputText.isEmpty {
            for item  in _list {
                item.pwd = ""
            }
        }else {
            
            for i  in 0..<_list.count {
                let item  = _list[i]
                if i < text.count {
                    let s = text[i,i];
                    debugPrint("s:\(s!)")
                    item.pwd = s
                }else {
                  item.pwd = ""
                }
            }
        }
        
         self.reloadData();
    }
    
    func finished() {
        
        var d = [String:String]();
        d["pwd"] = inputText;
        let pwd = d["pwd"]
        
//        //用本地数据库中的密码来验证
//        if Common.judgePasswordisMatch(withPassWord: pwd, withOntId: ZYUtilsSW.getOntId()) == false {
//            self.showHint(LocalizeEx("PASSWORDERROR"), yOffset: -200)
//            return;
//        }
        
        if type == PwdType.login {
            if self.completionHandler != nil {
                self.completionHandler!(true,d)
            }
            return;
        }
        
        //通过私钥证书来验证
        CommonOCAdapter.share().confirmPwd(pwd) { [weak self] (bSuccess, callBacks) in
            if bSuccess == false {
                
                var msg = LocalizeEx("PASSWORDERROR");
                if let d = callBacks as? [String:String] {
                    msg = d["msg"] as! String
                }
                self?.showHint(msg, yOffset: -200)
                return;
            }
            
            if self?.completionHandler != nil {
               self?.completionHandler!(true,d)
            }
        }
    }
    
    func updateText() {
        
        guard let myText = self.textField.text else {
            return;
        }
        self.updateByText(myText)
        if (myText.count == 6) {
            
            self.textField.resignFirstResponder()
            //self.finished();
        }
    }
    
    //MARK: - clicked
    @IBAction func okBtnClicked(_ sender: Any) {
        
        self.finished();
    }
    
    //MARK: - delegate
    override func backGroudViewTap(sender: Any?) {
        
        if completionHandler != nil {
            let d = ["bBackGroudTap":"1"]
            completionHandler!(false,d)
        }
        
    }
    
    // MARK: - collection
    func reloadData() ->Void{
        _collectionView.reloadData()
    }
    
    @objc func getIconWidth(layout:UICollectionViewFlowLayout) -> CGFloat {
        
        let space = CGFloat(cols - 1) * (layout.minimumInteritemSpacing) + layout.sectionInset.left + layout.sectionInset.right + _collectionViewLeadingLayout.constant*2;
        let screenWidth = Const.ScreenSize.SCREEN_WIDTH - space;
        let width = CGFloat(screenWidth)/CGFloat(cols);
        return width;
    }
    
    func updateCollectioview(_ layout:UICollectionViewFlowLayout,_ list:[WDConfirmModel]) {
        
//        var cnt = list.count/4;
//        if list.count % 4 > 0 {
//            cnt += 1;
//        }
//        rows = cnt;
        
        let width = self.getIconWidth(layout: layout)
        layout.itemSize =  CGSize(width:width, height:50)
//        let height = layout.itemSize.height * CGFloat(rows) + layout.minimumLineSpacing * CGFloat( rows - 1)  + layout.sectionInset.top + layout.sectionInset.bottom;
//        _collectionViewHeightLayout.constant = max(40, height);
//                print("rows:\(layout.itemSize.height * CGFloat(rows)),linespace:\(layout.minimumLineSpacing * CGFloat( rows - 1)),top:\(layout.sectionInset.top),bottom:\(layout.sectionInset.bottom)")
    }
    
    func setupCollectionView() ->Void{
        
        //  设置 layOut
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 4;
        //        layout.headerReferenceSize = CGSize(width:0,height:  0)   //头部间隔
        //        layout.footerReferenceSize = CGSize(width:0,height:  0)   //底部间隔
        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0)            //section四周的缩进
        layout.scrollDirection = .horizontal;
        
        self.updateCollectioview(layout,_list);
        
        // 设置CollectionView
        let ourCollectionView:UICollectionView!  = _collectionView;
        ourCollectionView.collectionViewLayout = layout;
        ourCollectionView.delegate = self
        ourCollectionView.dataSource = self
        ourCollectionView.delaysContentTouches = false
        ourCollectionView.backgroundColor = UIColor.clear;
        ourCollectionView.isScrollEnabled = false;
        ourCollectionView.register(WDConfirmItemCLCell.nib(), forCellWithReuseIdentifier: WDConfirmItemCLCell.cellIdentifier())
    }
    
}

extension WithdrawPwdController:CommonDelegate {
    
    
}


extension WithdrawPwdController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return _list.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row;
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WDConfirmItemCLCell.cellIdentifier(), for: indexPath as IndexPath) as! WDConfirmItemCLCell;
        
        let mod:WDConfirmModel! = _list[row]
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout;
        cell.fillCellWithMod(mod: mod, row: row, delegate: self,size: layout.itemSize)
        return cell;
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap ==\(indexPath.row)")
        let row = indexPath.row;
        let mod:WDConfirmModel! = _list[row];
        _delegate?.itemClicked?(mod);
        
        if(textField.isFirstResponder == false){
            self.showKeyBoard();
        }
    }
    
    //MARK:UICollectionViewDelegate - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero;
    }
    
    //MARK: CollectionView Cell highlighted
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        let cell:BaseSWCLCell! = collectionView.cellForItem(at: indexPath) as! BaseSWCLCell;
        cell.highlightView?.isHidden = false;
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        let cell:BaseSWCLCell! = collectionView.cellForItem(at: indexPath) as! BaseSWCLCell;
        cell.highlightView?.isHidden = true;
    }
}


class BoardExView: UIView,HYKeyboardDelegate {
    func inputOver(with textField: UITextField!, inputArrayText arrayText: [Any]!) {
        
    }
    
    func inputOver(with textField: UITextField!, inputText text: String!) {
        
    }
    
    func inputOver(withChange textField: UITextField!, changeText text: String!) {
    
    }
    
    
}

//extension WithdrawController:HYKeyboardDelegate {
//
//    func inputOver(with textField: UITextField!, inputArrayText arrayText: [Any]!) {
//
//    }
//
//    func inputOver(with textField: UITextField!, inputText text: String!) {
//
//    }
//
//    func inputOver(withChange textField: UITextField!, changeText text: String!) {
//
//    }
//
//
//
//}
