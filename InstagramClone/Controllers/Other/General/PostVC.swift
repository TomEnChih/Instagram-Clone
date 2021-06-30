//
//  PostVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class PostVC: UIViewController {
    
    // MARK: - Properties
    
    private var userPost: UserPost
    // MARK: - Init
    
    init(model: UserPost) {
        self.userPost = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Methods

}
