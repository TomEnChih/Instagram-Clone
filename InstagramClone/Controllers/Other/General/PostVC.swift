//
//  PostVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

/// states of  a rendered cell
enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost) //post
    case actions(provider: String) // like , comment ,share
    case comments(comments: [PostComment])
}

/// Model of rendered Post
struct PostRenderViewModel {
    let renderType: PostRenderType
}


class PostVC: UIViewController {
    
    // MARK: - Properties
    
    private let postView = PostView()
    
    private var userPost: UserPost?
    
    private var renderModels = [PostRenderViewModel]()
    
    private var model: UserPost?
    // MARK: - Init
    
    init(model: UserPost) {
        self.userPost = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureModels() {
        guard let userPostModel = self.userPost else {
            return
        }
        
        // header
        renderModels.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))
        
        // Post
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))

        // Actions
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))
        
        // 4 Comments
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(PostComment(username: "@tom", text: "Great post!", createdDate: Date(), like: []))
        }
        renderModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))

        
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = postView
        postView.tableView.delegate = self
        postView.tableView.dataSource = self
    }
    
    // MARK: - Methods

}

//MARK: - TableViewDelegate,TableViewDataSource
extension PostVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        renderModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType {
        case .header(_):
            return 1
        case .primaryContent(_):
            return 1
        case .actions(_):
            return 1
        case .comments(let comments):
            return comments.count > 4 ? 4 : comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = renderModels[indexPath.section]
        
        switch renderModels[indexPath.section].renderType {
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.cellKey, for: indexPath) as! IGFeedPostHeaderTableViewCell
            
            cell.configure(with: user)
            
            cell.delegate = self

            return cell
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.cellKey, for: indexPath) as! IGFeedPostTableViewCell
            
            cell.configure(with: post)
            
            
            return cell
        case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.cellKey, for: indexPath) as! IGFeedPostActionsTableViewCell
            
//            cell.configure(with: actions)
            cell.delegate = self

            
            return cell
        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.cellKey, for: indexPath) as! IGFeedPostGeneralTableViewCell
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch renderModels[indexPath.section].renderType {
        case .header(_):
            return 70
        case .primaryContent(_):
            return tableView.frame.width
        case .actions(_):
            return 60
        case .comments(_):
            return 50
        }
    }
    
    
}

extension PostVC: IGFeedPostHeaderTableViewCellDelegate {
    
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func reportPost() {
        
    }
    
}

extension PostVC: IGFeedPostActionsTableViewCellDelegate {
    
    func didTapLikeButton() {
        print("like")
    }
    
    func didTapCommentButton() {
        print("comment")
    }
    
    func didTapSendButton() {
        print("send")
    }
    
    
}
