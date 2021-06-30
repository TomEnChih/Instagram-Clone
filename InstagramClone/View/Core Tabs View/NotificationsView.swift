//
//  NotificationsView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/29.
//

import UIKit

class NotificationsView: UIView {

    // MARK: - Properties
    
    // MARK: - IBOutlets
        
    let notificationsTableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "notificationsTableView")
        return tv
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        notificationsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(notificationsTableView)
        autoLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

}
