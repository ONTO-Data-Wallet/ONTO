//
//  DescController.swift
//  ONTO
//
//  Created by zhan zhong yi on 2018/8/25.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class DescController: ZYSWController {
    
    @IBOutlet weak var textView:UITextView!;
    var _mod:BoxDetailModel!;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.UISet();
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
        self.title = ""
        textView.font = Const.font.DINProFontType(.medium, 14);
        textView.textColor = Const.color.kAPPDefaultBlackColor;
        textView.isEditable = false
        textView.backgroundColor = UIColor.clear
        textView.text = _mod.webContent;
    }

}
