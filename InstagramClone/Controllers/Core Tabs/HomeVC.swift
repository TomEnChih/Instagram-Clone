//
//  ViewController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/23.
//

import UIKit
import FirebaseAuth

struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
    
}



class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private let homeView = HomeView()
    
    private var feedRenderModels = [[PostRenderViewModel]]()
    
    private var userPost = [UserPost]()
    
    
    // MARK: - Init
    
    //    init(model: UserPost) {
    //
    //        super.init(nibName: nil, bundle: nil)
    //        configureModels(model: model)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    //
    private func configureModels() {
        
        let user1 = User(name: (first: "String", last: "tom"),
                        username: "tom", bio: "hi,my name is tom",
                        profilePhoto: URL(string: "https://storage.googleapis.com/redso-challenge.appspot.com/catalog/1.jpg")!,
                        birthDate: Date(),
                        gender: .male,
                        counts: UserCount(followers: 1, following: 2, posts: 3),
                        joinDate: Date())
        
        let post1 = UserPost(postType: .photo,
                            postURL: URL(string: "https://storage.googleapis.com/redso-challenge.appspot.com/catalog/0.jpg")!,
                            caption: "it's my first picture",
                            likeCount: [],
                            comments: [PostComment(thumbnailImage: URL(string: "https://storage.googleapis.com/redso-challenge.appspot.com/catalog/1.jpg")!, username: "Mark", text: "so good!", createdDate: Date()),
                                       PostComment(thumbnailImage: URL(string: "https://storage.googleapis.com/redso-challenge.appspot.com/catalog/1.jpg")!, username: "Mike", text: "nice", createdDate: Date())],
                            createdDate: Date(),
                            owner: user1)
        
        
        let user2 = User(name: (first: "String", last: "tom"),
                        username: "tom", bio: "hi,my name is tom",
                        profilePhoto: URL(string: "https://storage.googleapis.com/redso-challenge.appspot.com/catalog/3.jpg")!,
                        birthDate: Date(),
                        gender: .male,
                        counts: UserCount(followers: 1, following: 2, posts: 3),
                        joinDate: Date())
        
        let post2 = UserPost(postType: .photo,
                            postURL: URL(string: "https://storage.googleapis.com/redso-challenge.appspot.com/catalog/4.jpg")!,
                            caption: "it's my first picture",
                            likeCount: [],
                            comments: [PostComment(thumbnailImage: URL(string: "https://storage.googleapis.com/redso-challenge.appspot.com/catalog/5.jpg")!, username: "Mark", text: "so good!", createdDate: Date()),
                                       PostComment(thumbnailImage: URL(string: "https://storage.googleapis.com/redso-challenge.appspot.com/catalog/1.jpg")!, username: "Mike", text: "nice", createdDate: Date())],
                            createdDate: Date(),
                            owner: user1)
        
        
        var feedRenderModel1 = [PostRenderViewModel]()
        var feedRenderModel2 = [PostRenderViewModel]()

        //header
        feedRenderModel1.append(PostRenderViewModel(renderType: .header(provider: post1.owner)))
        feedRenderModel2.append(PostRenderViewModel(renderType: .header(provider: post2.owner)))

        //Post
        feedRenderModel1.append(PostRenderViewModel(renderType: .primaryContent(provider: post1)))
        feedRenderModel2.append(PostRenderViewModel(renderType: .primaryContent(provider: post2)))

        //Actions
        feedRenderModel1.append(PostRenderViewModel(renderType: .actions(provider: "")))
        feedRenderModel2.append(PostRenderViewModel(renderType: .actions(provider: "")))

        //Caption
        feedRenderModel1.append(PostRenderViewModel(renderType: .caption(provider: post1)))
        feedRenderModel2.append(PostRenderViewModel(renderType: .caption(provider: post2)))

        feedRenderModels.append(feedRenderModel1)
        feedRenderModels.append(feedRenderModel2)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        homeView.teamTableView.delegate = self
        homeView.teamTableView.dataSource = self
        handleNotAuthenticated()
        configureModels()
        
    }
    
    // MARK: - Methods
    
    private func handleNotAuthenticated() {
        // Check auth status
        if Auth.auth().currentUser == nil {
            // Show log in
            let loginVC = LoginController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
    }
    
    
    
}

//MARK: - TableViewDelegate,TableViewDataSource
extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        feedRenderModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let sectionModel = feedRenderModels[indexPath.section]
//        let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.id, for: indexPath)
        
        switch feedRenderModels[indexPath.section][indexPath.row].renderType {
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.cellKey, for: indexPath) as! IGFeedPostHeaderTableViewCell
            
            cell.configure(with: user)
            
            //            cell.delegate = self
            
            return cell
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.cellKey, for: indexPath) as! IGFeedPostTableViewCell
            
            cell.configure(with: post)
            
            
            return cell
        case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.cellKey, for: indexPath) as! IGFeedPostActionsTableViewCell
            
            //            cell.delegate = self as IGFeedPostActionsTableViewCellDelegate
            
            return cell
        case .caption(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.cellKey, for: indexPath) as! IGFeedPostGeneralTableViewCell
            
            cell.configure(with: model)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        switch renderModels[indexPath.section].renderType {
        //        case .header(_):
        //            return 70
        //        case .primaryContent(_):
        //            return tableView.frame.width
        //        case .actions(_):
        //            return 60
        //        case .caption(_):
        //            return 50
        //        }
        
        switch feedRenderModels[indexPath.section][indexPath.row].renderType {
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
}

