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
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
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
//    private func configureModels(model: UserPost) {
        
        // header
//        renderModels.append(PostRenderViewModel(renderType: .header(provider: model.owner)))
        
//        renderModels.append([PostRenderViewModel(renderType: .header(provider: model.owner))])
        // Post
//        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: model)))

        // Actions
//        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))
        
        // Caption
//        renderModels.append(PostRenderViewModel(renderType: .caption(provider: model)))

//        comments = model.comments
        
//    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        homeView.teamTableView.delegate = self
        homeView.teamTableView.dataSource = self
        handleNotAuthenticated()
        
    }
    
    // MARK: - Methods
    
    private func handleNotAuthenticated() {
        // Check auth status
        if Auth.auth().currentUser == nil {
            // Show log in
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
    }
    
    

}

//MARK: - TableViewDelegate,TableViewDataSource
extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.cellKey, for: indexPath)
        
        return cell
    }
    
    
    
}

