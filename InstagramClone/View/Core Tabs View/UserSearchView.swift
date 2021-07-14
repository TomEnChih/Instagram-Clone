//
//  UserSearchView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class UserSearchView: UIView {
    
    // MARK: - UIElement
    
    var  userSearchCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UserSearchCell.self, forCellWithReuseIdentifier: UserSearchCell.id)
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.keyboardDismissMode = .onDrag
        
        return cv
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        
        userSearchCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.snp_topMargin)
            make.bottom.equalTo(self.snp_bottomMargin)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(userSearchCollectionView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
