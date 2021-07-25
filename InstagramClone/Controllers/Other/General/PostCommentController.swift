//
//  PostCommentsVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/5.
//

import UIKit

class PostCommentController: UIViewController {
    
    // MARK: - Properties
    
    private var post: PostTest
    private var comments = [Observable<Comment>]() {
        didSet {
            postCommentView.commentTableView.reloadData()
        }
    }
    
    private let postCommentView = PostCommentView()
    private let postCommentBottomView = PostCommentBottomView()
    
    // MARK: - Init
    
    init(post: PostTest) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = postCommentView
        
        self.navigationItem.title = "Comments"
        postCommentView.commentTableView.delegate = self
        postCommentView.commentTableView.dataSource = self
        buttonActionFunction()
        fetchComments()
        setupKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Methods
    
    override var inputAccessoryView: UIView? {
        get {
            postCommentBottomView.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
            
            return postCommentBottomView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func fetchComments() {
        guard let postId = post.id else { return }
        
        DatabaseManager.shared.fetchPostComments(postId: postId) { (user, dictionary) in
            let comment = Observable<Comment>(Comment(user: user, dictionary: dictionary))
            self.comments.append(comment)
            self.postCommentView.commentTableView.reloadData()
        }
    }
    
    private func buttonActionFunction() {
        
        postCommentBottomView.didTapSendButton = { [weak self] in

            guard let postId = self?.post.id else { return }
            guard let text = self?.postCommentBottomView.commentTextView.text,text.count > 0 else { return }
            DatabaseManager.shared.uploadPostComment(postId: postId, text: text) {
                self?.postCommentBottomView.commentTextView.returnCommentText()
            }
        }
    }
    
    //MARK: tableView隨keyboard調整
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let height = (keyboardFrame?.cgRectValue.height)
        postCommentView.commentTableView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-height!)
        }
        
        postCommentView.commentTableView.scrollTo(direction: .bottom)
        
        let keyboardDuration = notification.userInfo? [UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        postCommentView.commentTableView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.view.snp_topMargin)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp_bottomMargin)
        }
        
        let keyboardDuration = notification.userInfo? [UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    
}

//MARK: - TableViewDelegate,TableViewDataSource

extension PostCommentController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id, for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.row]
        
        comment.bind { (comment) in
            cell.configure(with: comment!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    
}
