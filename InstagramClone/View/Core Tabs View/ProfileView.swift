//
//  ProfileView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class ProfileView: UIView {

    // MARK: - UIElement
    
    var  prfileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //每行的間距(上下,左右)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1) 
//        let fullScreenSize = UIScreen.main.bounds.size
//        layout.itemSize = CGSize(width: fullScreenSize.width/3, height: fullScreenSize.height/5)
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(ProfileInformationCollectionViewCell.self, forCellWithReuseIdentifier: ProfileInformationCollectionViewCell.cellkey)
        //header
        collectionView.register(ProfileTabsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileTabsCollectionReusableView.cellKey)
        
         collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return collectionView
    }()
    // MARK: - Autolayout
    
    func autoLayout() {
        
        prfileCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.snp_topMargin)
            make.bottom.equalTo(self.snp_bottomMargin)
        }
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addSubview(prfileCollectionView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
