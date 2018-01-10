//
//  AppDelegate.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/1/8.
//  Copyright © 2018年 dev.liufeng. All rights reserved.
//

import UIKit
import  IQKeyboardManagerSwift
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        SVProgressHUD.setMaximumDismissTimeInterval(1)
        
        let keyboardShareManager = IQKeyboardManager.sharedManager()
        keyboardShareManager.shouldResignOnTouchOutside = true  //控制点击背景是否收起键盘
        keyboardShareManager.toolbarManageBehaviour = IQAutoToolbarManageBehaviour.bySubviews
        keyboardShareManager.keyboardDistanceFromTextField = 10 //输入框距离键盘的距离
        
//        let logVC = Helper.getViewControllerFrom(sbName: "LoginRegister", sbID: "LoginController")
//        let logNav = NavigationController(rootViewController: logVC)
//        self.window?.rootViewController = logNav
        self.window?.rootViewController = TabBarController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}
