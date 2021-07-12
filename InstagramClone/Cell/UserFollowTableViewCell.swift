//
//  UserFollowTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/29.
//

import UIKit

protocol UserFollowTableViewCellDelegate: AnyObject {
    func didTapFollowUnFollowButton(model: UserRelationship)
}

enum FollowState {
    case following //indicates the current user is following the other user
    case unFollowing //indicates the current user is NOT following the other user
}

struct UserRelationship {
    let username: String
    let name: String
    let type: FollowState
}



class UserFollowTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let cellKey = "UserFollowTableViewCell"
    
    weak var delegate: UserFollowTableViewCellDelegate?
    
    private let imageViewSize: CGFloat = 50
    
    private var model: UserRelationship?
    
    // MARK: - IBOutlets
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "tom"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "@tom"
        return label
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    // MARK: - Autolayout
    
    func autoLayout() {
        
        profileImageView.layer.cornerRadius = imageViewSize/2

        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.left.equalTo(contentView).offset(5)
            make.size.equalTo(imageViewSize)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(5)
            make.left.equalTo(profileImageView.snp.right).offset(5)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(nameLabel).offset(2)
            make.left.equalTo(profileImageView.snp.right).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
        }
        
        followButton.snp.makeConstraints { (make) in
            make.height.equalTo(contentView).multipliedBy(0.5)
            make.width.equalTo(contentView).multipliedBy(0.2)
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-5)
        }
        
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(followButton)
        selectionStyle = .none
        autoLayout()
        
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    
    @objc func didTapFollowButton() {
        delegate?.didTapFollowUnFollowButton(model: model!)
    }
    
    public func configure(with model: UserRelationship) {
        
        self.model = model
        
        nameLabel.text = model.name
        usernameLabel.text = model.username
        
        switch model.type {
        case .unFollowing:
            followButton.setTitle("UnFollow", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
        case .following:
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 0
        }
    }
    
}
