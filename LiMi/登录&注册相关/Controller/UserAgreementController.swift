//
//  UserAgreementController.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/3/6.
//  Copyright © 2018年 dev.liufeng. All rights reserved.
//

import UIKit

class UserAgreementController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle{return .default}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户协议"
    }

    deinit {
        print("用户协议销毁")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
