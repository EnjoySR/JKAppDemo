//
//  JKFeedCellLayout.swift
//  JKAppDemo
//
//  Created by EnjoySR on 2016/10/12.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit
import AsyncDisplayKit

private let JKFeedCellPictureMargin: CGFloat = 5

class JKFeedCellLayout: NSObject {
    
    class func pictureLayoutSpec(pictureImageNodes: [ASNetworkImageNode]) -> ASLayoutSpec? {
        
        if pictureImageNodes.count == 0 {
            return nil
        }
        let count = pictureImageNodes.count
        var contentSpec: ASLayoutSpec
        switch count {
        case 1, 2, 3:
            contentSpec = self.pictureLayoutSpec123(pictureImageNodes: pictureImageNodes)
        case 4, 5, 6:
            let topSpec = pictureLayoutSpec123(pictureImageNodes: Array(pictureImageNodes.dropLast(3)))
            let bottomSpec = pictureLayoutSpec123(pictureImageNodes: Array(pictureImageNodes.dropFirst(count - 3)))
            contentSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 5, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topSpec, bottomSpec])
        case 7, 8, 9:
            let topSpec = pictureLayoutSpec123(pictureImageNodes: Array(pictureImageNodes.dropLast(6)))
            let middleSpec = pictureLayoutSpec123(pictureImageNodes: Array(pictureImageNodes.dropLast(3).dropFirst(count - 6)))
            let bottomSpec = pictureLayoutSpec123(pictureImageNodes: Array(pictureImageNodes.suffix(3)))
            contentSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 5, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [topSpec, middleSpec, bottomSpec])
        default:
            contentSpec = ASLayoutSpec()
            break
        }
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(15, 0, 0, 0), child: contentSpec)
        return insetSpec
    }
    
    class func pictureLayoutSpec123(pictureImageNodes: [ASNetworkImageNode]) -> ASLayoutSpec {
        let count = pictureImageNodes.count
        let width = (screenW - 20 * 2 - 5 * CGFloat(count - 1)) / CGFloat(count)
        let height = count == 1 ? 188 : width
        pictureImageNodes.forEach({ (node) in
            node.preferredFrameSize = CGSize(width: width, height: height)
        })
        let contentSpec = ASStackLayoutSpec(direction: ASStackLayoutDirection.horizontal, spacing: 5, justifyContent: ASStackLayoutJustifyContent.spaceBetween, alignItems: ASStackLayoutAlignItems.stretch, children: pictureImageNodes)
        return contentSpec
    }
    
    /// 底部收藏评论工具条的布局
    class func bottomBarLayoutSpec(chidren: [ASLayoutable]) -> ASLayoutSpec {
        let spec = ASStackLayoutSpec(direction: ASStackLayoutDirection.horizontal, spacing: 25, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: chidren)
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(13, 0, 0, 0), child: spec)
        return insetSpec
    }
    
    class func videoLayoutSpec(videoNode: ASDisplayNode, videoShadowNode: ASDisplayNode, videoPlayButtonNode: ASDisplayNode) -> ASLayoutSpec {
        let shadowSpec = ASOverlayLayoutSpec(child: videoShadowNode, overlay: videoPlayButtonNode)
        let layoutSpec = ASOverlayLayoutSpec(child: videoNode, overlay: shadowSpec)
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(13, 0, 0, 0), child: layoutSpec)
        return insetSpec
    }
}
