//
//  ProfileInformationCollectionViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

protocol ProfileInformationCollectionViewCellDelegate: AnyObject {
    func editProfileAction(_ cell: UICollectionViewCell)
    func profileDidTapPostButton(_ cell: UICollectionViewCell)
    func profileDidTapFollowersButton(_ cell: UICollectionViewCell)
    func profileDidTapFolloweringButton(_ cell: UICollectionViewCell)

}


class ProfileInformationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let cellkey = "ProfileInformationCollectionViewCell"
    
    var editProfileAction: (()->Void)?
    
    public weak var delegate: ProfileInformationCollectionViewCellDelegate?

    // MARK: - IBElement
    
    var userImageView: UIView = {
        let imageView = UIView()
        imageView.layer.cornerRadius = 40
//        imageView.clipsToBounds = true
        imageView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        return imageView
    }()

    
    let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("貼文", for: .normal)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return button
    }()
    
    let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("粉絲", for: .normal)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return button
    }()
    
    let followeringButton: UIButton = {
        let button = UIButton()
        button.setTitle("追蹤中", for: .normal)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return button
    }()
    
    let articleNumbelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "5"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        return label
    }()

    let followersNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "3"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let followeringNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "4"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    lazy var numberStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [articleNumbelLabel,followersNumberLabel,followeringNumberLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .bottom
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var tabsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postButton,followersButton,followeringButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var personalInforStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [numberStackView,tabsStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
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
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 12)
        button.isEnabled = true
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        userImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.size.equalTo(80)
        }
        
        personalInforStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(userImageView)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userImageView.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-30)
        }
        
        bioLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-30)
            make.bottom.equalTo(self).offset(-60)
        }
        
        editPersonInforButton.snp.makeConstraints { (make) in
            make.top.equalTo(bioLabel.snp.bottom).offset(20)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-10)
        }
        
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userImageView)
        addSubview(personalInforStackView)
        addSubview(bioLabel)
        addSubview(nameLabel)
        addSubview(editPersonInforButton)
        autoLayout()
        
        buttonTapAction()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    
    func buttonTapAction() {
        editPersonInforButton.addTarget(self, action: #selector(didTapEditProfile), for: .touchUpInside)
        
        postButton.addTarget(self, action: #selector(didTapArticleButton), for: .touchUpInside)

        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)

        followeringButton.addTarget(self, action: #selector(didTapFolloweringButton), for: .touchUpInside)
    }
    
    @objc private func didTapEditProfile() {
        delegate?.editProfileAction(self)
    }
    
    @objc private func didTapArticleButton() {
        delegate?.profileDidTapPostButton(self)
    }
    
    @objc private func didTapFollowersButton() {
        delegate?.profileDidTapFollowersButton(self)
    }
    
    @objc private func didTapFolloweringButton() {
        delegate?.profileDidTapFolloweringButton(self)
    }
}
