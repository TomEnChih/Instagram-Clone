//
//  HomeController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/11.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let homeView = HomeView()
    
    private var posts = [PostTest]()
    
    var refreshControl: UIRefreshControl!
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        handleNotAuthenticated()
        
        homeView.homeCollectionView.delegate = self
        homeView.homeCollectionView.dataSource = self
        
        setupNavigationItems()
        setupRefreshControl()
        fetchPosts()
//        fetchFollowingUserEmail()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName , object: nil)
    }
    
    // MARK: - Methods
    
    private func setupNavigationItems() {
        let titleImageView = UIImageView(image: UIImage(named: "text"))
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        homeView.homeCollectionView.addSubview(refreshControl)
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func handleNotAuthenticated() {
        // Check auth status
        if Auth.auth().currentUser == nil {
            // Show log in
            let loginVC = LoginController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
    }
    
    private func fetchPosts() {
        guard let email = Auth.auth().currentUser?.email else { return }
        
        Database.fetchUserWithEmail(with: email) { user in
            
            self.fetchPostsWithUser(with: user)
            self.fetchFollowingUserEmail()
        }
    }
    
    private func fetchPostsWithUser(with user: UserTest) {
        
        let safeEmail = user.email.safeDatabaseKey()
        
        let ref = Database.database().reference().child("posts").child(safeEmail)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            self.refreshControl.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String:Any] else { return }
                
                var post = PostTest(user: user, dictionary: dictionary)
                post.id = key ///用於 comment
                
                guard let email = Auth.auth().currentUser?.email else { return }
                let safeUserEmail = email.safeDatabaseKey()
                
                Database.database().reference().child("likes").child(key).child(safeUserEmail).observeSingleEvent(of: .value) { (snapshot) in
                    print(post.id,snapshot.value)
                    if let value = snapshot.value as? Int,value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    print(post.id,snapshot.value,post.hasLiked)
                }
                
                self.posts.append(post)
            }
            self.posts.sort { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            }
            self.homeView.homeCollectionView.reloadData()
        }
    }
    
    private func fetchFollowingUserEmail() {
        guard let email = Auth.auth().currentUser?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        
        Database.database().reference().child("following").child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard let userEmailDictionary = snapshot.value as? [String:Any] else { return }
            
            userEmailDictionary.forEach { (key,value) in
                Database.fetchUserWithEmail(with: key) { (user) in
                    self.fetchPostsWithUser(with: user)
                }
            }
        }
    }
    
    @objc func handleRefresh() {
        print("handling refresh ...")
        posts.removeAll()
        fetchPosts()
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
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
        cell.post = posts[indexPath.item]
        
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
        
        var post = posts[indexPath.item]
        
        guard let postId = post.id else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        let values = [safeEmail: post.hasLiked == true ? 0 : 1]
        
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to like post:",error)
                return
            }
            print("Successfully liked post.")
            post.hasLiked = !post.hasLiked ///post 跟 posts 無關，需要把他帶換掉 posts[indexPath.item]
            self.posts[indexPath.item] = post
            self.homeView.homeCollectionView.reloadItems(at: [indexPath])
        }

    }
    
    func didTapComment(post: PostTest) {
        print(post.caption)
        let vc = PostCommentController()
        vc.post = post
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapSave(for cell: HomePostCell) {
        guard let indexPath = homeView.homeCollectionView.indexPath(for: cell) else { return }
        
        var post = posts[indexPath.item]
        
        guard let postId = post.id else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        let values = [safeEmail: post.hasSaved == true ? 0 : 1]
        
        Database.database().reference().child("save").child(postId).updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to save post:",error)
                return
            }
            print("Successfully saved post.")
            post.hasSaved = !post.hasSaved
            self.posts[indexPath.item] = post
            self.homeView.homeCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    
}
