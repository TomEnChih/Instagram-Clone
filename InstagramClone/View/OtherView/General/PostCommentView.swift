//
//  PostCommentView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/5.
//

import UIKit

class PostCommentView: UIView {

    // MARK: - Properties
    
    var sendButtonAction: (()->Void)?
    
    // MARK: - IBElement
    
    let commentTableView: UITableView = {
        let tv = UITableView()
        
        tv.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.cellKey)
        tv.backgroundColor = .secondarySystemBackground
        
        return tv
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "新增留言..."
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .default
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        return button
    }()
    
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        
        commentTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.topMargin)
            make.left.right.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.85)
        }
        
        separateView.snp.makeConstraints { (make) in
            make.top.equalTo(commentTableView.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(1)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(separateView.snp.bottom)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        commentTextField.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView).offset(10)
            make.bottom.equalTo(bottomView).offset(-10)
            make.left.equalTo(bottomView).offset(15)
            make.width.equalTo(bottomView).multipliedBy(0.8)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView).offset(10)
            make.bottom.equalTo(bottomView).offset(-10)
            make.right.equalTo(bottomView).offset(-10)
            make.left.equalTo(commentTextField.snp.right).offset(5)
        }
        
        
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(commentTableView)
        addSubview(separateView)
        addSubview(bottomView)
        bottomView.addSubview(commentTextField)
        bottomView.addSubview(sendButton)
        
        autoLayout()
        
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    
    @objc func didTapSendButton() {
        print("comment")
        sendButtonAction?()
    }

}
