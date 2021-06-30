//
//  NotificationLikeEventTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/29.
//

import UIKit

protocol NotificaionLikeEventTableViewCellDelegate: AnyObject {
    func didTapRelatedPostButton(model: String)
}


class NotificationLikeEventTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let cellKey = "NotificationLikeEventTableViewCell"
    
    weak var delegate: NotificaionLikeEventTableViewCellDelegate?
    
    // MARK: - IBOutlets
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let lable: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
        
    // MARK: - Autolayout
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(lable)
        contentView.addSubview(postButton)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: String) {
        
    }


}
