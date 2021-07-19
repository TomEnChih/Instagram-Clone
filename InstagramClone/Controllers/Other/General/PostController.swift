//
//  PostController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/17.
//

import UIKit

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
        fetchPostLikeAndSave()
    }
    

    // MARK: - Methods
    
    private func fetchPostLikeAndSave() {
        DatabaseManager.shared.fetchPostLike(postId: post.value!.id!) { (hasLiked) in
            self.post.value?.hasLiked = hasLiked
        }
        DatabaseManager.shared.fetchPostSave(postId: post.value!.id!) { (hasSaved) in
            self.post.value?.hasSaved = hasSaved
        }
    }
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
        
        guard let postId = post.value?.id else { return }
        guard let hasLiked =  post.value?.hasLiked else { return }
        
        DatabaseManager.shared.uploadPostLike(postId: postId, hasLiked: hasLiked) { change in
            self.post.value?.hasLiked = change
        }
    }
    
    func didTapComment(post: PostTest) {
        let vc = PostCommentController(post: post)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapSave(for cell: HomePostCell) {
        
        guard let postId = post.value?.id else { return }
        guard let hasSaved =  post.value?.hasSaved else { return }
        
        DatabaseManager.shared.uploadPostSave(postId: postId, hasSaved: hasSaved) { (change) in
            self.post.value?.hasSaved = change
        }
    }
    
    
}
