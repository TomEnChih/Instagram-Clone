//
//  ExploreVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserSearchController: UIViewController {
    
    // MARK: - Properties
    
    private let userSearchView = UserSearchView()
    
    private var users = [UserTest]()
    private var filteredUsers = [UserTest]()
    
    // MARK: - IBElements
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
//    private let dimmedView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .red
//        view.isHidden = true
//        view.alpha = 0
//
//        return view
//    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = userSearchView
//        view.addSubview(dimmedView)
        
        userSearchView.userSearchCollectionView.dataSource = self
        userSearchView.userSearchCollectionView.delegate = self
        
        configureSearchBar()
//        configureDimmedView()
        
        fetchUser()
    }
    
//    private func configureDimmedView() {
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
//        gesture.numberOfTapsRequired = 1
//        gesture.numberOfTouchesRequired = 1
//        userSearchView.userSearchCollectionView.addGestureRecognizer(gesture)
//    }
    
    private func configureSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        dimmedView.frame = view.bounds
//    }
    
    // MARK: - Methods
    
    private func fetchUser() {
         
        let ref = Database.database().reference().child("user")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            dictionaries.forEach { (key,value) in
                
                if key == Auth.auth().currentUser?.email?.safeDatabaseKey() {
                    return /// 搜尋不包含自己
                }
                
                guard let userDictionary = value as? [String:Any] else { return }
                
                let user = UserTest(email: key, dictionary: userDictionary)
                self.users.append(user)
            }
            
            self.users.sort { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            }
            self.filteredUsers = self.users
            self.userSearchView.userSearchCollectionView.reloadData()
        }
    }
    
}

//MARK: -

extension UserSearchController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchCell.id, for: indexPath) as! UserSearchCell
        
        cell.user = filteredUsers[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.item]
        let vc = UserProfileController()
        vc.userEmail = user.email
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK: - SearchBarDelegate

extension UserSearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        userSearchView.userSearchCollectionView.reloadData()
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        didCancelSearch()
//
//        guard let text = searchBar.text, !text.isEmpty else { return }
//
//        query(text)
//    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didCancelSearch))
    
//        dimmedView.isHidden = false
//        UIView.animate(withDuration: 0.2) {
//            self.dimmedView.alpha = 0.4
//        }
    }
    
    @objc private func didCancelSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
//        UIView.animate(withDuration: 0.2,animations: { self.dimmedView.alpha = 0 }) { done in
//            if done {
//                self.dimmedView.isHidden = true
//            }
//        }
    }
    
    
//    private func query(_ text: String) {
//         perform the search in the back end
//    }
}
