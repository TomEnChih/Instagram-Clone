//
//  NoNotificationsView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/29.
//

import UIKit

class NoNotificationsView: UIView {

    // MARK: - Properties
    // MARK: - IBOutlets
    
    private let lablel: UILabel = {
        let label = UILabel()
        label.text = "No Notifications Yet"
        label.textColor = .secondaryLabel
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "bell")
        return imageView
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(imageView).offset(30)
        }
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(lablel)
        addSubview(imageView)
        
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

}
