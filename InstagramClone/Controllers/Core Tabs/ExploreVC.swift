//
//  ExploreVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class ExploreVC: UIViewController {
    // MARK: - Properties
    private let exploreView = ExploreView()
    
    // MARK: - IBOutlets
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "搜尋"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dimmedView)
        
        configureSearchBar()
        configureDimmedView()
    }
    
    private func configureDimmedView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }
    
    private func configureSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dimmedView.frame = view.bounds
    }
    
    // MARK: - Autolayout
    
    
    
    // MARK: - Methods
    
    
    
}

//MARK: - SearchBarDelegate

extension ExploreVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        didCancelSearch()
        
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        query(text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didCancelSearch))
    
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = 0.4
        }
    }
    
    @objc private func didCancelSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        UIView.animate(withDuration: 0.2,animations: { self.dimmedView.alpha = 0 }) { done in
            if done {
                self.dimmedView.isHidden = true
            }
        }
    }
    
    
    private func query(_ text: String) {
        // perform the search in the back end
    }
}
