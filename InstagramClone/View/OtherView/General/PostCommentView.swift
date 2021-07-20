//
//  PostCommentView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/5.
//

import UIKit

class PostCommentView: UIView {

    // MARK: - Properties
        
    // MARK: - IBElement
    
    let commentTableView: UITableView = {
        let tv = UITableView()
        
        tv.register(CommentCell.self, forCellReuseIdentifier: CommentCell.id)
        tv.backgroundColor = .secondarySystemBackground
        tv.separatorStyle = .none
        tv.keyboardDismissMode = .interactive
        
        return tv
    }()
    
    // MARK: - Autolayout
    
    func autoLayout() {
        
        commentTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.topMargin)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(commentTableView)
        
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    
}
