//
//  IGFeedPostTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class IGFeedPostTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    static let cellKey = "IGFeedPostTableViewCell"
    
    // MARK: - IBOutlets
    // MARK: - Autolayout
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
}
