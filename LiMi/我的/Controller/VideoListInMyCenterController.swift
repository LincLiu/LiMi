//
//  VideoListInMyCenterController.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/6/7.
//  Copyright © 2018年 Chengdu you Hong Science & Technology Co., Ltd. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import DZNEmptyDataSet

enum MyCenterVideoListType {
    case myVideo
    case iLikedVideo
}
class VideoListInMyCenterController: UIViewController {
    var type:MyCenterVideoListType = .myVideo
    var topBackGroundView:UIView!
    var collectionView:UICollectionView!
    var bottomBackGroundView:UIView!
    var dataArray = [VideoTrendModel]()
    var pageIndex:Int = 1
    var time:Int? = Int(Date().timeIntervalSince1970)
    
    init(type:MyCenterVideoListType = .myVideo) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.topBackGroundView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT))
//        self.topBackGroundView.backgroundColor = RGBA(r: 30, g: 30, b: 30, a: 1)
//        self.view.addSubview(self.topBackGroundView)
        
        let collectionFrame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)
        let layOut = UICollectionViewFlowLayout.init()
        layOut.minimumLineSpacing = 1
        layOut.minimumInteritemSpacing = 1
        let width = (SCREEN_WIDTH-2.5)/3
        let height = width/0.75
        layOut.itemSize = CGSize.init(width: width, height: height)
        
        self.collectionView = UICollectionView.init(frame: collectionFrame, collectionViewLayout: layOut)
        self.collectionView.register(UINib.init(nibName: "VideoListInPersonCenterCell", bundle: nil), forCellWithReuseIdentifier: "VideoListInPersonCenterCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.mj_header = mjGifHeaderWith {[unowned self] in
            self.pageIndex = 1
            self.loadData()
        }
        
        self.collectionView.mj_footer = mjGifFooterWith {[unowned self] in
            self.pageIndex += 1
            self.loadData()
        }
        self.collectionView.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        
        self.bottomBackGroundView = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT-TAB_BAR_HEIGHT, width: SCREEN_WIDTH, height: TAB_BAR_HEIGHT))
        self.bottomBackGroundView.backgroundColor = RGBA(r: 30, g: 30, b: 30, a: 1)
        self.view.addSubview(self.bottomBackGroundView)
        self.loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(didVideoTrendMoreOperation(notification:)), name: DID_VIDEO_TREND_MORE_OPERATION, object: nil)
    }
    
    @objc func didVideoTrendMoreOperation(notification:Notification){
        //删除并切换video
        if let moreOprationModel = notification.userInfo![MORE_OPERATION_KEY] as? MoreOperationModel{
            if moreOprationModel.operationType == .delete{
                for i in 0 ..< self.dataArray.count{
                    if self.dataArray[i].id == moreOprationModel.action_id{
                        self.dataArray.remove(at: i)
                        self.collectionView.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData(){
        let moyaProvider = MoyaProvider<LiMiAPI>(manager: DefaultAlamofireManager.sharedManager)
        let videoMyVideoList = VideoMyVideoList.init(time: self.time, page: self.pageIndex, type: self.type.hashValue)
        _ = moyaProvider.rx.request(.targetWith(target: videoMyVideoList)).subscribe(onSuccess: {[unowned self] (response) in
            let videoTrendListModel = Mapper<VideoTrendListModel>().map(jsonData: response.data)
            self.time = videoTrendListModel?.time
            if let trends = videoTrendListModel?.data{
                if self.pageIndex == 1{
                    self.dataArray.removeAll()
                }
                for trend in trends{
                    self.dataArray.append(trend)
                }
                self.collectionView.reloadData()
            }
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.mj_footer.endRefreshing()
            Toast.showErrorWith(model: videoTrendListModel)
            }, onError: { (error) in
                self.collectionView.mj_header.endRefreshing()
                self.collectionView.mj_footer.endRefreshing()
                Toast.showErrorWith(msg: error.localizedDescription)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension VideoListInMyCenterController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let videoListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoListInPersonCenterCell", for: indexPath) as! VideoListInPersonCenterCell
        videoListCollectionViewCell.configWith(model: self.dataArray[indexPath.row])
        return videoListCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoListInMyCenterPlayContainController = VideoListInMyCenterPlayContainController.init(type: self.type, currentVideoTrendIndex: indexPath.row, dataArray: self.dataArray)
        self.navigationController?.pushViewController(videoListInMyCenterPlayContainController, animated: true)
    }
}
