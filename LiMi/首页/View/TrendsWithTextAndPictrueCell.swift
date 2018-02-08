//
//  TrendsWithTextAndPictrueCell.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/1/18.
//  Copyright © 2018年 dev.liufeng. All rights reserved.
//

import UIKit
import XLPhotoBrowser_CoderXL

class TrendsWithTextAndPictrueCell: TrendsWithTextCell {
    var collectionView:UICollectionView!
    var tapPictureBlock:((Int)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentText.snp.remakeConstraints { (make) in
            make.top.equalTo(self.trendsContentContainView)
            make.left.equalTo(self.trendsContentContainView)
            //make.bottom.equalTo(self.trendsContentContainView)
            make.right.equalTo(self.trendsContentContainView)
        }
        
        let collectionFrame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-24, height: 0)
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (SCREEN_WIDTH-12*2 - 5*2)/3
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 4.9
        layout.minimumLineSpacing = 5
        self.collectionView = UICollectionView.init(frame: collectionFrame, collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TrendsImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TrendsImageCollectionCell")
        self.trendsContentContainView.addSubview(collectionView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    //MARK: - misc
    override func configWith(model: TrendModel?) {
        super.configWith(model: model)
        self.collectionView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.contentText.snp.bottom).offset(5)
            make.left.equalTo(self.trendsContentContainView)
            make.bottom.equalTo(self.trendsContentContainView)
            make.right.equalTo(self.trendsContentContainView)
        }
        self.collectionView.reloadData()
        self.collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        }
    }
}

extension TrendsWithTextAndPictrueCell:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let pics = self.model?.action_pic{
            return pics.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendsImageCollectionCell", for: indexPath) as! TrendsImageCollectionCell
        if let pics = self.model?.action_pic{
            cell.configWith(picUrl: pics[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imgArr = self.model?.action_pic{
            let photoBroswer = XLPhotoBrowser.show(withImages: imgArr, currentImageIndex: indexPath.row)
            photoBroswer?.browserStyle = .indexLabel
            photoBroswer?.setActionSheeWith(self)
        }
        if let _tapPictureBlock = self.tapPictureBlock{
            _tapPictureBlock(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (SCREEN_WIDTH-12*2 - 5*2)/3
        var itemSize = CGSize(width: itemWidth, height: itemWidth)
        if let pics = self.model?.action_pic{
            if pics.count == 1{
                itemSize.width = SCREEN_WIDTH-12*2
                itemSize.height = itemSize.width*(262/349.0)
            }
            if pics.count == 2 || pics.count == 4{
                itemSize.width = (SCREEN_WIDTH-12*2 - 5)/2
                itemSize.height = itemSize.width
            }
        }
        return itemSize
    }
}

extension TrendsWithTextAndPictrueCell:XLPhotoBrowserDelegate{
    func photoBrowser(_ browser: XLPhotoBrowser!, clickActionSheetIndex actionSheetindex: Int, currentImageIndex: Int) {
        browser.saveCurrentShowImage()
    }
}

