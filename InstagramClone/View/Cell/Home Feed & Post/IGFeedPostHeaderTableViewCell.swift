//
//  IGFeedPostHeaderTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/28.
//

import UIKit

protocol IGFeedPostHeaderTableViewCellDelegate: AnyObject {
    func didTapMoreButton()
}


class IGFeedPostHeaderTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let cellKey = "IGFeedPostHeaderTableViewCell"
    
    private let imageViewSize: CGFloat = 40
    
    weak var delegate: IGFeedPostHeaderTableViewCellDelegate?
    
    // MARK: - IBOutlets
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "@tom"
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
//        profileImageView.layer.cornerRadius = imageViewSize

        profileImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.size.equalTo(imageViewSize)
            make.left.equalTo(self).offset(10)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(profileImageView.snp.right).offset(10)
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(contentView)
            make.width.equalTo(50)
        }
    }
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemRed
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        
        autoLayout()
        
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: User) {
        // configure the cell
        usernameLabel.text = model.username
        profileImageView.image = UIImage(systemName: "person")
    }
    
    @objc func didTapMoreButton() {
        delegate?.didTapMoreButton()
    }

}
