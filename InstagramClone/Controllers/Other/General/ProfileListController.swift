//
//  ProfileListController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/18.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileListController: UIViewController {

    // MARK: - Properties
    
    private let listView = HomeView()
    
    private var posts: [PostTest]
    private var index: IndexPath
    
    var isUsed = false
    // MARK: - Init
    
    init(posts: [PostTest],index: IndexPath) {
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
}

//MARK: - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension ProfileListController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
extension ProfileListController: HomePostButtonDelegate {
    
    func didTapLike(for cell: HomePostCell) {
        guard let indexPath = listView.homeCollectionView.indexPath(for: cell) else { return }
        
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
            self.listView.homeCollectionView.reloadItems(at: [indexPath])
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
        guard let indexPath = listView.homeCollectionView.indexPath(for: cell) else { return }
        
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
            self.listView.homeCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    
}

