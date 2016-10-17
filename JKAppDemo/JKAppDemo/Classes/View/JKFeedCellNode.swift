//
//  JKFeedCellNode.swift
//  JKAppDemo
//
//  Created by EnjoySR on 2016/10/11.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import CRToast
import ESPictureBrowser

class JKFeedCellNode: ASCellNode {

    var feedModel: JKFeedModel?
    
    lazy var pictureImageNodes: [ASNetworkImageNode] = [ASNetworkImageNode]()
    
    /// 配置数据
    func configurModel(feedModel: JKFeedModel) {
        self.selectionStyle = .none
        self.feedModel = feedModel
        self.addSubnode(bgNode)
        let msgItemModel = feedModel.item as? JKFeedMsgItemModel
        // 设置头像
        headImageNode.url = URL(string: (feedModel.item as? JKFeedMsgItemModel)?.topic?.thumbnailUrl ?? "")
        self.addSubnode(headImageNode)
        // 设置name
        topicNameNode.attributedText = NSAttributedString(string: msgItemModel?.topic?.content ?? "", attributes: JKTextStyle.feedNameStyle())
        self.addSubnode(topicNameNode)
        // 设置时间
        topicTimeNode.attributedText = NSAttributedString(string: msgItemModel?.createdAt?.description ?? "", attributes: JKTextStyle.feedTimeStyle())
        self.addSubnode(topicTimeNode)
        // 设置内容
        contentNode.attributedText = NSAttributedString(string: msgItemModel?.content ?? "", attributes: JKTextStyle.feedContentStyle())
        self.addSubnode(contentNode)
        // 收藏
        favoriteNode.setAttributedTitle(NSAttributedString(string: "\(msgItemModel?.collectCount ?? 0)", attributes: JKTextStyle.feedCollectCountStyle()), for: [])
        self.addSubnode(favoriteNode)
        // 评论
        commentNode.setAttributedTitle(NSAttributedString(string: "\(msgItemModel?.commentCount ?? 0)", attributes: JKTextStyle.feedCollectCountStyle()), for: [])
        self.addSubnode(commentNode)
        self.addSubnode(shareNode)
        // 根据图片张数添加 imageNode
        if let imageUrls = msgItemModel?.pictureUrls {
            for pictureModel in imageUrls {
                let node = ASNetworkImageNode()
                node.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
                node.url = URL(string: pictureModel.middlePicUrl ?? "")
                node.addTarget(self, action: #selector(showPhotoBrowser(imageNode:)), forControlEvents: ASControlNodeEvent.touchUpInside)
                self.addSubnode(node)
                self.pictureImageNodes.append(node)
            }
        }
        
        // 判断视频
        if let video = msgItemModel?.video {
            // 添加视频 node
            videoNode.url = URL(string: video.thumbnailUrl ?? "")
            self.addSubnode(videoNode)
            self.addSubnode(videoShadowNode)
            self.addSubnode(videoPlayButtonNode)
        }
        
        self.addSubnode(spliteNode)
        self.addSubnode(bottomNode)
    }
    // MARK: - 监听方法
    @objc private func showPhotoBrowser(imageNode: ASNetworkImageNode) {
        let photoBrowser = ESPictureBrowser()
        photoBrowser.delegate = self
        photoBrowser.showForm(imageNode.view, picturesCount: UInt(self.pictureImageNodes.count), currentPictureIndex: UInt(pictureImageNodes.index(of: imageNode) ?? 0))
    }
    
    // MARK: - 布局
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        // 顶部内容
        let nameAndTimeSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 7, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topicNameNode, topicTimeNode])
        
        let topicSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.horizontal, spacing: 10.0, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [headImageNode, nameAndTimeSpec])
        
        var contentSpecChildren: [ASLayoutable] = [topicSpec, contentLayoutSpec()]
        if let pictureSpec = JKFeedCellLayout.pictureLayoutSpec(pictureImageNodes: self.pictureImageNodes) {
            contentSpecChildren.append(pictureSpec)
        }
        // 判断是否有视频
        if (feedModel?.item as? JKFeedMsgItemModel)?.video != nil {
            contentSpecChildren.append(JKFeedCellLayout.videoLayoutSpec(videoNode: videoNode, videoShadowNode: videoShadowNode, videoPlayButtonNode: videoPlayButtonNode))
        }
        
        // 添加底部分割线
        let spliteSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(20, 0, 0, 0), child: spliteNode)
        contentSpecChildren.append(spliteSpec)
        // 添加底部工具条
        contentSpecChildren.append(bottomBarLayoutSpec(chidren: [favoriteNode, commentNode, shareNode]))
        
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
    
    func bottomBarLayoutSpec(chidren: [ASLayoutable]) -> ASLayoutSpec {
        let spec = ASStackLayoutSpec(direction: ASStackLayoutDirection.horizontal, spacing: 25, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [favoriteNode, commentNode, shareNode])
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(13, 0, 0, 0), child: spec)
        return insetSpec
    }
    
    // MARK: - 监听方法
    
    @objc private func playVideo() {
        CRToastManager.showNotification(withMessage: "没有做~", completionBlock: nil)
    }
    
    // MARK: - 高亮效果
    
    override func __setHighlighted(fromUIKit highlighted: Bool) {
        bgNode.backgroundColor = highlighted ? RGB(r: 221, g: 221, b: 221) : UIColor.white
    }
    
    override func __setSelected(fromUIKit selected: Bool) {
        bgNode.backgroundColor = selected ? RGB(r: 221, g: 221, b: 221) : UIColor.white
    }
    
    // MARK: - 懒加载Node
    
    lazy var videoPlayButtonNode: JKSoftButtonNode = {
        let node = JKSoftButtonNode()
        node.addTarget(self, action: #selector(playVideo), forControlEvents: ASControlNodeEvent.touchUpInside)
        node.setImage(UIImage(named: "video_play_50x50_"), for: [])
        return node
    }()
    
    lazy var videoShadowNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return node
    }()
    
    lazy var videoNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.preferredFrameSize = CGSize(width: screenW - 20 * 2, height: 188)
        node.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        return node
    }()
    // 分享
    lazy var shareNode: ASButtonNode = {
        let node = ASButtonNode()
        node.isUserInteractionEnabled = true
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

extension JKFeedCellNode: ESPictureBrowserDelegate {
    
    func pictureView(_ pictureBrowser: ESPictureBrowser!, imageSizeFor index: Int) -> CGSize {
        if let msgItemModel = feedModel?.item as? JKFeedMsgItemModel,
            let pictureModel = msgItemModel.pictureUrls?[index]
        {
            return CGSize(width: pictureModel.width, height: pictureModel.height)
        }
        return CGSize.zero
    }
    
    func pictureView(_ pictureBrowser: ESPictureBrowser!, viewFor index: Int) -> UIView! {
        return self.pictureImageNodes[index].view
    }
    
    func pictureView(_ pictureBrowser: ESPictureBrowser!, defaultImageFor index: Int) -> UIImage! {
        return self.pictureImageNodes[index].image
    }

    func pictureView(_ pictureBrowser: ESPictureBrowser!, highQualityUrlStringFor index: Int) -> String! {
        let pictureModel = (feedModel?.item as? JKFeedMsgItemModel)?.pictureUrls?[index]
        return pictureModel?.picUrl
    }
}





