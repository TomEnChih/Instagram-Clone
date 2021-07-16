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
    
    private var posts = [PostTest]()
    
    private var user: UserTest?
    
    var userEmail: String?
    
    var isGridView = true
    var isFinishedPaging = false
    
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
        guard let email = self.user?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        
        let ref = Database.database().reference().child("follower").child(safeEmail)
        ref.observe(.value) { (snapshot) in
            
            self.follower = String(snapshot.childrenCount)
        }
    }
    
    func fetchFollowing(){
        guard let email = self.user?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        
        //        var tempSet = Set<String>()
        
        let ref = Database.database().reference().child("following").child(safeEmail)
        ref.observe(.value) { (snapshot) in
            
            self.following = String(snapshot.childrenCount)
        }
        
    }
    
    @objc func updateUser() {
        guard let email = Auth.auth().currentUser?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        
        Database.fetchUserWithEmail(with: safeEmail) { (user) in
            
            self.user = user
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
            
            self.user = user
            self.navigationItem.title = user.username
            
            self.fetchOrderedPosts()
            self.fetchFollowing()
            self.fetchFollower()
        }
    }
    
    func peginatePosts() {
        guard let email = self.user?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        
        let ref = Database.database().reference().child("posts").child(safeEmail)
        //        var query = ref.queryOrdered(byChild: "creationDate")
        var query = ref.queryOrderedByKey()
        
        if posts.count > 0 {
            let value = posts.last?.id
            
            //            let value = posts.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding (atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.posts.count > 0 && allObjects.count > 0 {
                allObjects .removeFirst()
            }
            
            guard let user = self.user else { return }
            
            allObjects.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else { return }
                var post = PostTest(user: user, dictionary: dictionary)
                
                post.id = snapshot.key
                self.posts.append(post)
            })
            self.posts.forEach { (post) in
                print("postid:",post.id)
            }
            
            self.posts.sort { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedAscending
            }
            self.userProfileView.prfileCollectionView.reloadData()
        }
    }
    
    
    
    func fetchOrderedPosts() {
        //        guard let email = Auth.auth().currentUser?.email else { return }
        
        guard let email = self.user?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        
        let ref = Database.database().reference().child("posts").child(safeEmail)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            
            guard let user = self.user else { return }
            
            let post = PostTest(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)
            self.userProfileView.prfileCollectionView.reloadData()
        }
    }
    
}

//MARK: - CollectionViewDataSource
extension UserProfileController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //show you how to fire off the paginate cell
        //        if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
        //            peginatePosts()
        //        }
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoCell.id, for: indexPath) as! UserProfilePhotoCell
            
            cell.photoImageView.image = nil
            cell.post = posts[indexPath.item]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.id, for: indexPath) as! HomePostCell
            
            cell.post = posts[indexPath.item]
            
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
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            //footer
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeader.id, for: indexPath) as! UserProfileHeader
        
        header.user = user
        header.delegate = self
        header.setButtonTitle(String1: String(posts.count), String2: "貼文", button: header.postButton)
        header.setButtonTitle(String1: following, String2: "追蹤中", button: header.followeringButton)
        header.setButtonTitle(String1: follower, String2: "粉絲", button: header.followersButton)
        header.gridButton.tintColor = isGridView ? .systemBlue: .lightGray
        header.ListButton.tintColor = !isGridView ? .systemBlue: .lightGray
        
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(item: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
        //                return CGSize(width: userProfileView.prfileCollectionView.frame.width, height: 400)
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
        
        guard let user = user else { return }
        
        let vc = EditProfileController(user: user)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
}
