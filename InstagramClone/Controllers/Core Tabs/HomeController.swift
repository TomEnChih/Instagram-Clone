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
    
    private let homeView = HomeTestView()
    
    private var posts = [PostTest]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        handleNotAuthenticated()
        
        homeView.homeCollectionView.delegate = self
        homeView.homeCollectionView.dataSource = self
        
        setupNavigationItems()
        fetchPosts()
//        fetchFollowingUserEmail()
        
        let refreshController = UIRefreshControl()
        homeView.homeCollectionView.addSubview(refreshController)
        refreshController.tintColor = .black
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName , object: nil)
    }
    
    // MARK: - Methods
    
    private func setupNavigationItems() {
        let titleImageView = UIImageView(image: UIImage(named: "text"))
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(handleCamera))
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
            
            self.homeView.homeCollectionView.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String:Any] else { return }
                
                var post = PostTest(user: user, dictionary: dictionary)
                post.id = key ///用於 comment
                
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
    
    @objc func handleCamera() {
        let vc = CameraController()
        present(vc, animated: true, completion: nil)
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
    
    func didTapLike() {
        
    }
    
    func didTapComment(post: PostTest) {
        print(post.caption)
        let vc = PostCommentVC()
        vc.post = post
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
