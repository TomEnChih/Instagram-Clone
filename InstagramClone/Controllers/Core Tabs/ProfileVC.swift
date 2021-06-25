//
//  ProfileVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class ProfileVC: UIViewController {

    // MARK: - Properties
    
    private let profileView = ProfileView()
    private let profileSection: [Profile] = [.Information,.Article]
    private let userPost : [UserPost] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        profileView.prfileArticleCollectionView.delegate = self
        profileView.prfileArticleCollectionView.dataSource = self
        configureNavigationBar()
    }
    
    // MARK: - Methods
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettingsButton))
    }
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsVC()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - CollectionViewDataSource
extension ProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        profileSection.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch profileSection[section] {
        case .Information:
            return 1
        case .Article:
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch profileSection[indexPath.section] {
        case .Information:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileInformationCollectionViewCell.cellkey, for: indexPath) as! ProfileInformationCollectionViewCell
            
            cell.nameLabel.text = "tom tung"
            cell.bioLabel.text = "hello,it is my first account."
            
            cell.editProfileAction = {
                let vc = EditProfileVC()
                vc.title = "編輯個人資訊"
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            }
            
            return cell
            
        case .Article:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
            
            cell.backgroundColor = .systemBlue
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (profileView.prfileArticleCollectionView.frame.width - 4)/3
        
        switch profileSection[indexPath.section] {
        case .Information:
            return CGSize(width: profileView.prfileArticleCollectionView.frame.width, height: profileView.prfileArticleCollectionView.frame.height/3)
        case .Article:
            return CGSize(width: size, height: size)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = userPost[indexPath.row]
        switch profileSection[indexPath.section] {
        case .Information: break
        case .Article: break
//            let vc = ArticleVC(model: nil)
//            vc.title = "tom Test"
//            vc.navigationItem.largeTitleDisplayMode = .never
//            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
