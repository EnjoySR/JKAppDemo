//
//  JKTextStyle.swift
//  JKAppDemo
//
//  Created by EnjoySR on 2016/10/12.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit

class JKTextStyle: NSObject {
    
    class func feedNameStyle() -> [String: Any] {
        return [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: RGB(r: 58, g: 143, b: 183)
        ];
    }
    
    class func feedTimeStyle() -> [String: Any] {
        return [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12),
            NSForegroundColorAttributeName: RGB(r: 153, g: 160, b: 167)
        ];
    }
    
    class func feedContentStyle() -> [String: Any] {
        // 设置行间距
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        return [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16),
            NSForegroundColorAttributeName: RGB(r: 118, g: 120, b: 124),
            NSParagraphStyleAttributeName: style
        ];
    }
    
    class func feedCollectCountStyle() -> [String: Any] {
        return [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12),
            NSForegroundColorAttributeName: RGB(r: 153, g: 160, b: 167)
        ];
    }
}
