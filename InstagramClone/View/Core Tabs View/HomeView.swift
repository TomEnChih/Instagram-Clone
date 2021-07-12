//
//  HomeView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class HomeView: UIView {

    // MARK: - UIElement
    let teamTableView: UITableView = {
        let tv = UITableView()
//        
//        tv.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.cellKey)
//        tv.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.cellKey)
//        tv.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.cellKey)
//        tv.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.cellKey)
//        
        tv.separatorStyle = .none

        return tv
    }()
    // MARK: - Autolayout
    
    func autoLayout() {
        
        teamTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addSubview(teamTableView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
