//
//  LoginCenter.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/30.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class LoginCenter: NSObject {
    
    private var withdrawPwdController:WithdrawPwdController?
    private static var _instance: LoginCenter! = {
        let ins = LoginCenter();
        return ins;
    }()
    
    @objc public class func shared() -> LoginCenter! {
        return _instance;
    }
    
    public var userCenter:UserCenter? = nil;
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    override init() {
        super.init();
            
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(NotificationName.kLoginExpired), object: nil, queue: OperationQueue.main) { (nc) in
            //self.login()
            let cv = ZYUtilsSW.topController();
            self.showLogin(baseController: cv, handler: { (bSuccess, callBacks) in
                
                if bSuccess == false {
                    return;
                }
                
                cv.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    //MARK: - login
    @objc func bNeedLogin() -> Bool {
        
//        return true;
//        CommonOCAdapter.share().deleteOntSession();
        let json = CommonOCAdapter.share().getOntSession();
        if json != nil {
            self.userCenter = Mapper<UserCenter>().map(JSONString: json!)
        }
    
        if( self.userCenter == nil){
            return true;
        }
        
        
        if( self.userCenter!.bExpired() == false ){
            return false;
        }
        
        return true;
    }
    
    @objc func showLogin(baseController:UIViewController?,handler:@escaping RequestCommonBlock) -> Void {
        
        let cv = LoginDescController()
        cv.bShowBack = true;
        let nav = UINavigationController.init(rootViewController: cv)
        nav.navigationBar.isTranslucent = false;
        baseController?.present(nav, animated: false, completion: nil)
        cv.completionHandler = {  (bSuccess,callBacks) in
            
            if bSuccess == false {
                if let d = callBacks as? [String:String]  {
                    if d["bBack"] != nil {
                        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName.kLoginbBackAction), object: nil)
                    }
                }
            }

            handler(bSuccess!,callBacks)
        }
    }
    
    @objc func login() {
        login(baseController: ZYUtilsSW.topController()) { (bSuccess, callBacks) in
            
        }
    }
    
    //账号zhan6
//    fullUrl:http://47.100.77.82:7001/user/login?sig=AfiiIwFbROfO2lCuvuxSqAE0k/Rx1jmRaj9F/IaVya2UYvG9KfNANcEs6zaY8+Tuwdld9+GpdQNtfrL6qzXSd4I=&ontId=did:ont:AKjc78oq47DzL92yX696RLwvum8yEJyUhX&deviceCode=device5781ee62294d4331beefb260d6efc541&timestamp=1536195750&nonce=1585130
//    url:Optional("http://47.100.77.82:7001/user/login")
//    params:{
//    "sig" : "AfiiIwFbROfO2lCuvuxSqAE0k\/Rx1jmRaj9F\/IaVya2UYvG9KfNANcEs6zaY8+Tuwdld9+GpdQNtfrL6qzXSd4I=",
//    "ontId" : "did:ont:AKjc78oq47DzL92yX696RLwvum8yEJyUhX",
//    "deviceCode" : "device5781ee62294d4331beefb260d6efc541",
//    "timestamp" : "1536195750",
//    "nonce" : "1585130"
//    }
    @objc func login(baseController:UIViewController?,handler:@escaping RequestCommonBlock) -> Void {
        
        let action = "user/login";
        var params = ZYUtilsSW.ontForCanyParams()
        params["timestamp"] = ZYUtilsSW.timeStamp();
        let n:UInt32 = 1000000
        let nonce = arc4random()%n;
        params["nonce"] = "\(nonce + n)";
        
        let asend = AlamofireModel.asendParams(params)
        print("asend:\(asend)")
        
        let cv  = WithdrawPwdController();
        cv.type = WithdrawPwdController.PwdType.login;
        let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
        cv.modalTransitionStyle = modalStyle
        cv.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        baseController?.present(cv, animated: false, completion: nil)
        cv.completionHandler = { (bSuccess,callBacks) in
            if bSuccess == false {
                handler(false,nil)
                return;
            }
            
            MBProgressHUD.showAdded(to: cv.view, animated: true)
            let d = callBacks as! [String:String]
            let pwd = d["pwd"]
            CommonOCAdapter.share().signContent(asend.toHex(), pwd: pwd, handler: { (bOkEx, callBacks) in
                
                let  d = callBacks as! [String:Any];
                params["sig"] = d["Value"] as? String;
//                print("d:\(d.debugDescription)")
                print("sig:\(params.debugDescription)")
                self.login(action: action, params: params, completionHandler: {  (bOk, callBacks) in
                
                    DispatchQueue.main.async {
                
                        MBProgressHUD.hide(for: cv.view, animated: false)
                        if bOk == false {
                            cv.showHint(LocalizeEx("newError"), yOffset: -180)
                            handler(false,callBacks)
                            return;
                        }
                        
                        handler(true,callBacks)
                    }
        
                })
            })
        }
        self.withdrawPwdController = cv
    }
    
    func login(action:String,params:[String:String],completionHandler:@escaping(SFRequestCommonBlock)){
        AlamofireModel().loadModelEx(path: action, type: HTTPMethod.post, parameters: params,headers:AlamofireModel.loginHeaderParams()) { (bSuccess, response: DataResponse<UserCenter>) in
            
            let mappedObject = response.result.value
            if mappedObject == nil {
                let mod = BaseAdapterMappable();
                mod.msg = Const.msg.kServerStateErrorEx;
                completionHandler(false,mod);
                return;
            }
            
            let str = mappedObject?.toJSONString();
            CommonOCAdapter.share().saveOntSession(str);
            CommonOCAdapter.share().save(inKeyChain: params["sig"], key: ONTID_CANDY_SING)
            
            self.userCenter = mappedObject;
            NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName.kLoginSuccessed), object: nil)
            completionHandler(true,mappedObject);
            
            //ZYUtilsSW.topController().showHint("Login Success!", yOffset: -180)
        }
    }
    
}
