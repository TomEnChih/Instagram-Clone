//
//  NotificationsVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class NotificationsVC: UIViewController {
    
    // MARK: - Properties
    
    private let notificationsView = NotificationsView()
    
    private let noNotificationsView = NoNotificationsView()
    
    // MARK: - Init
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = noNotificationsView
        navigationController?.title = "Notifications"
        notificationsView.notificationsTableView.delegate = self
        notificationsView.notificationsTableView.dataSource = self
    }
    
    // MARK: - Methods

    
}

extension NotificationsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsTableView", for: indexPath)
        
        return cell
    }
    
    
}
