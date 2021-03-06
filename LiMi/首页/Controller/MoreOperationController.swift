//
//  MoreOperationController.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/6/6.
//  Copyright © 2018年 Chengdu you Hong Science & Technology Co., Ltd. All rights reserved.
//

import UIKit
protocol MoreOperationControllerDelegate: class {
    func moreOperationReportClicked(model:VideoTrendModel?)
    func moreOperationBlackClicked(model:VideoTrendModel?)
    func moreOperationDeleteClicked(model:VideoTrendModel?)
}
class MoreOperationController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var deleteContainVIew: UIView!
    
    @IBOutlet weak var bottomTopView: UIView!
    @IBOutlet weak var topView: UIView!
    var statusBarHidden:Bool = false
    override var prefersStatusBarHidden: Bool{
        return self.statusBarHidden
    }
    var videoTrendModel:VideoTrendModel?
    
   weak var delegate:MoreOperationControllerDelegate?
    
//    var reportButton:UIButton!
//    var blackButton:UIButton!
//    var deleteButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        let tapTopView = UITapGestureRecognizer.init(target: self, action: #selector(clickedCancelButton(_:)))
        self.topView.addGestureRecognizer(tapTopView)
        if self.videoTrendModel?.user?.user_id != Defaults[.userId] || Defaults[.userId] == nil{
            self.deleteContainVIew.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction @objc func clickedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func reportButtonClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.moreOperationReportClicked(model: self.videoTrendModel)
        }
    }
    @IBAction func blackButtonClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.moreOperationBlackClicked(model: self.videoTrendModel)
        }

    }
    @IBAction func deleteButtonClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.moreOperationDeleteClicked(model: self.videoTrendModel)
        }
    }
}
