//
//  NotificationLikeEventTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/29.
//

import UIKit

protocol NotificaionLikeEventTableViewCellDelegate: AnyObject {
    func didTapRelatedPostButton(model: UserNotification)
}


class NotificationLikeEventTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let cellKey = "NotificationLikeEventTableViewCell"
    
    weak var delegate: NotificaionLikeEventTableViewCellDelegate?
    
    private var model: UserNotification?
    
    private let imageViewSize: CGFloat = 50

    // MARK: - IBOutlets
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let lable: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "@tom like your photo. "
        return label
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
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
        
        postButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView)
            make.right.equalTo(contentView).offset(-5)
            make.size.equalTo(imageViewSize)
        }
    }

    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(lable)
        contentView.addSubview(postButton)
        autoLayout()
        
//        selectionStyle = .none
        
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: UserNotification) {
        
        self.model = model
        #warning("還要加東西")
        switch model.type {
        case .like(let post):
//            let thumbnail = post.thumbnailImage
            postButton.setImage(UIImage(systemName: "person"), for: .normal)
        break
        case .follow:
            break
        }
        
        lable.text = model.text
    }
    
    @objc func didTapPostButton() {
        guard let model = model else {
            print("錯誤")
            return
        }
        
        delegate?.didTapRelatedPostButton(model: model )
    }


}
