//
//  ViewController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/23.
//

import UIKit
import FirebaseAuth

struct HomeFeedRenderViewModel {
    
}



class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private let homeView = HomeView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        homeView.teamTableView.delegate = self
        homeView.teamTableView.dataSource = self
        handleNotAuthenticated()
        
    }
    
    // MARK: - Methods
    
    private func handleNotAuthenticated() {
        // Check auth status
        if Auth.auth().currentUser == nil {
            // Show log in
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
    }

}

//MARK: - TableViewDelegate,TableViewDataSource
extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.cellKey, for: indexPath)
        
        return cell
    }
    
    
    
}

