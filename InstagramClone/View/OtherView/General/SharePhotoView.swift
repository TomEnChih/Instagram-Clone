//
//  SharePhotoView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/10.
//

import UIKit

class SharePhotoView: UIView {

    // MARK: - Properties
    
    // MARK: - IBElements
    
    var postImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return imageView
    }()
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.keyboardType = .default
        tv.returnKeyType = .default
        tv.isEditable = true
        tv.isSelectable = true
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.backgroundColor = .white
        return tv
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp_topMargin)
            make.left.right.equalTo(self)
            make.height.equalTo(120)
        }
        
        postImageView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView).offset(10)
            make.bottom.equalTo(containerView).offset(-10)
            make.left.equalTo(containerView).offset(10)
            make.width.equalTo(postImageView.snp.height)
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.bottom.equalTo(containerView)
            make.left.equalTo(postImageView.snp.right).offset(10)
            make.right.equalTo(containerView).offset(-10)
        }
        
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(containerView)
        containerView.addSubview(postImageView)
        containerView.addSubview(textView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods

}
