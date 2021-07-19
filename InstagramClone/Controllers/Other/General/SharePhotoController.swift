//
//  SharePhotoController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/7/10.
//

import UIKit

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
        
        StorageManager.shared.uploadPostImage(with: uploadData) { (result) in
            switch result {
            case .failure(let error):
                print(error)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
            case .success(let downloadURLString):
                self.saveToDatabase(imageURL: downloadURLString, caption: caption)
            }
        }
    }
    
    private func saveToDatabase(imageURL: String,caption: String) {
        
        DatabaseManager.shared.uploadPost(imageURL: imageURL, caption: caption) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
                
                NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
                
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        
    }

}
