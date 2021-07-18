//
//  PostController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/17.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PostController: UIViewController {
    
    // MARK: - Properties
    
    private let postView = HomeView()
        
    var post: Observable<PostTest>
    
    // MARK: - Init
    
    init(with post: Observable<PostTest>) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = postView
        
        postView.homeCollectionView.delegate = self
        postView.homeCollectionView.dataSource = self
    }
    

    // MARK: - Methods
    
    
}

//MARK: - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension PostController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.id, for: indexPath) as! HomePostCell
        
        cell.delegate = self
        
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
extension PostController: HomePostButtonDelegate {
    
    func didTapLike(for cell: HomePostCell) {
        guard let indexPath = postView.homeCollectionView.indexPath(for: cell) else { return }
                
        guard let postId = post.value?.id else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        let values = [safeEmail: post.value?.hasLiked == true ? 0 : 1]
        
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to like post:",error)
                return
            }
            print("Successfully liked post.")
            self.post.value?.hasLiked = !self.post.value!.hasLiked ///post 跟 posts 無關，需要把他帶換掉 posts[indexPath.item]
//            self.postView.homeCollectionView.reloadItems(at: [indexPath])
        }

    }
    
    func didTapComment(post: PostTest) {
        print(post.caption)
        let vc = PostCommentController(post: post)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapSave(for cell: HomePostCell) {
        print("Save...")
    }
    
    
}

