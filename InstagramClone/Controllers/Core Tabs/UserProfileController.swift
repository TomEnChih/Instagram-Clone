//
//  ProfileVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileController: UIViewController {
    
    // MARK: - Properties
    
    private let userProfileView = UserProfileView()
    
    private var posts = [Observable<PostTest>]()
    
    private var user: Observable<UserTest>?
    
    var userEmail: String?
    
    var isGridView = true
    
    var following = "" {
        didSet {
            self.userProfileView.prfileCollectionView.reloadData()
        }
    }
    
    var follower = "" {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettingsButton))
    }
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsVC()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchFollower(){
        guard let email = self.user?.value?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        
        let ref = Database.database().reference().child("follower").child(safeEmail)
        ref.observe(.value) { (snapshot) in
            
            self.follower = String(snapshot.childrenCount)
        }
    }
    
    func fetchFollowing(){
        guard let email = self.user?.value?.email else { return }
        let safeEmail = email.safeDatabaseKey()
                
        let ref = Database.database().reference().child("following").child(safeEmail)
        ref.observe(.value) { (snapshot) in
            
            self.following = String(snapshot.childrenCount)
        }
        
    }
    
    @objc func updateUser() {
        guard let email = Auth.auth().currentUser?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        
        Database.fetchUserWithEmail(with: safeEmail) { (user) in
            
            self.user = Observable<UserTest>(user)
            self.navigationItem.title = user.username
            self.userProfileView.prfileCollectionView.reloadData()
        }
        
    }
    
    #warning("database之後要整理")
    func fetchUser() {
        
        let email = userEmail ?? (Auth.auth().currentUser?.email ?? "")
        
        //        guard let email = Auth.auth().currentUser?.email else {
        //            return
        //        }
        
        Database.fetchUserWithEmail(with: email) { (user) in
            
            self.user = Observable<UserTest>(user)
            self.navigationItem.title = user.username
            
            self.fetchOrderedPosts()
            self.fetchFollowing()
            self.fetchFollower()
        }
    }
    
    func fetchOrderedPosts() {
        
        guard let email = self.user?.value?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        
        let ref = Database.database().reference().child("posts").child(safeEmail)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            
            guard let user = self.user?.value else { return }
            let post = Observable<PostTest>(PostTest(user: user, dictionary: dictionary))
            self.posts.insert(post, at: 0)
            self.userProfileView.prfileCollectionView.reloadData()
        }
    }
    
    func fetchSavedPosts() {
        
    }
    
}

//MARK: - CollectionViewDataSource
extension UserProfileController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoCell.id, for: indexPath) as! UserProfilePhotoCell
            
            posts[indexPath.item].bind { (post) in
                cell.configure(with: post!)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.id, for: indexPath) as! HomePostCell
            
            posts[indexPath.item].bind { (post) in
                cell.configure(with: post!)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridView {
            let articleCellSize = (userProfileView.prfileCollectionView.frame.width - 4)/3
            
            return CGSize(width: articleCellSize, height: articleCellSize)
        } else {
            var height:CGFloat = 110
            height += view.frame.width
            height += 120
            
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProfileListController(posts: posts, index: indexPath)
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
            header.configure(with: user!, postCount: String(self.posts.count), followerCount: self.follower, followingCount: self.following, isGridView: self.isGridView)
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

extension UserProfileController: UserProfileButtonDelegate {
    
    func didChangeToGridView() {
        isGridView = true
        userProfileView.prfileCollectionView.reloadData()
    }
    
    func didChangeToListView() {
        isGridView = false
        userProfileView.prfileCollectionView.reloadData()
        
    }
    
    func didChangeToTaggedView() {
        
    }
    
    func didTapEditProfile() {
        
        guard let user = user?.value else { return }
        
        let vc = EditProfileController(user: user)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
}
