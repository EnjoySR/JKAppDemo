//
//  JKSoftButton.swift
//  JKAppDemo
//
//  Created by EnjoySR on 2016/10/13.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class JKSoftButtonNode: ASButtonNode {
    
    override var isHighlighted: Bool {
        didSet {
            animForImageNode(isZoomOut: isHighlighted)
        }
    }
    
    func animForImageNode(isZoomOut: Bool) {
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.duration = 0.15
        anim.fromValue = NSNumber(value: isZoomOut ? 1 : 0.8)
        anim.toValue = NSNumber(value: isZoomOut ? 0.8 : 1)
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        self.imageNode.layer.add(anim, forKey: "anim")
    }
}
