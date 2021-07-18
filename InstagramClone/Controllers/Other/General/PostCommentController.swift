//
//  PostCommentsVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/5.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PostCommentController: UIViewController {
    
    // MARK: - Properties
    
    var post: PostTest
    var comments = [Observable<Comment>]() {
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
        postCommentBottomView.commentTextView.delegate = self
        buttonActionFunction()
        fetchComments()
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
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let email = dictionary["email"] as? String else { return }
            Database.fetchUserWithEmail(with: email) { (user) in
                let comment = Observable<Comment>(Comment(user: user, dictionary: dictionary))
                self.comments.append(comment)
                self.postCommentView.commentTableView.reloadData()
            }
        }
    }
    
    private func buttonActionFunction() {
        
        postCommentBottomView.didTapSendButton = {
            guard let email = Auth.auth().currentUser?.email else { return }
            let safeEmail = email.safeDatabaseKey()
            guard let postId = self.post.id else { return }
            
            let values = ["text": self.postCommentBottomView.commentTextView.text ?? "error",
                          "creationDate": Date().timeIntervalSince1970,
                          "email" : safeEmail]
                as [String : Any]
            
            Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, ref) in
                if let error = error {
                    print("Failed to insert comment:", error)
                    return
                }
                print("Successfully inserted comment.")
                self.postCommentBottomView.commentTextView.returnCommentText()
            }
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
        
//        cell.configure(with: comment)
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


//MARK: - TextFieldDelegate

extension PostCommentController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        NotificationCenter.default.post(name: CommentTextView.textChangeNotificationName, object: nil)
    }
    
}
