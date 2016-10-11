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
        let node = self.tableView.nodeForRow(at: indexPath) as! JKFeedCellNode
        node.bgNode.backgroundColor = RGB(r: 221, g: 221, b: 221)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) {
            node.bgNode.backgroundColor = UIColor.white
        }
    }
}

