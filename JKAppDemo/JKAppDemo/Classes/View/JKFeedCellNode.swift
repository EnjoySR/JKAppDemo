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
    
    lazy var pictureImageNodes: [ASNetworkImageNode] = [ASNetworkImageNode]()
    
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
        // 收藏评论
        favoriteNode.setAttributedTitle(NSAttributedString(string: "\(msgItemModel?.collectCount ?? 0)", attributes: JKTextStyle.feedCollectCountStyle()), for: [])
        commentNode.setAttributedTitle(NSAttributedString(string: "\(msgItemModel?.commentCount ?? 0)", attributes: JKTextStyle.feedCollectCountStyle()), for: [])
        
        // 添加 node
        self.addSubnode(bgNode)
        self.addSubnode(headImageNode)
        self.addSubnode(topicNameNode)
        self.addSubnode(topicTimeNode)
        self.addSubnode(contentNode)
        self.addSubnode(bottomNode)
        // 根据图片张数添加 imageNode
        if let imageUrls = msgItemModel?.pictureUrls {
            for pictureModel in imageUrls {
                let node = ASNetworkImageNode()
                node.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
                node.url = URL(string: pictureModel.middlePicUrl ?? "")
                self.addSubnode(node)
                self.pictureImageNodes.append(node)
            }
        }
        // 添加底部分割线
        self.addSubnode(spliteNode)
        // 添加底部工具条内部的Node
        self.addSubnode(favoriteNode)
        self.addSubnode(commentNode)
        self.addSubnode(shareNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        // 顶部内容
        let nameAndTimeSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 7, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topicNameNode, topicTimeNode])
        
        let topicSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.horizontal, spacing: 10.0, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [headImageNode, nameAndTimeSpec])
        
        var contentSpecChildren: [ASLayoutable] = [topicSpec, contentLayoutSpec()]
        if let pictureSpec = JKFeedCellLayout.pictureLayoutSpec(pictureImageNodes: self.pictureImageNodes) {
            contentSpecChildren.append(pictureSpec)
        }
        
        // 添加底部分割线
        let spliteSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(20, 0, 0, 0), child: spliteNode)
        contentSpecChildren.append(spliteSpec)
        // 添加底部工具条
        contentSpecChildren.append(bottomBarLayoutSpec())
        
        let contentSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 0, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: contentSpecChildren)
        let topSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(20, 20, 13, 20), child: contentSpec)

        // 添加底部灰色条
        let spec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 0, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topSpec, bottomNode]);
        
        return ASBackgroundLayoutSpec(child: spec, background: bgNode)
    }
    
    func contentLayoutSpec() -> ASLayoutSpec {
        let spec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(18, 0, 0, 0), child: contentNode);
        return spec
    }
    
    /// 底部收藏评论工具条的布局
    func bottomBarLayoutSpec() -> ASLayoutSpec {
        let spec = ASStackLayoutSpec(direction: ASStackLayoutDirection.horizontal, spacing: 25, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [favoriteNode, commentNode, shareNode])
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(13, 0, 0, 0), child: spec)
        return insetSpec
    }
    
    // MARK: - 懒加载Node
    //
    lazy var shareNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(UIImage(named: "message_share_20x20_"), for: [])
        return node
    }()
    
    
    // 评论
    lazy var commentNode: ASButtonNode = {
        let node = ASButtonNode()
        node.contentHorizontalAlignment = ASHorizontalAlignment.alignmentLeft
        node.preferredFrameSize = CGSize(width: 52, height: 20)
        node.setImage(UIImage(named: "comment_button_20x20_"), for: [])
        return node
    }()
    
    // 是否收藏
    lazy var favoriteNode: ASButtonNode = {
        let node = ASButtonNode()
        node.contentHorizontalAlignment = ASHorizontalAlignment.alignmentLeft
        node.preferredFrameSize = CGSize(width: 52, height: 20)
        node.setImage(UIImage(named: "like_star_border_20x20_"), for: [])
        node.setImage(UIImage(named: "like_star_20x20_"), for: ASControlState.selected)
        return node
    }()
    
    // 分割线
    lazy var spliteNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.preferredFrameSize = CGSize(width: screenW, height: 0.5)
        node.backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.85, alpha: 1)
        return node
    }()
    
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
            return image.image(cornerRadius: 5)
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





