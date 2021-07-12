//
//  CommentTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/5.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellKey = "CommentTableViewCell"
    
    private let imageViewSize: CGFloat = 40
    
    // MARK: - IBElements
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "@tom"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let commentContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        
        thumbnailImageView.layer.cornerRadius = imageViewSize/2
        
        thumbnailImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(15)
            make.size.equalTo(imageViewSize)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thumbnailImageView)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(thumbnailImageView.snp.right).offset(10)
            make.width.equalTo(50)
        }
        
        commentContentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thumbnailImageView)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(usernameLabel.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(thumbnailImageView)
        addSubview(usernameLabel)
        addSubview(commentContentLabel)
        
        autoLayout()
        selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: PostComment){
        commentContentLabel.text = model.text
        usernameLabel.text = model.username
        
        let data = try? Data(contentsOf: model.thumbnailImage)
        if let imageData = data {
            let image = UIImage(data: imageData)
            thumbnailImageView.image = image!
        }
    }
}
