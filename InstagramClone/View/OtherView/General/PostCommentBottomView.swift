//
//  CommentBottomView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/13.
//

import UIKit

class PostCommentBottomView: UIView {
    
    // MARK: - Properties
    
    var didTapSendButton: (()->Void)?
    
    // MARK: - IBElements
    
    let commentTextView: CommentTextView = {
        let textField = CommentTextView()
        textField.keyboardType = .default
        textField.isScrollEnabled = false
        textField.font = UIFont.systemFont(ofSize: 18)
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        
        commentTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self.snp.bottomMargin).offset(-10)
            make.width.equalTo(self).multipliedBy(0.8)
        }
        
        sendButton.snp.makeConstraints { (make) in
//            make.top.equalTo(self)
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(commentTextView.snp.right).offset(5)
            make.height.equalTo(50)
            make.centerY.equalTo(commentTextView)
        }
        
        separateView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(separateView)
        addSubview(commentTextView)
        addSubview(sendButton)
        autoLayout()
        autoresizingMask = .flexibleHeight
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    @objc func handleSend() {
        didTapSendButton?()
    }
    
    
}
