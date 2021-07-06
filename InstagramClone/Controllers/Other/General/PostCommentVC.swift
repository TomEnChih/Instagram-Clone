//
//  PostCommentsVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/5.
//

import UIKit

class PostCommentVC: UIViewController {
    
    // MARK: - Properties
    
    private let postCommentView = PostCommentView()
    
    private var comments: [PostComment] = [] {
        didSet {
            postCommentView.commentTableView.reloadData()
        }
    }
    
    // MARK: - Init
    
    init(comments: [PostComment]) {
        self.comments = comments
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = postCommentView
        postCommentView.commentTableView.delegate = self
        postCommentView.commentTableView.dataSource = self
        postCommentView.commentTextField.delegate = self
        buttonActionFunction()


    }

    // MARK: - Methods
    
    func buttonActionFunction() {
        postCommentView.sendButtonAction = {
            guard let text = self.postCommentView.commentTextField.text, !text.isEmpty else {
                return
            }
            #warning("之後改回")
            let username = "who"
            let date = Date()
            
            self.comments.append(PostComment(thumbnailImage: URL(string: "https://storage.googleapis.com/redso-challenge.appspot.com/catalog/1.jpg")!, username: username, text: text, createdDate: date))
            self.postCommentView.commentTextField.text = ""
        }
    }
    

}

//MARK: - TableViewDelegate,TableViewDataSource

extension PostCommentVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = comments[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.cellKey, for: indexPath) as! CommentTableViewCell
        
        cell.configure(with: comment)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    
}


//MARK: - TextFieldDelegate

extension PostCommentVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postCommentView.commentTextField.resignFirstResponder()
        
        postCommentView.didTapSendButton()
        
        return true
    }
    
}
