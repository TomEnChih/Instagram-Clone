//
//  IGFeedPostTableViewCell.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
import AVFoundation

class IGFeedPostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellKey = "IGFeedPostTableViewCell"
    
    private var player: AVPlayer?
    private var playerLayer = AVPlayerLayer()
    
    // MARK: - IBOutlets
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        
        postImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        playerLayer.frame = contentView.bounds
        
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubview(postImageView)
        contentView.layer.addSublayer(playerLayer)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - Methods
    
    public func configure(with post: UserPost) {
        // configure the cell        
        
        switch post.postType {
        case .photo:
            // show image
            let data = try? Data(contentsOf: post.postURL)
            if let imageData = data {
                let image = UIImage(data: imageData)
                postImageView.image = image!
            }
        case .video:
            // load and play video
            player = AVPlayer(url: post.postURL)
            playerLayer.player = player
            playerLayer.player?.volume = 0
            playerLayer.player?.play()
        }
        
    }
    
}
