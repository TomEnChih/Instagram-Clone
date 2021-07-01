//
//  PostView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/30.
//

import UIKit

class PostView: UIView {

    // MARK: - Properties
    // MARK: - IBElement
    
    let tableView: UITableView = {
        let tv = UITableView()
        
        tv.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.cellKey)
        tv.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.cellKey)
        tv.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.cellKey)
        tv.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.cellKey)

        return tv
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(tableView)
        
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods

}
