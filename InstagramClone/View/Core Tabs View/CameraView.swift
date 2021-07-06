//
//  CameraView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/4.
//

import UIKit

class CameraView: UIView {

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
    
    var contentTextView: UITextView = {
        let tv = UITextView()
        tv.keyboardType = .default
        tv.returnKeyType = .default
        tv.isEditable = true
        tv.isSelectable = true
        tv.backgroundColor = .white
        return tv
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp_topMargin)
            make.left.right.equalTo(self)
            make.height.equalTo(120)
        }
        
        postImageView.snp.makeConstraints { (make) in
            make.top.equalTo(topView).offset(20)
            make.bottom.equalTo(topView).offset(-20)
            make.left.equalTo(topView).offset(10)
            make.width.equalTo(postImageView.snp.height)
        }
        
        contentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(topView).offset(20)
            make.bottom.equalTo(topView).offset(-20)
            make.left.equalTo(postImageView.snp.right).offset(10)
            make.right.equalTo(topView).offset(-10)
        }
        
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(topView)
        topView.addSubview(postImageView)
        topView.addSubview(contentTextView)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods

}
