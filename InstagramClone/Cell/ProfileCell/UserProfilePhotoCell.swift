//
//  ProfilePhotoCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/10.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let id = "UserProfilePhotoCell"
    
    // MARK: - IBElements
    
    let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        
        photoImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with model: PostTest) {
        
        photoImageView.image = nil
        photoImageView.loadingImage(url: URL(string: model.imageURL)!)
    }
}
