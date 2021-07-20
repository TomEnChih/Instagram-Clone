//
//  ListView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/29.
//

import UIKit

class ListView: UIView {
    
    // MARK: - Properties
    
    // MARK: - IBElements
        
    let listTableView: UITableView = {
        let tv = UITableView()
        tv.register(UserFollowTableViewCell.self, forCellReuseIdentifier: UserFollowTableViewCell.cellKey)
        return tv
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        listTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(listTableView)
        autoLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    
}
