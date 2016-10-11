//
//  CommonTools.swift
//  JKAppDemo
//
//  Created by EnjoySR on 2016/10/11.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import Foundation


/// 消息盒子数据
func getFeedDatas() -> [JKFeedModel] {
    // 获取数据
    let url = Bundle.main.url(forResource: "list.json", withExtension: nil)!
    let data = try! Data(contentsOf: url)
    let array = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
    
    var result = [JKFeedModel]()
    // 遍历字典转模型
    for value in array {
        let model = JKFeedModel()
        model.setValuesForKeys(value)
        result.append(model)
    }
    return result
}
