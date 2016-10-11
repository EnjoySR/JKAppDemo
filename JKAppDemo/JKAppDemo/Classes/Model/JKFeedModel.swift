//
//  JKFeedModel.swift
//  JKAppDemo
//
//  Created by EnjoySR on 2016/10/11.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit
import YYModel

enum JKFeedItemType: String {
    case popular_message = "POPULAR_MESSAGE"
    case weather_forecast = "WEATHER_FORECAST"
    case message = "MESSAGE"
}

class JKFeedModel: NSObject {

    var type: String?
    
    var item: AnyObject?
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "item" {
            let type = (value as! [String: Any])["type"] as! String
            
            switch type {
            case JKFeedItemType.message.rawValue:
                item = JKFeedMsgItemModel.yy_model(withJSON: value)
            default:
                break
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}

class JKFeedMsgItemModel: NSObject {
    // 内容
    var content: String?
    // 标题
    var title: String?
    // 链接地址
    var linkUrl: String?
    // 资源的原始值： "link", "video", ""
    var sourceRawValue: String?
    // 收藏数量
    var collectCount: Int = 0
    // 评论数量
    var commentCount: Int = 5
    // 创建时间
    var createdAt: Date?
    // 更新时间
    var updateAt: Date?
    
    var pictureUrls: [JKFeedPictureModel]?
    
    class func modelContainerPropertyGenericClass() -> [String: Any] {
        return ["pictureUrls": JKFeedPictureModel.self]
    }
    
}
