//
//  ZYBlackTransParentController.swift
//  SNSBasePro
//
//  Created by zhan zhong yi on 2017/9/5.
//  Copyright © 2017年 zhan zhong yi. All rights reserved.
//



import UIKit
import Foundation;

class ZYBlackTransParentController: UIViewController {
    
    @IBOutlet weak var _imageView: UIImageView?
    @objc public var bShowBack:Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.UISetUp();
    }
    
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated);
        
    }
    
    override func viewWillDisappear(_ animated:Bool){
        super.viewWillDisappear(animated);
        
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
    
    
    //common
     func UISetUp(){
        
        self.view.backgroundColor =  UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        let sampleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ZYBlackTransParentController.tap(recognizer:)))
        _imageView?.addGestureRecognizer(sampleTapGesture)
        _imageView?.isUserInteractionEnabled = true;
    }
    
    public func backGroudViewTap(sender:Any?) {
        
    }
    
    
    @objc func tap(recognizer: UITapGestureRecognizer) {
        print("Tapping working")
        
        self.backGroudViewTap(sender: self);
        self.dismiss(animated: false, completion: nil)
    }

}

