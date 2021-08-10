//
//  ZYSWController.swift
//  SNSBasePro
//
//  Created by zhan zhong yi on 2017/9/5.
//  Copyright © 2017 zhan zhong yi. All rights reserved.
//

import UIKit
import Foundation;


class ZYSWController: UIViewController {
    
    @objc public var bShowBack  = false;
    public var bShowCrossBack = false;
    public var page = 0;
    public var hasMore = false;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.UISetUp();
        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17),NSAttributedStringKey.foregroundColor: Const.color.kAPPDefaultBlackColor]
        //        UINavigationBar.appearance().titleTextAttributes = attributes
        self.navigationController?.navigationBar.titleTextAttributes = attributes;
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
    // MARK: - common

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
     func UISetUp(){
    
        self.view.backgroundColor = Const.color.kAPPDefaultBgColor;
        if(bShowBack == true){

            let image = UIImage(named:"candyback")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            let item:UIBarButtonItem! =  UIBarButtonItem.init(image:image , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backClicked(sender:)) );
            self.navigationItem.leftBarButtonItem = item;

        }else if(bShowCrossBack == true){
            
            let item:UIBarButtonItem! =  UIBarButtonItem.init(image: UIImage(named:"cross_back"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(self.crossClicked(sender:)));
            self.navigationItem.leftBarButtonItem = item;
        }
    }
    
    
    // MARK: - common
    @objc public func backClicked(sender:Any) -> Void {
        let nav = self.navigationController;
        nav?.popViewController(animated: true);
    }
    
    @objc public func crossClicked(sender:Any) -> Void {
        
        self.navigationController?.dismiss(animated: true, completion: {
            
        });
    }
    
    
    @objc public func backGroudViewTap(sender:Any?) {
        
    }
    
    func tap(recognizer: UITapGestureRecognizer) {
        print("Tapping working")
        
        if self.responds(to: #selector(backGroudViewTap(sender:))) == true {
            self.backGroudViewTap(sender: self);
            return;
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}


