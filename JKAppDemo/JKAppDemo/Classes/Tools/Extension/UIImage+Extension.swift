//
//  UIImage+Extension.swift
//  JKAppDemo
//
//  Created by EnjoySR on 2016/10/12.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 圆角图片
    func image(cornerRadius: CGFloat) -> UIImage? {
        let modifiedImage: UIImage?
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.width)
        // 开启上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        // 画个圆
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        // 将图片画到上下文中
        self.draw(in: rect)
        // 获取图片
        modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
        // 结束上下文
        UIGraphicsEndImageContext()
        return modifiedImage
    }
    
}
