//
//  ThumbUpAndCommentMessageContainModel.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/3/9.
//  Copyright © 2018年 dev.liufeng. All rights reserved.
//

import Foundation
import ObjectMapper

class ThumbUpAndCommentMessageContainModel: BaseModel {
    var datas:[ThumbUpAndCommentMessageModel]?

    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        datas<-map["data"]
    }
}

class ThumbUpAndCommentMessageModel:BaseModel{
    var type:Int?
    var type_id:Int?
    var user_id:Int?
    var sex:String?
    var nickname:String?
    var head_pic:String?
    var msg:String?
    var text:String?
    var img:String?
    var video:String?
    var time:String?
    
    ///评论id
    var discuss_id:Int?
    ///所属评论组id
    var group_id:Int?
    ///父评论的 评论人 昵称
    var parent_nickname:String?
    ///父评论的评论人id
    var parent_uid:Int?
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        type <- map["type"]
        type_id <- map["type_id"]
        user_id <- map["user_id"]
        sex <- map["sex"]
        nickname <- map["nickname"]
        head_pic <- map["head_pic"]
        msg <- map["msg"]
        text <- map["text"]
        img <- map["img"]
        video <- map["video"]
        time <- map["time"]
        
        discuss_id <- map["discuss_id"]
        group_id <- map["group_id"]
        parent_nickname <- map["parent_nickname"]
        parent_uid <- map["parent_uid"]

    }
}
