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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = userProfileView
        userProfileView.prfileCollectionView.delegate = self
        userProfileView.prfileCollectionView.dataSource = self
        setupNavigationButtons()
        fetchUser()
//        fetchOrderedPosts()
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
    
//    func setupProfileImage() {
//
//        guard let profileImageURL = user?.profileImageURL else { return }
//
//        guard let url = URL(string: profileImageURL) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data,_,error) in
//
//            guard error == nil,
//                  let data = data else { return }
//
//            let image = UIImage(data: data)
//
//            DispatchQueue.main.async {
//                //                self.userProfileView.prfileCollectionView.
//            }
//        }
//
//    }
    
    
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
        }
        
//        let ref = Database.database().reference().child("user").child(safeEmail)
//
//        ref.observe(.value) { (snapshot) in
//            guard let dictionary = snapshot.value as? [String:Any] else {
//                return
//            }
//            let user = UserTest(email: safeEmail, dictionary: dictionary)
//
//            self.user = user
//            self.navigationItem.title = user.username
//
//            self.fetchOrderedPosts()
//        }
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
            self.posts.append(post)
            self.userProfileView.prfileCollectionView.reloadData()
        }
        
        self.userProfileView.prfileCollectionView.reloadData()
    }
    
    private func fetchPosts() {
        guard let email = Auth.auth().currentUser?.email else { return }
        
        let safeEmail = email.safeDatabaseKey()
        let ref = Database.database().reference().child("posts").child(safeEmail)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            dictionaries.forEach { (key, value) in
                print("key \(key), value \(value)")
                
                guard let dictionary = value as? [String:Any] else { return }
                
                guard let user = self.user else { return }

                let post = PostTest(user: user, dictionary: dictionary)
                self.posts.append(post)
                
            }
            
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoCell.id, for: indexPath) as! UserProfilePhotoCell
        
        cell.photoImageView.image = nil
        
        cell.post = posts[indexPath.item]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let articleCellSize = (userProfileView.prfileCollectionView.frame.width - 4)/3
        
        return CGSize(width: articleCellSize, height: articleCellSize)
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

