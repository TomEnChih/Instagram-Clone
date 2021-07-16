//
//  CommentCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/5.
//

import UIKit

class CommentCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let id = "CommentCell"
    
    private let imageViewSize: CGFloat = 40
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            profileImageView.loadingImage(url: URL(string: comment.user.profileImageURL)!)
            setupAttributedCaption()
        }
    }
    
    // MARK: - IBElements
    
    private let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let  contentLabel: UITextView = {
        let label = UITextView()
        label.textColor = .black
        label.backgroundColor = .secondarySystemBackground
        label.isScrollEnabled = false
        label.textContainer.lineFragmentPadding = 0
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
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(15)
            make.size.equalTo(imageViewSize)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(profileImageView.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
            make.height.greaterThanOrEqualTo(imageViewSize)
        }
        
        separateView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(contentLabel)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(1)
        }
        
        
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        addSubview(profileImageView)
        addSubview(contentLabel)
        addSubview(separateView)
        
        autoLayout()
        selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: Comment){
        
        
    }
    
    private func setupAttributedCaption() {
        
        guard let comment = self.comment else { return }
        
        let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        
        attributedText.append(NSMutableAttributedString(string: " ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSMutableAttributedString(string: comment.text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        contentLabel.attributedText = attributedText
    }
    
}
