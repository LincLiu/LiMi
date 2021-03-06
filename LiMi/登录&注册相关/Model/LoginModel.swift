//
//  LoginModel.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/1/11.
//  Copyright © 2018年 dev.liufeng. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginModel: BaseModel {
    var id:Int?
    var token:String?
//    identity_status        0 ：未认证   1：认证中  2：认证完成  3：认证失败
//    "user_info_status": 0,只发送了验证码   1：点击了登录按钮   2：点击了登录按钮，并且填写了学校信息【即登录成功】证
    var user_info_status:Int?
    var identity_status:Int?
    var is_login:Bool?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        is_login<-map["data.is_login"]
        id<-map["data.id"]
        token<-map["data.token"]
        user_info_status<-map["data.user_info_status"]
        identity_status<-map["data.identity_status"]
        
    }
}

