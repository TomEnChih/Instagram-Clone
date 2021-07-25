//
//  ExploreVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class UserSearchController: UIViewController {
    
    // MARK: - Properties
    
    private let userSearchView = UserSearchView()
    
    private var users = [Observable<UserTest>]()
    private var filteredUsers = [Observable<UserTest>]()
    
    private var refreshControl: UIRefreshControl!
    
    // MARK: - IBElements
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = userSearchView
        setupKeyboardObservers()
        userSearchView.userSearchCollectionView.dataSource = self
        userSearchView.userSearchCollectionView.delegate = self
        setupRefreshControl()
        configureSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleRefresh()
    }
    
    private func configureSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
        
    // MARK: - Methods
    
    //MARK: fetch Data
    private func fetchUser() {
        DatabaseManager.shared.fetchUserWithoutOneself { (email, dictionary) in
            
            self.refreshControl.endRefreshing()
            
            let user = Observable<UserTest>(UserTest(email: email, dictionary: dictionary))
            self.users.append(user)
            
            self.users.sort { (u1, u2) -> Bool in
                return u1.value?.username.compare(u2.value!.username) == .orderedAscending
            }
            
            self.filteredUsers = self.users
            /// 還是要加
            self.userSearchView.userSearchCollectionView.reloadData()
        }
    }
    
    //MARK: RefreshControl
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        userSearchView.userSearchCollectionView.addSubview(refreshControl)
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc func handleRefresh() {
        print("handling refresh ...")
        users.removeAll()
        fetchUser()
    }
    
    //MARK: tableView隨keyboard調整
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let height = (keyboardFrame?.cgRectValue.height)
        userSearchView.userSearchCollectionView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_topMargin)
            make.bottom.equalTo(self.view).offset(-height!)
        }
        
        let keyboardDuration = notification.userInfo? [UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        userSearchView.userSearchCollectionView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_topMargin)
            make.bottom.equalTo(self.view.snp_bottomMargin)
        }
        
        let keyboardDuration = notification.userInfo? [UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - CollectionViewDataSource,CollectionViewDelegateFlowLayout

extension UserSearchController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchCell.id, for: indexPath) as! UserSearchCell
        
        filteredUsers[indexPath.item].bind { (user) in
            cell.configure(with: user!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.item].value
        let vc = UserProfileController()
        vc.userEmail = user?.email
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
                return (user.value?.username.lowercased().contains(searchText.lowercased()))!
            }
        }
        /// 還是要加...
        userSearchView.userSearchCollectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didCancelSearch))
    }
    
    @objc private func didCancelSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
}
