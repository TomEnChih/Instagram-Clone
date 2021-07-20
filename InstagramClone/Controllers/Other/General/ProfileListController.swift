//
//  ProfileListController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/18.
//

import UIKit
//import FirebaseAuth
//import FirebaseDatabase

class ProfileListController: UIViewController {

    // MARK: - Properties
    
    private let listView = HomeView()
    
    private var posts: [Observable<PostTest>]
    private var index: IndexPath
    private var currentPosts = [Observable<PostTest>]()
    
    var isUsed = false
    // MARK: - Init
    
    init(posts: [Observable<PostTest>],index: IndexPath) {
        self.posts = posts
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = listView
        setupNavigationItems()
        listView.homeCollectionView.delegate = self
        listView.homeCollectionView.dataSource = self
        fetchHasSave()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isUsed {
            listView.homeCollectionView.scrollToItem(at: index, at: .centeredVertically, animated: true)
            isUsed = !isUsed
        }
    }

    // MARK: - Methods
    
    private func setupNavigationItems() {
        self.navigationItem.title = "Posts"
    }
    
    private func fetchHasSave() {
        
        posts.forEach { (post) in
            DatabaseManager.shared.fetchPostSave(userEmail: AuthManager.shared.fetchCurrentUserEmail(), postId: post.value!.id!) { (hasSaved) in
                post.value?.hasSaved = hasSaved
                self.currentPosts.append(post)
                self.listView.homeCollectionView.reloadData()
            }
        }
    }
    
    
}

//MARK: - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension ProfileListController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.id, for: indexPath) as! HomePostCell
        
        cell.delegate = self
        
        let post = currentPosts[indexPath.item]
        
        post.bind { (post) in
            cell.configure(with: post!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height:CGFloat = 110
        height += view.frame.width
        height += 120
        
        return CGSize(width: view.frame.width, height: height)
    }
    
}

//MARK: - HomePostButtonDelegate
extension ProfileListController: HomePostButtonDelegate {
    
    func didTapLike(for cell: HomePostCell) {
        guard let indexPath = listView.homeCollectionView.indexPath(for: cell) else { return }
        let post = currentPosts[indexPath.item]
        
        guard let postId = post.value?.id else { return }
        guard let hasLiked =  post.value?.hasLiked else { return }
        
        DatabaseManager.shared.uploadPostLike(postId: postId, hasLiked: hasLiked) { change in
            post.value?.hasLiked = change
        }
    }
    
    func didTapComment(post: PostTest) {
        let vc = PostCommentController(post: post)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapSave(for cell: HomePostCell) {
        guard let indexPath = listView.homeCollectionView.indexPath(for: cell) else { return }
        let post = currentPosts[indexPath.item]
        
        guard let postId = post.value?.id else { return }
        guard let hasSaved =  post.value?.hasSaved else { return }
        
        DatabaseManager.shared.uploadPostSave(postId: postId, hasSaved: hasSaved) { (change) in
            post.value?.hasSaved = change
        }
    }
    
    
}
