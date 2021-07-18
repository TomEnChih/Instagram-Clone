//
//  HomePostCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/11.
//

import UIKit

protocol HomePostButtonDelegate: AnyObject {
    func didTapLike(for cell: HomePostCell)
    func didTapComment(post: PostTest)
    func didTapSave(for cell: HomePostCell)
}


class HomePostCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let id = "HomePostCell"
    
    private let imageViewSize: CGFloat = 40
    
    var post: PostTest?
    
    weak var delegate: HomePostButtonDelegate?
    
    // MARK: - IBElements
    
    private let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "username"
        return label
    }()
    
    private let optionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    private let postImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let btn = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        
        return btn
    }()
    
    private let commentButton: UIButton = {
        let btn = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
        let image = UIImage(systemName: "message", withConfiguration: config)
        
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private let sendButton: UIButton = {
        let btn = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
        let image = UIImage(systemName: "paperplane", withConfiguration: config)
        
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let bookmarkButton: UIButton = {
        let btn = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
        let image = UIImage(systemName: "bookmark", withConfiguration: config)
        
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        
        userProfileImageView.layer.cornerRadius = imageViewSize/2

        userProfileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.size.equalTo(imageViewSize)
            make.left.equalTo(self).offset(10)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(userProfileImageView)
            make.centerY.equalTo(userProfileImageView)
            make.left.equalTo(userProfileImageView.snp.right).offset(15)
        }
        
        optionButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(userProfileImageView)
            make.height.equalTo(userProfileImageView)
            make.width.equalTo(50)
        }
        
        postImageView.snp.makeConstraints { (make) in
            make.top.equalTo(userProfileImageView.snp.bottom).offset(10)
            make.left.right.equalTo(self)
            make.height.equalTo(postImageView.snp.width)
        }
        
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(postImageView.snp.bottom)
            make.left.equalTo(self).offset(10)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        
        bookmarkButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(buttonStackView)
            make.right.equalTo(-10)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        captionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(self)
            make.bottom.equalTo(self)
        }
        
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionButton)
        addSubview(postImageView)
        addSubview(buttonStackView)
        addSubview(bookmarkButton)
        addSubview(captionLabel)
        autoLayout()
        commentButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with post: PostTest) {
        self.post = post
        
        likeButton.setImage(post.hasLiked == true ? setLikeButtonImage(btn: likeButton, select: .Like):setLikeButtonImage(btn: likeButton, select: .Unlike), for: .normal)
        bookmarkButton.setImage(post.hasSaved == true ? setBookMarkButtonImage(btn: bookmarkButton, select: .Save):setBookMarkButtonImage(btn: bookmarkButton, select: .UnSave), for: .normal)
        
        postImageView.image = nil
        postImageView.loadingImage(url: URL(string: post.imageURL)!)

        usernameLabel.text = post.user.username

        userProfileImageView.image = nil
        userProfileImageView.loadingImage(url: URL(string: post.user.profileImageURL)!)

        setupAttributedCaption()
        
        
        
    }
    
    private func setupAttributedCaption() {
        
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        
        attributedText.append(NSMutableAttributedString(string: " ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSMutableAttributedString(string: post.caption, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        
        let timeAgoDisplay = post.creationDate.compareCurrentTime()
        attributedText.append(NSMutableAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
        
        captionLabel.attributedText = attributedText
    }
    
    
    @objc func handleLike() {
        delegate?.didTapLike(for: self)
    }
    
    @objc func handleComment() {
        guard let post = post else { return }
        delegate?.didTapComment(post: post)
    }
    
    @objc func handleSave() {
        delegate?.didTapSave(for: self)
    }
    
    private func setLikeButtonImage(btn: UIButton,select:LikeSelect) -> UIImage{
        switch select {
        case .Like:
            let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
            let image = UIImage(systemName: select.rawValue, withConfiguration: config)
            btn.tintColor = .systemPink
            return image!
        case .Unlike:
            let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
            let image = UIImage(systemName: select.rawValue, withConfiguration: config)
            btn.tintColor = .black
            return image!
        }
    }
    
    enum LikeSelect: String {
        case Like = "heart.fill"
        case Unlike = "heart"
    }
    
    private func setBookMarkButtonImage(btn: UIButton,select:SaveSelect) -> UIImage{
        switch select {
        case .Save:
            let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
            let image = UIImage(systemName: select.rawValue, withConfiguration: config)
            btn.tintColor = .systemBlue
            return image!
        case .UnSave:
            let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .thin)
            let image = UIImage(systemName: select.rawValue, withConfiguration: config)
            btn.tintColor = .black
            return image!
        }
    }
    
    enum SaveSelect: String {
        case Save = "bookmark.fill"
        case UnSave = "bookmark"
    }
    
    
}
