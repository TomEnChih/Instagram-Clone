//
//  EditProfileView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class EditProfileView: UIView {

    // MARK: - Properties
    
    
    // MARK: - IBElement
    
    let editProfileTableView: UITableView = {
        let tv = UITableView()
        tv.register(EditProfileCell.self, forCellReuseIdentifier: EditProfileCell.id)
        tv.register(EditProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: EditProfileHeaderView.id)
        tv.keyboardDismissMode = .interactive
        tv.separatorStyle = .none
        
        return tv
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        editProfileTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp_topMargin)
            make.bottom.left.right.equalTo(self)
        }
    }

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(editProfileTableView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

}
