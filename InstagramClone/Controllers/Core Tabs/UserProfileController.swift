//
//  ProfileVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class UserProfileController: UIViewController {
    
    // MARK: - Properties
    
    private let userProfileView = UserProfileView()
    
    private var allPosts = [Observable<PostTest>]()
    private var posts = [Observable<PostTest>]()
    private var savePosts = [Observable<PostTest>]()
    
    private var user: Observable<UserTest>?
    
    var userEmail: String?
    
    var isGridView = true
    
    var following = [String]() {
        didSet {
            self.userProfileView.prfileCollectionView.reloadData()
        }
    }
    
    var follower = [String]() {
        didSet {
            self.userProfileView.prfileCollectionView.reloadData()
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = userProfileView
        userProfileView.prfileCollectionView.delegate = self
        userProfileView.prfileCollectionView.dataSource = self
        setupNavigationButtons()
        fetchUser()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser), name: EditProfileController.editProfileNotificationName, object: nil)
    }
    
    
    // MARK: - Methods
    func setupNavigationButtons() {
        let button = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                     style: .done,
                                     target: self,
                                     action: #selector(didTapSettingsButton))
        button.tintColor = .black
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsVC()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchFollowerAndFollowing(){
        guard let email = self.user?.value?.email else { return }
        
        DatabaseManager.shared.fetchFollowerEmail(userEmail: email) { (email) in
            self.follower.append(email)
        }
        
        DatabaseManager.shared.fetchFollowingEmail(userEmail: email) { (followingEmail) in
            self.following.append(followingEmail)
            
            DatabaseManager.shared.fetchUserWithEmail(with: followingEmail) { (user) in
                self.fetchSavePostsWithUser(with: user)
            }
        }
    }
    
    @objc func updateUser() {
        let email = AuthManager.shared.fetchCurrentUserEmail()

        DatabaseManager.shared.fetchUserWithEmail(with: email) { (user) in
            self.user = Observable<UserTest>(user)
            self.navigationItem.title = user.username
            /// 要加
            self.userProfileView.prfileCollectionView.reloadData()
        }
    }

    
    private func fetchUser() {
        let email = userEmail ?? AuthManager.shared.fetchCurrentUserEmail()
        
        DatabaseManager.shared.fetchUserWithEmail(with: email) { (user) in
            self.user = Observable<UserTest>(user)
            self.navigationItem.title = user.username
            
            self.fetchFollowerAndFollowing()
            self.fetchPostsWithUser(with: user)
        }
    }
    
    private func fetchPostsWithUser(with user: UserTest) {
        
        DatabaseManager.shared.fetchPostsWithEmail(with: user.email) { (id, dictionary) in
                        
            let post = Observable<PostTest>(PostTest(user: user, dictionary: dictionary))
            post.value?.id = id ///用於 comment
            
            DatabaseManager.shared.fetchPostLike(postId: id) { (hasLiked) in
                post.value?.hasLiked = hasLiked
            }
            DatabaseManager.shared.fetchPostSave(postId: id) { (hasSaved) in
                post.value?.hasSaved = hasSaved
            }
            
            self.posts.append(post)
            self.posts.sort { (p1, p2) -> Bool in
                return p1.value!.creationDate.compare(p2.value!.creationDate) == .orderedDescending
            }
            
            self.allPosts.append(post)
            self.allPosts.sort { (p1, p2) -> Bool in
                return p1.value!.creationDate.compare(p2.value!.creationDate) == .orderedDescending
            }
            self.deletePostNoSave()
            self.userProfileView.prfileCollectionView.reloadData()
        }
    }
    
    private func fetchSavePostsWithUser(with user: UserTest) {
        
        DatabaseManager.shared.fetchPostsWithEmail(with: user.email) { (id, dictionary) in
                        
            let post = Observable<PostTest>(PostTest(user: user, dictionary: dictionary))
            post.value?.id = id ///用於 comment
            
            DatabaseManager.shared.fetchPostLike(postId: id) { (hasLiked) in
                post.value?.hasLiked = hasLiked
            }
            DatabaseManager.shared.fetchPostSave(postId: id) { (hasSaved) in
                post.value?.hasSaved = hasSaved
            }
            
            self.allPosts.append(post)
            self.allPosts.sort { (p1, p2) -> Bool in
                return p1.value!.creationDate.compare(p2.value!.creationDate) == .orderedDescending
            }
            self.deletePostNoSave()
            self.userProfileView.prfileCollectionView.reloadData()
        }
    }
    
    private func deletePostNoSave(){
        allPosts.forEach { (post) in
            if post.value?.hasSaved == true {
                savePosts.append(post)
                savePosts.sort { (p1, p2) -> Bool in
                    return p1.value!.creationDate.compare(p2.value!.creationDate) == .orderedDescending
                }
            }
        }
    }
    
}

//MARK: - CollectionViewDataSource
extension UserProfileController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isGridView {
            return posts.count
        } else {
            return savePosts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoCell.id, for: indexPath) as! UserProfilePhotoCell
            
            posts[indexPath.item].bind { (post) in
                cell.configure(with: post!)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoCell.id, for: indexPath) as! UserProfilePhotoCell
            
            savePosts[indexPath.item].bind { (post) in
                cell.configure(with: post!)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let articleCellSize = (userProfileView.prfileCollectionView.frame.width - 4)/3
            
            return CGSize(width: articleCellSize, height: articleCellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var testPost = [Observable<PostTest>]()
        
        if isGridView {
            testPost = posts
        } else {
            testPost = savePosts
        }
        
        let vc = ProfileListController(posts: testPost, index: indexPath)
        vc.modalPresentationStyle = .formSheet
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            //footer
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeader.id, for: indexPath) as! UserProfileHeader
        
        user?.bind({ (user) in
            header.configure(with: user!, postCount: String(self.posts.count), followerCount: String(self.follower.count), followingCount: String(self.following.count), isGridView: self.isGridView)
        })
        
        header.delegate = self
        
        
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(item: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
    }
    
}

//MARK: - UserProfileButtonDelegate
extension UserProfileController: UserProfileButtonDelegate {
    
    func didChangeToGridView() {
        isGridView = true
        userProfileView.prfileCollectionView.reloadData()
    }
    
    func didChangeToTaggedView() {
        isGridView = false
        userProfileView.prfileCollectionView.reloadData()
    }
    
    func didTapEditProfile() {
        
        guard let user = user?.value else { return }
        
        let vc = EditProfileController(user: user)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
}
