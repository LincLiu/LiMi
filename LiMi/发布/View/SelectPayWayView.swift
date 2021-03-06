//
//  SelectPayWayView.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/1/22.
//  Copyright © 2018年 dev.liufeng. All rights reserved.
//

import UIKit

enum PayWay {
    case accountBalance
    case alipay
    case wechatPay
}

class SelectPayWayView: UIView {
    @IBOutlet weak var containView: UIView!
    var selectPayWayBlock:((PayWay)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        containView.layer.cornerRadius = 20
        containView.clipsToBounds = true
    }

@IBAction func dealChoseWeChatPay(_ sender: Any) {
        if let _selectPayWayBlock = self.selectPayWayBlock{
            if !isInstalled(app: .wechat){
                Toast.showErrorWith(msg: "请先安装微信")
                return
            }
            _selectPayWayBlock(.wechatPay)
        }
        self.removeFromSuperview()
    }
    
    @IBAction func dealChoseAlipay(_ sender: Any) {
        if let _selectPayWayBlock = self.selectPayWayBlock{
            if !isInstalled(app: .alipay){
                Toast.showErrorWith(msg: "请先安装支付宝")
                return
            }
            _selectPayWayBlock(.alipay)
        }
        self.removeFromSuperview()
    }
    
    @IBAction func dealClose(_ sender: Any) {
        self.removeFromSuperview()
    }
}
