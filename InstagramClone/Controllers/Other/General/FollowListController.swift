//
//  FollowListController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/20.
//

import UIKit

class FollowListController: UIViewController {

    // MARK: - Properties
    
    private let listView = UserSearchView()
    
    private var emails = [String]()
    
    private var followUsers = [UserTest]()
    // MARK: - Init
    
    init(emails: [String]) {
        self.emails = emails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = listView
        listView.userSearchCollectionView.delegate = self
        listView.userSearchCollectionView.dataSource = self
        fetchUsers()
    }

    // MARK: - Methods
    
    private func fetchUsers() {
        emails.forEach { (email) in
            
            DatabaseManager.shared.fetchUserWithEmail(with: email) { (user) in
                
                self.followUsers.append(user)
                self.listView.userSearchCollectionView.reloadData()
            }
        }
    }
    
}

//MARK: - CollectionViewDataSource,CollectionViewDelegateFlowLayout

extension FollowListController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        followUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchCell.id, for: indexPath) as! UserSearchCell
        
        let user = followUsers[indexPath.item]
        
        cell.configure(with: user)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = UserProfileController()
        vc.userEmail = followUsers[indexPath.item].email
        navigationController?.pushViewController(vc, animated: true)
    }
}

