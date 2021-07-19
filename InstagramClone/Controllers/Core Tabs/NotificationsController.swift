//
//  NotificationsController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
//import FirebaseAuth
//import FirebaseDatabase

enum UserNotificationType {
    case like(post: PostTest)
    case follow
}

struct UserNotification {
    let type: UserNotificationType
    //    let text: String
    let user: UserTest
}


class NotificationsController: UIViewController {
    
    // MARK: - Properties
    
    private let notificationsView = NotificationsView()
    
    private var models = [Observable<UserNotification>]()
    
    private var isModelsEmpty = true
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = notificationsView
        self.navigationItem.title = "Notifications"
        notificationsView.notificationsTableView.delegate = self
        notificationsView.notificationsTableView.dataSource = self
        fetchUser()
    }
    
    // MARK: - Methods
    
    private func fetchUser() {
        let email = AuthManager.shared.fetchCurrentUserEmail()
        
        DatabaseManager.shared.fetchUserWithEmail(with: email) { (user) in
            self.fetchLikePosts(with: user)
            self.fetchFollowers(with: email)
        }
    }
    
    //    func fetchLikePosts(with user: UserTest) {
    //        let currentUserEmail = AuthManager.shared.fetchCurrentUserEmail()
    //
    //        let postRef = Database.database().reference().child("posts").child(currentUserEmail)
    //        postRef.observeSingleEvent(of: .value) { (snapshot) in
    //            guard let dictionaries = snapshot.value as? [String:Any] else { return }
    //
    //            dictionaries.forEach { (key, value) in
    //                guard let dictionary = value as? [String:Any] else { return }
    //                var post = PostTest(user: user, dictionary: dictionary) //自己的post
    //                post.id = key /// comment 編號
    //                let likeRef = Database.database().reference().child("likes").child(key)
    //                likeRef.observeSingleEvent(of: .value) { (snapshot) in
    //                    guard let likeDictionary = snapshot.value as? [String:Any] else { return }
    //
    //                    likeDictionary.forEach { (key,value) in
    //                        guard key != currentUserEmail else { return }
    //                        Database.fetchUserWithEmail(with: key) { (user) in
    //                            let model = Observable<UserNotification>(UserNotification(type: .like(post: post), user: user))
    //                            self.models.append(model)
    //                            self.handleViewDisplay()
    //                            self.notificationsView.notificationsTableView.reloadData()
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func fetchLikePosts(with user: UserTest) {
        let currentUserEmail = user.email
        
        DatabaseManager.shared.fetchPostsWithEmail(with: currentUserEmail) { (id, dictionary) in
            var post = PostTest(user: user, dictionary: dictionary) //自己的post
            post.id = id /// comment 編號
            
            DatabaseManager.shared.fetchPostLikeAllUser(postId: id) { (email) in
                guard email != currentUserEmail else { return }
                
                DatabaseManager.shared.fetchUserWithEmail(with: email) { (user) in
                    let model = Observable<UserNotification>(UserNotification(type: .like(post: post), user: user))
                    self.models.append(model)
                    self.handleViewDisplay()
                    self.notificationsView.notificationsTableView.reloadData()
                }
            }
        }
    }
    
    func fetchFollowers(with email: String) {
        
        DatabaseManager.shared.fetchFollowerEmail(userEmail: email) { (email) in
            DatabaseManager.shared.fetchUserWithEmail(with: email) { (user) in
                let model = Observable<UserNotification>(UserNotification(type: .follow, user: user))
                self.models.append(model)
                self.handleViewDisplay()
                self.notificationsView.notificationsTableView.reloadData()
            }
        }
    }
    
    
    func handleViewDisplay() {
        if models.isEmpty {
            isModelsEmpty = true
        } else {
            isModelsEmpty = false
        }
    }
    
    
}

//MARK: - TableViewDelegate,TableViewDataSource
extension NotificationsController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isModelsEmpty {
            return 1
        }
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isModelsEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationNoCell.id, for: indexPath) as! NotificationNoCell
            
            return cell
        } else {
            
            let model = models[indexPath.row]
            
            switch model.value!.type {
            
            case .like(_):
                // like cell
                let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.id, for: indexPath) as! NotificationLikeEventTableViewCell
                
                model.bind { (model) in
                    cell.configure(with: model!)
                }
                
                cell.delegate = self
                
                return cell
            case .follow:
                // follow cell
                let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.id, for: indexPath) as! NotificationFollowEventTableViewCell
                
                model.bind { (model) in
                    cell.configure(with: model!)
                }
                
                return cell
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isModelsEmpty {
            return view.frame.height * 0.7
        } else {
            return 75
        }
    }
}

//MARK: - NotificaionLikeEventTableViewCellDelegate
extension NotificationsController: NotificaionLikeEventTableViewCellDelegate {
    
    func didTapRelatedPostButton(model: UserNotification) {
        // open the post
        switch model.type {
        case .like(let post):
            #warning("不確定這樣對不對 post")
            print("test",post.hasLiked,post.hasSaved)
            let vc = PostController(with: Observable<PostTest>(post))
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        case .follow: break
        }
    }
    
    
}
