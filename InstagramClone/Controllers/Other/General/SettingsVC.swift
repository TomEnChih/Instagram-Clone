//
//  SettingsVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
import SafariServices

struct SettingCellModel {
    let title: String
    let handle: (()->Void)
}

class SettingsVC: UIViewController {
    
    // MARK: - Properties
    
    private let settingsView = SettingsView()
    private var data = [ [SettingCellModel]]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = settingsView
        settingsView.settingsTableVeiw.dataSource = self
        settingsView.settingsTableVeiw.delegate = self
        
        configureModels()
    }
    
    // MARK: - Methods
    ///一個參數 title 為 Log Out, 帶有 handle
    private func configureModels() {
        data.append([
            SettingCellModel(title: "Edit Profile") { [weak self] in
                
            },
            SettingCellModel(title: "Invite Friends") { [weak self] in
                self?.didtapInviteFriends()
            },
            SettingCellModel(title: "Save original Posts") { [weak self] in
                self?.didTapSaveOriginalPosts()
            }
        ])
        
        
        data.append([
            SettingCellModel(title: "Terms of Service") { [weak self] in
                self?.openURL(type: .terms)
            },
            SettingCellModel(title: "Privacy Policy") { [weak self] in
                self?.openURL(type: .privacy)
            },
            SettingCellModel(title: "Help / Feedback") { [weak self] in
                self?.openURL(type: .help)
            }
        ])
        
        data.append([
            SettingCellModel(title: "Log Out") { [weak self] in
                self?.didTapLogOut()
            }
        ])
    }
    
    enum SettingsURLType {
        case terms, privacy, help
    }
    
    private func openURL(type: SettingsURLType) {
        let urlString: String
        
        switch type {
        case .terms: urlString = "https://www.instagram.com/about/legal/terms/before-january-19-2013/"
        case .privacy: urlString = "https://help.instagram.com/519522125107875"
        case .help: urlString = "https://help.instagram.com/"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    private func didtapInviteFriends() {
        // Show share sheet to invite friends
    }
    
    private func didTapSaveOriginalPosts() {
        
    }
    
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive,handler: { (_) in
            AuthManager.shared.logOut { (success) in
                DispatchQueue.main.async {
                    if success {
                        //present log in
                        let loginVC = LoginController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            /// 不然 ProfileVC 會停在 SettingsVC
                            self.navigationController?.popViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    } else {
                        //error
                        fatalError("Could not Log Out user")
                    }
                }
            }
        }))
        actionSheet.popoverPresentationController?.sourceView = settingsView.settingsTableVeiw
        actionSheet.popoverPresentationController?.sourceRect = settingsView.bounds
        present(actionSheet, animated: true, completion: nil)
        
    }
    
}

//MARK: -TableViewDelegate,TableViewDataSource
extension SettingsVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsTableVeiwCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ///點到特定 cell ，執行裡頭 handle
        data[indexPath.section][indexPath.row].handle()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
