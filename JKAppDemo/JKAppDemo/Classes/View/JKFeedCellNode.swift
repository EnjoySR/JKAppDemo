//
//  JKFeedCellNode.swift
//  JKAppDemo
//
//  Created by EnjoySR on 2016/10/11.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class JKFeedCellNode: ASCellNode {

    var feedModel: JKFeedModel?
    
    /// 配置数据
    func configurModel(feedModel: JKFeedModel) {
        self.selectionStyle = .none
        self.feedModel = feedModel
        let msgItemModel = feedModel.item as? JKFeedMsgItemModel
        // 设置头像
        headImageNode.url = URL(string: (feedModel.item as? JKFeedMsgItemModel)?.topic?.thumbnailUrl ?? "")
        // 设置name
        topicNameNode.attributedText = NSAttributedString(string: msgItemModel?.topic?.content ?? "", attributes: JKTextStyle.feedNameStyle())
        // 设置时间
        topicTimeNode.attributedText = NSAttributedString(string: msgItemModel?.createdAt?.description ?? "", attributes: JKTextStyle.feedTimeStyle())
        // 设置内容
        contentNode.attributedText = NSAttributedString(string: msgItemModel?.content ?? "", attributes: JKTextStyle.feedContentStyle())
        // 添加 node
        self.addSubnode(bgNode)
        self.addSubnode(headImageNode)
        self.addSubnode(topicNameNode)
        self.addSubnode(topicTimeNode)
        self.addSubnode(contentNode)
        self.addSubnode(bottomNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let nameAndTimeSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 7, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topicNameNode, topicTimeNode])
        
        let topicSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.horizontal, spacing: 10.0, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [headImageNode, nameAndTimeSpec])
        
        let contentSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 18.0, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topicSpec, contentNode])
        
        let topSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(20, 20, 10, 20), child: contentSpec)

        let spec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 0, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topSpec, bottomNode]);
        return ASBackgroundLayoutSpec(child: spec, background: bgNode)
    }
    
    // MARK: - 懒加载Node
    
    // 底部分割条
    lazy var bottomNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.preferredFrameSize = CGSize(width: screenW, height: 8)
        node.backgroundColor = RGB(r: 233, g: 237, b: 241)
        return node
    }()
    
    // 内容
    lazy var contentNode: ASTextNode = {
        let textNode = ASTextNode()
        return textNode
    }()
    // 时间
    lazy var topicTimeNode: ASTextNode = {
        let textNode = ASTextNode()
        textNode.maximumNumberOfLines = 1
        return textNode
    }()
    // 话题名字
    lazy var topicNameNode: ASTextNode = {
        let textNode = ASTextNode()
        textNode.maximumNumberOfLines = 1
        return textNode
    }()
    
    // 头像
    lazy var headImageNode: ASNetworkImageNode = {
        let headImageNode = ASNetworkImageNode()
        headImageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        headImageNode.preferredFrameSize = CGSize(width: 33, height: 33)
        headImageNode.cornerRadius = 5;
        headImageNode.imageModificationBlock = { (image) -> UIImage? in
            let modifiedImage: UIImage?
            let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.width)
            // 开启上下文
            UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
            // 画个圆
            UIBezierPath(roundedRect: rect, cornerRadius: 5).addClip()
            // 将图片画到上下文中
            image.draw(in: rect)
            // 获取图片
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
            // 结束上下文
            UIGraphicsEndImageContext()
            return modifiedImage
        }
        return headImageNode
    }()
    
    // 背景 Node
    lazy var bgNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = UIColor.white
        return node
    }()
}





