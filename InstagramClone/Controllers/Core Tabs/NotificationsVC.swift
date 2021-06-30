//
//  NotificationsVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}


class NotificationsVC: UIViewController {
    
    // MARK: - Properties
    
    private let notificationsView = NotificationsView()
    
    private let noNotificationsView = NoNotificationsView()
    
    private var models = [UserNotification]()
    // MARK: - Init
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = notificationsView
        navigationController?.title = "Notifications"
        notificationsView.notificationsTableView.delegate = self
        notificationsView.notificationsTableView.dataSource = self
        fetchNotifications()
    }
    
    // MARK: - Methods

    func fetchNotifications() {
        for x in 0...100 {
            let post = UserPost(identifier: "", postType: .photo,
                                thumbnailImage: URL(string: "https://www.google.com")!,
                                postURL: URL(string: "https://www.google.com")!,
                                caption: nil,
                                likeCount: [],
                                comments: [],
                                createdDate: Date(),
                                taggedUser: [])
                
            let model = UserNotification(type: x % 2 == 0 ? .follow(state: .unFollowing):.like(post: post),
                                         text: "hellow world",
                                         user: User(name: (first: "String", last: "tom"),
                                                    username: "tom", bio: "123123",
                                                    profilePhoto: URL(string: "https://www.google.com")!,
                                                    birthDate: Date(),
                                                    gender: .male,
                                                    counts: UserCount(followers: 1, following: 2, posts: 3),
                                                    joinDate: Date()))
        
            models.append(model)
        }
    }
    
    
}

//MARK: - TableViewDelegate,TableViewDataSource
extension NotificationsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        
        switch model.type {
        case .like(_):
            // like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.cellKey, for: indexPath) as! NotificationLikeEventTableViewCell
            
            cell.configure(with: model)

            
            cell.delegate = self

            return cell
        case .follow:
            // follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.cellKey, for: indexPath) as! NotificationFollowEventTableViewCell
            
//            cell.configure(with: model)
            
            cell.delegate = self
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsTableView", for: indexPath)
        
        return cell
    }
    
    
}

extension NotificationsVC: NotificaionLikeEventTableViewCellDelegate,NotificaionFollowEventTableViewCellDelegate {
    
    func didTapFollowButton(model: UserNotification) {
        print("Tapped button")
        // perfom database update
    }
    
    func didTapRelatedPostButton(model: UserNotification) {
        print("Tapped post")
        switch model.type {
        case .like(let post):
            let vc = PostVC(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .follow(_):
            fatalError("Dev Issue: Should never get called")
        }
        
        // open the post
        
        
    }
    
    
}
