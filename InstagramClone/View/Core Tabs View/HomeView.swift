//
//  HomeView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/11.
//

import UIKit

class HomeView: UIView {

    
    
    // MARK: - UIElement
    
    var  homeCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HomePostCell.self, forCellWithReuseIdentifier: HomePostCell.id)
        cv.backgroundColor = .white
        
        return cv
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        
        homeCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.snp_topMargin)
            make.bottom.equalTo(self.snp_bottomMargin)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(homeCollectionView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
