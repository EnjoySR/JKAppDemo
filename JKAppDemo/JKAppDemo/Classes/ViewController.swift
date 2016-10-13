//
//  ViewController.swift
//  JKAppDemo
//
//  Created by EnjoySR on 2016/10/11.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SnapKit
import CRToast


class ViewController: UIViewController {
    
    // 数据
    lazy var feedDatas: [JKFeedModel] = getFeedDatas()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    lazy var tableView: ASTableView = {
        let tableView = ASTableView()
        tableView.asyncDelegate = self
        tableView.asyncDataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
}

extension ViewController: ASTableViewDataSource, ASTableViewDelegate {
    
    func tableView(_ tableView: ASTableView, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cellNode = JKFeedCellNode()
        let model = feedDatas[indexPath.row]
        cellNode.configurModel(feedModel: model)
        return cellNode
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedDatas.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        CRToastManager.showNotification(withMessage: "消息抖动是因为没有附带的外链", completionBlock: nil)
        let anim = CAKeyframeAnimation(keyPath: "transform.translation.x")
        anim.values = [0, -3, 0, 3, 0]
        anim.repeatCount = 2
        anim.duration = 0.15
        let node = self.tableView.nodeForRow(at: indexPath)
        node.layer.add(anim, forKey: nil)
    }
}

