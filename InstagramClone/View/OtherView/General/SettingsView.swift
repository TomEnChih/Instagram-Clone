//
//  SettingsView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class SettingsView: UIView {

    // MARK: - UIElement
    
    let settingsTableVeiw: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "settingsTableVeiwCell")
        return tv
    }()

    
    // MARK: - Autolayout
    
    func autoLayout() {
        
        settingsTableVeiw.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addSubview(settingsTableVeiw)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
