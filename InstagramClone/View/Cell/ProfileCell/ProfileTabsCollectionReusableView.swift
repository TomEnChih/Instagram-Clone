//
//  ProfileTabsCollectionReusableView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/28.
//

import UIKit

class ProfileTabsCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let cellKey = "ProfileTabsCollectionReusableView"
    
    // MARK: - IBElements
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()

    
    let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("貼文/n11", for: .normal)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return button
    }()
    
    let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("粉絲\n12", for: .normal)
        button.titleLabel?.numberOfLines = 0
        
//        let attributedText = NSMutableAttributedString(string: "11\n",attributes: [NSMutableAttributedString:UIFont.boldSystemFont(ofSize: 14)])
        
        
//        button.setAttributedTitle(<#T##title: NSAttributedString?##NSAttributedString?#>, for: .normal)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return button
    }()
    
//    let followeringButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("追蹤中/n13", for: .normal)
//        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15)
//        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
//        return button
//    }()
    
    let followeringButton: UILabel = {
        let label = UILabel()
        label.text = "11\n追蹤"
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    lazy var tabsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postButton,followersButton,followeringButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.spacing = 0
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let editPersonInforButton: UIButton = {
        let button = UIButton()
        button.setTitle("編輯個人資料", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    
    
    
     private let gridButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.contentVerticalAlignment = .fill
//        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private let taggedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "tag"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.contentVerticalAlignment = .fill
//        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    lazy var tabStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [gridButton,taggedButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    // MARK: - Autolayout
    
    func autoLayout() {
        userImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.size.equalTo(80)
        }
        
        tabsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(50)
        }
        
        editPersonInforButton.snp.makeConstraints { (make) in
//            make.top.equalTo(userImageView.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(tabStackView.snp.top).offset(-10)
        }
        
        tabStackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        addSubview(userImageView)
        addSubview(tabsStackView)
        addSubview(editPersonInforButton)
        addSubview(tabStackView)
        autoLayout()
        
        gridButton.addTarget(self, action: #selector(didTapGridButton), for: .touchUpInside)
        taggedButton.addTarget(self, action: #selector(didTapTaggedButton), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc func didTapGridButton() {
        
    }
    
    @objc func didTapTaggedButton() {
        
    }
    
}
