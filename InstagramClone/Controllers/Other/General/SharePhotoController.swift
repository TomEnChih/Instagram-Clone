//
//  SharePhotoController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/10.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class SharePhotoController: UIViewController {

    // MARK: - Properties
    
    static let updateFeedNotificationName = NSNotification.Name("UpdateFeed")
    
    private let sharePhotoView = SharePhotoView()
    
    var selectedImage: UIImage? {
        didSet {
            sharePhotoView.postImageView.image = selectedImage
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view  = sharePhotoView
        
        setupNavigationButtons()
    }
    
    // MARK: - Methods

    private func setupNavigationButtons() {
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }
    
    @objc func handleShare() {
        
        guard let image = selectedImage,
              let uploadData = image.jpegData(compressionQuality: 0.5),
              let caption = sharePhotoView.textView.text, caption.count > 0 else { return }
        
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
        
    }
    
    private func saveToDatabaseWithImageURL(imageURL: String) {
        #warning("caption 刪除 縮減, postImage 知道在幹嘛？, database ,storage 整理")
        guard let postImage = selectedImage else { return }
        guard let caption = sharePhotoView.textView.text else { return }
        
        guard let email = Auth.auth().currentUser?.email else { return }
    
        let key = email.safeDatabaseKey()
        
        let userPostRef = Database.database().reference().child("posts").child(key)
    
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageURL": imageURL,
                      "caption": caption,
                      "imageWidth": postImage.size.width,
                      "imageHeight": postImage.size.height,
                      "creationDate": Date().timeIntervalSince1970] as [String:Any]
        
        ref.updateChildValues(values) { (error, ref) in
            guard error == nil else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print(error)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }

}
