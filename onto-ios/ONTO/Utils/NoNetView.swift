//
//  NoNetView.swift
//  ONTO
//
//  Created by Apple on 2019/5/7.
//  Copyright © 2019 Zeus. All rights reserved.
//

import UIKit

class NoNetView: UIView {

    var bgView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    
    func createUI() {
        bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.addSubview(bgView)
        
        self.mas_makeConstraints { (make) in
            make?.height.offset()(SwiftCommon.ScreenSize.SCREEN_HEIGHT)
            make?.width.offset()(SwiftCommon.ScreenSize.SCREEN_WIDTH)
        }
        
        bgView.mas_makeConstraints { (make) in
            make?.left.right()?.top()?.bottom()?.equalTo()(self)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        show()
    }
    @objc public func show() {
        UIView.animate(withDuration: 0.1) {
            self.bgView.alpha = 1
            
            let window = UIApplication.shared.windows
            window[0].addSubview(self)
            window[0].makeKeyAndVisible()        }
    }
    
    @objc public func dismiss() {
        UIView.animate(withDuration: 0.1, animations: {
            self.bgView.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
            self.superview?.isHidden = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
