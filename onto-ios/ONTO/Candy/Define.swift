//
//  Define.swift
//  SNSBasePro
//
//  Created by zhan zhong yi on 2017/9/5.
//  Copyright © 2017年 zhan zhong yi. All rights reserved.
//

import UIKit

typealias CompletionBlock = (NSString?) -> Void
typealias SFBlock = (_ bSuccess:Bool,_ callBacks:NSData?) -> Void
typealias SFRequestCommonBlock = (_ bSucces: Bool?,_ callBacks: Any?) -> Void
typealias SFRequestCommonExBlock = (Bool,Any) -> Void
typealias TwoViewControllerClosure = (_ string :String) -> Void;
typealias SFRequestCommonAnyBlock = (Any,Any) -> Void
