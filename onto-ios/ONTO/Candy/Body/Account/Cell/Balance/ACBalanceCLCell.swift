//
//  ACBalanceCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/24.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit
//屏幕宽高
private let SYSHeight = UIScreen.main.bounds.size.height
private let SYSWidth = UIScreen.main.bounds.size.width
private let SCALE_W = (SYSWidth/375)
class ACBalanceCLCell: BaseSWCLCell {
    
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var lineImgViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionView:UICollectionView!;
    @IBOutlet weak var _collectionViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionViewLeadingLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionViewTopLayout: NSLayoutConstraint!
    public weak var _delegate:CommonDelegate?;
    var _dict:Any?;
    var _mod:ACBalanceListModel?;
    var originHeight:CGFloat! = 0;
    var rows  = 0; //maybe not work
    let cols = 4;
    var _list = [ACBalanceItemModel]();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
    
        originHeight = _collectionViewHeightLayout.constant;
        setupCollectionView();
    }
    
    //MARK -- common
    public func fillCellWithMod(mod:ACBalanceListModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {
        
        _delegate = delegate;
        _mod = mod;
        
        if let count  = mod.items?.count {
            if _list.count != count {
                let layout = self._collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                self.updateCollectioview(layout,mod.items!);
            }
        }
        _list = mod.items ?? [ACBalanceItemModel]();
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
    
    func updateCollectioview(_ layout:UICollectionViewFlowLayout,_ list:[ACBalanceItemModel]) {
        
        var cnt = list.count/cols;
        if list.count % cols > 0 {
            cnt += 1;
        }
        rows = cnt;
        
        let width = SYSWidth
        layout.itemSize =  CGSize(width:width, height:70*SCALE_W)
        
        let height = layout.itemSize.height * CGFloat(rows) + layout.minimumLineSpacing * CGFloat( rows - 1)  + layout.sectionInset.top + layout.sectionInset.bottom;
        _collectionViewHeightLayout.constant = 70 * CGFloat(list.count) //max(40, height);
//        print("rows:\(layout.itemSize.height * CGFloat(rows)),linespace:\(layout.minimumLineSpacing * CGFloat( rows - 1)),top:\(layout.sectionInset.top),bottom:\(layout.sectionInset.bottom)")
    }
    
    func setupCollectionView() ->Void{
        
        //  设置 layOut
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
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
        ourCollectionView.register(NewBalanceItemCell.self, forCellWithReuseIdentifier: NewBalanceItemCell.cellIdentifier())
    }
    
}

extension ACBalanceCLCell:CommonDelegate {

    
}


extension ACBalanceCLCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return _list.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row;
        
        let cell:NewBalanceItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBalanceItemCell.cellIdentifier(), for: indexPath as IndexPath) as! NewBalanceItemCell;
        
        let mod:ACBalanceItemModel! = _list[row]
        cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        return cell;
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap ==\(indexPath.row)")
        let row = indexPath.row;
        let mod:ACBalanceItemModel! = _list[row];
        _delegate?.itemClicked?(mod);
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
