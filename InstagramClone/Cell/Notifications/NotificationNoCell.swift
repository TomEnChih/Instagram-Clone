//
//  NotificationNoCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/16.
//

import UIKit

class NotificationNoCell: UITableViewCell {

    // MARK: - Properties
    
    static let id = "NotificationNoCell"
    
    // MARK: - IBElement
    
    private let bellLabel: UILabel = {
        let label = UILabel()
        label.text = "No Notifications Yet"
        label.textColor = .secondaryLabel
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    private let bellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "bell")
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        
        bellImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(200)
        }
        
        bellLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(bellImageView.snp.bottom).offset(20)
        }
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubview(bellLabel)
        addSubview(bellImageView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

}
