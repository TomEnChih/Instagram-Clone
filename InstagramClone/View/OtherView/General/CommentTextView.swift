//
//  CommentTextView.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/15.
//

import UIKit

class CommentTextView: UITextView {

    // MARK: - Properties
        
    static let textChangeNotificationName = Notification.Name("textChange")

    // MARK: - IBElements
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Comment..."
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Autolayout
    
    private func autoLayout() {
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
                
        addSubview(placeholderLabel)
        autoLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: CommentTextView.textChangeNotificationName, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    func returnCommentText() {
        self.text = nil
        placeholderLabel.isHidden = false
    }
    
}
