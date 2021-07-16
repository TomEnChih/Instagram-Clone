//
//  NotificationFollowEventTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/29.
//

import UIKit

class NotificationFollowEventTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let id = "NotificationFollowEventTableViewCell"
        
    private var model: UserNotification?
    
    private let imageViewSize: CGFloat = 50

    // MARK: - IBOutlets
    
    private let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let lable: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "@tom started following you. "
        return label
    }()
    
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
        
    // MARK: - Autolayout
    
    func autoLayout() {
        
        profileImageView.layer.cornerRadius = imageViewSize/2

        profileImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(5)
            make.size.equalTo(imageViewSize)
        }
        
        lable.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(5)
        }
        
        separateView.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.left.equalTo(lable)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(1)
        }
        
    }
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(lable)
        contentView.addSubview(separateView)
        autoLayout()
        selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: UserNotification ) {
        self.model = model
        switch model.type {
        case .like(_): break
        case .follow:
            profileImageView.loadingImage(url: URL(string: model.user.profileImageURL)!)
            setupAttributedLabel()
        }
        
    }
    
    private func setupAttributedLabel() {
        guard let model = self.model else { return }
        
        let attributedText = NSMutableAttributedString(string: model.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        
        attributedText.append(NSMutableAttributedString(string: " started following you.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        lable.attributedText = attributedText
    }
    
}
