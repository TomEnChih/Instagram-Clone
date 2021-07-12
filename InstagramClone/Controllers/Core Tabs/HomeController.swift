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
        
        homeView.homeCollectionView.delegate = self
        homeView.homeCollectionView.dataSource = self
        
        setupNavigationItems()
        handleNotAuthenticated()
        fetchPosts()
    }
    
    // MARK: - Methods
    
    private func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "text"))
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
        }
    }
    
    private func fetchPostsWithUser(with user: UserTest) {
        
        let safeEmail = user.email.safeDatabaseKey()
        
        let ref = Database.database().reference().child("posts").child(safeEmail)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            dictionaries.forEach { (key, value) in
                print("key \(key), value \(value)")
                
                guard let dictionary = value as? [String:Any] else { return }
                
                let post = PostTest(user: user, dictionary: dictionary)
                self.posts.append(post)
                
            }
            
            self.homeView.homeCollectionView.reloadData()
        }
    }
    
    
}

//MARK: - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.id, for: indexPath) as! HomePostCell
        
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
