//
//  PhotoSelectorView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/8.
//

import UIKit

class PhotoSelectorView: UIView {

    // MARK: - Properties
    
    // MARK: - IBElement
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 0, right: 1)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: UICollectionView.id)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoSelectorHeader.id)
        
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(collectionView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

}
