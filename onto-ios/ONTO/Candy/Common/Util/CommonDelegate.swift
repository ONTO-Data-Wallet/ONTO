//
//  CommonDelegate.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

@objc public protocol CommonDelegate:NSObjectProtocol {

    
    @objc optional func itemClicked(_ sender:Any);
    @objc optional func itemExClicked(_ sender:Any);
    @objc optional func headTap(_ sender:Any);
    @objc optional func cdSendClicked(_ sender:Any);
    @objc optional func cdBottomBtnClicked(_ sender:Any);
    @objc optional func cdRightArrowClicked(_ sender:Any);
    @objc optional func cdRightArrowExClicked(_ sender:Any);
    @objc optional func cdUrlClicked(_ sender:Any);
}
