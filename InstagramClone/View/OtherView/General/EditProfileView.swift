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
        tv.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.cellKey)
        
        return tv
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        editProfileTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp_topMargin)
            make.right.left.bottom.equalTo(self)
        }
    }

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(editProfileTableView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

}
