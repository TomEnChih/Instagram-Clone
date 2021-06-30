//
//  ListVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class ListVC: UIViewController {
    // MARK: - Properties
    
    private let data: [UserRelationship]
    
    private let listView = ListView()
    
    // MARK: - Init
    
    init(data: [UserRelationship]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = listView
        listView.listTableView.dataSource = self
        listView.listTableView.delegate = self
    }

    // MARK: - Methods
    
    
}

extension ListVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserFollowTableViewCell.cellKey, for: indexPath) as! UserFollowTableViewCell
        
        cell.configure(with: data[indexPath.row])
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListVC: UserFollowTableViewCellDelegate {
    
    
    func didTapFollowUnFollowButton(model: UserRelationship) {
        switch model.type {
        case .following:
            // perform firebase update to unfollow
            break
        case .unFollowing:
            // perform firebase update to follow
            break
        }
    }
    
    
}
