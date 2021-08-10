//
//  BoxListDetailMissionCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/24.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit

class BoxListDetailMissionCLCell: BaseSWCLCell {
    
    @IBOutlet weak var titleLabel:UILabel!;
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var lineImgViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionView:UICollectionView!;
    @IBOutlet weak var _collectionViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionViewLeadingLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionViewTopLayout: NSLayoutConstraint!
    public weak var _delegate:CommonDelegate?;
    var _dict:Any?;
    var _mod:BoxListDetailMissionModel?;
    var originHeight:CGFloat! = 0;
    var rows  = 2; //maybe not work
    let cols = 2;
    var _list = [BoxListDetailMissionItemModel]();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
    
        titleLabel.font = Const.font.DINProFontType(.bold, 18);
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        titleLabel.text = LocalizeEx("missions")
        
        originHeight = _collectionViewHeightLayout.constant;
        setupCollectionView();
    }
    
    //MARK -- common
    public func fillCellWithMod(mod:BoxListDetailMissionModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {
        
        _delegate = delegate;
        _mod = mod;
        
        
        if let count  = mod.items?.count {
            if _list.count != count {
                let layout = self._collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                self.updateCollectioview(layout,mod.items!);
            }
        }
        _list = mod.items ?? [BoxListDetailMissionItemModel]();
        self.reloadData();
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
    
    // MARK: - collection
    func reloadData() ->Void{
        _collectionView.reloadData();
    }
    
    
    @objc func getIconWidth(layout:UICollectionViewFlowLayout) -> CGFloat {
        
        let space = CGFloat(cols - 1) * (layout.minimumInteritemSpacing) + layout.sectionInset.left + layout.sectionInset.right + _collectionViewLeadingLayout.constant*2;
        let screenWidth = Const.ScreenSize.SCREEN_WIDTH - space;
        let width = CGFloat(screenWidth)/CGFloat(cols);
        return width;
    }
    
//    func setupCollectionView() ->Void{
//        
//        //  设置 layOut
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
//        layout.minimumLineSpacing = 20;
//        layout.minimumInteritemSpacing = 20;
//        //        layout.headerReferenceSize = CGSize(width:0,height:  0)   //头部间隔
//        //        layout.footerReferenceSize = CGSize(width:0,height:  0)   //底部间隔
//        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0)            //section四周的缩进
//        
//        let width = self.getIconWidth(layout: layout)
//        layout.itemSize =  CGSize(width:width, height:width*240/160)
//        
//        let height = layout.itemSize.height * CGFloat(rows) + layout.minimumLineSpacing * CGFloat( rows - 1)  + layout.sectionInset.top + layout.sectionInset.bottom;
//        _collectionViewHeightLayout.constant = height;
//        
//        // 设置CollectionView
//        let ourCollectionView:UICollectionView!  = _collectionView;
//        ourCollectionView.collectionViewLayout = layout;
//        ourCollectionView.delegate = self
//        ourCollectionView.dataSource = self
//        ourCollectionView.delaysContentTouches = false
//        ourCollectionView.backgroundColor = UIColor.clear;
//        ourCollectionView.isScrollEnabled = false;
//        ourCollectionView.register(BoxListDetailMissionItemCLCell.nib(), forCellWithReuseIdentifier: BoxListDetailMissionItemCLCell.cellIdentifier())
//    }
    
    func updateCollectioview(_ layout:UICollectionViewFlowLayout,_ list:[BoxListDetailMissionItemModel]) {
        
        var cnt = list.count/cols;
        if list.count % cols > 0 {
            cnt += 1;
        }
        rows = cnt;
        
        let width = self.getIconWidth(layout: layout)
        layout.itemSize =  CGSize(width:width, height:width + 50)
        
        let height = layout.itemSize.height * CGFloat(rows) + layout.minimumLineSpacing * CGFloat( rows - 1)  + layout.sectionInset.top + layout.sectionInset.bottom;
        _collectionViewHeightLayout.constant = max(40, height);
        //        print("rows:\(layout.itemSize.height * CGFloat(rows)),linespace:\(layout.minimumLineSpacing * CGFloat( rows - 1)),top:\(layout.sectionInset.top),bottom:\(layout.sectionInset.bottom)")
    }
    
    func setupCollectionView() ->Void{
        
        //  设置 layOut
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        layout.minimumLineSpacing = 35;
        layout.minimumInteritemSpacing = 35;
        //        layout.headerReferenceSize = CGSize(width:0,height:  0)   //头部间隔
        //        layout.footerReferenceSize = CGSize(width:0,height:  0)   //底部间隔
        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0)            //section四周的缩进
        
        self.updateCollectioview(layout,_list);
        
        // 设置CollectionView
        let ourCollectionView:UICollectionView!  = _collectionView;
        ourCollectionView.collectionViewLayout = layout;
        ourCollectionView.delegate = self
        ourCollectionView.dataSource = self
        ourCollectionView.delaysContentTouches = false
        ourCollectionView.backgroundColor = UIColor.clear;
        ourCollectionView.isScrollEnabled = false;
        ourCollectionView.register(BoxListDetailMissionItemCLCell.nib(), forCellWithReuseIdentifier: BoxListDetailMissionItemCLCell.cellIdentifier())
    }
    
}

extension BoxListDetailMissionCLCell:CommonDelegate {

    
}


extension BoxListDetailMissionCLCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return _list.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row;
        
        let cell:BoxListDetailMissionItemCLCell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxListDetailMissionItemCLCell.cellIdentifier(), for: indexPath as IndexPath) as! BoxListDetailMissionItemCLCell;
        
        let mod:BoxListDetailMissionItemModel! = _list[row]
        cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        return cell;
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap ==\(indexPath.row)")
        let row = indexPath.row;
        let mod:BoxListDetailMissionItemModel! = _list[row];
//        if mod.bOk == "1" {
//            mod.bOk = "0";
//        } else {
//            mod.bOk = "1";
//        }
        _delegate?.itemExClicked!(mod)
//        collectionView.reloadItems(at: [indexPath]);
    }
    
    //MARK:UICollectionViewDelegate - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero;
    }
    
    //MARK: CollectionView Cell highlighted
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        let cell:BaseSWCLCell! = collectionView.cellForItem(at: indexPath) as! BaseSWCLCell;
        cell.highlightView?.isHidden = false;
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        let cell:BaseSWCLCell! = collectionView.cellForItem(at: indexPath) as! BaseSWCLCell;
        cell.highlightView?.isHidden = true;
    }
}
