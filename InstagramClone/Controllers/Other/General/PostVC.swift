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
    case caption(provider: UserPost)
}

/// Model of rendered Post
struct PostRenderViewModel {
    let renderType: PostRenderType
}


class PostVC: UIViewController {
    
    // MARK: - Properties
    
    private let postView = PostView()
    
//    private var userPost: UserPost?
    
    private var renderModels = [PostRenderViewModel]()
    
//    private var model: UserPost?
    private var comments: [PostComment] = []
    // MARK: - Init
    
    init(model: UserPost) {
        
        super.init(nibName: nil, bundle: nil)
        configureModels(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureModels(model: UserPost) {
        
        // header
        renderModels.append(PostRenderViewModel(renderType: .header(provider: model.owner)))
        
        // Post
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: model)))

        // Actions
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))
        
        // Caption
        renderModels.append(PostRenderViewModel(renderType: .caption(provider: model)))

        comments = model.comments
        
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
        case .caption(_):
            return 1
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
            
            cell.delegate = self as IGFeedPostActionsTableViewCellDelegate
            
            return cell
        case .caption(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.cellKey, for: indexPath) as! IGFeedPostGeneralTableViewCell
            
            cell.configure(with: model)
            
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
        case .caption(_):
            return 50
        }
    }
    
}

//MARK: - delegate
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
        postView.tableView.reloadData()
    }
    
    func didTapCommentButton() {
        
        let vc = PostCommentVC(comments: comments)
        present(vc, animated: true, completion: nil)
    }
    
    func didTapSendButton() {
        print("send")
    }
    
    
}
