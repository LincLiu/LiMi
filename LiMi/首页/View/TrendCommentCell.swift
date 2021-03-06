//
//  TrendCommentCell.swift
//  LiMi
//
//  Created by dev.liufeng on 2018/1/22.
//  Copyright © 2018年 dev.liufeng. All rights reserved.
//

import UIKit
import YYText

class TrendCommentCell: UITableViewCell {
    ///最底层容器
    var commentContainView:UIView!
    
    /******************顶部工具栏******************/
    var commentTopToolsContainView:CommentTopToolsContainView!    //顶部工具栏容器
    
    /******************发布内容区域******************/
    var commentContentContainView:UIView!
    
    var comment:YYLabel!    //内容
    var blankView:UIView!
    var commentModel:CommentModel?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.commentContainView = UIView()
        //self.commentContainView.backgroundColor = UIColor.red
        self.contentView.addSubview(commentContainView)
        self.commentContainView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
        }
        
        self.commentTopToolsContainView = CommentTopToolsContainView()
        self.commentTopToolsContainView.moreOperationBtn.isHidden = true
        //self.commentTopToolsContainView.backgroundColor = UIColor.orange
        self.commentContainView.addSubview(self.commentTopToolsContainView)
        self.commentTopToolsContainView.tapHeadBtnBlock = {
            print("点击了头像")
        }
        self.commentTopToolsContainView.snp.makeConstraints { (make) in
            make.top.equalTo(self.commentContainView)
            make.left.equalTo(self.commentContainView)
            make.right.equalTo(self.commentContainView)
        }
        
        self.commentContentContainView = UIView()
        //self.commentContentContainView.backgroundColor = UIColor.green
        self.commentContainView.addSubview(self.commentContentContainView)
        self.commentContentContainView.snp.makeConstraints { (make) in
            make.top.equalTo(self.commentTopToolsContainView.snp.bottom)
            make.left.equalTo(self.commentContainView).offset(62)
            make.bottom.equalTo(self.commentContainView).offset(-15)
            make.right.equalTo(self.commentContainView).offset(-12)
        }
        
        self.comment = YYLabel()
        self.comment.text = nil
        //self.comment.backgroundColor = UIColor.orange
        self.comment.font = UIFont.systemFont(ofSize: 14)
        self.comment.textColor = RGBA(r: 51, g: 51, b: 51, a: 1)
        self.comment.numberOfLines = 0
        self.comment.lineBreakMode = .byWordWrapping
        self.comment.preferredMaxLayoutWidth = SCREEN_WIDTH-62-12
        self.commentContentContainView.addSubview(self.comment)
        self.comment.snp.makeConstraints { (make) in
            make.top.equalTo(self.commentContentContainView)
            make.left.equalTo(self.commentContentContainView)
            make.bottom.equalTo(self.commentContentContainView)
            make.right.lessThanOrEqualTo(self.commentContainView)
            //make.right.equalTo(self.commentContentContainView)
        }
        
        self.blankView = UIView()
        //self.blankView.backgroundColor = UIColor.purple
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dealTapLabel))
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(dealLongPresslabel))
        self.blankView.addGestureRecognizer(tap)
        self.blankView.addGestureRecognizer(longPress)
        self.commentContainView.addSubview(blankView)
        self.blankView.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(self.comment)
            make.bottom.equalTo(self.comment)
            make.left.equalTo(self.comment.snp.right)
            make.right.equalTo(self.commentContentContainView)
        }
        
        let separateLine = UIView()
        separateLine.backgroundColor = RGBA(r: 228, g: 228, b: 228, a: 1)
        self.commentContainView.addSubview(separateLine)
        separateLine.snp.makeConstraints { (make) in
            make.left.equalTo(self.commentContainView)
            make.bottom.equalTo(self.commentContainView)
            make.right.equalTo(self.commentContainView)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - misc
    @objc func dealLongPresslabel(){
        NotificationCenter.default.post(name: LONGPRESS_COMMENT_NOTIFICATION, object: nil, userInfo: [COMMENT_MODEL_KEY:self.commentModel])
    }
    
    @objc func dealTapLabel(){
        NotificationCenter.default.post(name: TAPED_COMMENT_NOTIFICATION, object: nil, userInfo: [COMMENT_MODEL_KEY:self.commentModel])
    }
    
    func configWith(model:CommentModel?,isForSubComment:Bool = false){
        self.commentModel = model
        self.commentTopToolsContainView.configWith(commentModel: model)
        
        var attContent = NSMutableAttributedString.init(string: "")
        if isForSubComment{
            if let beCommentedPersonName = model?.parent_name{
                let attReply = NSMutableAttributedString.init(string: "回复  @ ")
                attReply.yy_setAttributes([NSAttributedStringKey.font.rawValue:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor.rawValue:RGBA(r: 51, g: 51, b: 51, a: 51)])
                
                let attBecommentPersonName = NSMutableAttributedString.init(string: beCommentedPersonName)
                attBecommentPersonName.yy_setAttributes([NSAttributedStringKey.font.rawValue:UIFont.systemFont(ofSize: 15)])
                
                let nsBecommentPersonName = NSString.init(string: beCommentedPersonName)
                let attBecommentPersonNameRange = nsBecommentPersonName.range(of: beCommentedPersonName)
                attBecommentPersonName.yy_setTextHighlight(attBecommentPersonNameRange, color: APP_THEME_COLOR, backgroundColor: nil, userInfo: nil, tapAction: { (view, nsAttStr, range, rect) in
                    NotificationCenter.default.post(name: TAPED_COMMENT_PERSON_NAME_NOTIFICATION, object: nil, userInfo: [COMMENT_MODEL_KEY:self.commentModel])
                    print("短点击：\(nsAttStr)")
                }, longPressAction: { (view, nsAttStr, range, rect) in
                    print("长按：\(nsAttStr)")
                })
                let attColon = NSMutableAttributedString.init(string: ":")
                attColon.yy_setAttributes([NSAttributedStringKey.font.rawValue:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor.rawValue:RGBA(r: 51, g: 51, b: 51, a: 51)])
                
                attContent.append(attReply)
                attContent.append(attBecommentPersonName)
                attContent.append(attColon)
            }
        }
        if let commentContent = model?.content{
            let attCommentContent = NSMutableAttributedString.init(string: commentContent)
            attCommentContent.yy_setAttributes([NSAttributedStringKey.font.rawValue:UIFont.systemFont(ofSize: 15)])
            let nsCommentContent = NSString.init(string: commentContent)
            let attCommentContentRange = nsCommentContent.range(of: commentContent)
            attCommentContent.yy_setTextHighlight(attCommentContentRange, color: RGBA(r: 51, g: 51, b: 51, a: 1), backgroundColor: nil, userInfo: nil, tapAction: { (view, nsAttStr, range, rect) in
                NotificationCenter.default.post(name: TAPED_COMMENT_NOTIFICATION, object: nil, userInfo: [COMMENT_MODEL_KEY:self.commentModel])
                print("短点击：\(nsAttStr)")
            }, longPressAction: { (view, nsAttStr, range, rect) in
                NotificationCenter.default.post(name: LONGPRESS_COMMENT_NOTIFICATION, object: nil, userInfo: [COMMENT_MODEL_KEY:self.commentModel])
                print("长按：\(nsAttStr)")
            })
            
            attContent.append(attCommentContent)
        }
        self.comment.attributedText = attContent
    }

}
