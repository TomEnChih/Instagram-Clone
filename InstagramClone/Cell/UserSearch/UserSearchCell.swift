//
//  UserSearchCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/12.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let id = "UserSearchCell"
    
    private let imageViewSize: CGFloat = 40
    
    // MARK: - IBElements
    
    private let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private let separaorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    // MARK: - Autolayout

    private func autoLayout() {
        
        profileImageView.layer.cornerRadius = imageViewSize/2
        
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(10)
            make.size.equalTo(imageViewSize)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(10)
            make.height.equalTo(30)
        }
        
        separaorView.snp.makeConstraints { (make) in
            make.left.equalTo(usernameLabel)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(separaorView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with model: UserTest) {
        
        usernameLabel.text = model.username
        profileImageView.loadingImage(url: URL(string: model.profileImageURL)!)
        
    }
}
