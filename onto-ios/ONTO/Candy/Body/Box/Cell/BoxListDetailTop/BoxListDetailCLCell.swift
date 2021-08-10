//
//  BoxListCLCell.swift
//  ONTO
//
//  Created by PC-269 on 2018/8/23.
//  Copyright © 2018年 Zeus. All rights reserved.
//

import UIKit


class BoxListDetailCLCell: BaseSWCLCell {
    
    @IBOutlet weak var headImgView:UIImageView!;
    @IBOutlet weak var backImgView:UIImageView!
    @IBOutlet weak var hotLabel:UILabel!;
    @IBOutlet weak var titleLabel:UILabel!;
    @IBOutlet weak var contentLabel:UILabel!;
    @IBOutlet weak var firtLineImgView:UIImageView!;
    @IBOutlet weak var lineImgView:UIImageView!
    @IBOutlet weak var lineImgViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var websiteLabel:UILabel!;
    @IBOutlet weak var urlBtn:UIButton!;
    @IBOutlet weak var webContentLabel:UILabel!;
    @IBOutlet weak var _collectionView:UICollectionView!;
    @IBOutlet weak var _collectionViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionViewLeadingLayout: NSLayoutConstraint!
    @IBOutlet weak var _collectionViewTopLayout: NSLayoutConstraint!
    @IBOutlet weak var arrowBtn:UIButton!
    public weak var _delegate:CommonDelegate?;
    var _dict:Any?;
    var _mod:BoxDetailModel?;
    var originHeight:CGFloat! = 0;
    let rows  = 1; //maybe not work
    let cols = 3;
    var _list = [BoxListDetailItemModel]();

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white

        backImgView.backgroundColor = ZYUtilsSW.getColor(hexColor: "FAFAFC")
        hotLabel.font = Const.font.kAPPFont30;
        hotLabel.textColor = Const.color.kAPPDefaultBlackColor;
        
        titleLabel.font = Const.font.DINProFontType(.bold, 18);
        titleLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        contentLabel.font = Const.font.DINProFontType(.medium, 12)
        contentLabel.textColor = Const.color.kAPPDefaultGrayColor;
        
        firtLineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
        lineImgView.backgroundColor = Const.color.kAPPDefaultLineColor;
        
        originHeight = _collectionViewHeightLayout.constant;
        setupCollectionView();
        
        websiteLabel.font = Const.font.DINProFontType(.medium, 14);
        websiteLabel.textColor = Const.color.kAPPDefaultBlackColor
        
