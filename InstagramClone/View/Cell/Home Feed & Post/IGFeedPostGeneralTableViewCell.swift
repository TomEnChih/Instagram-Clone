//
//  IGFeedPostGeneralTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/28.
//

import UIKit


// Commets
class IGFeedPostGeneralTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let cellKey = "IGFeedPostGeneralTableViewCell"
    
    // MARK: - IBOutlets
    // MARK: - Autolayout
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure() {
        // configure the cell
    }

}
