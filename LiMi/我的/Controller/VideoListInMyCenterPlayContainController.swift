//
//  VideoListInMyCenterPlayContainController.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/6/7.
//  Copyright © 2018年 Chengdu you Hong Science & Technology Co., Ltd. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import DZNEmptyDataSet

class VideoListInMyCenterPlayContainController: ScanVideosContainController {

    var type:MyCenterVideoListType?
    var collegeId:Int?

    
    init(type:MyCenterVideoListType?,currentVideoTrendIndex:Int,dataArray:[VideoTrendModel]) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
        self.currentVideoTrendIndex = currentVideoTrendIndex
        for videoTrendModel in dataArray{
            self.dataArray.append(videoTrendModel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*函数*/
    override func scanVideosControllerRequestDataWith(scanVideosController: ScanVideosController) {
        let _time = self.time ?? Int(Date().timeIntervalSince1970)
        let videoMyVideoList = VideoMyVideoList.init(time: _time, page: self.pageIndex, type: self.type?.hashValue)
        let moyaProvider = MoyaProvider<LiMiAPI>(manager: DefaultAlamofireManager.sharedManager)
        _ = moyaProvider.rx.request(.targetWith(target: videoMyVideoList)).subscribe(onSuccess: {[unowned self] (response) in
            let videoTrendListModel = Mapper<VideoTrendListModel>().map(jsonData: response.data)
            if let _time = videoTrendListModel?.time{
                self.time = _time
            }
            if let trends = videoTrendListModel?.data{
                if self.pageIndex == 1{
                    self._dataArray.removeAll()
                }
                var isAdd = true
                let firstTrend = trends.first
                for trend in self.dataArray{
                    if trend.id == firstTrend?.id{
                        isAdd = false
                        break
                    }
                }
                if isAdd{
                    for trend in trends{
                        self.dataArray.append(trend)
                    }
                }
                scanVideosController.reloadTableViewData()
            }
            scanVideosController.tableView.mj_header.endRefreshing()
            Toast.showErrorWith(model: videoTrendListModel)
            }, onError: { (error) in
                scanVideosController.tableView.mj_header.endRefreshing()
                Toast.showErrorWith(msg: error.localizedDescription)
        })
    }
}
