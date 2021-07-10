//
//  ProfileVC.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileVC: UIViewController {

    // MARK: - Properties
    
    private let profileView = ProfileView()
//    private let profileSection: [Profile] = [.Information,.Article]
    private let userPost : [UserPost] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        profileView.prfileCollectionView.delegate = self
        profileView.prfileCollectionView.dataSource = self
        configureNavigationBar()
        fetchUser()
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
    
    func fetchUser() {
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        
        let safeEmail = email.safeDatabaseKey()
        let ref = Database.database().reference().child("user").child(safeEmail)
        
        ref.observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {
                return
            }
            let user = UserTest(dictionary: dictionary)
            
            self.navigationItem.title = user.username
            
            self.profileView.prfileCollectionView.reloadData()
        }
    }
    
}

//MARK: - CollectionViewDataSource
extension ProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        profileSection.count
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch profileSection[section] {
//        case .Information:
//            return 1
//        case .Article:
////            return userPost.count
//            return 20
//        }
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        switch profileSection[indexPath.section] {
//        case .Information:
            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileInformationCollectionViewCell.cellkey, for: indexPath) as! ProfileInformationCollectionViewCell
//
//            cell.delegate = self
//
//            cell.nameLabel.text = "tom tung"
//            cell.bioLabel.text = "hello,it is my first account."
//
//            cell.editProfileAction = {
//                let vc = EditProfileVC()
//                vc.title = "編輯個人資訊"
//                let navVC = UINavigationController(rootViewController: vc)
//                navVC.modalPresentationStyle = .fullScreen
//                self.present(navVC, animated: true, completion: nil)
//            }
//
//            return cell
            
//        case .Article:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
            
//            let model = userPost[indexPath.row]
            
            
            cell.backgroundColor = .systemBlue
            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let articleCellSize = (profileView.prfileCollectionView.frame.width - 4)/3
        
//        switch profileSection[indexPath.section] {
//        case .Information:
//            return CGSize(width: profileView.prfileCollectionView.frame.width, height: profileView.prfileCollectionView.frame.height/3)
//        case .Article:
            return CGSize(width: articleCellSize, height: articleCellSize)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = userPost[indexPath.row]
        
//        switch profileSection[indexPath.section] {
        
//        case .Information: break
        
//        case .Article: break
//            let vc = PostVC(model: model)
//            vc.title = "tom Test"
//            vc.navigationItem.largeTitleDisplayMode = .never
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            //footer
            return UICollectionReusableView()
        }
        
//        switch profileSection[indexPath.section] {
//        case .Information:
//            break
//        case .Article:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileTabsCollectionReusableView.cellKey, for: indexPath) as! ProfileTabsCollectionReusableView
            
            return header
//        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        switch profileSection[section] {
//        case .Information:
//            return .zero
//        case .Article:
            return CGSize(width: profileView.prfileCollectionView.frame.width, height: 200)
//        }
    }
    
}

//MARK: - ProfileInformationCollectionViewCellDelegate
#warning("思考一下需不需要")
extension ProfileVC: ProfileInformationCollectionViewCellDelegate {
    
    func editProfileAction(_ cell: UICollectionViewCell) {
        let vc = EditProfileVC()
        vc.title = "編輯個人資訊"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    func profileDidTapPostButton(_ cell: UICollectionViewCell) {
//        let index = IndexPath()
//        let profileIndex = profileSection[index.section]
//
//        switch profileIndex {
//        case .Information:
//            break
//        case .Article:
//            profileView.prfilePostCollectionView.scrollToItem(at: IndexPath(row: 0, section: 1) , at: .top, animated: true)
//
//        }
    }
    
    func profileDidTapFollowersButton(_ cell: UICollectionViewCell) {
        var tomdata = [UserRelationship]()
        for x in 0...10 {
            tomdata.append(UserRelationship(username: "@tom", name: "tom", type: x % 2 == 0 ? .following:.unFollowing))
        }
        
        let vc = ListVC(data: tomdata)
        vc.title = "Followers"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileDidTapFolloweringButton(_ cell: UICollectionViewCell) {
        var tomdata = [UserRelationship]()
        for x in 0...10 {
            tomdata.append(UserRelationship(username: "@tom", name: "tom", type: x % 2 == 0 ? .following:.unFollowing))
        }
        
        let vc = ListVC(data: tomdata)
        vc.title = "Followering"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
