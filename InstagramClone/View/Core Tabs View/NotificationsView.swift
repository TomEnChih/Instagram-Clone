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
        tv.register(NotificationFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationFollowEventTableViewCell.id)
        tv.register(NotificationLikeEventTableViewCell.self, forCellReuseIdentifier: NotificationLikeEventTableViewCell.id)
        tv.register(NotificationNoCell.self, forCellReuseIdentifier: NotificationNoCell.id)
        tv.separatorStyle = .none
        return tv
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        notificationsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp_topMargin)
            make.bottom.equalTo(self.snp_bottomMargin)
            make.left.right.equalTo(self)
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
