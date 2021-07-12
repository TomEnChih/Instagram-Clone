//
//  PhotoSelectorHeader.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/8.
//

import UIKit

class PhotoSelectorHeader: UICollectionReusableView {
        
    // MARK: - Properties
    
    static let id = "PhotoSelectorHeader"
    
    // MARK: - IBElement
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
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
    
}
