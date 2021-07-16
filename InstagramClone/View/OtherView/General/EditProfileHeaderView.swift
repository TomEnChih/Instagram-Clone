//
//  EditProfileHeaderView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

protocol EditProfileHeaderViewDelegate: AnyObject {
    func changeProfileImage()
}


class EditProfileHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
        
    static let id = "EditProfileHeaderView"
    
    weak var delegate: EditProfileHeaderViewDelegate?
    
    // MARK: - IBElement
    
    let profilePhotoButton: CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 70
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        return button
    }()
    // MARK: - Autolayout
    
    func autoLayout() {
        profilePhotoButton.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(140)
        }
    }
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubview(profilePhotoButton)
        autoLayout()
        profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc private func didTapProfilePhotoButton() {
        delegate?.changeProfileImage()
    }
    
}
