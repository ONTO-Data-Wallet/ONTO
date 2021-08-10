//
//  ShuftiSurePreViewController.swift
//  ONTO
//
//  Created by Apple on 2018/11/2.
//  Copyright © 2018 Zeus. All rights reserved.
//


//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class ShuftiSurePreViewController: BaseViewController,XWCountryCodeControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    var docType : String!
    var country : String!
    
    var countryBtn = UIButton(type: .custom)
    var myphoneBtn = UIButton(type: .custom)
    var myphoneNumF = UITextField.init()
    var myfullNameF = UITextField.init()
    var mylastNameF = UITextField.init()
    var mytypeNameF = UITextField.init()
    var myEmailF = UITextField.init()
    
    
    var myImageView: UIImageView!
    var myImageView1: UIImageView?
    var leftBtn:UIButton!
    var scrollView:UIScrollView?
    var lastImageView:UIImageView?
    var originalFrame:CGRect!
    var isDoubleTap:ObjCBool!
    var isGetImage : Bool!
    var isSecondImage : Bool!
    var isGetImage2 : Bool!
    
    var ALPHANUM = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
    
    
    var ischosenCountry : Bool!
    
    var shuftiModel:IdentityModel!
    
    
    enum Enum_IMType:NSInteger{
        case type1
        case type2
        case type3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.UIConfig()
        self.setNavTitle(self.loacalkey(key: "SHUFTIPRO"))
        self.setNavLeftImageIcon(UIImage.init(named:"cotback"), title: "Back")
    }
    
    override func navLeftAction() {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = {[NSAttributedStringKey.foregroundColor : UIColor.black,
                                                                         NSAttributedStringKey.font : UIFont.systemFont(ofSize: 21, weight: .bold),
                                                                         NSAttributedStringKey.kern: 2]}()
    }
    @objc func  setisGetImge() {
        
        self.isGetImage = true
    }
    
    @objc   func  setisGetImge2() {
        self.isGetImage2 = true
    }
    
    func UIConfig()  {
        
        self.nextBtnConfig()
        
        //副标题
        let titleBtn = UIButton(type: .custom)
        titleBtn.frame = CGRect(x:25,y:15,width:300,height:40)
        
        if  UIScreen.main.bounds.width == 320{
            titleBtn.frame = CGRect(x:25,y:0,width:300,height:40)
        }
        titleBtn.setTitleColor(UIColor(hexString:"#6A797C"), for: UIControlState.normal)
        titleBtn.setTitle("   "+self.loacalkey(key: "IMStep1"), for: UIControlState.normal)
        titleBtn.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .medium)
        titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        titleBtn.setImage(UIImage.init(named:"dot"), for: UIControlState.normal)
        self.view.addSubview(titleBtn)
        
        let docTypefield = UIButton(type: .custom)
        self.view.addSubview(docTypefield)
        docTypefield.setTitle(self.docType, for: UIControlState.normal)
        docTypefield.setTitleColor(UIColor(hexString:"#2B4045"), for: UIControlState.normal)
        docTypefield.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        docTypefield.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        docTypefield.mas_makeConstraints { (make) in
            
            make?.height.equalTo()(44)
            make?.top.equalTo()(titleBtn.mas_bottom)?.offset()(10)
            make?.left.equalTo()(self.view)?.offset()(25)
            make?.right.equalTo()(self.view)?.offset()(-25)
        }
        
        
        let line1 = UIView.init()
        self.view.addSubview(line1)
        line1.backgroundColor = UIColor(hexString:"#E9EDEF")
        line1.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(docTypefield)
            make?.top.equalTo()(docTypefield.mas_bottom)?.offset()(0)
            make?.height.equalTo()(1)
        }
        
        let typeName = UITextField.init()
        self.view.addSubview(typeName)
        typeName.placeholder = "\(self.docType!)\(self.loacalkey(key: "IMNumber"))"
        typeName.mas_makeConstraints { (make) in
            make?.top.equalTo()(line1.mas_bottom)?.offset()(25)
            make?.left.height().equalTo()(titleBtn)
            make?.right.equalTo()(self.view)?.offset()(-25)
        }
        
        typeName.font = UIFont.systemFont(ofSize: 14)
        mytypeNameF = typeName;
        mytypeNameF.delegate = self
        
        let line4 = UIView.init()
        self.view.addSubview(line4)
        line4.backgroundColor = UIColor(hexString:"#E9EDEF")
        line4.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(line1)
            make?.top.equalTo()(typeName.mas_bottom)?.offset()(0)
            make?.height.equalTo()(1)
        }
        
        //上传照片
        let upLoadLabel = UILabel.init()
        upLoadLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.view .addSubview(upLoadLabel)
        upLoadLabel.text = self.loacalkey(key: "IM_UploadDocument")
        upLoadLabel.textColor =  UIColor(hexString:"#AAB3B4")
        upLoadLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(line1)
            make?.top.equalTo()(line4.mas_bottom)?.offset()(28)
