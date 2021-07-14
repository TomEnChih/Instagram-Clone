//
//  ProfileTabsCollectionReusableView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/28.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let id = "UserProfileHeader"
    
    var user: UserTest? {
        didSet {
            
            guard let profileImageURL = user?.profileImageURL else { return }
            
            profileImageView.loadingImage(url: URL(string: profileImageURL)!)
            usernameLabel.text = user?.username
            
            setEditFollowButton()
        }
    }
    
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
        button.setTitle("編輯個人資料", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    private let gridButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: config)
        
        button.tintColor = .black
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let taggedButton: UIButton = {
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
        autoLayout()
        
        usernameLabel.text = "tom"
        bioLabel.text = "hello,my name is tom. I'm learning Swift to become an iOS engineer."
        
        setButtonTitle(String1: "1", String2: "貼文", button: postButton)
        setButtonTitle(String1: "2", String2: "粉絲", button: followersButton)
        setButtonTitle(String1: "3", String2: "追蹤中", button: followeringButton)

        
        editProfileFollowButton.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        gridButton.addTarget(self, action: #selector(didTapGridButton), for: .touchUpInside)
        taggedButton.addTarget(self, action: #selector(didTapTaggedButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc func handleEditProfileOrFollow() {
        guard let currentLoggedInUserEmail = Auth.auth().currentUser?.email else { return }
        let safeCurrentEmail = currentLoggedInUserEmail.safeDatabaseKey()
        
        guard let userEmail = user?.email else { return }
        let safeUserEmail = userEmail.safeDatabaseKey()
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            //unfollow
            let ref = Database.database().reference().child("following").child(safeCurrentEmail).child(safeUserEmail)
            ref.removeValue { (error, ref) in
                if let error = error {
                    print(error)
                    return
                }
                self.setupFollowStyle()
                print("successfully unfollowed user: \(self.user?.username)")
            }
        } else {
            //follow
            let value = [safeUserEmail: 1]
            let ref = Database.database().reference().child("following").child(safeCurrentEmail)
            ref.updateChildValues(value, withCompletionBlock: { (error, ref) in
                guard error == nil else {
                    print("Failed to follow user: \(error)")
                    return
                }
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = .white
                self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            })
        }
        
    }
    
    @objc func didTapGridButton() {
        
    }
    
    @objc func didTapTaggedButton() {
        
    }
    
    private func setEditFollowButton() {
        guard let currentLoggedInUserEmail = Auth.auth().currentUser?.email else { return }
        guard let userEmail = user?.email else { return }
        let safeCurrentEmail = currentLoggedInUserEmail.safeDatabaseKey()
        let safeUserEmail = userEmail.safeDatabaseKey()
        
        if safeUserEmail == safeCurrentEmail {
            //edit Profile
        } else {
            
            //check if following
             let ref = Database.database().reference().child("following").child(safeCurrentEmail).child(safeUserEmail)
            ref.observe(.value) { (snapshot) in
                if let isFollowing = snapshot.value as? Int,isFollowing == 1 {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    
                } else {
                    self.setupFollowStyle()
                }
            } withCancel: { (error) in
                    print(error)
            }

            
        }
        
    }
    
    private func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .systemBlue
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
    }
    
    func setButtonTitle(String1: String, String2: String, button: UIButton){
        //applying the line break mode
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        let buttonText: NSString = "\(String1)\n\(String2)" as NSString
        
        //getting the range to separate the button title strings
        let newlineRange: NSRange = buttonText.range(of: "\n")
        
        //getting both substrings 為了分成兩個String
        var substring1 = ""
        var substring2 = ""
        
        if(newlineRange.location != NSNotFound) {
            substring1 = buttonText.substring(to: newlineRange.location)
            substring2 = buttonText.substring(from: newlineRange.location)
        }
        
        //assigning diffrent fonts to both substrings
        let font1: UIFont = UIFont.boldSystemFont(ofSize: 18)
        let attributes1 = [NSMutableAttributedString.Key.font: font1]
        let attrString1 = NSMutableAttributedString(string: substring1, attributes: attributes1)
        
        let font2: UIFont = UIFont.systemFont(ofSize: 15)
        let attributes2 = [NSMutableAttributedString.Key.font: font2]
        let attrString2 = NSMutableAttributedString(string: substring2, attributes: attributes2)
        
        //appending both attributed strings
        attrString1.append(attrString2)
        
        //assigning the resultant attributed strings to the button
        button.setAttributedTitle(attrString1, for: [])
    }
    
}
