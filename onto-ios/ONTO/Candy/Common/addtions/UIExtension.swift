//
//  UIExtension.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit


extension UICollectionReusableView {

    class func nib() -> UINib {
        return UINib.init(nibName: self.classNameEx, bundle: nil)
    }

    class func cellIdentifier() -> String {
        return self.classNameEx + "ID";
    }

}
