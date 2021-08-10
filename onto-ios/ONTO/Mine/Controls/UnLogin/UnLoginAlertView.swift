//
//  UnLoginAlertView.swift
//  ONTO
//
//  Created by Apple on 2019/5/6.
//  Copyright © 2019 Zeus. All rights reserved.
//

import UIKit
class UnLoginAlertView: UIView {

    var mView: UIView!
    var bgView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    func createUI() {
        
        mView = UIView.init()
        mView.backgroundColor = UIColor.white
        mView.isUserInteractionEnabled = true
        self.addSubview(mView)
        
        bgView = UIView.init()
        bgView.layer.cornerRadius = 5
        bgView.clipsToBounds = true
        bgView.backgroundColor = UIColor.white
        self.addSubview(bgView)
        
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "UnLoginClose"), for: .normal)
        closeBtn.setEnlargeEdge(20)
        closeBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        bgView.addSubview(closeBtn)
        
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "HomeID")
        bgView.addSubview(logoImage)
        
        let alertLB = UILabel()
        alertLB.text = LocalizeEx("NewONTIDDec")
        alertLB.font = UIFont.systemFont(ofSize: 16)
        alertLB.numberOfLines = 0
        alertLB.alpha = 0.3
        alertLB.changeSpace(3, wordSpace: 0)
        alertLB.textAlignment = .center
        bgView.addSubview(alertLB)
        
        let createBtn = UIButton()
        createBtn.setTitle(LocalizeEx("newCreateOntId"), for: .normal)
        createBtn.backgroundColor = UIColor(hexString: "#0069E0")
        createBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        createBtn.addTarget(self, action: #selector(createClick), for: .touchUpInside)
        createBtn.setTitleColor(UIColor.white, for: .normal)
        createBtn.layer.cornerRadius = 5
        bgView.addSubview(createBtn)
        
        let importBtn = UIButton()
        importBtn.setTitle(LocalizeEx("ImportAIdentity"), for: .normal)
        importBtn.backgroundColor = UIColor.black
        importBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        importBtn.addTarget(self, action: #selector(imortClick), for: .touchUpInside)
        importBtn.setTitleColor(UIColor.white, for: .normal)
        importBtn.layer.cornerRadius = 5
        bgView.addSubview(importBtn)
        
        self.mas_makeConstraints { (make) in
            make?.height.offset()(SwiftCommon.ScreenSize.SCREEN_HEIGHT)
            make?.width.offset()(SwiftCommon.ScreenSize.SCREEN_WIDTH)
        }
        
        mView.mas_makeConstraints { (make) in
            make?.left.right()?.top()?.bottom()?.equalTo()(self)
        }
        
        bgView.mas_makeConstraints { (make) in
            make?.left.right()?.top()?.bottom()?.equalTo()(self)
        }
        
        let H:CGFloat = 23 + SwiftCommon.BarHeight.NavBarHeight
        closeBtn.mas_makeConstraints { (make) in
            make?.right.equalTo()(self.bgView)?.offset()(-23)
            make?.top.equalTo()(self.bgView)?.offset()(H)
            make?.height.width()?.offset()(26)
        }
        
        logoImage.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self.bgView)
            make?.top.equalTo()(closeBtn.mas_bottom)?.offset()(162*SwiftCommon.ScreenSize.SCALE_W)
            make?.width.offset()(50*SwiftCommon.ScreenSize.SCALE_W*0.6)
            make?.height.offset()(66.5*SwiftCommon.ScreenSize.SCALE_W*0.6)
        }
        alertLB.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.bgView)?.offset()(35*SwiftCommon.ScreenSize.SCALE_W)
            make?.right.equalTo()(self.bgView)?.offset()(-35*SwiftCommon.ScreenSize.SCALE_W)
            make?.top.equalTo()(logoImage.mas_bottom)?.offset()(42*SwiftCommon.ScreenSize.SCALE_W)
        }
        
        createBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.bgView)?.offset()(35*SwiftCommon.ScreenSize.SCALE_W)
            make?.right.equalTo()(self.bgView)?.offset()(-35*SwiftCommon.ScreenSize.SCALE_W)
            make?.height.offset()(45*SwiftCommon.ScreenSize.SCALE_W)
            make?.top.equalTo()(self.bgView.mas_bottom)?.offset()(-70*SwiftCommon.ScreenSize.SCALE_W - 110*SwiftCommon.ScreenSize.SCALE_W - SwiftCommon.BarHeight.TabBarHeight )
        }
        
        importBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.bgView)?.offset()(35*SwiftCommon.ScreenSize.SCALE_W)
            make?.right.equalTo()(self.bgView)?.offset()(-35*SwiftCommon.ScreenSize.SCALE_W)
            make?.height.offset()(45*SwiftCommon.ScreenSize.SCALE_W)
            make?.top.equalTo()(createBtn.mas_bottom)?.offset()(20*SwiftCommon.ScreenSize.SCALE_W)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        show()
    }
    @objc public func show() {
        UIView.animate(withDuration: 0.2) {
            self.mView.alpha = 1
            
            let window = UIApplication.shared.windows
            window[0].addSubview(self)
            window[0].makeKeyAndVisible()        }
    }
    
    @objc public func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.mView.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
            self.superview?.isHidden = true
        }
    }
    @objc func imortClick() {
        self.mView.alpha = 0
        self.removeFromSuperview()
        self.superview?.isHidden = true
        
        UserDefaults.standard.setValue("", forKey: "box")
        let vc = NewOntImportViewController()
        let window = UIApplication.shared.windows
        let rootVC = window[0].rootViewController
        rootVC?.myNavigationController.pushViewController(vc, animated: true)
    }
    
    @objc func createClick() {
        self.mView.alpha = 0
        self.removeFromSuperview()
        self.superview?.isHidden = true
        let vc = CreateViewController()
        let window = UIApplication.shared.windows
        let rootVC = window[0].rootViewController
        rootVC?.myNavigationController.pushViewController(vc, animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
