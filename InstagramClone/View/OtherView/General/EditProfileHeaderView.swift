//
//  EditProfileHeaderView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class EditProfileHeaderView: UIView {

    // MARK: - Properties
    
    var changeProfilePhoto: (()->Void)?
    // MARK: - IBElement
    
    let profilePhotoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        return button
    }()
    // MARK: - Autolayout
    
    func autoLayout() {
        profilePhotoButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.size.equalTo(50)
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profilePhotoButton)
        autoLayout()
        
        profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc private func didTapProfilePhotoButton() {
        changeProfilePhoto?()
    }

}
