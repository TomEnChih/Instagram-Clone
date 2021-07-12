//
//  IGFeedPostActionsTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/28.
//

import UIKit

protocol IGFeedPostActionsTableViewCellDelegate: AnyObject {
    func didTapLikeButton()
    func didTapCommentButton()
    func didTapSendButton()
}


class IGFeedPostActionsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellKey = "IGFeedPostActionsTableViewCell"
    
    weak var delegate: IGFeedPostActionsTableViewCellDelegate?
    
    // MARK: - IBOutlets
    
    private let likeButton: UIButton = {
        let btn = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        
        return btn
    }()
    
    private let commentButton: UIButton = {
        let btn = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin)
        let image = UIImage(systemName: "message", withConfiguration: config)
        
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private let sendButton: UIButton = {
        let btn = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin)
        let image = UIImage(systemName: "paperplane", withConfiguration: config)
        
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    // MARK: - Autolayout
    
    func autoLayout() {
        buttonStackView.snp.makeConstraints { (make) in
            make.height.equalTo(contentView)
            make.centerY.equalTo(self)
            make.width.equalTo(150)
            make.left.equalTo(10)
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemGray
        selectionStyle = .none
        contentView.addSubview(buttonStackView)
        
        autoLayout()
        selectionStyle = .none
        
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with post: UserPost) {
        // configure the cell
        
    }
    
    @objc func didTapLikeButton() {
        
        if !likeButton.isSelected {
            likeButton.isSelected = true
            likeButton.likeImage()
        } else {
            likeButton.isSelected = false
            likeButton.dislikeImage()
        }
        delegate?.didTapLikeButton()
    }
    
    @objc func didTapCommentButton() {
        delegate?.didTapCommentButton()
    }
    
    @objc func didTapSendButton() {
        delegate?.didTapSendButton()
    }
    
}


//MARK: - button
extension UIButton {
    func dislikeImage() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        self.setImage(image, for: .normal)
        self.tintColor = UIColor.black
    }
    
    func likeImage() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin)
        let image = UIImage(systemName: "heart.fill", withConfiguration: config)
        self.setImage(image, for: .normal)
        self.tintColor = UIColor.systemPink
    }
}
