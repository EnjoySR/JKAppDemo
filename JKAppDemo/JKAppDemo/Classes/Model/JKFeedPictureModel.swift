//
//  JKFeedPictureModel.swift
//  JKAppDemo
//
//  Created by EnjoySR on 2016/10/11.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit

class JKFeedPictureModel: NSObject {
    var thumbnailUrl: String?
    var middlePicUrl: String?
    var picUrl: String?
    var format: String?
    var cropperPosX: CGFloat = 0.0
    var cropperPosY: CGFloat = 0.0
    var width: Int = 0
    var height: Int = 0
}
