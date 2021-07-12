//
//  NotificationFollowEventTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/29.
//

import UIKit

protocol NotificaionFollowEventTableViewCellDelegate: AnyObject {
    func didTapFollowButton(model: UserNotification)
}



class NotificationFollowEventTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let cellKey = "NotificationFollowEventTableViewCell"
    
    weak var delegate: NotificaionFollowEventTableViewCellDelegate?
    
    private var model: UserNotification?
    
    private let imageViewSize: CGFloat = 50

    // MARK: - IBOutlets
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBlue

        return imageView
    }()
    
    private let lable: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "@tom started following you. "
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
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
        
        lable.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(5)
        }
        
        followButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView)
            make.right.equalTo(contentView).offset(-5)
            make.height.equalTo(contentView).multipliedBy(0.7)
            make.width.equalTo(contentView).multipliedBy(0.2)
        }
    }
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(lable)
        contentView.addSubview(followButton)
        
        autoLayout()
        
        selectionStyle = .none
        
        followButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: UserNotification ) {
        self.model = model
        #warning("還要加東西")
        switch model.type {
        case .like(let post):
            let thumbnail = post.owner.profilePhoto
//            followButton.
        case .follow(let state):
            switch state {
            case .following:
                followButton.setTitle("Follow", for: .normal)
                followButton.setTitleColor(.white, for: .normal)
            case .unFollowing:
                followButton.setTitle("UnFollow", for: .normal)
                followButton.setTitleColor(.label, for: .normal)
                followButton.layer.borderWidth = 1
                followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
            }
            
        }
        
        lable.text = model.text
        
        
    }
    
    @objc func didTapPostButton() {
        guard let model = model else {
            return
        }
        
        delegate?.didTapFollowButton(model: model )
    }
    
    
}