//            if  UIScreen.main.bounds.width == 320{
//                make?.top.equalTo()(line1.mas_bottom)?.offset()(1)
//            }
            make?.height.equalTo()(30)
        }
        
        let upLoadLabel2 = UILabel.init()
        upLoadLabel2.font = UIFont.boldSystemFont(ofSize: 14)
        self.view .addSubview(upLoadLabel2)
        upLoadLabel2.text = self.loacalkey(key: "IM_AllowedFile")
        
        upLoadLabel2.numberOfLines = 0
        upLoadLabel2.textColor =  UIColor(hexString:"#6A797C")
        upLoadLabel2.mas_makeConstraints { (make) in
            make?.left.equalTo()(line1)
            make?.top.equalTo()(upLoadLabel.mas_bottom)?.offset()(0)
            if  UIScreen.main.bounds.width == 320{
                make?.right.equalTo()(line1)
            }
        }
        
        
        let uploadImage1 = UIImageView.init()
        uploadImage1.image = UIImage.init(named:self.loacalkey(key: "frontImagename"))
        
        self.view.addSubview(uploadImage1)
        uploadImage1.mas_makeConstraints { (make) in
            make?.left.equalTo()(line1)
            make?.top.equalTo()(upLoadLabel2.mas_bottom)?.offset()(20)
            make?.width.equalTo()(96.5)
            make?.height.equalTo()(90)
        }
        
        myImageView = uploadImage1
        uploadImage1.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showZoomImageView(tap:)))
        uploadImage1.addGestureRecognizer(tap)
        
        self.isGetImage = false
        self.isGetImage2 = false
        
        
        if self.docType != self.loacalkey(key: "IM_Passort") {
            let uploadImage2 = UIImageView.init()
            uploadImage2.image = UIImage.init(named: self.loacalkey(key: "backImagename"))
            self.view.addSubview(uploadImage2)
            uploadImage2.mas_makeConstraints { (make) in
                make?.width.height().top().equalTo()(uploadImage1)
                make?.left.equalTo()(uploadImage1.mas_right)?.offset()(25)
            }
            
            myImageView1 = uploadImage2
            uploadImage2.isUserInteractionEnabled = true
            let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(showZoomImageView(tap:)))
            uploadImage2.addGestureRecognizer(tap2)
            
        }
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == self.myfullNameF || textField == self.mylastNameF {
            let cs  = NSCharacterSet.init(charactersIn: ALPHANUM).inverted
            let filtered  = string.components(separatedBy: cs).joined(separator: "")
            
            if string != filtered {
                return false
            }
            if (textField.text! as NSString).length <= 50{
                return true
            }else{
                return false
            }
        }
        else if textField == self.mytypeNameF{
            
            if (textField.text! as NSString).length <= 50{
                return true
            }else{
                return false
            }
        }
        else{
            
            guard let text = textField.text else{
                return true
            }
            let textLength = text.count + string.count - range.length
            if Common.validateNumber(string) == false{
                return false
            }
            return textLength<=20
        }
    }
    
    
    
    func nextBtnConfig()  {
        
        let nextBtn = UIButton(type: .custom)
        nextBtn.backgroundColor = UIColor(hexString:"#000000")
        nextBtn.setTitle(self.loacalkey(key: "IM_Submit"), for: UIControlState.normal)
        self.view.addSubview(nextBtn)
        nextBtn.setTitleColor(UIColor(hexString:"#FFFFFF"), for: UIControlState.normal)
        nextBtn.addTarget(self, action: #selector(nextAction), for: UIControlEvents.touchUpInside)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        nextBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(view)?.offset()(58*SCALE_W)
            make?.right.equalTo()(view)?.offset()(-58*SCALE_W)
            make?.height.equalTo()(60*SCALE_W)
            if UIDevice.current.isX(){
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W - 34)
            }else{
                make?.bottom.equalTo()(view)?.offset()(-40*SCALE_W)
            }
        }
    }
    
    @objc func nextAction(button:UIButton) {
        if mytypeNameF.text?.count == 0 {
            Common.showToast(self.loacalkey(key: "IM_Number"))
            return
        }
        if self.docType != self.loacalkey(key: "IM_Passort") {
            if (self.isGetImage==false||self.isGetImage2==false){
                Common.showToast(self.loacalkey(key: "IM_upLoadImage"))
                return
            }
        }else{
            if (self.isGetImage==false){
                Common.showToast(self.loacalkey(key: "IM_upLoadImage"))
                return
            }
            
        }
        let vc =  ShuftiSureViewController()
        vc.fullName = self.myfullNameF.text
        vc.lastName = self.mylastNameF.text
        vc.idNumber = self.mytypeNameF.text
        vc.doucumentType = self.docType
        vc.photo1 = self.myImageView.image
        
        vc.photo2 = self.myImageView1?.image
        vc.shuftiModel = shuftiModel
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func phoneNumClickAction(button:UIButton) {
        
        let vc =  XWCountryCodeController()
        vc.returnCountryCodeBlock = { countryString in
            print(countryString!)
            
            self.myphoneBtn.setTitle("+"+self.getIntFromString(str: countryString!), for: UIControlState.normal)
            self.myphoneBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.ischosenCountry = true;
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //正确代理回调方法
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.lastImageView
    }
    
    
    // 从字符串中提取数字
    func getIntFromString(str:String) -> String {
        let scanner = Scanner(string: str)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number :Int = 0
        
        scanner.scanInt(&number)
        
        print(number)
        return String(number)
        
    }
    //MARK: - 相机
    
    //从相册中选择
    func initPhotoPicker(){
        self.navigationController?.navigationBar.isHidden = false
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = false
        photoPicker.sourceType = .photoLibrary
        photoPicker.navigationBar.isTranslucent = false
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    
    @objc func showZoomImageView( tap : UITapGestureRecognizer) {
        
        if tap.view == myImageView {
            
            self.isSecondImage = false
            
            if self.isGetImage==false {
                self.getPhotot()
            }else{
                
                let bgView = UIScrollView.init(frame: UIScreen.main.bounds)
                bgView.backgroundColor = UIColor.black
                let tapBg = UITapGestureRecognizer.init(target: self, action: #selector(tapBgView(tapBgRecognizer:)))
                bgView.addGestureRecognizer(tapBg)
                let picView = tap.view as! UIImageView//view 强制转换uiimageView
                let imageView = UIImageView.init()
                imageView.image = picView.image;
                imageView.frame = bgView.convert(picView.frame, from: self.view)
                bgView.addSubview(imageView)
                UIApplication.shared.keyWindow?.addSubview(bgView)
                self.lastImageView = imageView
                self.originalFrame = imageView.frame
                self.scrollView = bgView
                self.scrollView?.maximumZoomScale = 1.5
                self.scrollView?.delegate = self
                //            contentHorizontalAlignment
                leftBtn = UIButton.init(type: UIButtonType.custom)
                leftBtn.frame = CGRect(x:16,y:30,width:44,height:44)
                leftBtn.setEnlargeEdge(20)
                leftBtn.contentHorizontalAlignment = .left
                leftBtn.setImage(UIImage.init(named:"nav_back"), for: .normal)
                UIApplication.shared.keyWindow?.addSubview(leftBtn)
                
                
                let deleteBtn = UIButton.init(type: UIButtonType.custom)
                deleteBtn.frame = CGRect(x:SYSWidth - 60,y:30,width:50,height:44)
                deleteBtn.setEnlargeEdge(20)
                deleteBtn.contentHorizontalAlignment = .right
                deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                deleteBtn.setTitle(self.loacalkey(key: "Edit"), for: .normal)
                
                UIApplication.shared.keyWindow?.addSubview(deleteBtn)
                deleteBtn.handleControlEvent(.touchUpInside) {
                    self.getPhotot()
                    self.scrollView?.contentOffset = CGPoint.zero
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        self.lastImageView!.frame = imageView.frame
                        bgView.backgroundColor = UIColor.clear
                    }) { (finished:Bool) in
                        bgView.removeFromSuperview()
                        self.leftBtn.removeFromSuperview()
                        deleteBtn.removeFromSuperview()
                        self.scrollView = nil
                        self.lastImageView = nil
                    }
                }
                leftBtn.handleControlEvent(.touchUpInside) {
                    self.scrollView?.contentOffset = CGPoint.zero
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        self.lastImageView!.frame = imageView.frame
                        bgView.backgroundColor = UIColor.clear
                    }) { (finished:Bool) in
                        self.leftBtn.removeFromSuperview()
                        deleteBtn.removeFromSuperview()
                        bgView.removeFromSuperview()
                        self.scrollView = nil
                        self.lastImageView = nil
                    }
                }
                
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    options: UIViewAnimationOptions.beginFromCurrentState,
                    animations: {
                        var frame = imageView.frame
                        frame.size.width = bgView.frame.size.width
                        frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
                        frame.origin.x = 0
                        frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
                        imageView.frame = frame
                }, completion: nil
                )
            }
            
        }else if tap.view == myImageView1 {
            
            
            
            
            self.isSecondImage = true
            if self.isGetImage2==false {
                self.getPhotot()
            }else{
                
                
                let bgView = UIScrollView.init(frame: UIScreen.main.bounds)
                bgView.backgroundColor = UIColor.black
                let tapBg = UITapGestureRecognizer.init(target: self, action: #selector(tapBgView(tapBgRecognizer:)))
                bgView.addGestureRecognizer(tapBg)
                let picView = tap.view as! UIImageView//view 强制转换uiimageView
                let imageView = UIImageView.init()
                imageView.image = picView.image;
                imageView.frame = bgView.convert(picView.frame, from: self.view)
                bgView.addSubview(imageView)
                UIApplication.shared.keyWindow?.addSubview(bgView)
                self.lastImageView = imageView
                self.originalFrame = imageView.frame
                self.scrollView = bgView
                self.scrollView?.maximumZoomScale = 1.5
                self.scrollView?.delegate = self
                
                
                leftBtn = UIButton.init(type: UIButtonType.custom)
                leftBtn.frame = CGRect(x:16,y:30,width:44,height:44)
                leftBtn.setEnlargeEdge(20)
                leftBtn.contentHorizontalAlignment = .left
                leftBtn.setImage(UIImage.init(named:"nav_back"), for: .normal)
                UIApplication.shared.keyWindow?.addSubview(leftBtn)
                
                
                let deleteBtn = UIButton.init(type: UIButtonType.custom)
                deleteBtn.frame = CGRect(x:UIScreen.main.bounds.width-60,y:30,width:50,height:44)
                deleteBtn.contentHorizontalAlignment = .right
                deleteBtn.setEnlargeEdge(20)
                deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                deleteBtn.setTitle(self.loacalkey(key: "Edit"), for: .normal)
                
                UIApplication.shared.keyWindow?.addSubview(deleteBtn)
                deleteBtn.handleControlEvent(.touchUpInside) {
                    self.getPhotot()
                    self.scrollView?.contentOffset = CGPoint.zero
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        self.lastImageView!.frame = imageView.frame
                        bgView.backgroundColor = UIColor.clear
                    }) { (finished:Bool) in
                        bgView.removeFromSuperview()
                        self.leftBtn.removeFromSuperview()
                        deleteBtn.removeFromSuperview()
                        self.scrollView = nil
                        self.lastImageView = nil
                    }
                }
                
                leftBtn.handleControlEvent(.touchUpInside) {
                    self.scrollView?.contentOffset = CGPoint.zero
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        self.lastImageView!.frame = imageView.frame
                        bgView.backgroundColor = UIColor.clear
                    }) { (finished:Bool) in
                        bgView.removeFromSuperview()
                        self.leftBtn.removeFromSuperview()
                        deleteBtn.removeFromSuperview()
                        self.scrollView = nil
                        self.lastImageView = nil
                    }
                }
                
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    options: UIViewAnimationOptions.beginFromCurrentState,
                    animations: {
                        var frame = imageView.frame
                        frame.size.width = bgView.frame.size.width
                        frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
                        frame.origin.x = 0
                        frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
                        imageView.frame = frame
                }, completion: nil
                )
            }
            
        }
    }
    
    @objc func tapBgView(tapBgRecognizer:UITapGestureRecognizer)
    {
        self.scrollView?.contentOffset = CGPoint.zero
        UIView.animate(withDuration: 0.5, animations: {
            self.lastImageView?.frame = self.originalFrame
            self.leftBtn.removeFromSuperview()
            tapBgRecognizer.view?.backgroundColor = UIColor.clear
            self.leftBtn.removeFromSuperview()
        }) { (finished:Bool) in
            tapBgRecognizer.view?.removeFromSuperview()
            
            self.scrollView = nil
            self.lastImageView = nil
        }
    }
    
    func getPhotot()  {
        initCameraPicker()
        
    }
    
    //拍照
    func initCameraPicker(){
        let vc = DDPhotoViewController.init()
        
        vc.imageblock =  { image in
            
            if self.isSecondImage==true {
                self.isGetImage2 = true
                self.myImageView1?.image =   Common.fixOrientation(image)
            }else{
                self.isGetImage = true
                self.myImageView?.image =  Common.fixOrientation(image)
            }
        }
        vc.albumBlock = { str in
            weak var weakSelf = self
            weakSelf?.initPhotoPicker()
        }
        self.present(vc, animated: true, completion: {
            
        })
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        //获得照片
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 拍照
        if picker.sourceType == .camera {
            //保存相册
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        if self.isSecondImage==true {
            
            self.isGetImage2 = true
            myImageView1?.image =   Common.fixOrientation(image)
            
            
            
            
        }else{
            
            self.isGetImage = true
            myImageView?.image =  Common.fixOrientation(image)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        
        if error != nil {
            
            print("保存失败")
            
        } else {
            
            print("保存成功")
            
            
        }
    }
    
    func loacalkey(key:String) -> String {
        let path1 = UserDefaults.standard.value(forKey: "userLanguage") as! String
        let  path = Bundle.main.path(forResource: path1, ofType: "lproj")
        let  bundle:String = (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
        return bundle
        
    }
}



