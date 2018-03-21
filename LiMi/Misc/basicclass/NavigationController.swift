//
//  NavigationController.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/1/9.
//  Copyright © 2018年 dev.liufeng. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            //push时隐藏TabBar
            viewController.hidesBottomBarWhenPushed = true
            //替换ViewController的导航栏返回按钮
            let backBtn = SuitableHotSpaceButton.init(type: .custom)
            backBtn.setImage(UIImage.init(named: "btn_back_hei"), for: .normal)
            backBtn.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
            backBtn.contentHorizontalAlignment = .left
//            backBtn.backgroundColor = UIColor.red
            backBtn.addTarget(self, action: #selector(dealTapBack), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        }
        super.pushViewController(viewController, animated: animated)
    }
    //导航栏返回按钮执行pop事件
    @objc func dealTapBack(){
        self.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension NavigationController:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count <= 1{return false}
        return true
    }
}