        urlBtn.titleLabel!.font = Const.font.DINProFontType(.medium, 14);
        urlBtn.titleLabel!.textColor = Const.color.kAPPDefaultBlueLBColor;
        urlBtn.setNeedsDisplay();
        webContentLabel.font = Const.font.DINProFontType(.medium, 14);
        webContentLabel.textColor = Const.color.kAPPDefaultBlackColor;
        
    }
    
    //MARK: - common
    func webContentLimitText(_ mod:BoxDetailModel) -> String {
        
        guard let text = mod.webContent else {
            return "";
        }
        
//        let last = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        if last.count > Content_Limit_Count {
//            let str = last.prefix(Int(Content_Limit_Count))
//            return str + "...";
//        }
//
//        return last;
        
        if text.count > Content_Limit_Count*2 {
            let str = text.trimToGBKLength(Int(Content_Limit_Count*2))
            return str + "...";
        }
        
        return text;
    }
    
    func bWebContentHasMore(_ mod:BoxDetailModel) -> Bool {
        
        guard let text = mod.webContent else {
            return false;
        }
        
        if text.count > Content_Limit_Count {
            return true;
        }
        
        return false;
    }
    
    //MARK: - clicked
    @IBAction func rightArrowClicked(_ sender:UIButton) {
        _delegate?.cdRightArrowClicked?(_mod!);
    }
    
    @IBAction func urlBtnClicked(_ sender: Any) {
        _delegate?.cdUrlClicked!(_mod!)
    }

    //MARK -- common
    public func fillCellWithMod(mod:BoxDetailModel!,row:NSInteger,delegate:CommonDelegate?) -> Void {

        _delegate = delegate;
        _mod = mod;
        
        _list = mod.itemSocials ?? [BoxListDetailItemModel]();
        self.reloadData();

        let holder = #imageLiteral(resourceName: "ongblue");
        let url = mod.headImg ?? ""
        headImgView.sd_setImage(with: URL.init(string: url), placeholderImage:holder , options: SDWebImageOptions.retryFailed) { (image, error,  SDImageCacheTypeNone, url) in
            
        }
        
        titleLabel.text = mod.title;
        contentLabel.text = mod.content;
        websiteLabel.text = LocalizeEx("website");
        urlBtn.setTitle(mod.url, for: UIControlState.normal)
        webContentLabel.text = webContentLimitText(mod)
//        if bWebContentHasMore(mod) == true {
//            arrowBtn.isHidden =  false;
//        }else {
//            arrowBtn.isHidden = true;
//        }
        arrowBtn.isHidden = false;
        
        self.updateConstraints();
        self.setNeedsUpdateConstraints();
        self.layoutIfNeeded();
    }
    
    // MARK: - collection
    func reloadData() ->Void{
        _collectionView.reloadData();
    }
    
    
    func getItemSpace(_ layout:UICollectionViewFlowLayout) -> CGFloat {
        
        var space:CGFloat = 0;
        let width = self.getIconWidth(layout: layout);
        if layout.scrollDirection == UICollectionViewScrollDirection.vertical {
            space = CGFloat(cols) * (width) + layout.sectionInset.left + layout.sectionInset.right + _collectionViewLeadingLayout.constant*2;
        }else {
            space = CGFloat(cols) * (width) + layout.sectionInset.top + layout.sectionInset.bottom + _collectionViewLeadingLayout.constant*2;
        }

        if cols <= 1 {
            debugPrint("error! cols must > 1");
            return 0;
        }
        
        space = (Const.ScreenSize.SCREEN_WIDTH - space)/CGFloat(cols - 1)
        return space;
        
//        var itemSpace:CGFloat = 0.0;
//        if layout.scrollDirection == UICollectionViewScrollDirection.vertical {
//            itemSpace = layout.minimumInteritemSpacing;
//        }else {
//            itemSpace = layout.minimumLineSpacing;
//        }
//        return itemSpace;
    }
    
     func getIconWidth(layout:UICollectionViewFlowLayout) -> CGFloat {
        
        return 84;
//        let itemSpace = getItemSpace(layout)
//        debugPrint("edges:\(layout.sectionInset)")
//        var space:CGFloat = 0;
//        if layout.scrollDirection == UICollectionViewScrollDirection.vertical {
//            space = CGFloat(cols - 1) * (itemSpace) + layout.sectionInset.left + layout.sectionInset.right + _collectionViewLeadingLayout.constant*2;
//        }else {
//            space = CGFloat(cols - 1) * (itemSpace) + layout.sectionInset.top + layout.sectionInset.bottom + _collectionViewLeadingLayout.constant*2;
//        }
//        let screenWidth = Const.ScreenSize.SCREEN_WIDTH - space;
//        let width = CGFloat(screenWidth)/CGFloat(cols); //65
//        return width;
    }
    
    func setupCollectionView() ->Void{

        
        //  设置 layOut
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal  //滚动方向
        if(layout.scrollDirection == UICollectionViewScrollDirection.vertical){
            layout.minimumLineSpacing = 0;
            layout.minimumInteritemSpacing = self.getItemSpace(layout);
            layout.sectionInset = UIEdgeInsetsMake(0,20,0,20)            //section四周的缩进
        }else {
            layout.minimumLineSpacing = self.getItemSpace(layout);
            layout.minimumInteritemSpacing = 0;
            layout.sectionInset = UIEdgeInsetsMake(20,0,20,0)            //section四周的缩进
        }
        
        let width = self.getIconWidth(layout: layout)
        layout.itemSize =  CGSize(width:width, height:width + 21 + 6)
       
        let itemSpace = getItemSpace(layout)
        
        var height:CGFloat = 0
         height = layout.itemSize.height * CGFloat(rows) + itemSpace * CGFloat( rows - 1)  + layout.sectionInset.top + layout.sectionInset.bottom;
        _collectionViewHeightLayout.constant = height;
        
        // 设置CollectionView
        let ourCollectionView:UICollectionView!  = _collectionView;
        ourCollectionView.collectionViewLayout = layout;
        ourCollectionView.delegate = self
        ourCollectionView.dataSource = self
        ourCollectionView.delaysContentTouches = false
        ourCollectionView.backgroundColor = UIColor.clear;
        ourCollectionView.isScrollEnabled = true;
        ourCollectionView.register(BoxListDetailItemCLCell.nib(), forCellWithReuseIdentifier: BoxListDetailItemCLCell.cellIdentifier())
    }
    
}

extension BoxListDetailCLCell:CommonDelegate {
    
    
    
}


extension BoxListDetailCLCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return _list.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row;
        
        let cell:BoxListDetailItemCLCell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxListDetailItemCLCell.cellIdentifier(), for: indexPath as IndexPath) as! BoxListDetailItemCLCell;
        
        let mod:BoxListDetailItemModel! = _list[row]
        cell.fillCellWithMod(mod: mod, row: row, delegate: self)
        return cell;
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        let width = Const.SCREEN_WIDTH;
    //
    //        let row = indexPath.row;
    //        let section = indexPath.section;
    //
    //        return collectionView.ar_sizeForCell(withIdentifier: BoxListDetailItemCLCell.cellIdentifier(), indexPath: indexPath, fixedWidth: width, configuration: { (cell) in
    //
    //            let d = _list[row];
    //
    //            let c:BoxListDetailItemCLCell = cell as! BoxListDetailItemCLCell;
    //            c.fillCellWithDict(dict: d, row: row, delegate: self)
    //        });
    //    }
    
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap ==\(indexPath.row)")
        
        let row = indexPath.row;
        let mod:BoxListDetailItemModel! = _list[row];
        _delegate?.headTap?(mod);
    }
    
    //MARK:UICollectionViewDelegate - Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero;
    }
    
    //MARK:UICollectionViewHeader-Footer
    //设置HeadView的宽高
    //注册header
    //    collectionView!.registerClass(SHomeHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
    //        return CGSize(width: Const.SCREEN_WIDTH, height: headerHeight)
    //    }
    //
    //    //返回自定义HeadView
    //    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
    //
    //        var v = SHomeHeader()
    //        if kind == UICollectionElementKindSectionHeader{
    //
    //            if indexPath.section == 0{
    //                return v;
    //            }
    //
    //            v = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! SHomeHeader
    //            let title:String = headerArr[indexPath.section] as! String
    //            v.titleLabel?.text = title
    //        }
    //
    //        return v
    //    }
    
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

