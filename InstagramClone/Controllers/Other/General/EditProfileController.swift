//
//  EditProfileController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct EditProfileModel {
    let label: String
    let placeholder: String
    var value: String?
}

class EditProfileController: UIViewController {
    
    // MARK: - Properties
    
    private let editProfileView = EditProfileView()
    
    private var models = [EditProfileModel]()
    
    var user: UserTest
    
    var isChangeProfileImage = false
    var selectedImage = UIImage()
    
    static let editProfileNotificationName = Notification.Name("editProfile")

    // MARK: - Init
    
    init(user: UserTest) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = editProfileView
        editProfileView.editProfileTableView.dataSource = self
        editProfileView.editProfileTableView.delegate = self
        configureNavigationBar()
        configureModels()
        
    }
    
    
    // MARK: - Methods
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(handleSave))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleCancel))
        
    }
    
    @objc private func handleSave() {
        saveAction()
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureModels() {
        //name, username, bio
        let section1Labels = ["Name": user.name,"Username": user.username,"Bio": user.bio]
        var section1 = [EditProfileModel]()
        for label in section1Labels {
            let model = EditProfileModel(label: label.key, placeholder: "Enter \(label.key)...", value: label.value)
            section1.append(model)
            section1.sort { (s1, s2) -> Bool in
                s1.label.count > s2.label.count
            }
        }
        models = section1
    }
    
    
    func saveAction() {
        
        if isChangeProfileImage {
            guard let uploadData = selectedImage.jpegData(compressionQuality: 0.5) else { return }
            
            navigationItem.rightBarButtonItem?.isEnabled = false
            
            let fileName = UUID().uuidString
            let ref = Storage.storage().reference().child("posts").child(fileName)
            ref.putData(uploadData, metadata: nil) { (metaData, error) in
                
                guard error == nil else {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print(error)
                    return
                }
                
                ref.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url else { return }
                    let downloadURLString = downloadURL.absoluteString
                    
                    self.saveToDatabaseWithImageURL(imageURL: downloadURLString)
                })
            }
        } else {
            self.saveToDatabaseWithImageURL(imageURL: user.profileImageURL)
        }
        
    }
    
    private func saveToDatabaseWithImageURL(imageURL: String) {
        
        guard let email = Auth.auth().currentUser?.email else { return }
        let safeEmail = email.safeDatabaseKey()
        
        let value = ["profileImageURL": imageURL,
                     "username": user.username,
                     "name": user.name ?? "",
                     "bio": user.bio ?? ""] as [String:Any]
        let ref = Database.database().reference().child("user").child(safeEmail)
        ref.updateChildValues(value) { (error, ref) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print(error)
                return
            }
            
            NotificationCenter.default.post(name: EditProfileController.editProfileNotificationName, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

//MARK: - TableViewDelegate,TableViewDataSource
extension EditProfileController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configureModels()
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileCell.id, for: indexPath) as!
            EditProfileCell
        
        cell.configure(with: model, index: indexPath)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: EditProfileHeaderView.id) as! EditProfileHeaderView
        
        headerView.delegate = self
        headerView.contentView.backgroundColor = .white
        
        if isChangeProfileImage {
            headerView.profilePhotoButton.setImage(selectedImage, for: .normal)
        } else {
            headerView.profilePhotoButton.loadingImage(url: URL(string: user.profileImageURL)!)
        }
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.bounds.height/5
    }
    
}


//MARK: - EditProfileCellDelegate
extension EditProfileController: EditProfileCellDelegate {
    
    func editProfileCell(_ cell: EditProfileCell, didUpdateField updatedModel: EditProfileModel?) {
        //update user
        if updatedModel?.label == "Name" {
            user.name = updatedModel?.value
        }
        if updatedModel?.label == "Username" {
            user.username = updatedModel?.value ?? user.username
        }
        if updatedModel?.label == "Bio" {
            user.bio = updatedModel?.value
        }
    }
    
}

//MARK: - EditProfileHeaderViewDelegate
extension EditProfileController: EditProfileHeaderViewDelegate {
    
    func changeProfileImage() {
        
        let actionSheet = UIAlertController(title: "Change Profile Photo", message: "", preferredStyle: .actionSheet)
        
        //            actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
        //
        //            }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { (action) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil )
    }
    
}


//MARK: - ImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            selectedImageFromPicker = originalImage
            
        }
        
        if let selectedImage = selectedImageFromPicker {
            pickImage(image: selectedImage)
        }
    }
    
    private func pickImage(image: UIImage) {
        isChangeProfileImage = true
        selectedImage = image
        self.editProfileView.editProfileTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}
