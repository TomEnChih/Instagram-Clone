//
//  ViewController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/23.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        handleNotAuthenticated()
        
    }
    
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

