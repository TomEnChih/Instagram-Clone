//
//  ProfileTabsCollectionReusableView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/28.
//

import UIKit

class ProfileTabsCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let cellKey = "ProfileTabsCollectionReusableView"
    
    // MARK: - IBOutlets
     private let gridButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
//        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        button.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private let taggedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
//        button.setBackgroundImage(UIImage(systemName: "tag"), for: .normal)
        button.setImage(UIImage(systemName: "tag"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
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
    
    func autoLayout() {
        tabStackView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(30)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        addSubview(tabStackView)
        autoLayout()
        
        gridButton.addTarget(self, action: #selector(didTapGridButton), for: .touchUpInside)
        taggedButton.addTarget(self, action: #selector(didTapTaggedButton), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc func didTapGridButton() {
        
    }
    
    @objc func didTapTaggedButton() {
        
    }
    
}
