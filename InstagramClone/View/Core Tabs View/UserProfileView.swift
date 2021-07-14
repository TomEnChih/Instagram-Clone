//
//  UserProfileView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class UserProfileView: UIView {

    // MARK: - UIElement
    
    var  prfileCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        ///每行的間距(上下,左右)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1) 
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //cell
        cv.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: UserProfilePhotoCell.id)
        //header
        cv.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.id)
        
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        
        prfileCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.snp_topMargin)
            make.bottom.equalTo(self.snp_bottomMargin)
        }
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(prfileCollectionView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
