//
//  TabBarController.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/1/9.
//  Copyright © 2018年 dev.liufeng. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homePageController = HomePageController()
        self.addControllerWith(controller: homePageController, title: "首页", tbImg: "icon_shouye", tbSelectedImg: "icon_shouye_highlight")
        let circleController = CircleController()
         self.addControllerWith(controller: circleController, title: "圈子", tbImg: "icon_quanzi", tbSelectedImg: "icon_quanzi_highlight")
        
        let blankController = ViewController()
        self.addControllerWith(controller: blankController, title: "", tbImg: "icon_fabu", tbSelectedImg: "icon_fabu")
        
        let msgController = MsgController()
         self.addControllerWith(controller: msgController, title: "消息", tbImg: "icon_xiaoxi", tbSelectedImg: "icon_xiaoxi_highlight")
        let personCenterController = GetViewControllerFrom(sbName: .personalCenter, sbID: "PersonCenterController")
        self.addControllerWith(controller: personCenterController, title: "我的", tbImg: "icon_wode", tbSelectedImg: "icon_wode_highlight")
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addControllerWith(controller:UIViewController!,title:String!,tbImg:String!,tbSelectedImg:String!){
        controller.title = title
        let navController = NavigationController(rootViewController: controller)
        navController.tabBarItem.image = UIImage.init(named: tbImg)?.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = UIImage.init(named: tbSelectedImg)?.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.title = nil
        navController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        self.addChildViewController(navController)
    }
    
}

extension TabBarController:UITabBarControllerDelegate{
    //控制是否跳转
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == self.viewControllers![2]{
            return false
        }
        if viewController == self.viewControllers![4]{
            if let _ = Defaults[.userId],let _ = Defaults[.userToken]{
                return true
            }else{
                let logVC = GetViewControllerFrom(sbName: .loginRegister, sbID: "LoginController")
                let logNav = NavigationController(rootViewController: logVC)
                self.present(logNav, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}







