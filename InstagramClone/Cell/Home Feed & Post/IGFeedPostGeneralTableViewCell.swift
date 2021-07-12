//
//  IGFeedPostGeneralTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/28.
//

import UIKit


// Commets
class IGFeedPostGeneralTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellKey = "IGFeedPostGeneralTableViewCell"
    
    private let imageViewSize: CGFloat = 40
    
    // MARK: - IBElements
    
    let ownerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        
        ownerImageView.layer.cornerRadius = imageViewSize/2
        
        ownerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(15)
            make.size.equalTo(imageViewSize)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ownerImageView)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(ownerImageView.snp.right).offset(10)
            make.width.equalTo(50)
        }
        
        captionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ownerImageView)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(usernameLabel.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemGreen
        addSubview(ownerImageView)
        addSubview(usernameLabel)
        addSubview(captionLabel)
        
        autoLayout()
        selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: UserPost) {
        // configure the cell
        usernameLabel.text = model.owner.username
        captionLabel.text = model.caption
        
        let data = try? Data(contentsOf: model.owner.profilePhoto)
        if let imageData = data {
            let image = UIImage(data: imageData)
            ownerImageView.image = image
        }
    }
    
}
