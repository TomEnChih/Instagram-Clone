//
//  ProfileTabsCollectionReusableView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/28.
//

import UIKit

protocol UserProfileButtonDelegate: AnyObject {
    func didChangeToGridView()
    func didChangeToTaggedView()
    func didTapEditProfile()
}

class UserProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let id = "UserProfileHeader"
    
    weak var delegate: UserProfileButtonDelegate?
    
    var user: UserTest?
    
    // MARK: - IBElements
    private let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    
    let postButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return button
    }()
    
    let followersButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return button
    }()
    
    let followeringButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postButton,followersButton,followeringButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let editProfileFollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    let gridButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: config)
        
        button.tintColor = .lightGray
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    let taggedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold)
        let image = UIImage(systemName: "tag", withConfiguration: config)
        
        button.tintColor = .lightGray
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    lazy var tabStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [gridButton,taggedButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.size.equalTo(80)
        }
        
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(profileImageView.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(80)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.equalTo(self).offset(10)
        }
        
        bioLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.lessThanOrEqualTo(self).offset(-10)
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.bottom.equalTo(editProfileFollowButton.snp.top).offset(-10)
        }
        
        editProfileFollowButton.snp.makeConstraints { (make) in
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
        
        separateView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(buttonStackView)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(editProfileFollowButton)
        addSubview(tabStackView)
        addSubview(separateView)
        autoLayout()
                
        editProfileFollowButton.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        gridButton.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        taggedButton.addTarget(self, action: #selector(handleChangeToTaggedView), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with model: UserTest,postCount: String,followerCount:String,followingCount: String,isGridView: Bool) {
        
        self.user = model
        
        postButton.setButtonTitle(String1: postCount, String2: "貼文")
        followeringButton.setButtonTitle(String1: followingCount, String2: "追蹤中")
        followersButton.setButtonTitle(String1: followerCount, String2: "粉絲")
        gridButton.tintColor = isGridView ? .systemBlue: .lightGray
        taggedButton.tintColor = !isGridView ? .systemBlue: .lightGray
        
        
        profileImageView.loadingImage(url: URL(string: model.profileImageURL)!)
        usernameLabel.text = model.name
        bioLabel.text = model.bio
        
        
        setEditFollowButton()
    }
    
    @objc func handleEditProfileOrFollow() {
        let currentEmail = AuthManager.shared.fetchCurrentUserEmail()
        
        guard let userEmail = user?.email else { return }
        let safeUserEmail = userEmail.safeDatabaseKey()
        
        guard safeUserEmail != currentEmail else {
            delegate?.didTapEditProfile()
            return
        }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            
            DatabaseManager.shared.cancelFollowerAndFollowing(currentUserEmail: currentEmail, OtherUserEmail: safeUserEmail) {
                
                self.setupFollowStyle()
            }
            
        } else {
            
            DatabaseManager.shared.followingOtherUserAndFollower(currentUserEmail: currentEmail, otherUserEmail: safeUserEmail) {
                
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = .white
                self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            }
        }
        
    }
    
    @objc func handleChangeToGridView() {

        delegate?.didChangeToGridView()
    }
    
    @objc func handleChangeToTaggedView() {
        
        delegate?.didChangeToTaggedView()
    }
    
    func setEditFollowButton() {
        let currentUserEmail = AuthManager.shared.fetchCurrentUserEmail()
        guard let userEmail = user?.email else { return }
        
        let safeUserEmail = userEmail.safeDatabaseKey()
        
        if safeUserEmail == currentUserEmail {
            //edit Profile
        } else {
            //check if following
            DatabaseManager.shared.fetchFollowing(currentUserEmail: currentUserEmail, followingEmail: safeUserEmail) { (following) in
                if following {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)

                } else {
                    self.setupFollowStyle()

                }
            }
        }
    }
    
    private func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .systemBlue
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
    }
    
    
}
