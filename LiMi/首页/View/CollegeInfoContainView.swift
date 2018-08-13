//
//  CollegeInfoContainView.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/8/9.
//  Copyright © 2018年 Chengdu you Hong Science & Technology Co., Ltd. All rights reserved.
//

import UIKit

protocol CollegeInfoContainViewDelegate : class {
    func collegeInfoContainView(view:CollegeInfoContainView,clickCollegeWith model:CollegeVideoInfoModel?)
    func collegeInfoContainView(view:CollegeInfoContainView,clickThumbUpWith model:CollegeVideoInfoModel?)
}

class CollegeInfoContainView: UIView {
    var college_id:Int?
    @IBOutlet weak var carousel: iCarousel!
    
    @IBOutlet weak var thumbUpLabel: UILabel!
    @IBOutlet weak var thumbUpButton: UIButton!
    @IBOutlet weak var carouselContainView: UIView!
    weak var delegate:CollegeInfoContainViewDelegate?
    var dataArray = [CollegeVideoInfoModel]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        carousel.isPagingEnabled = true
        carousel.type = .cylinder
        carousel.delegate = self
        carousel.dataSource = self
//        carousel.autoscroll = 10
        carousel.scrollOffset = 20
//        carousel.decelerationRate = 40
//        carousel.scrollSpeed = 50
        carousel.bounceDistance = 60

//        nonatomic, assign) CGFloat perspective;
//        @property (nonatomic, assign) CGFloat decelerationRate;
//        @property (nonatomic, assign) CGFloat scrollSpeed;
//        @property (nonatomic, assign) CGFloat bounceDistance;
        
        NotificationCenter.default.addObserver(self, selector: #selector(clickCollegeNotification(notification:)), name: NSNotification.Name.init(rawValue: "CLICK_COLLEGE_NOTIFICATION"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func clickCollegeNotification(notification:Notification){
        let info = notification.userInfo
        let model = self.dataArray[self.carousel.currentItemIndex]
        if model.college?.id == info!["collegeId"] as? Int{
            if model.college?.is_click == true{
                self.thumbUpLabel.alpha = 1
                self.thumbUpButton.isSelected = true
                UIView.animate(withDuration: 0.5) {[unowned self] in
                    self.thumbUpLabel.alpha = 0
                }
            }else{
                self.thumbUpLabel.alpha = 0
                self.thumbUpButton.isSelected = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func clickThumbUpButton(_ sender: Any) {
        let index = self.carousel.currentItemIndex
        let model = self.dataArray[index]
        self.delegate?.collegeInfoContainView(view: self, clickThumbUpWith: model)
    }
    
    
    func configWith(datas:[CollegeVideoInfoModel]){
        self.dataArray = datas
        self.carousel.reloadData()
    }
}

extension CollegeInfoContainView : iCarouselDelegate,iCarouselDataSource{
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.dataArray.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let collegeInfoView = GET_XIB_VIEW(nibName: "CollegeInfoView") as! CollegeInfoView
        let width = carousel.bounds.size.height * (305.0/425.0)
        collegeInfoView.frame = CGRect.init(x: 0, y: 0, width: width, height: carousel.bounds.size.height)
        let model = self.dataArray[index]
        collegeInfoView.configWith(model: model)
        collegeInfoView.delegate = self
        return collegeInfoView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if carousel.currentItemIndex >= self.dataArray.count || self.dataArray.count == 0{return}
        let model = self.dataArray[carousel.currentItemIndex]
        if let isClick = model.college?.is_click{
            self.thumbUpButton.isSelected = isClick
        }
    }
}

extension CollegeInfoContainView : CollegeInfoViewDelegate{
    func collegeInfoView(view: CollegeInfoView, clickStackViewWith model: CollegeVideoInfoModel?) {
        self.delegate?.collegeInfoContainView(view: self, clickCollegeWith: model)
    }
}
