//
//  HomeController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/11.
//

import UIKit
import FirebaseAuth

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let homeView = HomeView()
    
    private var posts = [Observable<PostTest>]() {
        didSet {
            homeView.homeCollectionView.reloadData()
        }
    }
    
    private var refreshControl: UIRefreshControl!
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        handleNotAuthenticated()
        
        homeView.homeCollectionView.delegate = self
        homeView.homeCollectionView.dataSource = self
        
        setupNavigationItems()
        setupRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleRefresh()
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
    
    private func setupNavigationItems() {
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "text"), for: .normal)
        button.addTarget(self, action: #selector(handleScrollToTop), for: .touchUpInside)
        
        self.navigationItem.titleView = button
    }
    
    @objc func handleScrollToTop() {
        homeView.homeCollectionView.scrollTo(direction: .top)
    }
    
    //MARK: fetch Data
    /// 有追蹤的條件下，才會顯示
    private func fetchPosts() {
        let email = AuthManager.shared.fetchCurrentUserEmail()
        DatabaseManager.shared.fetchUserWithEmail(with: email) { (user) in
            self.fetchPostsWithUser(with: user)
            self.fetchFollowingUserEmail(email: email)
        }
    }
    
    private func fetchFollowingUserEmail(email: String) {
        
        DatabaseManager.shared.fetchFollowingEmail(userEmail: email) { (email) in
            DatabaseManager.shared.fetchUserWithEmail(with: email) { (user) in
                self.fetchPostsWithUser(with: user)
            }
        }
    }
    
    private func fetchPostsWithUser(with user: UserTest) {
        
        DatabaseManager.shared.fetchPostsWithEmail(with: user.email) { (id, dictionary) in
            
            self.refreshControl.endRefreshing()
            
            let post = Observable<PostTest>(PostTest(user: user, dictionary: dictionary))
            post.value?.id = id ///用於 comment
            
            DatabaseManager.shared.fetchPostLike(userEmail: AuthManager.shared.fetchCurrentUserEmail(), postId: id) { (hasLiked) in
                post.value?.hasLiked = hasLiked
            }
            DatabaseManager.shared.fetchPostSave(userEmail: AuthManager.shared.fetchCurrentUserEmail(),postId: id) { (hasSaved) in
                post.value?.hasSaved = hasSaved
            }
            
            self.posts.append(post)
            self.posts.sort { (p1, p2) -> Bool in
                return p1.value!.creationDate.compare(p2.value!.creationDate) == .orderedDescending
            }
            self.homeView.homeCollectionView.reloadData()
            
        }
    }
    
    //MARK: RefreshControl
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        homeView.homeCollectionView.addSubview(refreshControl)
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc func handleRefresh() {
        print("handling refresh ...")
        posts.removeAll()
        fetchPosts()
    }
}

//MARK: - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.id, for: indexPath) as! HomePostCell
        
        cell.delegate = self
        posts[indexPath.item].bind { (post) in
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
extension HomeController: HomePostButtonDelegate {
    
    func didTapLike(for cell: HomePostCell) {
        guard let indexPath = homeView.homeCollectionView.indexPath(for: cell) else { return }
        let post = posts[indexPath.item]
        
        guard let postId = post.value?.id else { return }
        guard let hasLiked =  post.value?.hasLiked else { return }
        
        DatabaseManager.shared.uploadPostLike(postId: postId, hasLiked: hasLiked) { change in
            post.value?.hasLiked = change ///post 跟 posts 無關，需要把他帶換掉 posts[indexPath.item]
//            self.posts[indexPath.item] = post
//            self.homeView.homeCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func didTapComment(post: PostTest) {
        let vc = PostCommentController(post: post)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapSave(for cell: HomePostCell) {
        guard let indexPath = homeView.homeCollectionView.indexPath(for: cell) else { return }
        let post = posts[indexPath.item]
        
        guard let postId = post.value?.id else { return }
        guard let hasSaved =  post.value?.hasSaved else { return }
        
        DatabaseManager.shared.uploadPostSave(postId: postId, hasSaved: hasSaved) { (change) in
            post.value?.hasSaved = change
        }
    }
    
    
}
